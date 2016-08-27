//
//  TaxiListCell.swift
//
//  Created by Pavel and Rus on 8/27/16.
//  Copyright © 2016 Mad Devs. All rights reserved.
//

import UIKit

class TaxiListCell: UITableViewCell {

    @IBOutlet weak var taxiName: UILabel!
    @IBOutlet weak var taxiCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setTaxiContentList(name: String, count: String) {
        self.taxiName.text = name
        self.taxiCount.text = count
    }

}
