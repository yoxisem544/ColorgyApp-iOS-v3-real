//
//  FailToLoadDataHintView.swift
//  ColorgyCourse
//
//  Created by David on 2016/2/22.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

class FailToLoadDataHintView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
	
	init() {
		super.init(frame: CGRectZero)
		
		self.frame.size.width = UIScreen.mainScreen().bounds.width * 0.7
		self.frame.size.height = 50
		let label = UILabel()
		label.text = "⚠️ 資料下載錯誤...正在重新下載..."
		label.font = UIFont.systemFontOfSize(14)
		label.minimumScaleFactor = 0.5
		label.adjustsFontSizeToFitWidth = true
		label.textAlignment = .Center
		label.sizeToFit()
		label.frame.size.width = 0.9 * self.bounds.width
		label.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
		self.addSubview(label)
		self.backgroundColor = UIColor.lightGrayColor()
		self.layer.cornerRadius = 8.0
		self.center = CGPoint(x: UIScreen.mainScreen().bounds.midX, y: UIScreen.mainScreen().bounds.midY)
	}
	
	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}

}
