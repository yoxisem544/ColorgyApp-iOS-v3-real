//
//  SayHelloTableViewCell.swift
//  ColorgyCourse
//
//  Created by David on 2016/2/2.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

protocol SayHelloTableViewCellDelegate {
	func sayHelloTableViewCellAcceptHelloButtonClicked(hi: Hello)
	func sayHelloTableViewCellRejectHelloButtonClicked(hi: Hello)
	func sayHelloTableViewCellMoreActionButtonClicked(hi: Hello)
}

class SayHelloTableViewCell: UITableViewCell {
	
	@IBOutlet weak var profileImageView: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var messageLabel: UILabel!
	@IBOutlet weak var lastMessageLabel: UILabel!
	
	var delegate: SayHelloTableViewCellDelegate?
	
	var hello: Hello! {
		didSet {
			updateUI()
		}
	}
	
	func updateUI() {
		nameLabel.text = hello.name
		lastMessageLabel.text = hello.lastAnswer
		if let urlString = hello.imageURL {
			if let url = NSURL(string: urlString) {
				profileImageView.sd_setImageWithURL(url, placeholderImage: nil)
			}
		}
		messageLabel.text = hello.message
		self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(testCHeckhi)))
	}
	
	func testCHeckhi() {
		ColorgyChatAPI.checkUserAvailability({ (user) -> Void in
			ColorgyChatAPI.checkHi(user.userId, targetId: "56af0ebb4bd9c5f12d613d7c", success: { (canSayHi, whoSaidHi, chatroomId) -> Void in
				
				}, failure: { () -> Void in
					
			})
			}) { () -> Void in
				
		}
	}
	
	@IBAction func accpectHelloButtonClicked() {
		delegate?.sayHelloTableViewCellAcceptHelloButtonClicked(hello)
	}
	
	@IBAction func reclineHelloButtonClicked() {
		delegate?.sayHelloTableViewCellRejectHelloButtonClicked(hello)
	}
	
	@IBAction func moreActionButtonClicked() {
		delegate?.sayHelloTableViewCellMoreActionButtonClicked(hello)
	}

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		profileImageView.clipsToBounds = true
		profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2
		profileImageView.backgroundColor = UIColor.lightGrayColor()
		
		self.selectionStyle = .None
		self.backgroundColor = UIColor.clearColor()
		self.contentView.backgroundColor = UIColor.clearColor()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
