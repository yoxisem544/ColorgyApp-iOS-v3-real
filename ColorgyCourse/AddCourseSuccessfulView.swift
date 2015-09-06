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
    
    // private API
    private var shapeLayer: CAShapeLayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init() {
        self.init(frame: CGRectMake(0, 0, 130, 130))
        shapeLayer = CAShapeLayer()
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
    
    func animate(complete: () -> Void) {
        
        // initial state
        self.hidden = false
        self.transform = CGAffineTransformMakeScale(0.3, 0.3)
        self.alpha = 0.5
        var pathAnimation = CABasicAnimation(keyPath: "strokeEnd")
        pathAnimation.duration = 0.0
        pathAnimation.fromValue = 0
        pathAnimation.toValue = 0
        self.shapeLayer.addAnimation(pathAnimation, forKey: "strokeEndAnimation")
        
        UIView.animateWithDuration(0.2, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.4, options: nil, animations: { () -> Void in
            self.alpha = 1.0
            self.transform = CGAffineTransformIdentity
        }) { (finished) -> Void in
            if finished {
                // check
                var pathAnimation = CABasicAnimation(keyPath: "strokeEnd")
                pathAnimation.duration = 0.3
                pathAnimation.fromValue = 0
                pathAnimation.toValue = 1
                self.shapeLayer.addAnimation(pathAnimation, forKey: "strokeEndAnimation")
                let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * 0.7))
                dispatch_after(delay, dispatch_get_main_queue(), { () -> Void in
                    complete()
                    UIView.animateWithDuration(0.15, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.2, options: nil, animations: { () -> Void in
                        self.transform = CGAffineTransformMakeScale(0.1, 0.1)
                        self.alpha = 0.1
                    }, completion: { (finished) -> Void in
                        if finished {
                            self.hidden = true
                        }
                    })
                })
            }
        }
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
