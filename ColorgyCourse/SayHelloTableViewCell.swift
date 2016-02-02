//
//  SayHelloTableViewCell.swift
//  ColorgyCourse
//
//  Created by David on 2016/2/2.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

class SayHelloTableViewCell: UITableViewCell {
	
	@IBOutlet weak var userProfileImageView: UIImageView!
	@IBOutlet weak var userNameLabel: UILabel!
	@IBOutlet weak var userQuestionLabel: UILabel!
	@IBOutlet weak var userLastMessageLabel: UILabel!
	
	@IBAction func accpectHelloButtonClicked() {
		
	}
	
	@IBAction func reclineHelloButtonClicked() {
		
	}
	
	@IBAction func moreActionButtonClicked() {
		
	}

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		userProfileImageView.clipsToBounds = true
		userProfileImageView.layer.cornerRadius = userProfileImageView.bounds.width / 2
		
		self.selectionStyle = .None
		self.backgroundColor = UIColor.clearColor()
		self.contentView.backgroundColor = UIColor.clearColor()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
