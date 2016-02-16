//
//  ChooseDepartmentViewController.swift
//  ColorgyCourse
//
//  Created by David on 2015/11/24.
//  Copyright © 2015年 David. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics

class ChooseDepartmentViewController: UIViewController {
    
    @IBOutlet weak var departmentTableView: UITableView!
    
    var searchControl = UISearchController()
    
    var filteredDepartments: [Department] = []
    var filteredIndexPathUserSelected = -1
    
    var school: String!
    var indexPathUserSelected: Int = -1
    var departments: [Department]! {
        didSet {
            if departments == nil {
                ColorgyAPI.getDepartments(school, success: { (departments) -> Void in
                    self.departments = departments
                    print(departments)
                    }, failure: { () -> Void in
                        // try again
                        self.departments = nil
                })
            } else {
                // reload table view
                departmentTableView.reloadData()
            }
        }
    }
    var choosedDepartment: String!
	var shouldShowReport: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        departmentTableView.delegate = self
        departmentTableView.dataSource = self
        
        searchControl = UISearchController(searchResultsController: nil)
        searchControl.searchResultsUpdater = self
        searchControl.searchBar.sizeToFit()
		searchControl.searchBar.delegate = self
        searchControl.dimsBackgroundDuringPresentation = false
        
        departmentTableView.tableHeaderView = searchControl.searchBar
        searchControl.searchBar.placeholder = "搜尋系所"
		
		title = "選擇系所"
		Mixpanel.sharedInstance().track(MixpanelEvents.SelectDepartment)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        departments = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    struct Storyboard {
        static let segueIdentifier = "ChooseDepartmentIdentifer"
        static let showIntentedTimeSegue = "show intended time"
        static let cantFindDepIdentifier = "cant find dep identifier"
    }
    
    @IBAction func backButtonClicked() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == Storyboard.showIntentedTimeSegue {
            let destinationVC = segue.destinationViewController as! ChooseIntendedTimeViewController
            destinationVC.school = self.school
            destinationVC.department = self.choosedDepartment
			if let department = sender as? String {
				destinationVC.department = department
			}
        }
    }
    
    @IBAction func finishChoosingAndReadyToPATCHUserInfo() {
        if school != nil && choosedDepartment != nil {
            ColorgyAPI.PATCHUserInfo(school, department: choosedDepartment, year: "2014", success: { () -> Void in
                // login if user patch the info
                ColorgyAPI.me({ (result) -> Void in
                    // check if user has a school or deparment
                    // log out result here
                    if result.isUserRegisteredTheirSchool() {
                        // store usr settings
                        //                            self.statusLabel.text = "setting me api result"
                        UserSetting.storeAPIMeResult(result: result)
                        //                            self.statusLabel.text = "generateAndStoreDeviceUUID"
                        UserSetting.generateAndStoreDeviceUUID()
                        // set state refresh can use
                        ColorgyAPITrafficControlCenter.setRefreshStateToCanRefresh()
                        
                        // get period data
                        ColorgyAPI.getSchoolPeriodData({ (periodDataObjects) -> Void in
                            if let periodDataObjects = periodDataObjects {
                                UserSetting.storePeriodsData(periodDataObjects)
                                if Release().mode {
                                    Flurry.logEvent("v3.0: User login using FB")
									Answers.logCustomEventWithName(AnswersLogEvents.userLoginWithFacebook, customAttributes: nil)
                                }
                                // need update course
                                CourseUpdateHelper.needUpdateCourse()
                                // ready to change view
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let vc = storyboard.instantiateViewControllerWithIdentifier("TabBarViewController") as! UITabBarController
                                self.presentViewController(vc, animated: true, completion: nil)
                                UserSetting.changeLoginStateSuccessfully()
                            } else {
                                // fail to get period data
                                let alert = ErrorAlertView.alertUserWithError("讀取課程時間資料錯誤，請重新登入。或者為學校尚未開通使用！")
                                self.presentViewController(alert, animated: true, completion: nil)
                            }
                        })
                    } else {
                        // user need to fill in their school and their department
                        // show the register view
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewControllerWithIdentifier("A1") as! ChooseSchoolViewController
                        self.presentViewController(vc, animated: true, completion: nil)
                    }
                    }, failure: { () -> Void in
                        //                                self.statusLabel.text = "fail get me api"
                        let alert = ErrorAlertView.alertUserWithError("讀取個人資料錯誤，請重新登入。如果你是第一次登入，請至Colorgy網頁填寫你的學校！如果有不清楚的地方請到粉專詢問！")
                        self.presentViewController(alert, animated: true, completion: nil)
                })
                }, failure: { () -> Void in
                    // show something
            })
        }
    }
	
	func showReportController() {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let reportController = storyboard.instantiateViewControllerWithIdentifier("report view controller") as! ReportViewController
		reportController.headerTitle = "儘管沒有系所資料，還是可以使用喔！"
		reportController.reportProblemInitialSelectionTitle = "沒有我的系所"
		reportController.problemDescription = "請填入您尊貴的系所"
		reportController.delegate = self
		let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * 1.0))
		dispatch_after(delay, dispatch_get_main_queue(), { () -> Void in
			self.presentViewController(reportController, animated: true, completion: nil)
		})
	}
}

