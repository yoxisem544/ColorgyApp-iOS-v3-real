//
//  ClassmatesContainerView.swift
//  ColorgyCourse
//
//  Created by David on 2015/9/5.
//  Copyright (c) 2015年 David. All rights reserved.
//

import UIKit

protocol ClassmatesContainerViewDelegate {
    func classmatesContainerView(userDidTapOnUser userCourseObject: UserCourseObject)
}

class ClassmatesContainerView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init() {
        self.init(frame: UIScreen.mainScreen().bounds)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // public API
    var delegate: ClassmatesContainerViewDelegate!
    
    // set this and will resize this view
    var userCourseObjects: [UserCourseObject]! {
        didSet {
            self.resize()
            self.loadProfileImageViews()
        }
    }
    var profileImageViews: [UIImageView]!
    
    var peoplePerRow: Int = 3
    var spacing: CGFloat = 8.0
    
    private func resize() {
        // calculate counts in userCourseObjects
        if userCourseObjects != nil {
            profileImageViews = [UIImageView]()
            // determine people per rows, default is 3 people a row
            // calculate rows, divide by people
            var rows = userCourseObjects.count / peoplePerRow
            if userCourseObjects.count % peoplePerRow != 0 {
                rows++
            }
            // determine imageview height
            // width minus (peoplePerRow+1)*spacing
            let imageViewHeight: CGFloat = (self.bounds.width - (CGFloat(peoplePerRow + 1) * spacing)) / CGFloat(peoplePerRow)
            // loop through all objects
            for rowIndex in 0..<rows {
                // first new a containerview
                let containerView = UIView(frame: CGRectMake(0, CGFloat(rowIndex) * (imageViewHeight + spacing * 1), self.bounds.width, imageViewHeight + spacing * 1))
                for peopleIndex in 0..<peoplePerRow {
                    let profileImageView = UIImageView(frame: CGRectMake(0, 0, imageViewHeight, imageViewHeight))
                    // style
                    profileImageView.contentMode = UIViewContentMode.ScaleAspectFill
                    profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2
                    profileImageView.clipsToBounds = true
                    // need user interactable
                    profileImageView.userInteractionEnabled = true
                    // can tap
                    let tap = UITapGestureRecognizer(target: self, action: "tap:")
                    profileImageView.addGestureRecognizer(tap)
                    // need to pass self and its objects, use tag? also index of userCourseObjects
                    profileImageView.tag = (rowIndex * peoplePerRow + (peopleIndex))
                    // temp these image views
                    profileImageViews.append(profileImageView)
                    // check if end of row, be careful of end row
                    // TODO: check index problem
                    if (rowIndex * peoplePerRow + (peopleIndex)) < userCourseObjects.count {
                        // arrange
                        // x
                        profileImageView.frame.origin.x = CGFloat(peopleIndex + 1) * spacing + CGFloat(peopleIndex) * imageViewHeight
                        // y
                        print("containerView.bounds.midY \(containerView.bounds.midY)")
                        print("profileImageView.center.y \(profileImageView.center.y)")
                        profileImageView.center.y = containerView.bounds.midY
                        // add to its subview
                        containerView.addSubview(profileImageView)
                    }
                }
                // add container to selfview
                self.addSubview(containerView)
            }
            // after well prepared, resize view
            self.frame.size = CGSize(width: self.bounds.width, height: CGFloat(rows) * (imageViewHeight + spacing * 1))
        }
    }
    
    func loadProfileImageViews() {
        for userCourseObject in self.userCourseObjects.enumerate() {
            ColorgyAPI.getUserInfo(user_id: userCourseObject.element.user_id, success: { (result) -> Void in
                let qos = Int(QOS_CLASS_USER_INTERACTIVE.rawValue)
                dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in
                    if let ava_url = result.avatar_url {
                        if let url = NSURL(string: ava_url) {
                            if let data = NSData(contentsOfURL: url) {
                                let image = UIImage(data: data)
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    // back to main queue
                                    let transition = CATransition()
                                    transition.duration = 0.4
                                    transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                                    transition.type = kCATransitionFade
                                    self.profileImageViews[userCourseObject.index].image = image
                                    self.profileImageViews[userCourseObject.index].layer.addAnimation(transition, forKey: nil)
                                })
                            }
                        }
                    }
                })
            }, failure: { () -> Void in

            })
        }
    }
    
    func tap(gesture: UITapGestureRecognizer) {
        if let view = gesture.view {
            if view.tag < self.userCourseObjects.count {
                let object = self.userCourseObjects[view.tag]
                delegate?.classmatesContainerView(userDidTapOnUser: object)
            }
        }
    }
}
