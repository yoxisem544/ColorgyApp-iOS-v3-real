//
//  ChooseSchoolViewController.swift
//  ColorgyCourse
//
//  Created by David on 2015/11/19.
//  Copyright © 2015年 David. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics

class ChooseSchoolViewController: UIViewController {
    
    @IBOutlet weak var schoolTableView: UITableView!
    
    var searchControl = UISearchController()

    var schools: [School]! {
        didSet {
            if schools == nil {
                ColorgyAPI.getSchools({ (schools) -> Void in
                    self.schools = schools
                    }, failure: { () -> Void in
                        print("failllll...")
                        // try again
                        self.schools = nil
                })
            } else {
                // reload data
                self.schoolTableView.reloadData()
            }
        }
    }
    
    var filteredSchools: [School] = []
    
    
    @IBAction func test() {
        ColorgyAPI.getSchools({ (schools) -> Void in
            print(schools)
            }) { () -> Void in
                print("failllll...")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        schoolTableView.delegate = self
        schoolTableView.dataSource = self
        
        searchControl = UISearchController(searchResultsController: nil)
        searchControl.searchResultsUpdater = self
        searchControl.searchBar.sizeToFit()
        searchControl.dimsBackgroundDuringPresentation = false
        
        schoolTableView.tableHeaderView = searchControl.searchBar
        searchControl.searchBar.placeholder = "搜尋學校"
		
		title = "選擇學校"
		Mixpanel.sharedInstance().track(MixpanelEvents.SelectSchool)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if schools == nil {
            schools = nil
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == Storyboard.showDepartmentSegue {
            let destinationVC = segue.destinationViewController as! ChooseDepartmentViewController
            destinationVC.school = sender as! String
        }
    }

    
    struct Storyboard {
        static let cellIdentifier = "ChooseSchoolIdentifer"
        static let cantFindSchoolIdentifier = "cant find school identifier"
        static let showDepartmentSegue = "show department"
    }
	
	func showReportController() {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let reportController = storyboard.instantiateViewControllerWithIdentifier("report view controller") as! ReportViewController
		reportController.headerTitle = "儘管沒有學校資料，還是可以使用喔！"
		reportController.reportProblemInitialSelectionTitle = "沒有我的學校"
		reportController.problemDescription = "請填入您尊貴的學校"
		reportController.delegate = self
		let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * 1.0))
		dispatch_after(delay, dispatch_get_main_queue(), { () -> Void in
			self.presentViewController(reportController, animated: true, completion: nil)
		})
	}

}

extension ChooseSchoolViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if !searchControl.active {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.cantFindSchoolIdentifier, forIndexPath: indexPath)
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.cellIdentifier, forIndexPath: indexPath)
                let name = (schools == nil ? "" : schools[indexPath.row - 1].name)
                let code = (schools == nil ? "" : schools[indexPath.row - 1].code.uppercaseString + " ")
                cell.textLabel?.text = "\(code)\(name)"
            
                return cell
            }
        } else {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.cantFindSchoolIdentifier, forIndexPath: indexPath)
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.cellIdentifier, forIndexPath: indexPath)
                print("indexPath.row")
                print(indexPath.row)
                print(filteredSchools.count)
                let name = filteredSchools[indexPath.row - 1].name
                let code = filteredSchools[indexPath.row - 1].code.uppercaseString
                cell.textLabel?.text = "\(code)\(name)"
                
                return cell
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !searchControl.active {
            if schools == nil {
                return 1
            } else {
                return schools.count + 1
            }
        } else {
            if searchControl.searchBar.text == "" {
                return 0
            } else {
                print("returning number of rows")
                return filteredSchools.count + 1
            }
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if !searchControl.active {
            if indexPath.row == 0 {
                print("need to perform segue.....")
				showReportController()
				tableView.deselectRowAtIndexPath(indexPath, animated: true)
            } else {
                if let schoolCode = schools?[indexPath.row - 1].code {
                    let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * 0.3))
                    dispatch_after(delay, dispatch_get_main_queue(), { () -> Void in
                        self.performSegueWithIdentifier(Storyboard.showDepartmentSegue, sender: schoolCode)
                        tableView.deselectRowAtIndexPath(indexPath, animated: true)
                    })
                }
            }
        } else {
            if indexPath.row == 0 {
                print("need to perform segue.....")
				searchControl.active = false
				showReportController()
				tableView.deselectRowAtIndexPath(indexPath, animated: true)
            } else {
                let schoolCode = filteredSchools[indexPath.row - 1].code
                let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * 0.3))
                dispatch_after(delay, dispatch_get_main_queue(), { () -> Void in
                    self.performSegueWithIdentifier(Storyboard.showDepartmentSegue, sender: schoolCode)
                    tableView.deselectRowAtIndexPath(indexPath, animated: true)
                })
            }
        }
        
        // deactive search bar
        deactiveSearchBar()
        
    }
    
    func deactiveSearchBar() {
        searchControl.active = false
    }
}

extension ChooseSchoolViewController : UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        if searchController.active {
            filterContentForSearchText(searchController.searchBar.text!)
        } else {
            schoolTableView.reloadData()
        }
    }
    
    func filterContentForSearchText(searchText: String) {
        
        filteredSchools = []
        
        guard schools != nil else { return }
        
        if searchText != "" {
            let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
            dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in
                
                for s in self.schools {
                    var isMatch = false
                    if s.name.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch) != nil {
                        isMatch = true
                    }
                    if s.code.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil, locale: nil) != nil {
                        isMatch = true
                    }
                    if isMatch {
                        self.filteredSchools.append(s)
                    }
                }
                // after filtering, return to main queue
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    print(self.filteredSchools)
                    self.schoolTableView.reloadData()
                    print("reload after filtering")
                })
            })
        } else {
            schoolTableView.reloadData()
        }
    }
}

extension ChooseSchoolViewController : ReportViewControllerDelegate {
	func reportViewControllerSuccessfullySentReport() {
		print("ok report")
		ColorgyAPI.PATCHUserInfo("null", department: "null", year: "null", success: { () -> Void in
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
							if Release.mode {
								Analytics.trackLoginWithFB()
							}
							// need update course
							CourseUpdateHelper.needUpdateCourse()
							// ready to change view
							let storyboard = UIStoryboard(name: "Main", bundle: nil)
							let vc = storyboard.instantiateViewControllerWithIdentifier("TabBarViewController") as! UITabBarController
							self.presentViewController(vc, animated: true, completion: nil)
							UserSetting.changeLoginStateSuccessfully()
							UserSetting.registerCourseNotification()
						} else {
							// fail to get period data
							//                                let alert = ErrorAlertView.alertUserWithError("讀取課程時間資料錯誤，請重新登入。或者為學校尚未開通使用！")
							//                                self.presentViewController(alert, animated: true, completion: nil)
							UserSetting.storeFakePeriodsData()
							if Release.mode {
								Analytics.trackLoginWithFB()
							}
							// need update course
							CourseUpdateHelper.needUpdateCourse()
							// ready to change view
							let storyboard = UIStoryboard(name: "Main", bundle: nil)
							let vc = storyboard.instantiateViewControllerWithIdentifier("TabBarViewController") as! UITabBarController
							self.presentViewController(vc, animated: true, completion: nil)
							UserSetting.changeLoginStateSuccessfully()
							UserSetting.registerCourseNotification()
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