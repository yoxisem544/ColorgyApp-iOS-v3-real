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
    private var enrolledCourses: [Course]! = [Course]()
    
    private let cellColors = [
        UIColor(red:0.973,  green:0.588,  blue:0.502, alpha:1),
        UIColor(red:0.961,  green:0.651,  blue:0.137, alpha:1),
        UIColor(red:0.027,  green:0.580,  blue:0.749, alpha:1),
        UIColor(red:0,  green:0.816,  blue:0.678, alpha:1),
        UIColor(red:0.969,  green:0.420,  blue:0.616, alpha:1)
    ]
    // successful add course view
    private var successfullyAddCourseView: AddCourseSuccessfulView!
    private func configureSuccessfullyAddCourseView() {
        self.successfullyAddCourseView = AddCourseSuccessfulView()
        self.successfullyAddCourseView.center = self.view.center
        self.tabBarController?.view.addSubview(self.successfullyAddCourseView)
        self.successfullyAddCourseView.hidden = true
    }
    
    private func animateSuccessfullyAddCourseView() {
        configureSuccessfullyAddCourseView()
        self.successfullyAddCourseView.animate { () -> Void in
            
        }
    }
    private func showeSuccessfullyAddCourseView() {
        self.successfullyAddCourseView.hidden = false
    }
    private func hideSuccessfullyAddCourseView() {
        self.successfullyAddCourseView.hidden = true
    }
    
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
        searchCourseTableView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.OnDrag
        
        // configure segemented control
        courseSegementedControl.layer.cornerRadius = 0
        
        // configure navigation controller
        
        
        //        UserSetting.deleteLocalCourseDataDictionaries()
        //        UserSetting.deleteLocalCourseDataCaching()
        
        // check if need to refresh
        checkToken()
        
        // load course data
        loadCourseData()
        
        // configure successful add course view
        configureSuccessfullyAddCourseView()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // Flurry
        if Release().mode {
            Flurry.logEvent("v3.0: User Using Search Course View", timed: true)
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        if Release().mode {
            Flurry.endTimedEvent("v3.0: User Using Search Course View", withParameters: nil)
        }
    }
    
    func checkToken() {
        NetwrokQualityDetector.isNetworkStableToUse(stable: { () -> Void in
            ColorgyAPITrafficControlCenter.refreshAccessToken({ (loginResult) -> Void in
                
                }, failure: { () -> Void in
                    if !ColorgyAPITrafficControlCenter.isRefershTokenRefreshable() {
                        let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * 0.5))
                        dispatch_after(delay, dispatch_get_main_queue(), { () -> Void in
                            let alert = UIAlertController(title: "驗證過期", message: "請重新登入", preferredStyle: UIAlertControllerStyle.Alert)
                            let ok = UIAlertAction(title: "好", style: UIAlertActionStyle.Cancel, handler: {(hey) -> Void in
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let vc = storyboard.instantiateViewControllerWithIdentifier("Main Login View") as! FBLoginViewController
                                self.presentViewController(vc, animated: true, completion: nil)
                            })
                            alert.addAction(ok)
                            self.presentViewController(alert, animated: true, completion: nil)
                        })
                    }
            })
            }) { () -> Void in
                
        }
    }
    
    func downloadCourseIfNecessary() {
        // check if user already have course downloaded
        // TODO: - need async
        let qos = Int(QOS_CLASS_USER_INTERACTIVE.rawValue)
        dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in
            if LocalCachingData.dictionaryArrayFormat != nil {
                //            LocalCachingData.courseRawDataObjects
            } else {
                // block and download
                self.blockAndDownloadCourse()
            }
        })
    }
    
    private func loadCourseData() {
        //        let qos = Int(QOS_CLASS_USER_INTERACTIVE.value)
        let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
        dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in
            if let courseObjects = ServerCourseDB.getAllStoredCoursesObject() {
                var courses = [Course]()
                for courseObject in courseObjects {
                    if let course = Course(courseDataFromServerDBManagedObject: courseObject) {
                        courses.append(course)
                    }
                }
                self.localCachingObjects = courses
            } else {
                self.blockAndDownloadCourse()
            }
            self.loadEnrolledCourses()
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.searchCourseTableView.reloadData()
            })
        })
    }
    
    private func loadEnrolledCourses() {
        // enrolled courses
        if let courseObjects = CourseDB.getAllStoredCoursesObject() {
            var courses = [Course]()
            for object in courseObjects {
                if let course = Course(courseDBManagedObject: object) {
                    courses.append(course)
                }
            }
            self.enrolledCourses = courses
        }
    }
    
    @IBAction func updateCourseDataClicked(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let alert = UIAlertController(title: "更新課程資料", message: "你要更新課程資料嗎？過程可能需要數分鐘歐！", preferredStyle: UIAlertControllerStyle.Alert)
            let ok = UIAlertAction(title: "好", style: UIAlertActionStyle.Cancel, handler: { (action: UIAlertAction!) -> Void in
                self.blockAndDownloadCourse()
            })
            let cancel = UIAlertAction(title: "取消", style: UIAlertActionStyle.Default, handler: nil)
            alert.addAction(ok)
            alert.addAction(cancel)
            self.presentViewController(alert, animated: true, completion: nil)
        })
    }
    
    
    private func blockAndDownloadCourse() {
        let alert = UIAlertController(title: "請稍等", message: "正在為您下載新的課程資料，過程可能需要數分鐘。請等待歐！！ 😆", preferredStyle: UIAlertControllerStyle.Alert)
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.presentViewController(alert, animated: true, completion: nil)
        })
        ColorgyAPI.getSchoolCourseData(20000, year: 2015, term: 1, success: { (courses, json) -> Void in
            // ok!
            // save this
            //            UserSetting.storeRawCourseJSON(json)
            // generate array of dictionary
            //            UserSetting.storeLocalCourseDataDictionaries(courseRawDataDictionary)
            
            // dismiss alert
            alert.message = "下載完成！ 😆"
            
            // store data
            ServerCourseDB.storeABunchOfCoursesToDB(courses)
            
            let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * 1))
            dispatch_after(delay, dispatch_get_main_queue(), { () -> Void in
                alert.dismissViewControllerAnimated(true, completion: { () -> Void in
                    self.loadCourseData()
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
        
        print(sender.selectedSegmentIndex)
        if sender.selectedSegmentIndex == 1 {
            // reload enrolled data
            loadEnrolledCourses()
        }
        self.searchCourseTableView.reloadData()
    }
    
    @IBAction func backButtonClicked(sender: AnyObject) {
        self.searchControl.searchBar.resignFirstResponder()
        self.searchControl.dismissViewControllerAnimated(false, completion: nil)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    private struct Storyboard {
        static let courseCellIdentifier = "courseCellIdentifier"
    }
}

// MARK: - AlertDeleteCourseViewDelegate
extension SearchCourseViewController : AlertDeleteCourseViewDelegate {
    func alertDeleteCourseView(didTapDeleteCourseAlertDeleteCourseView alertDeleteCourseView: AlertDeleteCourseView, course: Course, cell: SearchCourseCell) {
        print("didTapDeleteCourseAlertDeleteCourseView")
        ColorgyAPI.DELETECourseToServer(course.code, success: { (courseCode) -> Void in
            CourseDB.deleteCourseWithCourseCode(course.code)
            alertDeleteCourseView.hideView(0.8)
            // successfully delete course
            // change state
            cell.hasEnrolledState = false
            CourseUpdateHelper.needUpdateCourse()
            // Flurry
            if Release().mode {
                Flurry.logEvent("v3.0: User Delete A Course")
            }
            }) { () -> Void in
                alertDeleteCourseView.hideView(0.4)
        }
    }
    func alertDeleteCourseView(didTapPreserveCourseAlertDeleteCourseView alertDeleteCourseView: AlertDeleteCourseView) {
        print("didTapPreserveCourseAlertDeleteCourseView")
    }
    func alertDeleteCourseView(didTapOnBackgroundAlertDeleteCourseView alertDeleteCourseView: AlertDeleteCourseView) {
        print("didTapOnBackgroundAlertDeleteCourseView")
    }
    
    
}

// MARK: - SearchCourseCellDelegate
extension SearchCourseViewController : SearchCourseCellDelegate {
    func searchCourseCell(didTapDeleteCourseButton course: Course, cell: SearchCourseCell) {
        print("didtapdelete")
        
        // alert user first
        let alertV = AlertDeleteCourseView()
        alertV.delegate = self
        alertV.course = course
        alertV.cellView = cell
        self.tabBarController?.view.addSubview(alertV)
    }
    
    func searchCourseCell(didTapAddCourseButton course: Course, cell: SearchCourseCell) {
        print("didtapadd")
        print("\(course)")
        print("didtapadd")
        ColorgyAPI.PUTCourseToServer(course.code, year: 2015, term: 1, success: { () -> Void in
            self.animateSuccessfullyAddCourseView()
            CourseDB.storeCourseToDB(course)
            CourseUpdateHelper.needUpdateCourse()
            cell.hasEnrolledState = true
            // Flurry
            if Release().mode {
                Flurry.logEvent("v3.0: User Add A Course")
            }
            }, failure: { () -> Void in
                
        })
    }
}

// MARK: - UISearchResultsUpdating
extension SearchCourseViewController : UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if searchController.active {
            print("searchController.searchBar.text \"\(searchController.searchBar.text)\"")
            // TODO: optional chaining??
            filterContentForSearchText(searchController.searchBar.text!)
        } else {
            self.searchCourseTableView.reloadData()
        }
    }
    
    func filterContentForSearchText(searchText: String) {
        
        self.filteredCourses = [Course]()
        
        if searchText != "" {
            //            let qos = Int(QOS_CLASS_USER_INTERACTIVE.value)
            let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
            dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in
                
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
                    print("reload after filtering")
                })
            })
        } else {
            self.searchCourseTableView.reloadData()
        }
    }
}

