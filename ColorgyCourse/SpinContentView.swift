//
//  SpinContentView.swift
//  ScrollViewWorkout
//
//  Created by David on 2015/12/14.
//  Copyright © 2015年 David. All rights reserved.
//

import UIKit

class SpinContentView: UIView {

    var titleLabel: UILabel?
    var subTitleLabel: UILabel?
    var imageView: UIImageView?
    
    let titleTextSize: CGFloat = 28.0
    let subtitleTextSize: CGFloat = 18.0
    let titleSpacing: CGFloat = 10.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(title: String, subtitle: String, image: UIImage) {
        self.init(frame: UIScreen.mainScreen().bounds)
        
        // setup title
        titleLabel = UILabel(frame: CGRectMake(0, 0, self.frame.width, titleTextSize))
        titleLabel?.textColor = UIColor.whiteColor()
        titleLabel?.textAlignment = .Center
        titleLabel?.font = UIFont(name: "STHeitiTC-Medium", size: titleTextSize)
        // 19.5% height
        titleLabel?.center = CGPoint(x: self.bounds.midX, y: self.bounds.height * 19.5 / 100.0)
        titleLabel?.text = title
//        titleLabel?.sizeToFit()
        
        // setup sub title
        subTitleLabel = UILabel(frame: CGRectMake(0, 0, self.frame.width, subtitleTextSize))
        subTitleLabel?.textAlignment = .Center
        subTitleLabel?.textColor = UIColor.whiteColor()
        subTitleLabel?.alpha = 0.75
        // below title
        subTitleLabel?.center = CGPoint(x: titleLabel!.center.x, y: titleLabel!.center.y + (titleTextSize + subtitleTextSize) / 2 + titleSpacing)
        subTitleLabel?.text = subtitle
        subTitleLabel?.font = UIFont(name: "STHeitiTC-Medium", size: subtitleTextSize)
//        subTitleLabel?.sizeToFit()
        
        // setup image view
        let imageWidth = UIScreen.mainScreen().bounds.height
        imageView = UIImageView(frame: CGRectMake(0, 0, imageWidth, imageWidth))
        imageView?.contentMode = .ScaleAspectFit
        imageView?.center = self.center
        imageView?.frame.origin.y = subTitleLabel!.frame.maxY + 30
        imageView?.image = image
        self.addSubview(imageView!)
        self.addSubview(titleLabel!)
        self.addSubview(subTitleLabel!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
