//
//  CreateCourseTableViewController.swift
//  ColorgyCourse
//
//  Created by David on 2016/1/4.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

class CreateCourseTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var createCourseTableView: UITableView!
    
    var locationContents: [String?]?
    var timeContents: [String?]?
    let timeAndLocationSection: Int = 1
    var courseName: String?
    var lecturerName: String?
    var keyboardAnimatingKey: Bool = false
    @IBAction func createDumpData() {
        if locationContents != nil {
            locationContents?.append("")
            timeContents?.append("")
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
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        locationContents = []
        timeContents = []
        
        // keyboard
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidHide:", name: UIKeyboardDidHideNotification, object: nil)
    }
    
    func keyboardDidShow(notification: NSNotification) {
        if let kbSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() {
            print(kbSize)
            keyboardAnimatingKey = true
            UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                self.createCourseTableView.contentInset.bottom = kbSize.height
                }, completion: { (finished) -> Void in
                    if finished {
                        self.keyboardAnimatingKey = false
                    }
            })
        }
    }
    
    func keyboardDidHide(notification: NSNotification) {
        UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.createCourseTableView.contentInset = UIEdgeInsetsZero
            }, completion: { (finised) -> Void in
                self.keyboardAnimatingKey = false
        })
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.inputView?.reloadInputViews()
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
            
            c.delegate = self
            
            return c
        case 1: // time and location
            let c = tableView.dequeueReusableCellWithIdentifier(Storyboard.timeAndLocationIdentifier, forIndexPath: indexPath) as! TimeAndLocationTableViewCell
            
            c.delegate = self
            c.cellIndex = indexPath.row
            c.timeTextField?.text = timeContents![indexPath.row]
            c.locationTextField?.text = locationContents![indexPath.row]
            
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

extension CreateCourseTableViewController : TimeAndLocationTableViewCellDelegate {
    func didTapOnLocationView() {
        print("yo")
    }
    
    func didTapOnTimeView() {
        print("yooo")
    }
    
    func contentUpdatedAtIndex(index: Int, time: String?, location: String?) {
        locationContents?[index] = location
        timeContents?[index] = time
    }
    
    func didPressDeleteButtonAtIndex(index: Int) {
        locationContents?.removeAtIndex(index)
        timeContents?.removeAtIndex(index)
        createCourseTableView.reloadSections(NSIndexSet(index: timeAndLocationSection), withRowAnimation: .Fade)
    }
}

extension CreateCourseTableViewController : CreateCourseNameAndLecturerTableViewCellDelegate {
    func contentUpdated(courseName: String?, lecturerName: String?) {
        self.courseName = courseName
        self.lecturerName = lecturerName
    }
}

extension CreateCourseTableViewController : ContinueAddTimeAndLocationTableViewCellDelegate {
    func didTapOnAddButton() {
        createDumpData()
    }
}

extension CreateCourseTableViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if keyboardAnimatingKey == false {
//            self.view.endEditing(true)
        }
    }
}