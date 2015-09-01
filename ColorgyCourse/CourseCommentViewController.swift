//
//  CourseCommentViewController.swift
//  ColorgyCourse
//
//  Created by David on 2015/9/1.
//  Copyright (c) 2015年 David. All rights reserved.
//

import UIKit

class CourseCommentViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // configure tableview
        self.tableView.estimatedRowHeight = 144
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }

    
    private struct Storyboard {
        static let CourseCommentCellIdentifier = "CourseCommentCell"
    }
}

extension CourseCommentViewController : UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.CourseCommentCellIdentifier, forIndexPath: indexPath) as! CourseCommentCell
        
        return cell
    }
}