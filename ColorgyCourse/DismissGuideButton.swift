//
//  DismissGuideButton.swift
//  ScrollViewWorkout
//
//  Created by David on 2015/12/14.
//  Copyright © 2015年 David. All rights reserved.
//

import UIKit

class DismissGuideView: UIView {
    
    let buttonHeight: CGFloat = 70.0
    let titleFontSize: CGFloat = 24.0
    var titleLabel: UILabel?
    
    var delegate: DismissGuideViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(title: String) {
        self.init(frame: CGRectMake(0, UIScreen.mainScreen().bounds.maxY, UIScreen.mainScreen().bounds.width, 140))
        print(self.frame)
        self.backgroundColor = UIColor(red:0,  green:0.812,  blue:0.894, alpha:1)
        
        // setup label
        titleLabel = UILabel(frame: CGRectMake(0, 0, self.bounds.width, titleFontSize))
        titleLabel?.font = UIFont(name: "STHeitiTC-Medium", size: titleFontSize)
        titleLabel?.textColor = UIColor.whiteColor()
        titleLabel?.textAlignment = .Center
        titleLabel?.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY / 2)
        titleLabel?.text = title
        self.addSubview(titleLabel!)
        
        // gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: "dismissViewTapped")
        self.addGestureRecognizer(tapGesture)
    }
    
    func dismissViewTapped() {
        delegate?.dismissGuideTouchUpInside()
    }
    
    func show() {
        UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: { () -> Void in
            self.transform = CGAffineTransformMakeTranslation(0, -70)
            }) { (finished) -> Void in
                
        }
    }
    
    func hide() {
        UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: { () -> Void in
            self.transform = CGAffineTransformMakeTranslation(0, 0)
            }) { (finished) -> Void in
                
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public protocol DismissGuideViewDelegate {
    func dismissGuideTouchUpInside()
}
