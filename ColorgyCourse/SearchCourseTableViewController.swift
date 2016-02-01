//
//  SearchCourseTableViewController.swift
//  ColorgyCourse
//
//  Created by David on 2015/8/31.
//  Copyright (c) 2015年 David. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics

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

        // configure segemented control
        courseSegementedControl.layer.cornerRadius = 0
        
        // tableview and search problem
        self.definesPresentationContext = true
        
        // configure navigation controller
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // Flurry
        if Release().mode {
            Flurry.logEvent("v3.0: User Using Search Course View", timed: true)
			Answers.logCustomEventWithName(AnswersLogEvents.userUsingSearchCourseView, customAttributes: nil)
        }
		
		// focus
		self.searchControl.active = true
        
        // check if need to refresh
        checkToken()
        
        // load course data
        loadCourseData()
        
        // configure successful add course view
        configureSuccessfullyAddCourseView()
        
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
            ServerCourseDB.getAllStoredCoursesObject(complete: { (courseDataFromServerDBManagedObjects) -> Void in
                if let courseObjects = courseDataFromServerDBManagedObjects {
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
        })
    }
    
    private func loadEnrolledLocalCourses() {
		LocalCourseDB.getAllStoredCourses { (localCourses) -> Void in
			if let localCourses = localCourses {
				self.enrolledLocalCourse = localCourses
				dispatch_async(dispatch_get_main_queue(), { () -> Void in
					if self.courseSegementedControl.selectedSegmentIndex == 1 {
						self.searchCourseTableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: UITableViewRowAnimation.None)
					}
				})
			}
		}
    }
	
    private func loadEnrolledCourses() {
		CourseDB.getAllStoredCourses { (courses) -> Void in
			if let courses = courses {
				self.enrolledCourses = courses
				self.searchCourseTableView.reloadData()
			}
		}
    }
    
    @IBAction func updateCourseDataClicked(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let alert = UIAlertController(title: "更新課程資料", message: "您要更新課程資料嗎？過程需要30秒喔！", preferredStyle: UIAlertControllerStyle.Alert)
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
        processAlertController = UIAlertController(title: "資料要吐出來囉！", message: "正在為您下載新的課程資料，過程可能需要數分鐘。請等待歐！！ 😆", preferredStyle: UIAlertControllerStyle.Alert)
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.presentViewController(self.processAlertController, animated: true, completion: nil)
        })

        let semester: (year: Int, term: Int) = Semester.currentSemesterAndYear()
        ColorgyAPI.getSchoolCourseData(20000, year: semester.year, term: semester.term, success: { (courses, json) -> Void in
                // ok!
                // save this
            
                // store data
                ServerCourseDB.storeABunchOfCoursesToDB(courses)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.processAlertController.message = "下載完成！ 😆"
                    let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * 2))
                    dispatch_after(delay, dispatch_get_main_queue(), { () -> Void in
                        self.processAlertController.dismissViewControllerAnimated(true, completion: { () -> Void in
                            self.loadCourseData()
                        })
                    })
                })
            
            }, failure: { (failInfo) -> Void in
                // no data, error
                // TODO: test while fail to get courses
                if let failInfo = failInfo {
                    self.processAlertController.message = failInfo
                } else {
                    self.processAlertController.message = "下載課程資料時出錯了 😖，請檢查網路是否暢通！"
                }
                
                let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * 2))
                dispatch_after(delay, dispatch_get_main_queue(), { () -> Void in
                    self.processAlertController.dismissViewControllerAnimated(true, completion: nil)
                })
            }, processing: { (title, state) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    print("now on state:\(state)")
                    print(self.processAlertController.message)
                    self.processAlertController.message = state
					self.processAlertController.title = title
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
        static let showCourseDetailViewSegueIdentifier = "show course detail segue"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Storyboard.toCreateCourseSegue {
            let vc = segue.destinationViewController as! CreateCourseTableViewController
            vc.delegate = self
            if let courseName = sender as? String {
                vc.courseName = courseName
            }
        } else if segue.identifier == Storyboard.showCourseDetailViewSegueIdentifier {
            let vc = segue.destinationViewController as! DetailCourseViewController
            if let course = sender as? Course {
                vc.course = course
            } else if let localCourse = sender as? LocalCourse {
                vc.localCourse = localCourse
            }
        }
    }
}

// MARK: - AlertDeleteCourseViewDelegate
extension SearchCourseViewController : AlertDeleteCourseViewDelegate {
    func alertDeleteCourseView(didTapDeleteCourseAlertDeleteCourseView alertDeleteCourseView: AlertDeleteCourseView, course: Course, cell: SearchCourseCell) {
        print("didTapDeleteCourseAlertDeleteCourseView")
        ColorgyAPI.DELETECourseToServer(course.code, success: { (courseCode) -> Void in
            CourseDB.deleteCourseWithCourseCode(course.code)
            alertDeleteCourseView.hideView(0.4)
            alertDeleteCourseView.removeFromSuperview()
            // successfully delete course
            // change state
            cell.hasEnrolledState = false
            CourseUpdateHelper.needUpdateCourse()
			self.loadEnrolledCourses()
			self.searchCourseTableView.reloadData()
            // Flurry
            if Release().mode {
                Flurry.logEvent("v3.0: User Delete A Course")
				Answers.logCustomEventWithName(AnswersLogEvents.userDeleteCourse, customAttributes: nil)
            }
            }) { () -> Void in
                alertDeleteCourseView.hideView(0.4)
                alertDeleteCourseView.removeFromSuperview()
        }
    }
    
