//
//  TimeTableView2.swift
//  ColorgyAPIHandler
//
//  Created by David on 2015/8/29.
//  Copyright (c) 2015年 David. All rights reserved.
//

import UIKit

protocol TimeTableViewDelegate {
    func timeTableView(userDidTapOnCourseCell cell: CourseCellView)
    func timeTableView(userDidTapOnLocalCourseCell cell: CourseCellView)
    func timeTableViewDidScroll(scrollView: UIScrollView)
}

class TimeTableView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    // public API
    var courses: [Course]? {
        didSet {
            deleteCourseCellView()
            setupCourseCellView()
        }
    }
    
    var localCourse: [LocalCourse]? {
        didSet {
            deleteCourseCellView()
            setupLocalCourseCellView()
        }
    }
    
    let cellColors = [
        UIColor(red:0.973,  green:0.588,  blue:0.502, alpha:1),
        UIColor(red:0.961,  green:0.651,  blue:0.137, alpha:1),
        UIColor(red:0.027,  green:0.580,  blue:0.749, alpha:1),
        UIColor(red:0,  green:0.816,  blue:0.678, alpha:1),
        UIColor(red:0.969,  green:0.420,  blue:0.616, alpha:1)
    ]
    
    var delegate: TimeTableViewDelegate!
    var bounces: Bool! {
        didSet {
            print("didset bounces \(bounces)")
            self.timetableContentScrollView.bounces = bounces
            self.sessionSideBarScrollView.bounces = bounces
            self.weekdayHeaderScrollView.bounces = bounces
            print("didset bounces \(self.timetableContentScrollView.bounces) \(self.sessionSideBarScrollView.bounces) \(self.weekdayHeaderScrollView.bounces)")
        }
    }
    
    func expendFrameToFit() {
        let tmHeight = self.timetableContentScrollView.contentSize.height
        self.timetableContentScrollView.bounds.size = CGSize(width: self.timetableContentScrollView.bounds.width, height: tmHeight)
        self.sessionSideBarScrollView.bounds.size = CGSize(width: self.sessionSideBarScrollView.bounds.width, height: tmHeight)
        
        self.timetableContentScrollView.frame.origin.y = self.weekdayHeaderHeight
        self.sessionSideBarScrollView.frame.origin.y = self.weekdayHeaderHeight
        
        self.bounds.size = CGSize(width: self.bounds.width, height: tmHeight + self.weekdayHeaderHeight)
        self.frame.origin = CGPointZero
    }
    
    // setup course cell views
    private var courseCellViewsOnTimetable: [CourseCellView]?
    private func setupCourseCellView() {
        // init container
        self.courseCellViewsOnTimetable = [CourseCellView]()
        if let courses = self.courses {
            for course in courses.enumerate() {
                // generate cell
                let views = generateCourseCellViewWithCourse(course.element)
                // add subview
                for view in views {
                    self.courseCellViewsOnTimetable?.append(view)
                    // change color
                    view.backgroundColor = cellColors[course.index%cellColors.count]
                }
            }
            // after getting course cell view
            // add these to view
            for ccv in self.courseCellViewsOnTimetable! {
                self.timetableContentScrollView.addSubview(ccv)
//                ccv.alpha = 0
//                UIView.animateWithDuration(0.4, animations: { () -> Void in
//                    ccv.alpha = 1
//                })
                ccv.alpha = 1
            }
        }
    }
    
    // local course
    private var localCourseCellViewsOnTimetable: [CourseCellView]?
    private func setupLocalCourseCellView() {
        // init container
        self.localCourseCellViewsOnTimetable = [CourseCellView]()
        if let courses = self.localCourse {
            for course in courses.enumerate() {
                // generate cell
                let views = generateCourseCellViewWithLocalCourse(course.element)
                // add subview
                for view in views {
                    self.localCourseCellViewsOnTimetable?.append(view)
                    // change color
                    view.backgroundColor = cellColors[course.index%cellColors.count]
                }
            }
            // after getting course cell view
            // add these to view
            for ccv in self.localCourseCellViewsOnTimetable! {
                self.timetableContentScrollView.addSubview(ccv)
                //                ccv.alpha = 0
                //                UIView.animateWithDuration(0.4, animations: { () -> Void in
                //                    ccv.alpha = 1
                //                })
                ccv.alpha = 1
            }
        }
    }
    
    private func generateCourseCellViewWithCourse(course: Course) -> [CourseCellView] {
        if let days = course.days {
            // check length
            if course.days?.count == course.periods?.count {
                // init array
                var views = [CourseCellView]()
                for dayOfCourse: (index: Int, element: Int) in days.enumerate() {
                    // get periods and day, loop through
                    let day = course.days![dayOfCourse.index]
                    let period = course.periods![dayOfCourse.index]
                    let view = courseCellViewOn(day: day, period: period)
                    // assign content and index to this view
                    view.courseInfo = course
                    view.index = dayOfCourse.index
                    // its delegate
                    view.delegate = self
                    views.append(view)
                }
                return views
            }
        }
        return []
    }
    
    private func generateCourseCellViewWithLocalCourse(localCourse: LocalCourse) -> [CourseCellView] {
        if let days = localCourse.days {
            // check length
            if localCourse.days?.count == localCourse.periods?.count {
                // init array
                var views = [CourseCellView]()
                for dayOfCourse: (index: Int, element: Int) in days.enumerate() {
                    // get periods and day, loop through
                    let day = localCourse.days![dayOfCourse.index]
                    let period = localCourse.periods![dayOfCourse.index]
                    let view = courseCellViewOn(day: day, period: period)
                    // assign content and index to this view
                    view.localCourseInfo = localCourse
                    view.index = dayOfCourse.index
                    // its delegate
                    view.delegate = self
                    views.append(view)
                }
                return views
            }
        }
        return []
    }
    
    private func courseCellViewOn(day day: Int, period: Int) -> CourseCellView {
        // day and period all starting from 1
        let cellV = CourseCellView(frame: CGRectMake(0, 0, courseCellWidth, courseCellHeight))
        let x = (courseContainerWidth / 2) + CGFloat(day - 1) * courseContainerWidth
        let y = (courseContainerHeight / 2) + CGFloat(period - 1) * courseContainerHeight
        cellV.center = CGPoint(x: x, y: y)
        
        return cellV
    }
    
    private func deleteCourseCellView() {
        if self.courseCellViewsOnTimetable != nil {
            // 有東西
            for cellView in self.courseCellViewsOnTimetable! {
                cellView.removeFromSuperview()
            }
        }
    }
    
    private func deleteLocalCourseCellView() {
        if self.localCourseCellViewsOnTimetable != nil {
            // 有東西
            for cellView in self.localCourseCellViewsOnTimetable! {
                cellView.removeFromSuperview()
            }
        }
    }
    
    // private properties
    private let screenWidth: CGFloat
    
    private let sessionSideBarWidth: CGFloat = 37
    
    private let courseCellWidth: CGFloat
    private let courseCellHeight: CGFloat = 44
    private let courseCellSpacing: CGFloat = 2
    private let courseContainerWidth: CGFloat
    private let courseContainerHeight: CGFloat
    
    let weekdayHeaderHeight: CGFloat = 35
    
    var timetableContentScrollView: UIScrollView!
    private var weekdayHeaderScrollView: UIScrollView!
    private var sessionSideBarScrollView: UIScrollView!
    
    override init(frame: CGRect) {
        // get screen width
        screenWidth = UIScreen.mainScreen().bounds.width
        // we have 4 spacings between 5 days.
        // so here we want to get cell size
        // first, delete side bar width and 4 spacings
        // then divide by 5, cause we want to see 5 cell a time
        courseCellWidth = (screenWidth - (4 * courseCellSpacing) - sessionSideBarWidth) / CGFloat(5)
        // this is width without spacing, more accurate for align
        courseContainerWidth = (screenWidth - sessionSideBarWidth) / CGFloat(5)
        // height of container is 1 pixel lager then cell height
        courseContainerHeight = courseCellHeight + 2
        
        // init!
        super.init(frame: frame)
        
        let periods = UserSetting.getPeriodData()
        
        // first configure session side bar view
        let sessionSideBarView = UIView(frame: CGRectMake(0, 0, sessionSideBarWidth, courseContainerHeight * CGFloat(periods.count)))
        for period in periods.enumerate() {
            let periodLabel = UILabel(frame: CGRectMake(0, 0, sessionSideBarWidth, courseContainerHeight))
            periodLabel.textColor = UIColor(red:0.847, green:0.847, blue:0.847, alpha:1)
            periodLabel.text = period.element["code"]
            periodLabel.textAlignment = NSTextAlignment.Center
            periodLabel.font = UIFont(name: "STHeitiTC-Medium", size: 15)
            let baseOffset = courseContainerHeight / 2
            periodLabel.center.x = sessionSideBarView.bounds.midX
            periodLabel.center.y = baseOffset + CGFloat(period.index) * courseContainerHeight
            sessionSideBarView.addSubview(periodLabel)
        }
        // after we generate content of session side bar scroll view, we are going to add it
        var w = sessionSideBarWidth
        // according to frame assigned
        var h = frame.height - weekdayHeaderHeight
        self.sessionSideBarScrollView = UIScrollView(frame: CGRectMake(0, 0,  w, h))
        self.sessionSideBarScrollView.contentSize = sessionSideBarView.bounds.size
        self.sessionSideBarScrollView.addSubview(sessionSideBarView)
        // also, we dont want user to move this
        self.sessionSideBarScrollView.scrollEnabled = true
        self.sessionSideBarScrollView.bounces = false
        self.sessionSideBarScrollView.showsHorizontalScrollIndicator = false
        self.sessionSideBarScrollView.showsVerticalScrollIndicator = false
        self.sessionSideBarScrollView.delegate = self
        // configure
        self.sessionSideBarScrollView.backgroundColor = UIColor.whiteColor()
        
        // second configure header
        let headerView = UIView(frame: CGRectMake(0, 0, courseContainerWidth * 7, weekdayHeaderHeight))
        for day in ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"].enumerate() {
            let dayLabel = UILabel(frame: CGRectMake(0, 0, 60, 20))
            dayLabel.textAlignment = NSTextAlignment.Center
            dayLabel.text = day.element
            dayLabel.textColor = UIColor(red:0.847, green:0.847, blue:0.847, alpha:1)
            dayLabel.font = UIFont(name: "STHeitiTC-Medium", size: 15)
            let baseOffset = courseContainerWidth / 2
            dayLabel.center.x = baseOffset + CGFloat(day.index) * courseContainerWidth
            dayLabel.center.y = headerView.bounds.midY
            headerView.addSubview(dayLabel)
        }
        w = frame.width - sessionSideBarWidth
        h = weekdayHeaderHeight
        self.weekdayHeaderScrollView = UIScrollView(frame: CGRectMake(0, 0, w, h))
        self.weekdayHeaderScrollView.contentSize = headerView.bounds.size
        self.weekdayHeaderScrollView.addSubview(headerView)
        // also, we dont want user to move this
        self.weekdayHeaderScrollView.scrollEnabled = false
        self.weekdayHeaderScrollView.showsVerticalScrollIndicator = false
        self.weekdayHeaderScrollView.showsHorizontalScrollIndicator = false
        // configure
        self.weekdayHeaderScrollView.backgroundColor = UIColor.whiteColor()
        
        // third configure timetable content
        w = self.weekdayHeaderScrollView.bounds.width
        h = self.sessionSideBarScrollView.bounds.height
        timetableContentScrollView = UIScrollView(frame: CGRectMake(0, 0, w, h))
        w = self.weekdayHeaderScrollView.contentSize.width
        h = self.sessionSideBarScrollView.contentSize.height
        timetableContentScrollView.contentSize = CGSize(width: w, height: h)
        timetableContentScrollView.backgroundColor = UIColor.whiteColor()
        timetableContentScrollView.delegate = self
        timetableContentScrollView.bounces = false
        timetableContentScrollView.showsHorizontalScrollIndicator = false
        timetableContentScrollView.showsVerticalScrollIndicator = false
        // add rows to timetable scroll view
        for index in 1...periods.count {
            let rowView = UIView(frame: CGRectMake(0, 0, timetableContentScrollView.contentSize.width, courseContainerHeight - 2))
            rowView.backgroundColor = UIColor(red: 250/255.0, green: 247/255.0, blue: 245/255.0, alpha: 1)
            rowView.center.y = (courseContainerHeight / 2) + CGFloat(index - 1) * courseContainerHeight
            timetableContentScrollView.addSubview(rowView)
        }
        
        // arrange view position
        timetableContentScrollView.frame.origin.x = sessionSideBarWidth
        timetableContentScrollView.frame.origin.y = weekdayHeaderHeight
        self.addSubview(timetableContentScrollView)
        
        weekdayHeaderScrollView.frame.origin.x = sessionSideBarWidth
        self.addSubview(weekdayHeaderScrollView)
        
        sessionSideBarScrollView.frame.origin.y = weekdayHeaderHeight
        self.addSubview(sessionSideBarScrollView)
        
        // configure self scroll view
        self.backgroundColor = UIColor.whiteColor()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension TimeTableView: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView == self.timetableContentScrollView {
            self.weekdayHeaderScrollView.contentOffset.x = self.timetableContentScrollView.contentOffset.x
            self.sessionSideBarScrollView.contentOffset.y = self.timetableContentScrollView.contentOffset.y
        } else if scrollView == self.sessionSideBarScrollView {
            self.timetableContentScrollView.contentOffset.y = self.sessionSideBarScrollView.contentOffset.y
        }
        
//        self.sessionSideBarScrollView.bounds.size = CGSize(width: self.sessionSideBarScrollView.bounds.width, height: self.bounds.height)
//        self.timetableContentScrollView.bounds.size = CGSize(width: self.timetableContentScrollView.bounds.width, height: self.bounds.height)
        
        // delegate self timetable
        delegate?.timeTableViewDidScroll(timetableContentScrollView)
    }
}

extension TimeTableView: CourseCellViewDelegate {
    func tapOnCourseCell(courseCellView: CourseCellView) {
        delegate?.timeTableView(userDidTapOnCourseCell: courseCellView)
    }
    
    func tapOnLocalCourseCell(localCourseCellView: CourseCellView) {
        delegate?.timeTableView(userDidTapOnLocalCourseCell: localCourseCellView)
    }
}
