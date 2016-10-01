//
//  TaxiListCell.swift
//
//  Created by Pavel and Rus on 8/27/16.
//  Copyright © 2016 Mad Devs. All rights reserved.
//

import UIKit
import Kingfisher

class TaxiListCell: UITableViewCell {

    @IBOutlet weak var taxiName: UILabel!
    @IBOutlet weak var taxiCount: UILabel!
    @IBOutlet weak var iconTaxiImage: UIImageView!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var smsNumber: UILabel!
    @IBOutlet weak var smsImage: UIImageView!
    @IBOutlet weak var freeCabsName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setTaxiContentList(_ name: String, count: String, iconUrl: String, _phoneNumbers: String, _smsNumber: String, index: Int) {
        self.taxiName.text = name
        self.taxiCount.text = count
        self.freeCabsName.text = "Free cabs".localized()
        let url = URL(string: iconUrl)
        iconTaxiImage.kf.setImage(with: url)
        phoneNumber.text = _phoneNumbers
        if _smsNumber.isEmpty {
            smsImage.isHidden = true
        } else {
            smsImage.isHidden = false
        }
        smsNumber.text = _smsNumber
        if index == 0 {
            taxiCount.textColor = UIColor(hex: "#00a844")
            freeCabsName.textColor = UIColor(hex: "#00a844")
        } else {
            taxiCount.textColor = UIColor.black
            freeCabsName.textColor = UIColor.black
        }
    }
}
