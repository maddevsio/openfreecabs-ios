//
//  ContactsViewController.swift
//  openfreecabs
//
//  Created by Pavel and Rus on 10/1/16.
//  Copyright © 2016 Mad Devs. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var contactsTable: UITableView!
    var selectedCompany: CompaniesModel = CompaniesModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.navigationBar.topItem!.title = ""
        self.contactsTable.tableFooterView = UIView.init()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = String.init(format: "Contacts of %@".localized(), selectedCompany.name)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedCompany.contacts.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactIdentity", for: indexPath) as! ContactCell
        
        cell.setContact(name: selectedCompany.contacts[indexPath.row].type, content: selectedCompany.contacts[indexPath.row].contactNumber)
        
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (self.selectedCompany.contacts[indexPath.row].type == "sms") {
            let phoneUrl : URL = URL(string: "sms:" + self.selectedCompany.contacts[indexPath.row].contactNumber)!
            UIApplication.shared.openURL(phoneUrl)
        } else {
            let phoneUrl : URL = URL(string: "tel:" + self.selectedCompany.contacts[indexPath.row].contactNumber)!
            UIApplication.shared.openURL(phoneUrl)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