    func alertDeleteCourseView(didTapDeleteCourseAlertDeleteCourseView alertDeleteCourseView: AlertDeleteCourseView, localCourse: LocalCourse, cell: SearchCourseCell) {
        print("didTapDeleteCourseAlertDeleteCourseView:localCourse:")
        LocalCourseDB.deleteLocalCourseOnDB(localCourse)
        if let index = enrolledLocalCourse.indexOf(localCourse) {
            enrolledLocalCourse.removeAtIndex(index)
            searchCourseTableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: UITableViewRowAnimation.Fade)
        }
        
        alertDeleteCourseView.hideView(0.4)
        alertDeleteCourseView.removeFromSuperview()
    }
    
    func alertDeleteCourseView(didTapPreserveCourseAlertDeleteCourseView alertDeleteCourseView: AlertDeleteCourseView) {
        print("didTapPreserveCourseAlertDeleteCourseView")
        alertDeleteCourseView.removeFromSuperview()
    }
    
    func alertDeleteCourseView(didTapOnBackgroundAlertDeleteCourseView alertDeleteCourseView: AlertDeleteCourseView) {
        print("didTapOnBackgroundAlertDeleteCourseView")
        alertDeleteCourseView.removeFromSuperview()
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
        let semester: (year: Int, term: Int) = Semester.currentSemesterAndYear()
        ColorgyAPI.PUTCourseToServer(course.code, year: semester.year, term: semester.term, success: { () -> Void in
            self.animateSuccessfullyAddCourseView()
            CourseDB.storeCourseToDB(course)
            CourseUpdateHelper.needUpdateCourse()
            cell.hasEnrolledState = true
			self.searchCourseTableView.reloadData()
            // Flurry
            if Release().mode {
                Flurry.logEvent("v3.0: User Add A Course")
				Answers.logCustomEventWithName(AnswersLogEvents.userAddCourse, customAttributes: nil)
            }
            }, failure: { () -> Void in
                
        })
    }
    
    func searchCourseCell(didTapDeleteLocalCourseButton localCourse: LocalCourse, cell: SearchCourseCell) {
        // do something
        // need reload here
        // alert user first
        let alertV = AlertDeleteCourseView()
        alertV.delegate = self
        alertV.localCourse = localCourse
        alertV.cellView = cell
        self.tabBarController?.view.addSubview(alertV)
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
    
    func checkIfEnrolled(courseCode: String, complete: (ifEnrolled: Bool) -> Void) {
        CourseDB.getAllStoredCoursesObject { (courseDBManagedObjects) -> Void in
            var isMatch = false
            if let courses = courseDBManagedObjects {
                for course in courses {
                    // find if match
                    if let code = course.code {
                        if code == courseCode {
                            isMatch = true
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                complete(ifEnrolled: true)
                            })
                        }
                    }
                }
            }
            if !isMatch {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    complete(ifEnrolled: false)
                })
            }
        }
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
//                    cell.hasEnrolledState = checkIfEnrolled(cell.course.code)
                    checkIfEnrolled(cell.course.code, complete: { (ifEnrolled) -> Void in
                        cell.hasEnrolledState = ifEnrolled
                    })
                } else {
                    cell.course = localCachingObjects[indexPath.row]
                    cell.delegate = self
                    cell.sideColorHintView.backgroundColor = cellColors[indexPath.row % cellColors.count]
//                    cell.hasEnrolledState = checkIfEnrolled(cell.course.code)
                    checkIfEnrolled(cell.course.code, complete: { (ifEnrolled) -> Void in
                        cell.hasEnrolledState = ifEnrolled
                    })
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
                cell.localCourse = nil
                cell.course = enrolledCourses[indexPath.row]
                cell.delegate = self
                cell.sideColorHintView.backgroundColor = cellColors[indexPath.row % cellColors.count]
//                cell.hasEnrolledState = checkIfEnrolled(cell.course.code)
                checkIfEnrolled(cell.course.code, complete: { (ifEnrolled) -> Void in
                    print(ifEnrolled)
                    cell.hasEnrolledState = ifEnrolled
                })
            } else {
                cell.course = nil
                cell.localCourse = enrolledLocalCourse[indexPath.row]
                cell.delegate = self
                cell.sideColorHintView.backgroundColor = cellColors[indexPath.row % cellColors.count]
            }
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if self.courseSegementedControl.selectedSegmentIndex == 0 {
            if indexPath.section == 0 {
                performSegueWithIdentifier(Storyboard.showCourseDetailViewSegueIdentifier, sender: filteredCourses[indexPath.row])
            }
        } else {
            if indexPath.section == 0 {
                performSegueWithIdentifier(Storyboard.showCourseDetailViewSegueIdentifier, sender: enrolledCourses[indexPath.row])
            } else {
                performSegueWithIdentifier(Storyboard.showCourseDetailViewSegueIdentifier, sender: enrolledLocalCourse[indexPath.row])
            }
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if self.courseSegementedControl.selectedSegmentIndex == 1 {
            if section == 1 {
                // this section is for local course
                return "自訂課程"
            }
        }
        return nil
    }
}

// MARK: - CreateCourseTableViewCellDelegate
extension SearchCourseViewController : CreateCourseTableViewCellDelegate {
    func didTapOnCreateCourseCell(courseName: String?) {
        print(courseName)
        performSegueWithIdentifier(Storyboard.toCreateCourseSegue, sender: courseName)
    }
}

// MARK: - UITableViewDelegate
extension SearchCourseViewController : UITableViewDelegate {
    
}

// MARK: - CreateCourseTableViewControllerDelegate
extension SearchCourseViewController : CreateCourseTableViewControllerDelegate {
    func createCourseTableViewControllerDidCreateLocalCourse() {
        loadEnrolledLocalCourses()
    }
}

