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
        downloadAndRefreshTable()
    }
    
    private func downloadAndRefreshTable() {
        let qos = Int(QOS_CLASS_USER_INTERACTIVE.value)
        dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in
            self.courses = [Course]()
            ColorgyAPI.getMeCourses({ (userCourseObjects) -> Void in
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
                                                self.timetableView.courses = self.courses
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
        self.performSegueWithIdentifier("Timetable Show Detail Info", sender: cell.courseInfo)
    }
    
    func timeTableViewDidScroll(scrollView: UIScrollView) {
        
    }
}
