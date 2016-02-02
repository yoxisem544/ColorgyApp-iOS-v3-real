//
//  FriendListTableViewCell.swift
//  ColorgyCourse
//
//  Created by David on 2016/2/2.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

class FriendListTableViewCell: UITableViewCell {

	@IBOutlet weak var userProfileImageView: UIImageView!
	@IBOutlet weak var userNameLabel: UILabel!
	@IBOutlet weak var userQuestionLabel: UILabel!
	@IBOutlet weak var userLastMessageLabel: UILabel!
	@IBOutlet weak var timeStampLabel: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		userProfileImageView.clipsToBounds = true
		userProfileImageView.layer.cornerRadius = userProfileImageView.bounds.width / 2
		
		let separatorLine = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 0.5))
		separatorLine.backgroundColor = UIColor.lightGrayColor()
		separatorLine.frame.origin.y = self.frame.height - 0.5
		separatorLine.alpha = 0.8
		self.addSubview(separatorLine)
		
		self.selectionStyle = .None
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
