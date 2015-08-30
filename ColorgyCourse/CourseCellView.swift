//
//  CourseCellView.swift
//  ColorgyAPIHandler
//
//  Created by David on 2015/8/30.
//  Copyright (c) 2015年 David. All rights reserved.
//

import UIKit

protocol CourseCellViewDelegate {
    func tapOnCourseCell(courseCellView: CourseCellView)
}

class CourseCellView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    // public API
    var courseInfo: Course!
    var index: Int! {
        didSet {
            updateUI()
        }
    }
    
    var delegate: CourseCellViewDelegate!
    
    // private API
    private var courseTitleLabel: UILabel!
    private var courseLocationLabel: UILabel!
    
    private func updateUI() {
        if courseInfo != nil {
            courseTitleLabel?.text = courseInfo?.name
            courseLocationLabel?.text = courseInfo?.locations?[index]
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(red: 80/255.0, green: 227/255.0, blue: 194/255.0, alpha: 1)
        self.layer.cornerRadius = 2.0
        self.clipsToBounds = true
        
        // tap gesture
        var tapGes = UITapGestureRecognizer(target: self, action: "tap:")
        self.addGestureRecognizer(tapGes)
        
        // labels
        self.courseTitleLabel = UILabel(frame: CGRectMake(0, 0, self.bounds.width, self.bounds.height / 2))
        self.courseTitleLabel.textAlignment = NSTextAlignment.Center
        self.courseTitleLabel.textColor = UIColor.whiteColor()
        self.courseTitleLabel.adjustsFontSizeToFitWidth = true
        self.courseTitleLabel.minimumScaleFactor = 0.8
        
        self.courseLocationLabel = UILabel(frame: CGRectMake(0, 0, self.bounds.width, self.bounds.height / 2))
        self.courseLocationLabel.textAlignment = NSTextAlignment.Center
        self.courseLocationLabel.textColor = UIColor.whiteColor()
        self.courseLocationLabel.adjustsFontSizeToFitWidth = true
        self.courseLocationLabel.minimumScaleFactor = 0.5
        
        self.courseTitleLabel.center.x = self.bounds.midX
        self.courseTitleLabel.center.y = (self.bounds.midY + self.bounds.minY) / 2
        
        self.courseLocationLabel.center.x = self.bounds.midX
        self.courseLocationLabel.center.y = (self.bounds.midY + self.bounds.maxY) / 2
        
        self.addSubview(self.courseTitleLabel)
        self.addSubview(self.courseLocationLabel)
    }
    
    func tap(gesture: UITapGestureRecognizer) {
        if let view = gesture.view as? CourseCellView {
            delegate?.tapOnCourseCell(view)
        }
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
