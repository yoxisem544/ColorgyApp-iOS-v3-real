//
//  ClassmateHeaderView.swift
//  ColorgyCourse
//
//  Created by David on 2015/9/7.
//  Copyright (c) 2015年 David. All rights reserved.
//

import UIKit

protocol ClassmateHeaderViewDelegate {
    func classmateHeaderViewBacButtonClicked()
}

class ClassmateHeaderView: UIView {
    
    var originHeight: CGFloat!
    
    var coverImageView: UIImageView!
    var headerImageViewHeight: CGFloat!
    var dimView: UIView!
    
    var userProfileImage: UIImageView!
    var userProfileImageHeight: CGFloat!
    var userNameLabel: UILabel!
    
    var backButton: UIButton!
    
    var delegate: ClassmateHeaderViewDelegate!
    
    var yOffset: CGFloat! {
        didSet {
            updateUI()
        }
    }
    
    var xOffset: CGFloat! {
        didSet {
            shiftCover()
        }
    }
    
    private func shiftCover() {
        if coverImageView.image != nil {
            let multipler = coverImageView.image!.size.width / coverImageView.image!.size.height / 3
            coverImageView.frame.origin.x = xOffset * multipler + 10
        }
    }
    
    private func updateUI() {
        if yOffset >= 0 {
            // enlarge
            self.bounds.size.height = headerImageViewHeight + yOffset
            coverImageView.bounds.size.height = self.bounds.size.height
            dimView.bounds.size.height = coverImageView.bounds.size.height
            userProfileImage.bounds.size = CGSize(width: userProfileImageHeight + yOffset, height: userProfileImageHeight + yOffset)
            // move up
            self.frame.origin.y = -yOffset
            coverImageView.frame.origin.y = 0
            dimView.frame.origin.y = 0
            // set image
            
            // user name profile image
            userProfileImage.center = dimView.center
            userProfileImage.layer.cornerRadius = userProfileImage.bounds.width / 2
            userNameLabel.frame.origin.y = userProfileImage.frame.origin.y + userProfileImage.bounds.maxY + 16
        }
        
        // hide show button
        println(yOffset)
        if -yOffset >= 0 {
            // probelm with going up
            // maybe add height of button
            if originHeight <= self.bounds.height {
                self.bounds.size.height = originHeight
            }
//            backButton.frame.origin.y = (self.bounds.maxY - (-yOffset + 32))
            backButton.frame.origin.y = self.frame.origin.y - yOffset + 20
            // 12 + 20 + 32 is bottom margin buttonheight and top margin
            // but 12 top is now gone, 20 of status bar is left
            println("self.bounds.height \(self.bounds.height)")
            // top is 20 for status bar, 12 for invisible status bar and button margin
            if -yOffset >= (self.bounds.height - 20 - 12 - backButton.bounds.height) {
                backButton.frame.origin.y = (self.bounds.height - 20 - backButton.bounds.height)
            }
        } else {
            backButton.frame.origin.y = 20
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = true
        originHeight = frame.height
        // background
        headerImageViewHeight = frame.height
        coverImageView = UIImageView(frame: CGRectMake(0, 0, self.bounds.width, self.bounds.height))
        coverImageView.contentMode = UIViewContentMode.ScaleAspectFill
        xOffset = 0
//        coverImageView.clipsToBounds = true
        self.addSubview(coverImageView)
        
        //configure dimView
        // black view on top of headerimageview
        dimView = UIView(frame: coverImageView.frame)
        dimView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.addSubview(dimView)
        dimView.frame.origin = coverImageView.frame.origin
        
        // user name, profile image
        userProfileImageHeight = self.bounds.width * 0.3
        userProfileImage = UIImageView(frame: CGRectMake(0, 0, userProfileImageHeight, userProfileImageHeight))
        userProfileImage.clipsToBounds = true
        userProfileImage.contentMode = UIViewContentMode.ScaleAspectFill
        userProfileImage.layer.cornerRadius = userProfileImage.bounds.width / 2
        dimView.addSubview(userProfileImage)
        userProfileImage.center = coverImageView.center
        
        userNameLabel = UILabel(frame: CGRectMake(0, 0, self.bounds.width * 0.8, 20))
        userNameLabel.font = UIFont(name: "STHeitiTC-Medium", size: 20)
        userNameLabel.textColor = UIColor.whiteColor()
        userNameLabel.textAlignment = NSTextAlignment.Center
        dimView.addSubview(userNameLabel)
        userNameLabel.center.x = self.bounds.midX
        userNameLabel.frame.origin.y = userProfileImage.frame.origin.y + userProfileImage.bounds.maxY + 16
        
        // add buttons
        var backImage = UIImageView(image: UIImage(named: "backButtonWhite"))
//        backButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
//        backButton.frame = CGRectMake(16, 32, 12, 20)
        backButton = UIButton(frame: backImage.frame)
        backButton.frame.origin = CGPoint(x: 0, y: 20)
        backButton.frame.size.height = 20 + 24
        backButton.frame.size.width = 16 + 12 + 16
//        backButton.tintColor = UIColor.whiteColor()
        backButton.setImage(backImage.image, forState: UIControlState.Normal)
        backButton.addTarget(self, action: "backButtonClicked", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(backButton)
        self.userInteractionEnabled = true
//        userProfileImage.addSubview(backButton)
    }
    
    func backButtonClicked() {
        delegate?.classmateHeaderViewBacButtonClicked()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
