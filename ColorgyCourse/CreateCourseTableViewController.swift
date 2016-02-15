//
//  CreateCourseTableViewController.swift
//  ColorgyCourse
//
//  Created by David on 2016/1/4.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics

protocol CreateCourseTableViewControllerDelegate {
    func createCourseTableViewControllerDidCreateLocalCourse()
}

class CreateCourseTableViewController: UIViewController {
    
    @IBOutlet weak var createCourseTableView: UITableView!
    
    var locationContents: [String?]?
    var timeContents: [String?]?
    var timePeriodsContents: [[Int]]?
    let timeAndLocationSection: Int = 1
    var courseName: String?
    var lecturerName: String?
    
    var delegate: CreateCourseTableViewControllerDelegate?
    
    @IBAction func testLocalCourse() {
        let lc = LocalCourse(name: courseName, lecturer: lecturerName, timePeriodsContents: timePeriodsContents, locationContents: locationContents)
        print(lc)
//        LocalCourseDB.deleteAllCourses()
        print(CourseNotification.checkNeedNotifiedLocalCourse(lc!))
        LocalCourseDB.storeLocalCourseToDB(lc)
    }
    
    @IBAction func createLocalCourseClicked() {
        if let lc = LocalCourse(name: courseName, lecturer: lecturerName, timePeriodsContents: timePeriodsContents, locationContents: locationContents) {
            if let periods = lc.periods {
                print(periods.count)
                if periods.count >= 9 {
                    alertCreating("小提醒", error: "課程最多只能有9節的時間，多的時間將不會存下來喔！如果還是想要建立課程的話，請按建立！", confirmBlock: { () -> Void in
                        self.confirmCreateLocalCourse(lc)
                    })
                } else {
                    confirmCreateLocalCourse(lc)
                }
            } else {
                confirmCreateLocalCourse(lc)
            }
			Mixpanel.sharedInstance().track(MixpanelEvents.addCustomCourseSuccess)
        } else {
            if courseName == nil || courseName == "" {
                // no name of course
                alertError("資料有問題", error: "建立課程需要最少輸入課程的名稱！")
				Mixpanel.sharedInstance().track(MixpanelEvents.addCustomCourseFail)
            }
        }
    }
    
