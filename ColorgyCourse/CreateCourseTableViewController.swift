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
    
    var dummyDataLocation: [String?]?
    var dummyDataTime: [String?]?
    let timeAndLocationSection: Int = 1
    @IBAction func createDumpData() {
        if dummyDataLocation != nil {
            dummyDataLocation?.append("")
            dummyDataTime?.append("")
            createCourseTableView.reloadSections(NSIndexSet(index: timeAndLocationSection), withRowAnimation: .Fade)
            let indexPath = NSIndexPath(forRow: dummyDataLocation!.count - 1, inSection: timeAndLocationSection)
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
        dummyDataLocation = []
        dummyDataTime = []
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
            if dummyDataLocation != nil {
                return dummyDataLocation!.count
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
            
            return c
        case 1: // time and location
            let c = tableView.dequeueReusableCellWithIdentifier(Storyboard.timeAndLocationIdentifier, forIndexPath: indexPath) as! TimeAndLocationTableViewCell
            
            c.delegate = self
            c.cellIndex = indexPath.row
            c.timeLabel?.text = dummyDataTime![indexPath.row]
            c.locationTextField?.text = dummyDataLocation![indexPath.row]
            
            return c
        case 2: // footer
            let c = tableView.dequeueReusableCellWithIdentifier(Storyboard.newTimeAndLocationIdentifier, forIndexPath: indexPath) as! ContinueAddTimeAndLocationTableViewCell
            
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
    
    func shouldUpdateContentAtIndex(index: Int, time: String?, location: String?) {
        dummyDataLocation?[index] = location
        dummyDataTime?[index] = time
    }
    
    func didPressDeleteButtonAtIndex(index: Int) {
        dummyDataLocation?.removeAtIndex(index)
        dummyDataTime?.removeAtIndex(index)
        createCourseTableView.reloadSections(NSIndexSet(index: timeAndLocationSection), withRowAnimation: .Fade)
    }
}
