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
    
    // private API
    private var localCachingObjects: [Course]! = [Course]()
    private var filteredCourses: [Course]! = [Course]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // configure search control
        searchControl = UISearchController(searchResultsController: nil)
        searchControl.searchResultsUpdater = self
        searchControl.searchBar.sizeToFit()
        searchControl.dimsBackgroundDuringPresentation = false
        // assign to tableview header view
        searchCourseTableView.tableHeaderView = searchControl.searchBar
        
        // configure tableview
        searchCourseTableView.estimatedRowHeight = searchCourseTableView.rowHeight
        searchCourseTableView.rowHeight = 101
        searchCourseTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        // configure segemented control
        courseSegementedControl.layer.cornerRadius = 0
        
        // configure navigation controller
        
        
//        UserSetting.deleteLocalCourseDataDictionaries()
//        UserSetting.deleteLocalCourseDataCaching()
        
        downloadCourseIfNecessary()
        
        // load course data
        loadLocalCachingData()
    }
    
    func downloadCourseIfNecessary() {
        // check if user already have course downloaded
        // TODO: - need async
        let qos = Int(QOS_CLASS_USER_INTERACTIVE.value)
        dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in
            if LocalCachingData.dictionaryArrayFormat != nil {
                //            LocalCachingData.courseRawDataObjects
            } else {
                // block and download
                self.blockAndDownloadCourse()
            }
        })
    }
    
    private func loadLocalCachingData() {
        let qos = Int(QOS_CLASS_USER_INTERACTIVE.value)
        dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in
            if let courses = LocalCachingData.courses {
                self.localCachingObjects = courses
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.searchCourseTableView.reloadData()
            })
        })
    }
    
    private func blockAndDownloadCourse() {
        let alert = UIAlertController(title: "請稍等", message: "正在為您下載新的課程資料，過程可能需要數分鐘。請等待歐！！ 😆", preferredStyle: UIAlertControllerStyle.Alert)
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.presentViewController(alert, animated: true, completion: nil)
        })
        ColorgyAPI.getSchoolCourseData(20000, year: 2015, term: 1, success: { (courseRawDataDictionary, json) -> Void in
            // ok!
            // save this
            UserSetting.storeRawCourseJSON(json)
            // generate array of dictionary
            UserSetting.storeLocalCourseDataDictionaries(courseRawDataDictionary)
            
            // dismiss alert
            alert.message = "下載完成！ 😆"
            
            let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * 1))
            dispatch_after(delay, dispatch_get_main_queue(), { () -> Void in
                alert.dismissViewControllerAnimated(true, completion: { () -> Void in
                    self.loadLocalCachingData()
                })
            })
            }, failure: { () -> Void in
                // no data, error
                // TODO: test while fail to get courses
                alert.message = "下載課程資料時出錯了 😖"
                
                let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * 1))
                dispatch_after(delay, dispatch_get_main_queue(), { () -> Void in
                    alert.dismissViewControllerAnimated(true, completion: nil)
                })
        })
    }
    
    // segemented control action
    @IBAction func SegementedControlValueChanged(sender: UISegmentedControl) {
        
        println(sender.selectedSegmentIndex)
    }
    
    @IBAction func backButtonClicked(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
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
        if searchController.active {
            filterContentForSearchText(searchController.searchBar.text)
        } else {

        }
    }
    
    func filterContentForSearchText(searchText: String) {
        
        if searchText != "" {
            let qos = Int(QOS_CLASS_USER_INTERACTIVE.value)
            dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in
                // init container
                self.filteredCourses = [Course]()
                
                for localCachingObject in self.localCachingObjects {
                    var isMatch: Bool = false
                    
                    // course name
                    if localCachingObject.name.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch) != nil {
                        isMatch = true
                    }
                    // course lecturer name
                    if let lecturer = localCachingObject.lecturer {
                        if lecturer.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch) != nil {
                            isMatch = true
                        }
                    }
                    // course code
                    if localCachingObject.code.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch) != nil {
                        isMatch = true
                    }
                    
                    // if match, append it
                    if isMatch {
                        self.filteredCourses.append(localCachingObject)
                    }
                }
                
                // after filtering, return to main queue
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.searchCourseTableView.reloadData()
                    println("reload after filtering")
                })
            })
        }
    }
}

extension SearchCourseViewController : UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchControl.active {
            // searching
            return self.filteredCourses.count
        } else {
            return self.localCachingObjects.count
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.courseCellIdentifier, forIndexPath: indexPath) as! SearchCourseCell
        
        if searchControl.active {
            // searching
            cell.course = filteredCourses[indexPath.row]
        } else {
            cell.course = localCachingObjects[indexPath.row]
        }
        
        return cell
    }
}

extension SearchCourseViewController : UITableViewDelegate {
    
}
