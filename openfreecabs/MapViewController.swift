//
//  ViewController.swift
//
//  Created by Pavel and Rus on 8/27/16.
//  Copyright © 2016 Mad Devs. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps
import Kingfisher

class MapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var ktButton: UIButton!
    @IBOutlet weak var myMarkerOnMap: UIImageView!
    @IBOutlet weak var findMeButton: UIBarButtonItem!
    @IBOutlet weak var ktBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var addressViewHeightConstraint: NSLayoutConstraint!
    
    let locationManager = CLLocationManager()
    var userLocation = CLLocationCoordinate2DMake(0, 0)
    
    var driversMarker: [GMSMarker] = []
    var companiesModel: [CompaniesModel] = []
    var driversModel: [DriversModel] = []
    var isAutorized = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addressView.isHidden = true
        addressViewHeightConstraint.constant = 0
        
        ktButton.setTitle("What service is nearest?", for: UIControlState())
        addressTextField.placeholder = "Укажите адрес"
        ktButton.clipsToBounds = true
        ktButton.layer.cornerRadius = 5
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        }
        
        addressTextField.delegate = self
        
        mapView.delegate = self
        mapView.settings.rotateGestures = false
        mapView.settings.tiltGestures = false
        mapView.settings.allowScrollGesturesDuringRotateOrZoom = false
        mapView.camera = GMSCameraPosition(target: CLLocationCoordinate2DMake(42.876041, 74.603458), zoom: 10, bearing: 0, viewingAngle: 0)
        
        if (UserDefaults.standard.object(forKey: "alertDisabledLocation") == nil) {
            UserDefaults.standard.set(false, forKey: "alertDisabledLocation")
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(MapViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MapViewController.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "OpenFreeCabs".localized()
    }
    
    func checkLocationManagerAuthorization() {
        print("checkLocationManagerAuthorization")
        
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            isAutorized = true
            
        case .notDetermined:
            isAutorized = false
            locationManager.requestAlwaysAuthorization()
            
        case .authorizedWhenInUse, .restricted, .denied:
            isAutorized = false
        }
        
        if (locationManager.location == nil) {
            mapView.animate(to: GMSCameraPosition(target: CLLocationCoordinate2DMake(42.876041, 74.603458), zoom: 13, bearing: 0, viewingAngle: 0))
        } else {
            mapView.animate(to: GMSCameraPosition(target: locationManager.location!.coordinate, zoom: 15, bearing: 0, viewingAngle: 0))
        }
        if (isAutorized) {
            myMarkerOnMap.isHidden = false
            // все ок
        } else {
            myMarkerOnMap.isHidden = true
            UserDefaults.standard.set(false, forKey: "alertDisabledLocation")
            showAlertDisabledLocation()
            
        }
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("didChangeAuthorizationStatus")
        checkLocationManagerAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("didUpdateLocations")
        let locationArray = locations as NSArray
        let locationObj = locationArray.lastObject as! CLLocation
        
        userLocation = locationObj.coordinate
        
        locationManager.stopUpdatingLocation()
        
        mapView.animate(to: GMSCameraPosition(target: userLocation, zoom: 15, bearing: 0, viewingAngle: 0))
        getTaxiList(locationManager.location!.coordinate.latitude, lng: locationManager.location!.coordinate.longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError")
        locationManager.stopUpdatingLocation()
    }
    
    //Markers on map
    func showMarkerOnMap(_ coord: CLLocationCoordinate2D, markerImage: UIImage, animated: Bool) -> GMSMarker {
        
        let marker : GMSMarker = GMSMarker(position: coord)
        if (animated) {
            marker.appearAnimation = kGMSMarkerAnimationPop
        }
        marker.icon = markerImage
        marker.map = mapView
        return marker
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        print("tap marker at lat:\(marker.position.latitude) lng:\(marker.position.longitude)")
        return true //отключение нажатия на маркер
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("didTapAtCoordinate")
//        checkLocationManagerAuthorization()
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        print("willMove")
    }
    
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        if (isAutorized) {
            addressTextField.placeholder = "Укажите адрес".localized()
        }
        getTaxiList(position.target.latitude, lng: position.target.longitude)
    }
    
    func getTaxiList(_ lat: Double, lng: Double) {
        OpenFreeCabsApiClient.sharedInstance.getTaxiList("\(lat)", lng: "\(lng)") { (response) in
            print("getTaxiList \(response.response)")
            if (response.result.isSuccess) {
                if (response.result.value!.success) {
                    self.companiesModel = response.result.value!.companies
                    
                    self.companiesModel.sort { (l, r) -> Bool in
                        return l.drivers.count > r.drivers.count
                    }
                    
                    for i in 0 ..< self.driversMarker.count {
                        self.driversMarker[i].map = nil
                    }
                    self.driversMarker = []
                    
                    for j in 0..<response.result.value!.companies.count {
                        self.driversModel = response.result.value!.companies[j].drivers
                        
                        let fullUrl = URL(string: "\(response.result.value!.companies[j].iconURL)") as URL!
                        KingfisherManager.shared.retrieveImage(with: fullUrl!, options: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, imageURL) in
                            for i in 0 ..< self.driversModel.count {
                                
                                let coord = CLLocationCoordinate2D(latitude: self.driversModel[i].lat, longitude: self.driversModel[i].lng)
                                
                                if image != nil {
                                    self.driversMarker.append(self.showMarkerOnMap(coord, markerImage: image!, animated: true))
                                } else {
                                    let placeHolderImage = UIImage(named: "driverMarker")
                                    self.driversMarker.append(self.showMarkerOnMap(coord, markerImage: placeHolderImage!, animated: true))
                                }
                                
                                if (self.driversModel[i].lat != 0 && self.driversModel[i].lng != 0) {
                                    self.driversMarker[i].map = self.mapView
                                } else {
                                    self.driversMarker[i].map = nil
                                }
                            }
                        })
                    }
                } else {
                }
            } else {
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addressTextField.resignFirstResponder()
        return true
    }
    
    @IBAction func ktButtonAction(_ sender: UIButton) {
        print("ktButtonAction \(addressTextField.text) \(addressTextField.text?.isEmpty)")
        if (isAutorized || !addressTextField.text!.isEmpty) {
            performSegue(withIdentifier: "taxiListSegue", sender: companiesModel)
        } else {
            UserDefaults.standard.set(false, forKey: "alertDisabledLocation")
            showAlertDisabledLocation()
        }
    }
    
    @IBAction func findMeAction(_ sender: UIBarButtonItem) {
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways) {
            if (CLLocationManager.locationServicesEnabled() && locationManager.location != nil) {
                mapView.animate(to: GMSCameraPosition(target: locationManager.location!.coordinate, zoom: 15, bearing: 0, viewingAngle: 0))
            } else {
                showSimpleAlert("Внимание".localized(), message: "Не удалось определить ваше местоположение".localized())
            }
        } else {
            UserDefaults.standard.set(false, forKey: "alertDisabledLocation")
            showAlertDisabledLocation()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "taxiListSegue") {
            let info = segue.destination as! TaxiListViewController
            info.companies = companiesModel
        }
    }
    
    func showAlertDisabledLocation() {
        let flagLocation: Bool = UserDefaults.standard.object(forKey: "alertDisabledLocation") as! Bool
        if (!flagLocation) {
            UserDefaults.standard.set(true, forKey: "alertDisabledLocation")
            let alertController = UIAlertController(
                title: "Получение геолокации отключено".localized(),
                message: "Для работы с приложением, откройте настройки этого приложения и установить доступ местонахождения, «Всегда»".localized(),
                preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Отмена".localized(), style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let openAction = UIAlertAction(title: "Открыть настройки".localized(), style: .default) { (action) in
                if let url = URL(string:UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.openURL(url)
                }
            }
            alertController.addAction(openAction)
            
//            let addressManual = UIAlertAction(title: "Указать адрес вручную".localized(), style: .Default) { (action) in
//                self.addressTextField.becomeFirstResponder()
//            }
//            alertController.addAction(addressManual)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func showSimpleAlert(_ title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Назад".localized(), style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboardWillShow(_ notification: Notification) {
        var info = (notification as NSNotification).userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.ktBottomConstraint.constant = keyboardFrame.height
        })
    }

    func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.ktBottomConstraint.constant = 0        })
    }
}

