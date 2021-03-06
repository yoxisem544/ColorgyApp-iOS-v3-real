//
//  ClassmateTimeTableViewController.swift
//  ColorgyCourse
//
//  Created by David on 2015/9/5.
//  Copyright (c) 2015年 David. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics

class ClassmateTimeTableViewController: UIViewController {
    
    var timetable: TimeTableView!
    var headerView: ClassmateHeaderView!
    var headerImageViewHeight: CGFloat!
    
    var userProfileImage: UIImage!
    var coverPhoto: UIImage!
    // public API
    var userCourseObject: UserCourseObject!
    
    // private API
    private var courses: [Course]!
    
    var retryCounter = 20

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        // configure navigation bar

        // Do any additional setup after loading the view.
        let contentScrollView = UIScrollView(frame: self.view.frame)
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
        headerView = ClassmateHeaderView(frame: CGRectMake(0, 0, self.view.frame.width, headerImageViewHeight))
        headerView.delegate = self
        contentScrollView.addSubview(headerView)
        contentScrollView.contentInset.bottom = 49
        
        let qos = Int(QOS_CLASS_USER_INTERACTIVE.rawValue)
        dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in
            // load data, not on main queue
            self.loadUserImage()
            self.loadUserCourse()
        })
		Mixpanel.sharedInstance().track(MixpanelEvents.showOthersTable)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if Release.mode {
			let params: [String : AnyObject] = ["user_id": userCourseObject.user_id]
			Analytics.trackUsingTimeTable(params)
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        if Release.mode {
           Analytics.stopTrackingUsingTimeTable()
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func loadUserImage() {
        if userCourseObject != nil {
            ColorgyAPI.getUserInfo(user_id: userCourseObject.user_id, success: { (result) -> Void in
                let qos = Int(QOS_CLASS_USER_INTERACTIVE.rawValue)
                dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in
                    if let url_string = result.avatar_url {
                        if let url = NSURL(string: url_string) {
                            if let data = NSData(contentsOfURL: url) {
                                print(data)
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    let transition = CATransition()
                                    transition.duration = 0.4
                                    transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                                    transition.type = kCATransitionFade
                                    self.userProfileImage = UIImage(data: data)
                                    self.headerView.userProfileImage?.image = self.userProfileImage
                                    self.headerView.userProfileImage?.layer.addAnimation(transition, forKey: nil)
                                })
                            }
                        }
                    }
                    // username
                    if let username = result.name {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            let transition = CATransition()
                            transition.duration = 0.4
                            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                            transition.type = kCATransitionFade
                            self.headerView.userNameLabel?.text = username
                            self.headerView.userNameLabel?.layer.addAnimation(transition, forKey: nil)
                        })
                    }
                    // user cover_photo
                    if let url_string = result.cover_photo_url {
                        if let url = NSURL(string: url_string) {
                            if let data = NSData(contentsOfURL: url) {
                                print(data)
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    let transition = CATransition()
                                    transition.duration = 0.4
                                    transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                                    transition.type = kCATransitionFade
                                    self.coverPhoto = UIImage(data: data)
                                    self.headerView.coverImageView?.image = self.coverPhoto
                                    self.headerView.coverImageView?.layer.addAnimation(transition, forKey: nil)
                                    self.headerView.xOffset = 0
                                })
                            }
                        }
                    }
                })
            }, failure: { () -> Void in
                // maybe just reload, delay for 2 second.
                if self.retryCounter > 0 {
                    self.retryCounter -= 1
                    let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * 2.0))
                    dispatch_after(delay, dispatch_get_main_queue(), { () -> Void in
                        print("retrying")
                        self.loadUserImage()
                    })
                }
            })
        }
    }
    
    func loadUserCourse() {
        self.courses = [Course]()
        // check privacy setting
		print("getting user \(userCourseObject.user_id)")
        ColorgyAPI.GetUserPrivacySetting(userId: userCourseObject.user_id, success: { (isTimeTablePublic) -> Void in
			print(isTimeTablePublic)
            if isTimeTablePublic {
                ColorgyAPI.getUserCoursesWithUserId("\(self.userCourseObject.user_id)", completionHandler: { (userCourseObjects) -> Void in
                    if let userCourseObjects = userCourseObjects {
                        print(userCourseObjects)
                        // check only the match org, filter the other
                        let organizationCode = UserSetting.UserPossibleOrganization()
                        var filteredUserCourseObjects = [UserCourseObject]()
                        for object in userCourseObjects {
                            if let code = object.course_organization_code {
                                if code == organizationCode {
                                    filteredUserCourseObjects.append(object)
                                }
                            }
                        }
                        for object in filteredUserCourseObjects {
                            ColorgyAPI.getCourseRawDataObjectWithCourseCode(object.course_code, success: { (courseRawDataObject) -> Void in
                                let qos = Int(QOS_CLASS_USER_INTERACTIVE.rawValue)
                                dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in
                                    if let course = Course(rawData: courseRawDataObject) {
                                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                            self.courses.append(course)
                                            let b = NSDate()
                                            if filteredUserCourseObjects.count == self.courses.count {
                                                self.timetable.courses = self.courses
                                            }
                                            let now = NSDate().timeIntervalSinceDate(b)
                                            print(now*1000)
                                        })
                                    }
                                })
                                }, failure: { () -> Void in
                                    // TODO: ???
                            })
                        }
                    }
                    }, failure: { () -> Void in
                        // maybe just reload, delay for 2 second.
                        let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * 2.0))
                        dispatch_after(delay, dispatch_get_main_queue(), { () -> Void in
                            print("retrying")
                            self.loadUserCourse()
                        })
                })
            } else {
                // TODO: handle privacy setting
            }
            }, failure: { () -> Void in
                if self.retryCounter > 0 {
                    self.retryCounter -= 1
                    let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * 2.0))
                    dispatch_after(delay, dispatch_get_main_queue(), { () -> Void in
                        print("retrying")
                        self.loadUserCourse()
                    })
                }
        })
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }

    func updateHeader(scrollView: UIScrollView) {
        
        // scroll down
        let yOffset = -scrollView.contentOffset.y
        // enlarge
        self.headerView.yOffset = yOffset
    }
    
    func shiftHeader(scrollView: UIScrollView) {
        
        let offset = -scrollView.contentOffset.x
        self.headerView.xOffset = offset * 0.3
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Show Detail Course" {
            let vc = segue.destinationViewController as! DetailCourseViewController
            if let course = sender as? Course {
                vc.course = course
            }
        }
    }

}

extension ClassmateTimeTableViewController : ClassmateHeaderViewDelegate {
    func classmateHeaderViewBacButtonClicked() {
        self.navigationController?.popViewControllerAnimated(true)
    }
}

extension ClassmateTimeTableViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.updateHeader(scrollView)
    }
}

extension ClassmateTimeTableViewController : TimeTableViewDelegate {
    func timeTableViewDidScroll(scrollView: UIScrollView) {
        shiftHeader(scrollView)
    }
    
    func timeTableView(userDidTapOnCourseCell cell: CourseCellView) {
        if let course = cell.courseInfo {
            self.performSegueWithIdentifier("Show Detail Course", sender: course)
        }
    }
    
    func timeTableView(userDidTapOnLocalCourseCell cell: CourseCellView) {
        
    }
}
