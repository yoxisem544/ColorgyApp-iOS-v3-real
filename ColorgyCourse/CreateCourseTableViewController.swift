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
        return 100
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.timeAndLocationIdentifier, forIndexPath: indexPath) as! CreateCourseNameAndLecturerTableViewCell
        let c = tableView.dequeueReusableCellWithIdentifier(Storyboard.timeAndLocationIdentifier, forIndexPath: indexPath) as! TimeAndLocationTableViewCell
        // Configure the cell...

        return c
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 122.0
    }

}