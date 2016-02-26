//
//  SayHelloCountsCell.swift
//  ColorgyCourse
//
//  Created by David on 2016/2/26.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

class SayHelloCountsCell: UITableViewCell {
	
	@IBOutlet weak var countsLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		countsLabel.textColor = UIColor.whiteColor()
		countsLabel.backgroundColor = ColorgyColor.MainOrange
		countsLabel.layer.cornerRadius = countsLabel.bounds.height / 2
		
		self.selectionStyle = .None
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
