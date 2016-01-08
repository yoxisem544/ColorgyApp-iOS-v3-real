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
    var processAlertController: UIAlertController!
    var createCourseCellView: CreateCourseTableViewCell?
    
    // private API
    private var localCachingObjects: [Course]! = [Course]()
    private var filteredCourses: [Course]! = [Course]()
    private var enrolledCourses: [Course]! = [Course]()
    private var enrolledLocalCourse: [LocalCourse]! = [LocalCourse]()
    
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
        searchControl.searchBar.placeholder = "輸入課名、代碼、老師來搜尋"
        
        // configure tableview
        searchCourseTableView.estimatedRowHeight = searchCourseTableView.rowHeight
        searchCourseTableView.rowHeight = UITableViewAutomaticDimension
        searchCourseTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        searchCourseTableView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.OnDrag
        
        // animation
//        let transition = CATransition()
//        transition.type = kCATransitionPush
//        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
//        transition.fillMode = kCAFillModeForwards
//        transition.duration = 0.5
//        transition.subtype = kCATransitionFromTop
//        searchCourseTableView.layer.addAnimation(transition, forKey: "UITableViewReloadDataAnimationKey")
        
        // configure segemented control
        courseSegementedControl.layer.cornerRadius = 0
        
        // tableview and search problem
        self.definesPresentationContext = true
        
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
    
    private func loadCourseData() {
        //        let qos = Int(QOS_CLASS_USER_INTERACTIVE.value)
        let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
        
        // server course
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
                self.updateCourseDataClicked(0)
            }
            // load enroll courses
            self.loadEnrolledCourses()
            self.loadEnrolledLocalCourses()
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.searchCourseTableView.reloadData()
            })
        })
    }
    
    private func loadEnrolledLocalCourses() {
        if let courseObjects = LocalCourseDB.getAllStoredCoursesObject() {
            var courses = [LocalCourse]()
            for courseObject in courseObjects {
                if let c = LocalCourse(localCourseDBManagedObject: courseObject) {
                    courses.append(c)
                }
            }
            self.enrolledLocalCourse = courses
        }
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
        processAlertController = UIAlertController(title: "請稍等", message: "正在為您下載新的課程資料，過程可能需要數分鐘。請等待歐！！ 😆", preferredStyle: UIAlertControllerStyle.Alert)
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.presentViewController(self.processAlertController, animated: true, completion: nil)
        })
        // TODO: this is very important ! year2015 term1
        let semester: (year: Int, term: Int) = Semester.currentSemesterAndYear()
        ColorgyAPI.getSchoolCourseData(20000, year: semester.year, term: semester.term, success: { (courses, json) -> Void in
                // ok!
                // save this
                //            UserSetting.storeRawCourseJSON(json)
                // generate array of dictionary
                //            UserSetting.storeLocalCourseDataDictionaries(courseRawDataDictionary)
                
                // dismiss processAlertController
            
                // store data
                ServerCourseDB.storeABunchOfCoursesToDB(courses)
                
                //            let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * 1))
                //            dispatch_after(delay, dispatch_get_main_queue(), { () -> Void in
                //                self.processAlertController.dismissViewControllerAnimated(true, completion: { () -> Void in
                //                    self.loadCourseData()
                //                })
                //            })
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.processAlertController.message = "下載完成！ 😆"
                    self.processAlertController.dismissViewControllerAnimated(true, completion: { () -> Void in
                        self.loadCourseData()
                    })
                })
            
            }, failure: { (failInfo) -> Void in
                // no data, error
                // TODO: test while fail to get courses
                if let failInfo = failInfo {
                    self.processAlertController.message = failInfo
                } else {
                    self.processAlertController.message = "下載課程資料時出錯了 😖"
                }
                
                let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * 1))
                dispatch_after(delay, dispatch_get_main_queue(), { () -> Void in
                    self.processAlertController.dismissViewControllerAnimated(true, completion: nil)
                })
            }, processing: { (state) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    print("now on state:\(state)")
                    print(self.processAlertController.message)
                    self.processAlertController.message = state
//                    NSOperationQueue().addOperationWithBlock({ () -> Void in
//                        self.processAlertController.performSelector("setMessage:", onThread: NSThread.mainThread(), withObject: state, waitUntilDone: false)
//                    })
                })
        })
    }
    
    func setMessage(message: String) {
        self.processAlertController.message = message
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
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.searchControl.searchBar.resignFirstResponder()
        self.searchControl.dismissViewControllerAnimated(false, completion: nil)
        print("search will disapper")
    }
    
    private struct Storyboard {
        static let courseCellIdentifier = "courseCellIdentifier"
        static let createCourseCellIdentifier = "createCourseCellIdentifier"
        static let toCreateCourseSegue = "to create course view"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Storyboard.toCreateCourseSegue {
            
        }
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
            createCourseCellView?.courseName = searchController.searchBar.text
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
        if self.courseSegementedControl.selectedSegmentIndex == 0 {
            if searchControl.searchBar.text == "" {
                return 1
            } else {
                return 2
            }
        } else {
            return 2
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.courseSegementedControl.selectedSegmentIndex == 0 {
            if section == 0 {
                if searchControl.active {
                    // searching
                    if searchControl.searchBar.text == "" {
                        return 0
                    } else {
                        return self.filteredCourses.count
                    }
                } else {
                    // dont show data if not searching
                    //                return self.localCachingObjects.count
                    return 0
                }
            } else {
                return 1
            }
        } else {
            if section == 0 {
                // server
                return self.enrolledCourses.count
            } else {
                // local
                return self.enrolledLocalCourse.count
            }
        }
        
//        if section == 0 {
//            if self.courseSegementedControl.selectedSegmentIndex == 0 {
//                if searchControl.active {
//                    // searching
//                    if searchControl.searchBar.text == "" {
//                        return 0
//                    } else {
//                        return self.filteredCourses.count
//                    }
//                } else {
//                    // dont show data if not searching
//    //                return self.localCachingObjects.count
//                    return 0
//                }
//            } else if self.courseSegementedControl.selectedSegmentIndex == 1 {
//                // enrolled course
//                return self.enrolledCourses.count
//            } else {
//                return 0
//            }
//        } else {
//            // create course section
//            return 1
//        }
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
        
        if self.courseSegementedControl.selectedSegmentIndex == 0 {
            // searching
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.courseCellIdentifier, forIndexPath: indexPath) as! SearchCourseCell

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
                
                return cell
            } else {
                // create course section
                if createCourseCellView == nil {
                    createCourseCellView = tableView.dequeueReusableCellWithIdentifier(Storyboard.createCourseCellIdentifier, forIndexPath: indexPath) as? CreateCourseTableViewCell
                }
                createCourseCellView?.courseName = searchControl.searchBar.text
                createCourseCellView?.delegate = self
                
                return createCourseCellView!
            }
        } else {
           // viewing enrolled courses
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.courseCellIdentifier, forIndexPath: indexPath) as! SearchCourseCell
            
            if indexPath.section == 0 {
                cell.course = enrolledCourses[indexPath.row]
                cell.delegate = self
                cell.sideColorHintView.backgroundColor = cellColors[indexPath.row % cellColors.count]
                cell.hasEnrolledState = checkIfEnrolled(cell.course.code)
            } else {
                cell.localCourse = enrolledLocalCourse[indexPath.row]
                cell.delegate = self
                cell.sideColorHintView.backgroundColor = cellColors[indexPath.row % cellColors.count]
            }
            
            return cell
        }
    }
}

extension SearchCourseViewController : CreateCourseTableViewCellDelegate {
    func didTapOnCreateCourseCell(courseName: String?) {
        print(courseName)
        performSegueWithIdentifier(Storyboard.toCreateCourseSegue, sender: courseName)
    }
}

extension SearchCourseViewController : UITableViewDelegate {
    
}