// MARK: - UITableViewDataSource
extension SearchCourseViewController : UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.courseSegementedControl.selectedSegmentIndex == 0 {
            if searchControl.active {
                // searching
                return self.filteredCourses.count
            } else {
                return self.localCachingObjects.count
            }
        } else if self.courseSegementedControl.selectedSegmentIndex == 1 {
            // enrolled course
            return self.enrolledCourses.count
        } else {
            return 0
        }
    }
    
    
    func checkIfEnrolled(courseCode: String) -> Bool {
        if let courses = CourseDB.getAllStoredCoursesObject() {
            for course in courses {
                // find if match
                if let code = course.code {
                    if code == courseCode {
                        return true
                    }
                }
            }
        }
        return false
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.courseCellIdentifier, forIndexPath: indexPath) as! SearchCourseCell
        
        if self.courseSegementedControl.selectedSegmentIndex == 0 {
            if searchControl.active {
                // searching
                cell.course = filteredCourses[indexPath.row]
                cell.delegate = self
                cell.sideColorHintView.backgroundColor = cellColors[indexPath.row % cellColors.count]
                cell.hasEnrolledState = checkIfEnrolled(cell.course.code)
            } else {
                cell.course = localCachingObjects[indexPath.row]
                cell.delegate = self
                cell.sideColorHintView.backgroundColor = cellColors[indexPath.row % cellColors.count]
                cell.hasEnrolledState = checkIfEnrolled(cell.course.code)
            }
        } else if self.courseSegementedControl.selectedSegmentIndex == 1 {
            cell.course = enrolledCourses[indexPath.row]
            cell.delegate = self
            cell.sideColorHintView.backgroundColor = cellColors[indexPath.row % cellColors.count]
            cell.hasEnrolledState = checkIfEnrolled(cell.course.code)
        }
        
        
        return cell
    }
}

extension SearchCourseViewController : UITableViewDelegate {
    
}

