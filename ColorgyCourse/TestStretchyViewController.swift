//
//  TestStretchyViewController.swift
//  ColorgyCourse
//
//  Created by David on 2015/9/2.
//  Copyright (c) 2015年 David. All rights reserved.
//

import UIKit

class TestStretchyViewController: UIViewController {
    
    var tm: TimeTableView!
    var headerImageView: UIImageView!
    var headerImageViewHeight: CGFloat!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var backScrollV = UIScrollView(frame: self.view.frame)
        backScrollV.backgroundColor = UIColor.brownColor()
        
        self.view.addSubview(backScrollV)
        
        // content size
        backScrollV.contentSize = self.view.bounds.size
        
        tm = TimeTableView(frame: self.view.frame)
        // expend this view, same width, but full height
        // origin of calling this method will set to Zero
        tm.expendFrameToFit()
        // move down
        tm.frame.origin.y = self.view.frame.height / 2
        backScrollV.addSubview(tm)
        backScrollV.delegate = self
        backScrollV.contentSize.height = tm.bounds.height + self.view.bounds.height / 2
        
        tm.delegate = self
        tm.bounces = true
        
        // add a imageview
        headerImageView = UIImageView(frame: CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height / 2))
        headerImageView.image = UIImage(named: "4.jpg")
        headerImageView.contentMode = UIViewContentMode.ScaleAspectFill
        headerImageView.clipsToBounds = true
        backScrollV.addSubview(headerImageView)
        
        headerImageViewHeight = headerImageView.bounds.height
        
        // test db
        CourseDB.storeFakeData()
        var dd = CourseDB.getAllStoredCoursesObject()
        println(dd!)
        println(dd!.first?.code)
        println(dd!.first?.period_1)
        var yo = Course(courseDBManagedObject: dd!.first)
        println(yo)
//        CourseDB.deleteAllCourses()
    }
    
    func updateHeaderView(scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y <= 0 {
//            println(scrollView.contentOffset.y)
            let yOffset = -scrollView.contentOffset.y
            // enlarge
//            println("headerImageViewHeight \(headerImageViewHeight)")
            headerImageView.bounds.size.height = headerImageViewHeight + yOffset
            headerImageView.image = UIImage(named: "4.jpg")
            headerImageView.frame.origin.y = -yOffset
        }
        
    }
    
    override func viewWillLayoutSubviews() {
        println("viewWillLayoutSubviews")
    }
    
    override func viewDidLayoutSubviews() {
        println("viewDidLayoutSubviews")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension TestStretchyViewController : TimeTableViewDelegate {
    func timeTableViewDidScroll(scrollView: UIScrollView) {
        
    }
    
    func timeTableView(userDidTapOnCell cell: CourseCellView) {
        
    }
}

extension TestStretchyViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        updateHeaderView(scrollView)
    }
}
