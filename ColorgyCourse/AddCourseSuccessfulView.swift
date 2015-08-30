//
//  AddCourseSuccessfulView.swift
//  ColorgyCourse
//
//  Created by David on 2015/8/31.
//  Copyright (c) 2015年 David. All rights reserved.
//

import UIKit

class AddCourseSuccessfulView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init() {
        self.init(frame: CGRectMake(0, 0, 130, 130))
        var shapeLayer = CAShapeLayer()
        var path = UIBezierPath()
        path.moveToPoint(CGPoint(x: 42, y: 49))
        path.addLineToPoint(CGPoint(x: 54, y: 61))
        path.addLineToPoint(CGPoint(x: 85, y: 30))
        shapeLayer.path = path.CGPath
        shapeLayer.strokeColor = UIColor.whiteColor().CGColor
        shapeLayer.fillColor = UIColor.clearColor().CGColor
        shapeLayer.lineWidth = 3.0
        self.layer.addSublayer(shapeLayer)
        self.backgroundColor = UIColor(red: 248/255.0, green: 150/255.0, blue: 128/255.0, alpha: 0.7)
        
        var pathAnimation = CABasicAnimation(keyPath: "strokeEnd")
        pathAnimation.duration = 0.7
        pathAnimation.fromValue = 0
        pathAnimation.toValue = 1
        shapeLayer.addAnimation(pathAnimation, forKey: "strokeEndAnimation")
        
        var successLabel = UILabel(frame: CGRectMake(0, 0, self.bounds.width, 18))
        successLabel.textColor = UIColor.whiteColor()
        successLabel.text = "加課成功"
        successLabel.textAlignment = NSTextAlignment.Center
        self.addSubview(successLabel)
        successLabel.center.x = self.bounds.midX
        successLabel.frame.origin.y = 61+20
        
        self.layer.cornerRadius = 2.0
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
