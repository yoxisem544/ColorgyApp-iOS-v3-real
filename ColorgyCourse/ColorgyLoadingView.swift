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
	private var loadingView: UIView?
	
	init() {
		super.init(frame: CGRectZero)
		// fix size to 130
		self.frame.size = CGSize(width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height)
		
		// loading view
		loadingView = UIView(frame: CGRectMake(0, 0, 130, 130))
		loadingView?.backgroundColor = ColorgyColor.MainOrange.withAlpha(0.7)
		loadingView?.layer.cornerRadius = 2.0
		
		// image
		let loadingImage = UIImage(named: "ColorgyLoadingViewImage")
		loadingImageView = UIImageView(frame: CGRectMake(0, 0, 48, 48))
		loadingImageView?.image = loadingImage
		// arrange loading view
		loadingImageView?.center = loadingView?.bounds.centerPoint ?? CGPointZero
		
		loadingImageView?.anchorViewTo(loadingView)
		
		// center
		self.center = UIScreen.mainScreen().bounds.centerPoint
		loadingView?.center = self.bounds.centerPoint
		
		// add subview
		loadingView?.anchorViewTo(self)
		
		// background
		
		// can block user?
		
		// tap gesture
		self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "tapOnLoadingView"))
	}
	
	// MARK: Trick
	internal func tapOnLoadingView() {
		UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.8, options: [], animations: { () -> Void in
			self.loadingImageView?.transform = CGAffineTransformMakeScale(1.7, 1.7)
			}, completion: { (_) -> Void in
				UIView.animateWithDuration(0.2, animations: { () -> Void in
					self.loadingImageView?.transform = CGAffineTransformIdentity
				})
		})
	}
	
	// MARK: Life Cycle
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
