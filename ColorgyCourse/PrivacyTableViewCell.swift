//
//  PrivacyTableViewCell.swift
//  ColorgyCourse
//
//  Created by David on 2016/1/20.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

class PrivacyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var privacySwitch: UISwitch!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
