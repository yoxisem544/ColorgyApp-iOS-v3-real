//
//  ColorgyLoadingView.swift
//  ColorgyCourse
//
//  Created by David on 2016/3/11.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

class ColorgyLoadingView: UIView {
	
	private var loadingImageView: UIImageView?
	
	init() {
		super.init(frame: CGRectZero)
		// fix size to 130
		self.frame.size = CGSize(width: 130, height: 130)
		self.backgroundColor = ColorgyColor.MainOrange.withAlpha(0.7)
		self.layer.cornerRadius = 2.0
		
		// image
		let loadingImage = UIImage(named: "ColorgyLoadingViewImage")
		loadingImageView = UIImageView(frame: CGRectMake(0, 0, 48, 48))
		loadingImageView?.image = loadingImage
		// arrange loading view
		loadingImageView?.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
		
		loadingImageView?.anchorViewTo(self)
		
		// center
		self.center = UIScreen.mainScreen().bounds.centerPoint
		
		// background
		
		// can block user?
	}
	
	func startAnimating() {
		let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
		
		rotationAnimation.toValue = NSNumber(double: M_PI * 2.0)
		rotationAnimation.duration = 1.0
		rotationAnimation.cumulative = true
		rotationAnimation.repeatCount = MAXFLOAT
		
		loadingImageView?.layer.addAnimation(rotationAnimation, forKey: "rotationAnimation")
	}

	func stopAniamting() {
		loadingImageView?.layer.removeAnimationForKey("rotationAnimation")
	}
	
	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}

}
