//
//  CourseDetailView.swift
//  ColorgyCourse
//
//  Created by David on 2016/1/11.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

class CourseDetailView: UIView {

    var titleHeaderView: UIView?
    var headerTitleLabel: UILabel?
    
    var lecturerTitleLabel: UILabel?
    var codeTitleLabel: UILabel?
    var creditsTitleLabel: UILabel?
    
    var classmatesView: UIView?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func fakeData() {
        headerTitleLabel?.text = "kjdsuyuy"
        lecturerTitleLabel?.text = "ijdsjkdsjk"
        codeTitleLabel?.text = "iudasidsjk"
        creditsTitleLabel?.text = "i87cuj3"
    }
    
    convenience init() {
        self.init(frame: UIScreen.mainScreen().bounds)
        // title 90 pt height
        titleHeaderView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 90))
        titleHeaderView?.backgroundColor = UIColor(red:0.231,  green:0.227,  blue:0.231, alpha:1)
        headerTitleLabel = UILabel()
        headerTitleLabel?.font = UIFont(name: "STHeitiTC-Medium", size: 32)
        headerTitleLabel?.frame.size.height = 32
        headerTitleLabel?.frame.size.width = UIScreen.mainScreen().bounds.width - 32 * 2
        headerTitleLabel?.textColor = UIColor.whiteColor()
        headerTitleLabel?.center = titleHeaderView!.center
        titleHeaderView?.addSubview(headerTitleLabel!)
        self.addSubview(titleHeaderView!)
        
        // description
        // code lecturer credits
        lecturerTitleLabel = UILabel()
        lecturerTitleLabel?.textColor = UIColor(red:0.592,  green:0.592,  blue:0.592, alpha:1)
        lecturerTitleLabel?.font = UIFont(name: "STHeitiTC-Medium", size: 14)
        lecturerTitleLabel?.frame.size.height = 14
        var iconView = UIImageView(frame: CGRectMake(0, 0, 14, 14))
        iconView.image = UIImage(named: "lecturerIcon")
        var containerView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 44))
        containerView.backgroundColor = UIColor.whiteColor()
        iconView.frame.origin.x = 32
        iconView.center.y = containerView.bounds.midY
        lecturerTitleLabel?.frame.origin.x = iconView.frame.maxX + 8
        lecturerTitleLabel?.center.y = iconView.center.y
        lecturerTitleLabel?.frame.size.width = UIScreen.mainScreen().bounds.width - iconView.frame.maxX - 8 * 2
        containerView.addSubview(iconView)
        containerView.addSubview(lecturerTitleLabel!)
        containerView.frame.origin.y = 90
        self.addSubview(containerView)
        
        codeTitleLabel = UILabel()
        codeTitleLabel?.textColor = UIColor(red:0.592,  green:0.592,  blue:0.592, alpha:1)
        codeTitleLabel?.font = UIFont(name: "STHeitiTC-Medium", size: 14)
        codeTitleLabel?.frame.size.height = 14
        iconView = UIImageView(frame: CGRectMake(0, 0, 14, 14))
        iconView.image = UIImage(named: "codeIcon")
        containerView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 44))
        containerView.backgroundColor = UIColor.whiteColor()
        iconView.frame.origin.x = 32
        iconView.center.y = containerView.bounds.midY
        codeTitleLabel?.frame.origin.x = iconView.frame.maxX + 8
        codeTitleLabel?.center.y = iconView.center.y
        codeTitleLabel?.frame.size.width = UIScreen.mainScreen().bounds.width - iconView.frame.maxX - 8 * 2
        containerView.addSubview(iconView)
        containerView.addSubview(codeTitleLabel!)
        containerView.frame.origin.y = 90 + 45
        self.addSubview(containerView)
        
        creditsTitleLabel = UILabel()
        creditsTitleLabel?.textColor = UIColor(red:0.592,  green:0.592,  blue:0.592, alpha:1)
        creditsTitleLabel?.font = UIFont(name: "STHeitiTC-Medium", size: 14)
        creditsTitleLabel?.frame.size.height = 14
        iconView = UIImageView(frame: CGRectMake(0, 0, 14, 14))
        iconView.image = UIImage(named: "creditsIcon")
        containerView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 44))
        containerView.backgroundColor = UIColor.whiteColor()
        iconView.frame.origin.x = 32
        iconView.center.y = containerView.bounds.midY
        creditsTitleLabel?.frame.origin.x = iconView.frame.maxX + 8
        creditsTitleLabel?.center.y = iconView.center.y
        creditsTitleLabel?.frame.size.width = UIScreen.mainScreen().bounds.width - iconView.frame.maxX - 8 * 2
        containerView.addSubview(iconView)
        containerView.addSubview(creditsTitleLabel!)
        containerView.frame.origin.y = 90 + 45 * 2
        self.addSubview(containerView)
        
        // period/location s
        
        // my classmate
        classmatesView = UIView(frame: UIScreen.mainScreen().bounds)
        classmatesView?.frame.size.height = 44
        iconView = UIImageView(frame: CGRectMake(0, 0, 16, 16))
        iconView.image = UIImage(named: "classmatesIcon")
        iconView.frame.origin.x = 16
        iconView.center.y = classmatesView!.bounds.midY
        let classmatesLabel = UILabel(frame: UIScreen.mainScreen().bounds)
        classmatesLabel.frame.size.height = 16
        classmatesLabel.font = UIFont(name: "STHeitiTC-Medium", size: 16)
        classmatesLabel.frame.origin.x = iconView.frame.maxX + 15
        classmatesLabel.center.y = iconView.center.y
        classmatesLabel.text = "我的同學"
        classmatesView?.addSubview(iconView)
        classmatesView?.addSubview(classmatesLabel)
        classmatesView?.frame.origin.y = 90 + 45 * 3 + 8
        classmatesView?.backgroundColor = UIColor.whiteColor()
        self.addSubview(classmatesView!)
        
        // expand view
        self.frame.size.height = 90 + 45 * 3
    }
    
    func expandViewAndInsertPeriodAndLocation() {
        // check count
        
        // move classmates view
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