extension ChooseDepartmentViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if !searchControl.active {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.cantFindDepIdentifier, forIndexPath: indexPath)
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.segueIdentifier, forIndexPath: indexPath)
                cell.accessoryType = .None
                let name = (departments == nil ? "" : departments[indexPath.row - 1].name)
                cell.textLabel?.text = name
                
                // set checkmark
                if indexPathUserSelected >= 0 {
                    if indexPathUserSelected == indexPath.row {
                        cell.accessoryType = .Checkmark
                    }
                }
                
                return cell
            }
        } else {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.cantFindDepIdentifier, forIndexPath: indexPath)
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.segueIdentifier, forIndexPath: indexPath)
                cell.accessoryType = .None
                let name = filteredDepartments[indexPath.row - 1].name
                cell.textLabel?.text = name
                
                // set checkmark
                if indexPathUserSelected >= 0 {
                    if indexPathUserSelected == indexPath.row {
                        cell.accessoryType = .Checkmark
                    }
                }
                
                return cell
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if !searchControl.active {
            if departments == nil {
                return 1
            } else {
                return departments.count + 1
            }
        } else {
            if searchControl.searchBar.text == "" {
                return 0
            } else {
                print("returning number of rows")
                return filteredDepartments.count + 1
            }
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if !searchControl.active {
            if indexPath.row == 0 {
                print("dep need implement perform fro segue")
				searchControl.active = false
				showReportController()
            } else {
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
                if indexPathUserSelected >= 0 {
                    let previousCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: indexPathUserSelected, inSection: 0))
                    previousCell?.accessoryType = .None
                }
                
                print(indexPath.row)
                let thisCell = tableView.cellForRowAtIndexPath(indexPath)
                thisCell?.accessoryType = .Checkmark
                
                if departments != nil {
                    choosedDepartment = departments[indexPath.row - 1].code
                }
                
                indexPathUserSelected = indexPath.row
                
                let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * 0.4))
                dispatch_after(delay, dispatch_get_main_queue(), { () -> Void in
                    self.performSegueWithIdentifier(Storyboard.showIntentedTimeSegue, sender: nil)
                })
            }
        } else {
            if indexPath.row == 0 {
                print("dep need implement perform fro segue")
				searchControl.searchBar.endEditing(true)
				showReportController()
            } else {
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
                if indexPathUserSelected >= 0 {
                    let previousCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: indexPathUserSelected, inSection: 0))
                    previousCell?.accessoryType = .None
                }
                
                print(indexPath.row)
                let thisCell = tableView.cellForRowAtIndexPath(indexPath)
                thisCell?.accessoryType = .Checkmark
                
                choosedDepartment = filteredDepartments[indexPath.row - 1].code
                
                indexPathUserSelected = indexPath.row
                
                let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * 0.4))
                dispatch_after(delay, dispatch_get_main_queue(), { () -> Void in
                    self.performSegueWithIdentifier(Storyboard.showIntentedTimeSegue, sender: nil)
                })
            }
        }
        
        deactiveSearchBar()
    }
    
    func deactiveSearchBar() {
        searchControl.active = false
    }
}

extension ChooseDepartmentViewController : UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if searchController.active {
            filterContentForSearchText(searchController.searchBar.text!)
        } else {
            departmentTableView.reloadData()
        }
    }
    
    func filterContentForSearchText(searchText: String) {
        
        filteredDepartments = []
        
        indexPathUserSelected = -1
        filteredIndexPathUserSelected = -1
        
        guard departments != nil else { return }
        
        if searchText != "" {
            let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
            dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in
                
                for d in self.departments {
                    var isMatch = false
                    if d.name.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch) != nil {
                        isMatch = true
                    }

                    if isMatch {
                        self.filteredDepartments.append(d)
                    }
                }
                // after filtering, return to main queue
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    print(self.filteredDepartments)
                    self.departmentTableView.reloadData()
                    print("reload after filtering")
                })
            })
        } else {
            departmentTableView.reloadData()
        }
    }
}

extension ChooseDepartmentViewController : ReportViewControllerDelegate {
	func reportViewControllerSuccessfullySentReport() {
		self.performSegueWithIdentifier(Storyboard.showIntentedTimeSegue, sender: "null")
	}
}

extension ChooseDepartmentViewController : UISearchBarDelegate {
	func searchBarTextDidEndEditing(searchBar: UISearchBar) {
		print("end editing!!")
		if shouldShowReport {
			shouldShowReport = false
			showReportController()
		}
	}
}