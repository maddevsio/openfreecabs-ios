//
//  ViewController.swift
//
//  Created by Pavel and Rus on 8/27/16.
//  Copyright © 2016 Mad Devs. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps

class MapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var ktButton: UIButton!
    @IBOutlet weak var myMarkerOnMap: UIImageView!
    @IBOutlet weak var findMeButton: UIBarButtonItem!
    @IBOutlet weak var ktBottomConstraint: NSLayoutConstraint!
    
    let locationManager = CLLocationManager()
    var userLocation = CLLocationCoordinate2DMake(0, 0)
    
    var driversMarker: [GMSMarker] = []
    var companiesModel: [CompaniesModel] = []
    var driversModel: [DriversModel] = []
    //    var userMarker: GMSMarker = GMSMarker(position: CLLocationCoordinate2D(latitude: 0, longitude: 0))
    var isAutorized = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Машины рядом".localized()
        
        ktButton.setTitle("Какие машины рядом?", forState: UIControlState.Normal)
        addressTextField.placeholder = "Укажите адрес"
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            locationManager.requestAlwaysAuthorization()
        }
        
        addressTextField.delegate = self
        
        mapView.delegate = self
        mapView.settings.rotateGestures = false
        mapView.settings.tiltGestures = false
        mapView.settings.allowScrollGesturesDuringRotateOrZoom = false
        mapView.camera = GMSCameraPosition(target: CLLocationCoordinate2DMake(42.876041, 74.603458), zoom: 10, bearing: 0, viewingAngle: 0)
        
        if (NSUserDefaults.standardUserDefaults().objectForKey("alertDisabledLocation") == nil) {
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "alertDisabledLocation")
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MapViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MapViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil)
    }
    
    func checkLocationManagerAuthorization() {
        print("checkLocationManagerAuthorization")
        
        switch CLLocationManager.authorizationStatus() {
        case .AuthorizedAlways:
            isAutorized = true
            
        case .NotDetermined:
            isAutorized = false
            locationManager.requestAlwaysAuthorization()
            
        case .AuthorizedWhenInUse, .Restricted, .Denied:
            isAutorized = false
        }
        
        if (locationManager.location == nil) {
            mapView.animateToCameraPosition(GMSCameraPosition(target: CLLocationCoordinate2DMake(42.876041, 74.603458), zoom: 13, bearing: 0, viewingAngle: 0))
        } else {
            //            userMarker = showMarkerOnMap(locationManager.location!.coordinate, markerName: "userMarker", animated: false)
            mapView.animateToCameraPosition(GMSCameraPosition(target: locationManager.location!.coordinate, zoom: 15, bearing: 0, viewingAngle: 0))
        }
        if (isAutorized) {
            myMarkerOnMap.hidden = false
            // все ок
        } else {
            myMarkerOnMap.hidden = true
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "alertDisabledLocation")
            showAlertDisabledLocation()
            // не ок скрываем элементы экрана
            //            userMarker.map = nil
            //            orderMarker.map = nil
            
        }
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        print("didChangeAuthorizationStatus")
        checkLocationManagerAuthorization()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("didUpdateLocations")
        let locationArray = locations as NSArray
        let locationObj = locationArray.lastObject as! CLLocation
        
        userLocation = locationObj.coordinate
        
        locationManager.stopUpdatingLocation()
        
        //get locaiton
        //        myMarkerOnMap.hidden = true
        //        userMarker.map = nil
        //        userMarker = showMarkerOnMap(userLocation, markerName: "userMarker", animated: false)
        mapView.animateToCameraPosition(GMSCameraPosition(target: userLocation, zoom: 15, bearing: 0, viewingAngle: 0))
        getTaxiList(locationManager.location!.coordinate.latitude, lng: locationManager.location!.coordinate.longitude)
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("didFailWithError")
        locationManager.stopUpdatingLocation()
    }
    
    //Markers on map
    func showMarkerOnMap(coord: CLLocationCoordinate2D, markerName: String, animated: Bool) -> GMSMarker {
        if (markerName == "userMarker") {
            //            userMarker.map = nil
        }
        let marker : GMSMarker = GMSMarker(position: coord)
        if (animated) {
            marker.appearAnimation = kGMSMarkerAnimationPop
        }
        marker.icon = UIImage(named: markerName)
        marker.map = mapView
        return marker
    }
    
    func mapView(mapView: GMSMapView, didTapMarker marker: GMSMarker) -> Bool {
        print("tap marker at lat:\(marker.position.latitude) lng:\(marker.position.longitude)")
        return true //отключение нажатия на маркер
    }
    
    func mapView(mapView: GMSMapView, didTapAtCoordinate coordinate: CLLocationCoordinate2D) {
        print("didTapAtCoordinate")
//        checkLocationManagerAuthorization()
    }
    
    func mapView(mapView: GMSMapView, willMove gesture: Bool) {
        print("willMove")
        //        userMarker.map = nil
        //            orderMarker.map = nil
        //        myMarkerOnMap.hidden = false
    }
    
    
    func mapView(mapView: GMSMapView, idleAtCameraPosition position: GMSCameraPosition) {
        print("idleAtCameraPosition")
        if (isAutorized) {
            addressTextField.placeholder = "Укажите адрес".localized()
        }
        //        userMarker.map = nil
        //            orderMarker.map = nil
        //        userMarker = showMarkerOnMap(position.target, markerName: "userMarker", animated: false)
        //        myMarkerOnMap.hidden = true
        getTaxiList(position.target.latitude, lng: position.target.longitude)
    }
    
    func getTaxiList(lat: Double, lng: Double) {
        print("getTaxiList \(lat) \(lng)")
        OpenFreeCabsApiClient.sharedInstance.getTaxiList("\(lat)", lng: "\(lng)") { (response) in
            if (response.result.isSuccess) {
                if (response.result.value!.success) {
                    self.companiesModel = response.result.value!.companies
                    print("self.companiesModel.count \(self.companiesModel.count)")
                    for i in 0 ..< self.driversMarker.count {
                        self.driversMarker[i].map = nil
                    }
                    self.driversMarker = []
                    
                    for j in 0..<response.result.value!.companies.count {
                        self.driversModel = response.result.value!.companies[j].drivers
                        print("self.driversModel.count \(self.driversModel.count)")

                        for i in 0 ..< self.driversModel.count {
                            
                            let coord = CLLocationCoordinate2D(latitude: self.driversModel[i].lat, longitude: self.driversModel[i].lng)
                            
                            self.driversMarker.append(self.showMarkerOnMap(coord, markerName: "driverMarker", animated: true))
                            
                            if (self.driversModel[i].lat != 0 && self.driversModel[i].lng != 0) {
                                self.driversMarker[i].map = self.mapView
                                print("self.driversMarker[i].map")
                            } else {
                                self.driversMarker[i].map = nil
                                print("self.driversMarker[i].map nil")
                            }
                        }
                    }
                    print("driversMarker.count \(self.driversMarker.count)")
                } else {
                }
            } else {
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        addressTextField.resignFirstResponder()
        return true
    }
    
    @IBAction func ktButtonAction(sender: UIButton) {
        print("ktButtonAction \(addressTextField.text) \(addressTextField.text?.isEmpty)")
        if (isAutorized || !addressTextField.text!.isEmpty) {
            performSegueWithIdentifier("taxiListSegue", sender: companiesModel)
        } else {
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "alertDisabledLocation")
            showAlertDisabledLocation()
        }
    }
    
    @IBAction func findMeAction(sender: UIBarButtonItem) {
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedAlways) {
            if (CLLocationManager.locationServicesEnabled() && locationManager.location != nil) {
                mapView.animateToCameraPosition(GMSCameraPosition(target: locationManager.location!.coordinate, zoom: 15, bearing: 0, viewingAngle: 0))
            } else {
                showSimpleAlert("Внимание".localized(), message: "Не удалось определить ваше местоположение".localized())
            }
        } else {
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "alertDisabledLocation")
            showAlertDisabledLocation()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "taxiListSegue") {
            let info = segue.destinationViewController as! TaxiListViewController
            info.companies = companiesModel
        }
    }
    
    func showAlertDisabledLocation() {
        let flagLocation: Bool = NSUserDefaults.standardUserDefaults().objectForKey("alertDisabledLocation") as! Bool
        if (!flagLocation) {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "alertDisabledLocation")
            let alertController = UIAlertController(
                title: "Получение геолокации отключено".localized(),
                message: "Для работы с приложением, откройте настройки этого приложения и установить доступ местонахождения, «Всегда»".localized(),
                preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "Отмена".localized(), style: .Cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let openAction = UIAlertAction(title: "Открыть настройки".localized(), style: .Default) { (action) in
                if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                    UIApplication.sharedApplication().openURL(url)
                }
            }
            alertController.addAction(openAction)
            
            let addressManual = UIAlertAction(title: "Указать адрес вручную".localized(), style: .Default) { (action) in
                self.addressTextField.becomeFirstResponder()
            }
            alertController.addAction(addressManual)
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func showSimpleAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Назад".localized(), style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboardWillShow(notification: NSNotification) {
        var info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.ktBottomConstraint.constant = keyboardFrame.height
        })
    }

    func keyboardWillHide(notification: NSNotification) {
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.ktBottomConstraint.constant = 0        })
    }
}

