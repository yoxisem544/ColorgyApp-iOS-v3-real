//
//  SearchCourseTableViewController.swift
//  ColorgyCourse
//
//  Created by David on 2015/8/31.
//  Copyright (c) 2015年 David. All rights reserved.
//

import UIKit

class SearchCourseViewController: UIViewController {
    
    @IBOutlet weak var searchCourseTableView: UITableView!
    @IBOutlet weak var courseSegementedControl: UISegmentedControl!
    @IBOutlet weak var navigationBar: UINavigationBar!
    var searchControl = UISearchController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // configure search control
        searchControl = UISearchController(searchResultsController: nil)
        searchControl.searchResultsUpdater = self
        searchControl.searchBar.sizeToFit()
        // assign to tableview header view
        searchCourseTableView.tableHeaderView = searchControl.searchBar
        
        // configure tableview
        searchCourseTableView.estimatedRowHeight = searchCourseTableView.rowHeight
        searchCourseTableView.rowHeight = 101
        searchCourseTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        // configure segemented control
        courseSegementedControl.layer.cornerRadius = 0
        
        // configure navigation controller
        
        // testing region
//        var de = AlertDeleteCourseView()
//        self.tabBarController?.view.addSubview(de)
//        de.delegate = self
    }
    
    // segemented control action
    @IBAction func SegementedControlValueChanged(sender: UISegmentedControl) {
        
        println(sender.selectedSegmentIndex)
    }
    
    private struct Storyboard {
        static let courseCellIdentifier = "courseCellIdentifier"
    }
}

extension SearchCourseViewController : AlertDeleteCourseViewDelegate {
    func alertDeleteCourseView(didTapDeleteCourseAlertDeleteCourseView alertDeleteCourseView: AlertDeleteCourseView) {
        println("didTapDeleteCourseAlertDeleteCourseView")
    }
    func alertDeleteCourseView(didTapPreserveCourseAlertDeleteCourseView alertDeleteCourseView: AlertDeleteCourseView) {
        println("didTapPreserveCourseAlertDeleteCourseView")
    }
    func alertDeleteCourseView(didTapOnBackgroundAlertDeleteCourseView alertDeleteCourseView: AlertDeleteCourseView) {
        println("didTapOnBackgroundAlertDeleteCourseView")
    }
    
    
}

extension SearchCourseViewController : UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        println("yo")
        if searchController.active {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        } else {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
}

extension SearchCourseViewController : UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.courseCellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        return cell
    }
}

extension SearchCourseViewController : UITableViewDelegate {
    
}
