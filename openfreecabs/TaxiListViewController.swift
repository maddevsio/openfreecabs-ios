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
        
        self.navigationController!.navigationBar.topItem!.title = ""
        self.taxiListTable.tableFooterView = UIView.init()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Services list".localized()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taxiListIdentity", for: indexPath) as! TaxiListCell
        
        var allPhoneNumbers = ""
        var allSmsNumbers = ""
        for contact in companies[indexPath.row].contacts {
            if contact.type == "sms" {
                allSmsNumbers +=  (allSmsNumbers.isEmpty ? "" : " ,") + "\(contact.contactNumber)"
            } else if contact.type == "phone" {
                allPhoneNumbers +=  (allPhoneNumbers.isEmpty ? "" : " ,") + "\(contact.contactNumber)"
            }
        }
        
        cell.setTaxiContentList(companies[indexPath.row].name, count: "\(companies[indexPath.row].drivers.count)", iconUrl: companies[indexPath.row].iconURL, _phoneNumbers: allPhoneNumbers, _smsNumber: allSmsNumbers, index: indexPath.row)
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(companies[indexPath.row].contacts.count)")
        
        performSegue(withIdentifier: "contactsSegue", sender: companies[indexPath.row])
        
//        if (companies[indexPath.row].contacts.count > 0) {
//            var actionsArray: [UIAlertAction] = []
//            for i in 0..<companies[indexPath.row].contacts.count {
//                let action = UIAlertAction(title: companies[indexPath.row].contacts[i].type, style: UIAlertActionStyle.default, handler: { (action) in
//                    if (self.companies[indexPath.row].contacts[i].type == "sms") {
//                        let phoneUrl : URL = URL(string: "sms:" + self.companies[indexPath.row].contacts[i].contactNumber)!
//                        UIApplication.shared.openURL(phoneUrl)
//                    } else {
//                        let phoneUrl : URL = URL(string: "tel:" + self.companies[indexPath.row].contacts[i].contactNumber)!
//                        UIApplication.shared.openURL(phoneUrl)
//                    }
//                })
//                actionsArray.append(action)
//            }
//            showAlertWithContacts(actionsArray)
//        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "contactsSegue") {
            let info = segue.destination as! ContactsViewController
            info.selectedCompany = sender as! CompaniesModel
        }
    }
    
    func showAlertWithContacts(_ actions: [UIAlertAction]) {
        let alertController = UIAlertController(title: "Контакты служб", message:
            "", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        for i in 0..<actions.count {
            alertController.addAction(actions[i])
        }
        
        alertController.addAction(UIAlertAction(title: "Назад".localized(), style: UIAlertActionStyle.cancel,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
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
