//
//  ClassmateTimeTableViewController.swift
//  ColorgyCourse
//
//  Created by David on 2015/9/5.
//  Copyright (c) 2015年 David. All rights reserved.
//

import UIKit

class ClassmateTimeTableViewController: UIViewController {
    
    var timetable: TimeTableView!
    var headerImageView: UIImageView!
    var headerImageViewHeight: CGFloat!
    
    var userProfileImage: UIImage!
    
    // public API
    var userCourseObject: UserCourseObject!
    
    // private API
    private var courses: [Course]!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var contentScrollView = UIScrollView(frame: self.view.frame)
        contentScrollView.delegate = self
        self.view.addSubview(contentScrollView)
        
        // content size
        contentScrollView.contentSize = self.view.frame.size
        
        // image height
        headerImageViewHeight = self.view.frame.height / 2
        
        // timetable
        timetable = TimeTableView(frame: self.view.frame)
        timetable.expendFrameToFit()
        // adjust frame origin
        timetable.frame.origin.y = headerImageViewHeight
        timetable.delegate = self
        timetable.bounces = true
        
        // add to content view
        contentScrollView.addSubview(timetable)
        
        // adjust scroll content size
        contentScrollView.contentSize.height = timetable.bounds.height + headerImageViewHeight
        
        // configure header imageiview
        headerImageView = UIImageView(frame: CGRectMake(0, 0, self.view.bounds.width, headerImageViewHeight))
        headerImageView.contentMode = UIViewContentMode.ScaleAspectFill
        headerImageView.clipsToBounds = true
        contentScrollView.addSubview(headerImageView)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        loadUserImage()
        loadUserCourse()
    }
    
    func loadUserImage() {
        if userCourseObject != nil {
            ColorgyAPI.getUserInfo(user_id: userCourseObject.user_id, success: { (result) -> Void in
                let qos = Int(QOS_CLASS_USER_INTERACTIVE.value)
                dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in
                    if let url_string = result.avatar_url {
                        if let url = NSURL(string: url_string) {
                            if let data = NSData(contentsOfURL: url) {
                                println(data)
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    var transition = CATransition()
                                    transition.duration = 0.4
                                    transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                                    transition.type = kCATransitionFade
                                    self.userProfileImage = UIImage(data: data)
                                    self.headerImageView.image = self.userProfileImage
                                    self.headerImageView.layer.addAnimation(transition, forKey: nil)
                                })
                            }
                        }
                    }
                })
            }, failure: { () -> Void in
                
            })
        }
    }
    
    func loadUserCourse() {
        self.courses = [Course]()
        ColorgyAPI.getUserCoursesWithUserId("\(userCourseObject.user_id)", completionHandler: { (userCourseObjects) -> Void in
            if let userCourseObjects = userCourseObjects {
                for object in userCourseObjects {
                    ColorgyAPI.getCourseRawDataObjectWithCourseCode(object.course_code, completionHandler: { (courseRawDataObject) -> Void in
                        let qos = Int(QOS_CLASS_USER_INTERACTIVE.value)
                        dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in
                            if let courseRawDataObject = courseRawDataObject {
                                if let course = Course(rawData: courseRawDataObject) {
                                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                        self.courses.append(course)
                                        var b = NSDate()
                                        if userCourseObjects.count == self.courses.count {
                                            self.timetable.courses = self.courses
                                        }
                                        var now = NSDate().timeIntervalSinceDate(b)
                                        println(now*1000)
                                    })
                                }
                            }
                        })
                    })
                }
            }
            }, failure: { () -> Void in

        })
//        ColorgyAPI.getMeCourses({ (userCourseObjects) -> Void in
//            if let userCourseObjects = userCourseObjects {
//                for object in userCourseObjects {
//                    ColorgyAPI.getCourseRawDataObjectWithCourseCode(object.course_code, completionHandler: { (courseRawDataObject) -> Void in
//                        let qos = Int(QOS_CLASS_USER_INTERACTIVE.value)
//                        dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in
//                            if let courseRawDataObject = courseRawDataObject {
//                                if let course = Course(rawData: courseRawDataObject) {
//                                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                                        self.courses.append(course)
//                                        var b = NSDate()
//                                        if userCourseObjects.count == self.courses.count {
//                                            self.timetableView.courses = self.courses
//                                        }
//                                        var now = NSDate().timeIntervalSinceDate(b)
//                                        println(now*1000)
//                                    })
//                                }
//                            }
//                        })
//                    })
//                }
//            }
//            }, failure: { () -> Void in
//                
//        })
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }

    func updateHeader(scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y <= 0 {
            // scroll down
            let yOffset = -scrollView.contentOffset.y
            // enlarge
            headerImageView.bounds.size.height = headerImageViewHeight + yOffset
            // move up
            headerImageView.frame.origin.y = -yOffset
            // set image
            headerImageView.image = userProfileImage
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ClassmateTimeTableViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.updateHeader(scrollView)
    }
}

extension ClassmateTimeTableViewController : TimeTableViewDelegate {
    func timeTableViewDidScroll(scrollView: UIScrollView) {
        
    }
    
    func timeTableView(userDidTapOnCell cell: CourseCellView) {
        
    }
}
