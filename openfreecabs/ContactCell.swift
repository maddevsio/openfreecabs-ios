//
//  ContactCell.swift
//  openfreecabs
//
//  Created by Pavel and Rus on 10/1/16.
//  Copyright © 2016 Mad Devs. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {

    @IBOutlet weak var contactName: UILabel!
    @IBOutlet weak var contactContent: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setContact(name: String, content: String) {
        contactName.text = name
        contactContent.text = content
    }

}
