//
//  SayHelloCountsCell.swift
//  ColorgyCourse
//
//  Created by David on 2016/2/26.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

class SayHelloCountsCell: UITableViewCell {
	
	@IBOutlet weak var countsLabel: DLMessageLabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		countsLabel.textColor = UIColor.whiteColor()
		countsLabel.backgroundColor = ColorgyColor.MainOrange
		countsLabel.layer.cornerRadius = countsLabel.bounds.height / 2 + 8
		countsLabel.textAlignment = .Center
		countsLabel.clipsToBounds = true
		countsLabel.sizeToFit()
		
		let separatorLine = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 0.5))
		separatorLine.backgroundColor = UIColor.lightGrayColor()
		separatorLine.frame.origin.y = 51 - 0.5
		separatorLine.alpha = 0.8
		self.addSubview(separatorLine)
		
		self.selectionStyle = .None
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
