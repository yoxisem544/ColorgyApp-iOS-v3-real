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
	
	var delegate: DLMessageDelegate?
	
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
		userImageView.backgroundColor = UIColor.lightGrayColor()
		
		contentImageView.backgroundColor = UIColor.lightGrayColor()
		userImageView.userInteractionEnabled = true
		
		self.selectionStyle = .None
    }
	
	func tapOnUserImageView() {
		print("tapOnUserImageView")
		delegate?.DLMessage(didTapOnUserImageView: userImageView.image)
	}

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
