//
//  ChooseIntendedTimeViewController.swift
//  ColorgyCourse
//
//  Created by David on 2015/12/15.
//  Copyright © 2015年 David. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics

class ChooseIntendedTimeViewController: UIViewController {
    
    @IBOutlet weak var intendedTimeTableView: UITableView?
    var intendedTimes: [Int]?
    let intendedInfos = ["大六", "大五", "大四", "大三", "大二", "大一"]
    var indexPathUserSelected: Int = -1
    var choosedIntendedTime: Int?
    // temp
    var school: String!
    var department: String!
    var currentYear: Int = 1945
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        intendedTimeTableView?.delegate = self
        intendedTimeTableView?.dataSource = self
        
        let s = Semester.currentSemesterAndYear()
        currentYear = s.0
        intendedTimes = [Int]()
        for y in (currentYear-5)...(currentYear) {
            intendedTimes?.append(y)
        }
        intendedTimeTableView?.reloadData()
		
		title = "選擇入學年度"
		
		let barButton = UIBarButtonItem(title: "送出", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(finishChoosingAndReadyToPATCHUserInfo))
		self.navigationItem.rightBarButtonItem = barButton
		
		Mixpanel.sharedInstance().track(MixpanelEvents.SelectStartTime)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    struct Storyboard {
        static let segueIdentifier = "ChooseIntendedTimeentIdentifer"
    }
    
    @IBAction func finishChoosingAndReadyToPATCHUserInfo() {
        if school != nil && department != nil && choosedIntendedTime != nil {
            print("\(school) \(department) \(choosedIntendedTime)")
            ColorgyAPI.PATCHUserInfo(school, department: department, year: String(choosedIntendedTime!), success: { () -> Void in
                // login if user patch the info
                ColorgyAPI.me({ (result) -> Void in
                    // check if user has a school or deparment
                    // log out result here
                    if result.isUserRegisteredTheirSchool() {
                        // store usr settings
                        //                            self.statusLabel.text = "setting me api result"
                        UserSetting.storeAPIMeResult(result: result)
						print(result)
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
								Mixpanel.sharedInstance().track(MixpanelEvents.submitUserInfoSuccessfully)
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
								Mixpanel.sharedInstance().track(MixpanelEvents.SubmitFeedbackFormSuccess)
                            }
                        })
                    } else {
                        // user need to fill in their school and their department
                        // show the register view
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewControllerWithIdentifier("A1") as! ChooseSchoolViewController
                        self.presentViewController(vc, animated: true, completion: nil)
						Mixpanel.sharedInstance().track(MixpanelEvents.submitUserInfoFail)
                    }
                    }, failure: { () -> Void in
                        //                                self.statusLabel.text = "fail get me api"
                        let alert = ErrorAlertView.alertUserWithError("讀取個人資料錯誤，請重新登入。如果你是第一次登入，請至Colorgy網頁填寫你的學校！如果有不清楚的地方請到粉專詢問！")
                        self.presentViewController(alert, animated: true, completion: nil)
						Mixpanel.sharedInstance().track(MixpanelEvents.submitUserInfoFail)
                })
                }, failure: { () -> Void in
                    // show something
					Mixpanel.sharedInstance().track(MixpanelEvents.submitUserInfoFail)
            })
        }
    }

}

extension ChooseIntendedTimeViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.segueIdentifier, forIndexPath: indexPath)
        cell.accessoryType = .None
        let intendedTime = (intendedTimes == nil ? 1945 : intendedTimes![indexPath.row])
        // check year and term
        cell.textLabel?.text = String(intendedTime) + " " + String(intendedTime - 1911) + "年度 " + intendedInfos[indexPath.row]
        
        // set checkmark
        if indexPathUserSelected >= 0 {
            if indexPathUserSelected == indexPath.row {
                cell.accessoryType = .Checkmark
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if intendedTimes != nil {
            return intendedTimes!.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPathUserSelected >= 0 {
            let previousCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: indexPathUserSelected, inSection: 0))
            previousCell?.accessoryType = .None
        }
        
        print(indexPath.row)
        let thisCell = tableView.cellForRowAtIndexPath(indexPath)
        thisCell?.accessoryType = .Checkmark
        
        choosedIntendedTime = intendedTimes?[indexPath.row]
        
        indexPathUserSelected = indexPath.row
    }
}
