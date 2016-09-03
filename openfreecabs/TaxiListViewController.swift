//
//  TaxiListViewController.swift
//
//  Created by Pavel and Rus on 8/27/16.
//  Copyright © 2016 Mad Devs. All rights reserved.
//

import UIKit

class TaxiListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var taxiListTable: UITableView!
    var companies: [CompaniesModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Сервисы".localized()
        // Do any additional setup after loading the view.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("taxiListIdentity", forIndexPath: indexPath) as! TaxiListCell
        cell.setTaxiContentList(companies[indexPath.row].name, count: "\(companies[indexPath.row].drivers.count)")
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("\(companies[indexPath.row].contacts.count)")
        
        if (companies[indexPath.row].contacts.count > 0) {
            var actionsArray: [UIAlertAction] = []
            for i in 0..<companies[indexPath.row].contacts.count {
                let action = UIAlertAction(title: companies[indexPath.row].contacts[i].type, style: UIAlertActionStyle.Default, handler: { (action) in
                    if (self.companies[indexPath.row].contacts[i].type == "sms") {
                        let phoneUrl : NSURL = NSURL(string: "sms:" + self.companies[indexPath.row].contacts[i].contactNumber)!
                        UIApplication.sharedApplication().openURL(phoneUrl)
                    } else {
                        let phoneUrl : NSURL = NSURL(string: "tel:" + self.companies[indexPath.row].contacts[i].contactNumber)!
                        UIApplication.sharedApplication().openURL(phoneUrl)
                    }
                })
                actionsArray.append(action)
            }
            showAlertWithContacts(actionsArray)
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func showAlertWithContacts(actions: [UIAlertAction]) {
        let alertController = UIAlertController(title: "Контакты служб", message:
            "", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        for i in 0..<actions.count {
            alertController.addAction(actions[i])
        }
        
        alertController.addAction(UIAlertAction(title: "Назад".localized(), style: UIAlertActionStyle.Cancel,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
