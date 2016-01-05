//
//  ChooseIntendedTimeViewController.swift
//  ColorgyCourse
//
//  Created by David on 2015/12/15.
//  Copyright © 2015年 David. All rights reserved.
//

import UIKit

class ChooseIntendedTimeViewController: UIViewController {
    
    @IBOutlet weak var intendedTimeTableView: UITableView?
    var intendedTimes: [Int]?
    var indexPathUserSelected: Int = -1
    var choosedIntendedTime: Int?
    // temp
    var school: String!
    var department: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        intendedTimeTableView?.delegate = self
        intendedTimeTableView?.dataSource = self
        
        let now = NSDate()
        let formatter = NSDateFormatter()
        //        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
        formatter.dateFormat = "yyyy"
        // calculate the year
        let year = Int(formatter.stringFromDate(now)) ?? 1945
        intendedTimes = [Int]()
        for y in (year-10)...(year+4) {
            intendedTimes?.append(y)
        }
        intendedTimeTableView?.reloadData()
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

}

extension ChooseIntendedTimeViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.segueIdentifier, forIndexPath: indexPath)
        cell.accessoryType = .None
        let intendedTime = (intendedTimes == nil ? 1945 : intendedTimes![indexPath.row])
        cell.textLabel?.text = String(intendedTime)
        
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