//
//  ColorgyLoadingView.swift
//  ColorgyCourse
//
//  Created by David on 2016/3/11.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

class ColorgyLoadingView: UIView {
	
	init() {
		super.init(frame: CGRectZero)
		// fix size to 130
		self.frame.size = CGSize(width: 130, height: 130)
		self.backgroundColor = ColorgyColor.MainOrange.withAlpha(0.7)
		
		// image
		let loadingImage = UIImage(named: "ColorgyLoadingViewImage")
		let loadingImageView = UIImageView(frame: CGRectMake(0, 0, 48, 48))
		loadingImageView.image = loadingImage
		// arrange loading view
		loadingImageView.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
		
		self.addSubview(loadingImageView)
		
		// center
		
		// background
		
		// can block user?
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}

}
