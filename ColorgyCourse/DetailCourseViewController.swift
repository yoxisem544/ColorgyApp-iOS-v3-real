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
    
    private func updateUI() {
        detailNavigationItem?.title = course.name
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var headerViews = NSBundle.mainBundle().loadNibNamed("CourseDetailHeaderView", owner: self, options: nil)
        let headerView = headerViews[0] as! CourseDetailHeaderView
        headerView.frame = CGRectMake(0, 0, self.view.frame.width, 330)
        headerView.autoresizingMask = self.view.autoresizingMask
        headerView.translatesAutoresizingMaskIntoConstraints()
        
        //
        self.automaticallyAdjustsScrollViewInsets = false
        
        // content scorll view
        self.contentScrollView = UIScrollView(frame: CGRectMake(0, navHeight, self.view.frame.width, self.view.frame.height - navHeight - tabBarHeight))
        self.contentScrollView.backgroundColor = UIColor.lightGrayColor()
        self.view.addSubview(self.contentScrollView)
        self.contentScrollView.addSubview(headerView)
        self.contentScrollView.contentSize = self.view.bounds.size
        
        // test
        classmatesView = ClassmatesContainerView()
        classmatesView.frame.origin.y = 330
        classmatesView.backgroundColor = UIColor.blueColor()
        self.contentScrollView.addSubview(classmatesView)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        downloadCourseInfo()
    }
    
    private func downloadCourseInfo() {
        ColorgyAPI.getStudentsInSpecificCourse(course.code, completionHandler: { (userCourseObjects) -> Void in
            if let userCourseObjects = userCourseObjects {
                self.userCourseObjects = userCourseObjects
                println(userCourseObjects)
                self.classmatesView.userCourseObjects = userCourseObjects
            }
        })
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DetailCourseViewController : ClassmatesContainerViewDelegate {
    func classmatesContainerView(userDidTapOnUser userCourseObject: UserCourseObject) {
        println(userCourseObject)
    }
}
