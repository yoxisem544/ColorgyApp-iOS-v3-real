//
//  DetailCourseViewController.swift
//  ColorgyCourse
//
//  Created by David on 2015/9/5.
//  Copyright (c) 2015年 David. All rights reserved.
//

import UIKit

class DetailCourseViewController: UIViewController {
    
    @IBOutlet weak var detailNavigationItem: UINavigationItem!
    
    var course: Course! {
        didSet {
            updateUI()
        }
    }
    
    var localCourse: LocalCourse! {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        if course != nil {
            detailNavigationItem?.title = course?.name
        } else if localCourse != nil {
            detailNavigationItem?.title = localCourse?.name
        }
    }
    
    // containers
    var userCourseObjects: [UserCourseObject]!
    
    // views
    var contentScrollView: UIScrollView!
    let navHeight: CGFloat = 64.0
    let tabBarHeight: CGFloat = 49.0
    let statusBarHeight: CGFloat = 20.0
    
    // classamtes view
    var classmatesView: ClassmatesContainerView!
    var courseDetailView: CourseDetailView!
    
    var retryCounter = 10
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        var headerViews = NSBundle.mainBundle().loadNibNamed("CourseDetailHeaderView", owner: self, options: nil)
//        let headerView = headerViews[0] as! CourseDetailHeaderView
//        headerView.frame = CGRectMake(0, 0, self.view.frame.width, 330)
//        headerView.autoresizingMask = self.view.autoresizingMask
////        headerView.translatesAutoresizingMaskIntoConstraints()
//        headerView.translatesAutoresizingMaskIntoConstraints = true
//
//        // set content
//        headerView.course = course
        
        //
        self.automaticallyAdjustsScrollViewInsets = false
        
        // content scorll view
        self.contentScrollView = UIScrollView(frame: CGRectMake(0, navHeight, self.view.frame.width, self.view.frame.height - navHeight - tabBarHeight))
        self.contentScrollView.backgroundColor = UIColor(red: 250/255.0, green: 247/255.0, blue: 245/255.0, alpha: 1)
        self.view.addSubview(self.contentScrollView)
//        self.contentScrollView.addSubview(headerView)
        self.contentScrollView.contentSize = self.view.bounds.size
//        self.contentScrollView.contentInset.bottom = 49
        
        // test
        courseDetailView = CourseDetailView()
        courseDetailView.course = course
        courseDetailView.localCourse = localCourse
        self.contentScrollView.addSubview(courseDetailView)
        
        // test
        classmatesView = ClassmatesContainerView()
        classmatesView.frame.origin.y = courseDetailView.frame.height
        classmatesView.backgroundColor = UIColor.whiteColor()
        classmatesView.delegate = self
        classmatesView.peoplePerRow = 4
        self.contentScrollView.addSubview(classmatesView)
        
        
        
        downloadCourseInfo()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // Flurry
        if Release().mode {
            Flurry.logEvent("v3.0: User Using Detail Course View", timed: true)
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        if Release().mode {
            Flurry.endTimedEvent("v3.0: User Using Detail Course View", withParameters: nil)
        }
    }
    
    private func downloadCourseInfo() {
        if course != nil {
            let qos = Int(QOS_CLASS_USER_INTERACTIVE.rawValue)
            dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in
           
                ColorgyAPI.getStudentsInSpecificCourse(self.course.code, success: { (userCourseObjects) -> Void in
                    print(userCourseObjects)
                    self.userCourseObjects = userCourseObjects
                    print(userCourseObjects)
                    // set and will auto adjust hieght
                    self.classmatesView.userCourseObjects = userCourseObjects
                    // adjust content size height
                    self.contentScrollView.contentSize.height = self.courseDetailView.frame.height + self.classmatesView.bounds.size.height
                    }, failure: { () -> Void in
                        // retry
                        if self.retryCounter > 0 {
                            print("retry to download course again")
                            self.retryCounter -= 1
                            let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * 2.0))
                            dispatch_after(delay, dispatch_get_main_queue(), { () -> Void in
                                self.downloadCourseInfo()
                            })
                        }
                })
            })
        } else if localCourse != nil {
            self.contentScrollView.contentSize.height = self.courseDetailView.frame.height
            self.courseDetailView.classmatesView?.hidden = true
            self.classmatesView.hidden = true
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateUI()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateUI()
    }
    

    @IBAction func backButtonClicked(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Show Classmate Timetable" {
            let vc = segue.destinationViewController as! ClassmateTimeTableViewController
            if let userCourseObject = sender as? UserCourseObject {
                vc.userCourseObject = userCourseObject
            }
        }
    }

}

extension DetailCourseViewController : ClassmatesContainerViewDelegate {
    func classmatesContainerView(userDidTapOnUser userCourseObject: UserCourseObject) {
        print(userCourseObject)
        // Flurry
        if Release().mode {
            Flurry.logEvent("v3.0: User Tap on Classmate's Profile Photo", withParameters: ["user_id": userCourseObject.user_id])
        }
        self.performSegueWithIdentifier("Show Classmate Timetable", sender: userCourseObject)
    }
}
