//
//  AlertDeleteCourseView.swift
//  ColorgyCourse
//
//  Created by David on 2015/8/31.
//  Copyright (c) 2015年 David. All rights reserved.
//

import UIKit

protocol AlertDeleteCourseViewDelegate {
    func alertDeleteCourseView(didTapDeleteCourseAlertDeleteCourseView alertDeleteCourseView: AlertDeleteCourseView)
    func alertDeleteCourseView(didTapPreserveCourseAlertDeleteCourseView alertDeleteCourseView: AlertDeleteCourseView)
    func alertDeleteCourseView(didTapOnBackgroundAlertDeleteCourseView alertDeleteCourseView: AlertDeleteCourseView)
}

class AlertDeleteCourseView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    var delegate: AlertDeleteCourseViewDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init() {
        // 滿版！
        self.init(frame: UIScreen.mainScreen().bounds)
        // configure self view
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        
        // garbage can
        var garbageCanImageView = UIImageView(frame: CGRectMake(0, 0, 53, 63))
        garbageCanImageView.image = UIImage(named: "1.jpg")
        garbageCanImageView.contentMode = UIViewContentMode.ScaleAspectFill
        
        // confrim button
        var confirmButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        confirmButton.frame = CGRectMake(0, 0, 112, 32)
        confirmButton.tintColor = UIColor(red: 248/255.0, green: 150/255.0, blue: 128/255.0, alpha: 1)
        confirmButton.layer.borderColor = UIColor(red: 248/255.0, green: 150/255.0, blue: 128/255.0, alpha: 1).CGColor
        confirmButton.layer.borderWidth = 2.0
        confirmButton.layer.cornerRadius = 2.0
        confirmButton.setTitle("刪除課程", forState: UIControlState.Normal)
        
        // cancel button
        var cancelButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        cancelButton.frame = CGRectMake(0, 0, 112, 32)
        cancelButton.tintColor = UIColor(red: 248/255.0, green: 150/255.0, blue: 128/255.0, alpha: 1)
        cancelButton.layer.borderColor = UIColor(red: 248/255.0, green: 150/255.0, blue: 128/255.0, alpha: 1).CGColor
        cancelButton.layer.borderWidth = 2.0
        cancelButton.layer.cornerRadius = 2.0
        cancelButton.setTitle("保留課程", forState: UIControlState.Normal)
        
        // arrange position
        confirmButton.center = self.center
        // conform is below cancel
        cancelButton.center.x = confirmButton.center.x
        cancelButton.frame.origin.y = confirmButton.frame.origin.y + confirmButton.bounds.maxY + 12
        // garbage can is above cancel
        garbageCanImageView.center.x = confirmButton.center.x
        garbageCanImageView.frame.origin.y = confirmButton.frame.origin.y - garbageCanImageView.bounds.maxY - 16
        
        // add to subview
        self.addSubview(garbageCanImageView)
        self.addSubview(confirmButton)
        self.addSubview(cancelButton)
        
        // gesture
        var tap = UITapGestureRecognizer(target: self, action: "tap:")
        self.addGestureRecognizer(tap)
        confirmButton.addTarget(self, action: "deleteC", forControlEvents: UIControlEvents.TouchUpInside)
        cancelButton.addTarget(self, action: "preserveC", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func tap(gesture: UITapGestureRecognizer) {
        delegate?.alertDeleteCourseView(didTapOnBackgroundAlertDeleteCourseView: self)
    }
    
    func deleteC() {
        delegate?.alertDeleteCourseView(didTapDeleteCourseAlertDeleteCourseView: self)
    }
    
    func preserveC() {
        delegate?.alertDeleteCourseView(didTapPreserveCourseAlertDeleteCourseView: self)
    }
    
    func generateCover() {
        // draw a garbage can
        var path = UIBezierPath()
        path.moveToPoint(CGPoint(x: 0, y: 0))
        // up
        path.addLineToPoint(CGPoint(x: 0, y: -10))
        path.addArcWithCenter(CGPoint(x: 2, y: -10), radius: 2, startAngle: CGFloat(-M_PI), endAngle: CGFloat(-M_PI / 2), clockwise: true)
        path.moveToPoint(CGPoint(x: 2, y: -12))
        path.addLineToPoint(CGPoint(x: 32, y: -12))
        path.addArcWithCenter(CGPoint(x: 32, y: -10), radius: 2, startAngle: CGFloat(-M_PI / 2), endAngle: CGFloat(0), clockwise: true)
        path.moveToPoint(CGPoint(x: 34, y: -10))
        path.addLineToPoint(CGPoint(x: 34, y: 0))
        // right
        path.addLineToPoint(CGPoint(x: 84, y: 0))
        path.addArcWithCenter(CGPoint(x: 84, y: 2), radius: 2, startAngle: CGFloat(-M_PI / 2), endAngle: CGFloat(0), clockwise: true)
        // down
        path.moveToPoint(CGPoint(x: 86, y: 2))
        path.addLineToPoint(CGPoint(x: 86, y: 12))
        // left
        path.addArcWithCenter(CGPoint(x: 84, y: 12), radius: 2, startAngle: CGFloat(0), endAngle: CGFloat(M_PI / 2), clockwise: true)
        path.moveToPoint(CGPoint(x: 84, y: 14))
        path.addLineToPoint(CGPoint(x: -50, y: 14))
        // up
        path.addArcWithCenter(CGPoint(x: -50, y: 12), radius: 2, startAngle: CGFloat(M_PI / 2), endAngle: CGFloat(-M_PI), clockwise: true)
        path.moveToPoint(CGPoint(x: -52, y: 12))
        path.addLineToPoint(CGPoint(x: -52, y: 2))
        // right
        path.addArcWithCenter(CGPoint(x: -50, y: 2), radius: 2, startAngle: CGFloat(-M_PI), endAngle: CGFloat(-M_PI / 2), clockwise: true)
        path.moveToPoint(CGPoint(x: -50, y: 0))
        path.addLineToPoint(CGPoint(x: 0+1.5, y: 0))
        //        path.closePath()
        
        //        path.closePath()
        
        var shapeLayer = CAShapeLayer()
        shapeLayer.path = path.CGPath
        shapeLayer.strokeColor = UIColor.whiteColor().CGColor
        shapeLayer.lineWidth = 3.0
        shapeLayer.fillColor = UIColor.clearColor().CGColor
        shapeLayer.position = CGPoint(x: 200, y: 200)
        
        self.layer.addSublayer(shapeLayer)
    }

}
