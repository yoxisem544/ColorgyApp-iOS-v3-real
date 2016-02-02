//
//  UserDetailInformationView.swift
//  ColorgyCourse
//
//  Created by David on 2016/2/2.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

class UserDetailInformationView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
	convenience init(withBlurPercentage percentage: Double, withUserImage image: UIImage?) {
		self.init()
		
		// dismiss
		self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "dismissView"))
		
		self.backgroundColor = UIColor.blackColor()
		self.alpha = 0.7
		
		let userImageView = UIImageView(frame: CGRectMake(0, 0, self.bounds.width * 0.5, self.bounds.width * 0.5))
		userImageView.center = self.center
		userImageView.center.y = self.center.y * 0.7
		userImageView.layer.cornerRadius = userImageView.bounds.width / 2
		userImageView.clipsToBounds = true
		userImageView.contentMode = .ScaleAspectFill
		
		userImageView.image = image
		
		self.addSubview(userImageView)
	}
	
	func dismissView() {
		self.removeFromSuperview()
	}
	
	init() {
		super.init(frame: UIScreen.mainScreen().bounds)
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}

}
