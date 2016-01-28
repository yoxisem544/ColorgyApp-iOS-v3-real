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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		userImageView.layer.cornerRadius = userImageView.bounds.width / 2
		userImageView.clipsToBounds = true
		userImageView.contentMode = .ScaleAspectFill
		
		contentImageView.layer.cornerRadius = 10.0
		contentImageView.clipsToBounds = true
		contentImageView.contentMode = .ScaleAspectFill
		
		self.selectionStyle = .None
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
