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
    
    var dummyData: [TimeAndLocationTableViewCell]?
    var dummyDataLocation: [String?]?
    var dummyDataTime: [String?]?
    @IBAction func createDumpData() {
        if dummyData != nil {
            let cell = createCourseTableView.dequeueReusableCellWithIdentifier(Storyboard.timeAndLocationIdentifier) as! TimeAndLocationTableViewCell
            let c = TimeAndLocationTableViewCell()
            dummyData!.append(c)
            dummyDataLocation?.append("")
            dummyDataTime?.append("")
            createCourseTableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Fade)
            let indexPath = NSIndexPath(forRow: dummyData!.count - 1, inSection: 0)
            print(indexPath.row)
            print(indexPath.section)
            createCourseTableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Middle, animated: true)
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createCourseTableView.delegate = self
        createCourseTableView.dataSource = self
        
        createCourseTableView.estimatedRowHeight = UITableViewAutomaticDimension
        createCourseTableView.rowHeight = UITableViewAutomaticDimension
        
        createCourseTableView.backgroundColor = UIColor(red:0.980,  green:0.969,  blue:0.961, alpha:1)
        view.backgroundColor = UIColor(red:0.980,  green:0.969,  blue:0.961, alpha:1)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        dummyData = []
        dummyDataLocation = []
        dummyDataTime = []
    }
    
    struct Storyboard {
        static let nameAndLecturerIdentifier = "nameAndLecturerIdentifier"
        static let timeAndLocationIdentifier = "time location identifier"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dummyData != nil {
            return dummyData!.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.timeAndLocationIdentifier, forIndexPath: indexPath) as! CreateCourseNameAndLecturerTableViewCell
        let c = tableView.dequeueReusableCellWithIdentifier(Storyboard.timeAndLocationIdentifier, forIndexPath: indexPath) as! TimeAndLocationTableViewCell
        // Configure the cell...
        c.delegate = self
        c.cellIndex = indexPath.row
        c.timeLabel?.text = dummyDataTime![indexPath.row]
        c.locationTextField?.text = dummyDataLocation![indexPath.row]
        print(c.timeLabel?.text)

        return c
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 122.0
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
}
