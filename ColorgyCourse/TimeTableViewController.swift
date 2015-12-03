//
//  TimeTableViewController.swift
//  ColorgyCourse
//
//  Created by David on 2015/9/5.
//  Copyright (c) 2015年 David. All rights reserved.
//

import UIKit

class TimeTableViewController: UIViewController {
    
    var timetableView: TimeTableView!
    let navHeight: CGFloat = 64.0
    let tabBarHeight: CGFloat = 49.0
    
    var courses: [Course]!

    @IBAction func addCourseButtonClicked(sender: AnyObject) {
        if Release().mode {
            Flurry.logEvent("v3.0: User Tap Add Button To Search Course View")
        }
        self.performSegueWithIdentifier("Show Add Course", sender: sender)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // timetableview
        timetableView = TimeTableView(frame: CGRectMake(0, navHeight, self.view.frame.width, self.view.frame.height - navHeight - tabBarHeight))
        self.view.addSubview(timetableView)
        timetableView.delegate = self
//        timetableView.courses
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if Release().mode {
            Flurry.logEvent("v3.0: User Using User Timetable", timed: true)
        } else {
            Flurry.logEvent("test: Using User Timetable", timed: true)
        }
        
        // check token
        checkToken()
        
        // get courses from db
        getAndSetDataToTimeTable()
        
        // test update
//        CourseUpdateHelper.updateCourse()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        if Release().mode {
            Flurry.endTimedEvent("User Using User Timetable", withParameters: nil)
        } else {
            Flurry.logEvent("test: Using User Timetable", timed: true)
        }
    }
    
    private func checkToken() {
        ColorgyAPI.checkIfTokenHasExpired(unexpired: { () -> Void in
            // if accesstoken work, update course
            CourseUpdateHelper.updateCourse({ () -> Void in
                self.getAndSetDataToTimeTable()
            })
            }, expired: { () -> Void in
                NetwrokQualityDetector.isNetworkStableToUse(stable: { () -> Void in
                    ColorgyAPITrafficControlCenter.refreshAccessToken({ (loginResult) -> Void in
                        // if user get a new token
                        // load data again
                        self.getAndSetDataToTimeTable()
                        print(UserSetting.UserAccessToken())
                        }, failure: { () -> Void in
                            if !ColorgyAPITrafficControlCenter.isRefershTokenRefreshable() {
                                let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * 0.5))
                                dispatch_after(delay, dispatch_get_main_queue(), { () -> Void in
                                    let alert = UIAlertController(title: "驗證過期", message: "請重新登入", preferredStyle: UIAlertControllerStyle.Alert)
                                    let ok = UIAlertAction(title: "好", style: UIAlertActionStyle.Cancel, handler: {(hey) -> Void in
                                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                        let vc = storyboard.instantiateViewControllerWithIdentifier("Main Login View") as! FBLoginViewController
                                        self.presentViewController(vc, animated: true, completion: nil)
                                    })
                                    alert.addAction(ok)
                                    self.presentViewController(alert, animated: true, completion: nil)
                                })
                            }
                    })
                }, unstable: { () -> Void in
                    // not good network, dont update
                })
        })
        
//        
//        NetwrokQualityDetector.isNetworkStableToUse(stable: { () -> Void in
//            ColorgyAPI.checkIfTokenHasExpired(unexpired: { () -> Void in
//                // if accesstoken work, update course
//                CourseUpdateHelper.updateCourse()
//            }, expired: { () -> Void in
//                ColorgyAPITrafficControlCenter.refreshAccessToken({ (loginResult) -> Void in
//                    // if user get a new token
//                    // load data again
//                    self.getAndSetDataToTimeTable()
//                    println(UserSetting.UserAccessToken())
//                    }, failure: { () -> Void in
//                        if !ColorgyAPITrafficControlCenter.isRefershTokenRefreshable() {
//                            let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * 0.5))
//                            dispatch_after(delay, dispatch_get_main_queue(), { () -> Void in
//                                let alert = UIAlertController(title: "驗證過期", message: "請重新登入", preferredStyle: UIAlertControllerStyle.Alert)
//                                let ok = UIAlertAction(title: "好", style: UIAlertActionStyle.Cancel, handler: {(hey) -> Void in
//                                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                                    let vc = storyboard.instantiateViewControllerWithIdentifier("Main Login View") as! FBLoginViewController
//                                    self.presentViewController(vc, animated: true, completion: nil)
//                                })
//                                alert.addAction(ok)
//                                self.presentViewController(alert, animated: true, completion: nil)
//                            })
//                        }
//                    })
//                })
//            }) { () -> Void in
//                // if accesstoken not work, do nothing
////                CourseUpdateHelper.updateCourse()
//        }
    }
    
    private func getAndSetDataToTimeTable() {
        let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
        dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in
            var courses = [Course]()
            if let objects = CourseDB.getAllStoredCoursesObject() {
                for obj in objects {
                    if let course = Course(courseDBManagedObject: obj) {
                        courses.append(course)
                    }
                }
//                print(courses)
            }
            CourseNotification.registerForCourseNotification()
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.timetableView.courses = courses
            })
        })
    }
    
    private func downloadAndRefreshTable() {
        let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
//        let qos = Int(QOS_CLASS_USER_INTERACTIVE.value)
        dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in
            self.courses = [Course]()
            ColorgyAPI.getMeCourses({ (userCourseObjects) -> Void in
                if let userCourseObjects = userCourseObjects {
                    for object in userCourseObjects {
                        ColorgyAPI.getCourseRawDataObjectWithCourseCode(object.course_code, completionHandler: { (courseRawDataObject) -> Void in
//                            let qos = Int(QOS_CLASS_USER_INTERACTIVE.value)
                            let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
                            dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in
                                if let courseRawDataObject = courseRawDataObject {
                                    if let course = Course(rawData: courseRawDataObject) {
                                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                            self.courses.append(course)
                                            let b = NSDate()
                                            if userCourseObjects.count == self.courses.count {
                                                self.timetableView.courses = self.courses
                                            }
                                            let now = NSDate().timeIntervalSinceDate(b)
                                            print(now*1000)
                                        })
                                    }
                                }
                            })
                        })
                    }
                }
            }, failure: { () -> Void in
                
            })
        })
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Timetable Show Detail Info" {
            let destinationVC = segue.destinationViewController as! DetailCourseViewController
            destinationVC.course = sender as! Course
        }
    }

}

extension TimeTableViewController : TimeTableViewDelegate {
    func timeTableView(userDidTapOnCell cell: CourseCellView) {
        if Release().mode {
            Flurry.logEvent("v3.0: User Tap on Course on Their Timetable")
        }
        self.performSegueWithIdentifier("Timetable Show Detail Info", sender: cell.courseInfo)
    }
    
    func timeTableViewDidScroll(scrollView: UIScrollView) {
        
    }
}
