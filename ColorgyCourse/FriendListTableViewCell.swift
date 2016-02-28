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
	
	var userId: String!
	var historyChatroom: HistoryChatroom! {
		didSet {
			updateUI()
		}
	}
	
	func updateUI() {
		if historyChatroom.image.isValidURLString {
			
			let sc = SDImageCache()
			let imageFromCache = sc.imageFromDiskCacheForKey(self.historyChatroom.image)
			
			if imageFromCache == nil  {
				// load image if its nil
				UIImageView().sd_setImageWithURL(historyChatroom.image.url, completed: { (image: UIImage!, error: NSError!, cacheType: SDImageCacheType, url: NSURL!) -> Void in
					self.updateUI()
				})
			} else {
				let percentage = self.historyChatroom.chatProgress
				let qos = Int(QOS_CLASS_USER_INTERACTIVE.rawValue)
				dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in
					let radius = 20 * (CGFloat(100 - percentage) % 33) * 0.01
					print(radius)
					let blurImage = UIImage().gaussianBlurImage(imageFromCache, andInputRadius: radius)
					dispatch_async(dispatch_get_main_queue(), { () -> Void in
						self.userProfileImageView.image = blurImage
					})
				})
			}
		}
		userNameLabel.text = (historyChatroom.name != "" ? historyChatroom.name : " ")
		userQuestionLabel.text = " "
		let prefixString = (userId == historyChatroom.lastSpeaker ? "你：" : "")
		let lastMessage = (historyChatroom.lastContent != "" ? historyChatroom.lastContent : " ") ?? " "
		userLastMessageLabel.text = prefixString + lastMessage
		timeStampLabel.text = historyChatroom.lastContentTime.timeStampString()
		userQuestionLabel.text = historyChatroom.lastAnswer
//		if historyChatroom.unread {
//			userLastMessageLabel.font = UIFont.boldSystemFontOfSize(14.0)
//			userLastMessageLabel.textColor = UIColor.blackColor()
//		} else {
//			userLastMessageLabel.font = UIFont.systemFontOfSize(14.0)
//			userLastMessageLabel.textColor = UIColor(red: 151/255.0, green: 151/255.0, blue: 151/255.0, alpha: 1.0)
//		}
	}
	
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
