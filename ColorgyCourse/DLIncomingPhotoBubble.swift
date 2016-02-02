//
//  DLIncomingPhotoBubble.swift
//  ColorgyCourse
//
//  Created by David on 2016/1/28.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

class DLIncomingPhotoBubble: UITableViewCell {
	
	@IBOutlet weak var userImageView: UIImageView!
	@IBOutlet weak var contentImageView: UIImageView!
	
	var delegate: DLIncomingMessageDelegate?

	var imageURLString: String! {
		didSet {
			loadImageWithString(imageURLString)
		}
	}
	
	internal func loadImageWithString(string: String!) {
		self.contentImageView.image = nil
		if string != nil {
			if string.isValidURLString {
				if let url = NSURL(string: string) {
					let qos = Int(QOS_CLASS_USER_INTERACTIVE.rawValue)
					dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in
						if let data = NSData(contentsOfURL: url) {
							dispatch_async(dispatch_get_main_queue(), { () -> Void in
								self.contentImageView.image = UIImage(data: data)
							})
						}
					})
				}
			}
		}
	}
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		userImageView.layer.cornerRadius = userImageView.bounds.width / 2
		userImageView.clipsToBounds = true
		userImageView.contentMode = .ScaleAspectFill
		
		userImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "tapOnUserImageView"))
		
		contentImageView.layer.cornerRadius = 10.0
		contentImageView.clipsToBounds = true
		contentImageView.contentMode = .ScaleAspectFill
		
		contentImageView.backgroundColor = UIColor.lightGrayColor()
		userImageView.userInteractionEnabled = true
		
		self.selectionStyle = .None
    }
	
	func tapOnUserImageView() {
		print("tapOnUserImageView")
		delegate?.DLIncomingMessageDidTapOnUserImageView(userImageView.image)
	}

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