    @IBAction func popBackToSearchView() {
        delegate?.createCourseTableViewControllerDidCreateLocalCourse()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func confirmCreateLocalCourse(lc: LocalCourse) {
        
        let school = UserSetting.UserPossibleOrganization() ?? "no school"
        let semester = Semester.currentSemesterAndYear() as (year: Int, term: Int)
        let userId = UserSetting.UserId() ?? -1
        let department = UserSetting.UserPossibleDepartment() ?? "no department"
        
		let params: [String : AnyObject] = ["course_name": lc.name, "course_lecturer": lc.lecturer ?? "", "school": school, "department": department, "year": semester.year, "term": semester.term, "user_id": userId]
        if Release().mode {
            Flurry.logEvent("v3.0: User Created A Local Course", withParameters: params as [NSObject : AnyObject])
			Answers.logCustomEventWithName(AnswersLogEvents.userCreateALocalCourse, customAttributes: params)
        } else {
            Flurry.logEvent("v3.0: User Created A Local Course", withParameters: params as [NSObject : AnyObject])
        }
        
        LocalCourseDB.storeLocalCourseToDB(lc)
        popBackToSearchView()
    }
    
    func alertCreating(title: String?, error: String?, confirmBlock: () -> Void) {
        let alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        let ok = UIAlertAction(title: "建立", style: UIAlertActionStyle.Cancel) { (action: UIAlertAction) -> Void in
            confirmBlock()
        }
        let cancel = UIAlertAction(title: "重新輸入", style: UIAlertActionStyle.Default, handler: nil)
        alert.addAction(ok)
        alert.addAction(cancel)
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.presentViewController(alert, animated: true, completion: nil)
        })
    }
    
    func alertError(title: String?, error: String?) {
        let alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        let ok = UIAlertAction(title: "知道了", style: UIAlertActionStyle.Default, handler: nil)
        alert.addAction(ok)
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.presentViewController(alert, animated: true, completion: nil)
        })
    }
    
    func createNewTimeAndLocationContent() {
        if locationContents != nil {
            locationContents?.append("")
            timeContents?.append("")
            timePeriodsContents?.append([0, 0, 0])
            createCourseTableView.reloadSections(NSIndexSet(index: timeAndLocationSection), withRowAnimation: .Fade)
            let indexPath = NSIndexPath(forRow: locationContents!.count - 1, inSection: timeAndLocationSection)
            createCourseTableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Middle, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createCourseTableView.delegate = self
        createCourseTableView.dataSource = self
        
        createCourseTableView.estimatedRowHeight = UITableViewAutomaticDimension
        createCourseTableView.rowHeight = UITableViewAutomaticDimension
        
        createCourseTableView.backgroundColor = ColorgyColor.BackgroundColor
        view.backgroundColor = ColorgyColor.BackgroundColor

        initializeContents()
        
        createCourseTableView.keyboardDismissMode = .OnDrag
		
		Mixpanel.sharedInstance().track(MixpanelEvents.GetIntoCustomCourseView)
    }
    
    func initializeContents() {
        locationContents = []
        timeContents = []
        timePeriodsContents = []
        
        locationContents?.append("")
        timeContents?.append("")
        timePeriodsContents?.append([0, 0, 0])
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        unregisterNotification()
    }
    
    func registerNotification() {
        // keyboard
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidHide:", name: UIKeyboardDidHideNotification, object: nil)
    }
    
    func unregisterNotification() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func keyboardDidShow(notification: NSNotification) {
        if let kbSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() {
            print(kbSize)
            UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                self.createCourseTableView.contentInset.bottom = kbSize.height
                }, completion: nil)
        }
    }
    
    func keyboardDidHide(notification: NSNotification) {
        UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.createCourseTableView.contentInset = UIEdgeInsetsZero
            }, completion: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.inputView?.reloadInputViews()
        registerNotification()
    }
    
    struct Storyboard {
        static let nameAndLecturerIdentifier = "nameAndLecturerIdentifier"
        static let timeAndLocationIdentifier = "time location identifier"
        static let newTimeAndLocationIdentifier = "new time and location identifier"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension CreateCourseTableViewController : UITableViewDataSource, UITableViewDelegate {
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: // name and lecturer
            return 1
        case 1: // time and location
            if locationContents != nil {
                return locationContents!.count
            } else {
                return 10
            }
        case 2: // footer
            return 1
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0: // name and lecturer
            let c = tableView.dequeueReusableCellWithIdentifier(Storyboard.nameAndLecturerIdentifier, forIndexPath: indexPath) as! CreateCourseNameAndLecturerTableViewCell
            
            c.nameTextField.text = courseName
            c.delegate = self
            
            return c
        case 1: // time and location
            let c = tableView.dequeueReusableCellWithIdentifier(Storyboard.timeAndLocationIdentifier, forIndexPath: indexPath) as! TimeAndLocationTableViewCell
            
            c.delegate = self
            c.cellIndex = indexPath.row
            c.timeTextField?.text = timeContents![indexPath.row]
            c.locationTextField?.text = locationContents![indexPath.row]
            c.periods = timePeriodsContents![indexPath.row]
            
            return c
        case 2: // footer
            let c = tableView.dequeueReusableCellWithIdentifier(Storyboard.newTimeAndLocationIdentifier, forIndexPath: indexPath) as! ContinueAddTimeAndLocationTableViewCell
            
            c.delegate = self
            
            return c
        default:
            return tableView.dequeueReusableCellWithIdentifier(Storyboard.newTimeAndLocationIdentifier, forIndexPath: indexPath) as! ContinueAddTimeAndLocationTableViewCell
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 88.0
        case 1:
            return 122.0
        case 2:
            return 122.0
        default:
            return 44.0
        }
    }
}

// MARK: - TimeAndLocationTableViewCellDelegate
extension CreateCourseTableViewController : TimeAndLocationTableViewCellDelegate {
    func didTapOnLocationView() {
        print("yo")
    }
    
    func didTapOnTimeView() {
        print("yooo")
    }
    
    func contentUpdatedAtIndex(index: Int, periodDescription: String?, periods: [Int], location: String?) {
        locationContents?[index] = location
        timeContents?[index] = periodDescription
        timePeriodsContents?[index] = periods
        print(periods)
    }
    
    func didPressDeleteButtonAtIndex(index: Int) {
        locationContents?.removeAtIndex(index)
        timeContents?.removeAtIndex(index)
        timePeriodsContents?.removeAtIndex(index)
        createCourseTableView.reloadSections(NSIndexSet(index: timeAndLocationSection), withRowAnimation: .Fade)
    }
}

// MARK: - CreateCourseNameAndLecturerTableViewCellDelegate
extension CreateCourseTableViewController : CreateCourseNameAndLecturerTableViewCellDelegate {
    func contentUpdated(courseName: String?, lecturerName: String?) {
        self.courseName = courseName
        self.lecturerName = lecturerName
    }
}

// MARK: - ContinueAddTimeAndLocationTableViewCellDelegate
extension CreateCourseTableViewController : ContinueAddTimeAndLocationTableViewCellDelegate {
    func didTapOnAddButton() {
        if locationContents != nil {
            if locationContents!.count < 9 {
                // limit the content length to 9
                createNewTimeAndLocationContent()
            }
        }
    }
}