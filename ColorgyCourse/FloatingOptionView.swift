//
//  FloatingOptionView.swift
//  ColorgyCourse
//
//  Created by David on 2016/2/3.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

class FloatingOptionView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
	
	var isShown = false

	init() {
		super.init(frame: UIScreen.mainScreen().bounds)
		self.frame.size.height = 90.0
		self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
		
		// option views
		let sizeOfView = CGSize(width: 28, height: 38)
		
		let leaveView = UIView(frame: CGRectZero)
		leaveView.frame.size = sizeOfView
		let leaveLabel = UILabel()
		leaveLabel.text = "離開"
		leaveLabel.textAlignment = .Center
		leaveLabel.textColor = UIColor.whiteColor()
		leaveLabel.font = UIFont.systemFontOfSize(14)
		leaveLabel.sizeToFit()
		let leaveImageView = UIImageView(frame: CGRectMake(0, 0, 18, 18))
		leaveImageView.image = UIImage(named: "LeaveChatroom")
		// arrange
		leaveLabel.center.x = leaveView.bounds.midX
		leaveImageView.center.x = leaveView.bounds.midX
		leaveImageView.frame.origin.y = 0
		leaveLabel.frame.origin.y = leaveImageView.frame.maxY + 8
		leaveView.addSubview(leaveLabel)
		leaveView.addSubview(leaveImageView)
		
		let blockView = UIView(frame: CGRectZero)
		blockView.frame.size = sizeOfView
		let blockLabel = UILabel()
		blockLabel.text = "封鎖"
		blockLabel.textAlignment = .Center
		blockLabel.textColor = UIColor.whiteColor()
		blockLabel.font = UIFont.systemFontOfSize(14)
		blockLabel.sizeToFit()
		let blockImageView = UIImageView(frame: CGRectMake(0, 0, 18, 18))
		blockImageView.image = UIImage(named: "blockUser")
		// arrange
		blockLabel.center.x = blockView.bounds.midX
		blockImageView.center.x = blockView.bounds.midX
		blockImageView.frame.origin.y = 0
		blockLabel.frame.origin.y = blockImageView.frame.maxY + 8
		blockView.addSubview(blockImageView)
		blockView.addSubview(blockLabel)
		
		// arrange
		leaveView.center.y = self.bounds.midY
		blockView.center.y = self.bounds.midY
		leaveView.center.x = self.bounds.maxX * (1.0 / 3.0)
		blockView.center.x =  self.bounds.maxX * (2.0 / 3.0)
		
		// add to view
		self.addSubview(leaveView)
		self.addSubview(blockView)
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
}
