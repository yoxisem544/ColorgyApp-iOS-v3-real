//
//  ChooseDepartmentViewController.swift
//  ColorgyCourse
//
//  Created by David on 2015/11/24.
//  Copyright © 2015年 David. All rights reserved.
//

import UIKit

class ChooseDepartmentViewController: UIViewController {
    
    @IBOutlet weak var departmentTableView: UITableView!
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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        departmentTableView.delegate = self
        departmentTableView.dataSource = self
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
    }
    
    @IBAction func backButtonClicked() {
        dismissViewControllerAnimated(true, completion: nil)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ChooseDepartmentViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.segueIdentifier, forIndexPath: indexPath)
        cell.accessoryType = .None
        let name = (departments == nil ? "" : departments[indexPath.row].name)
        cell.textLabel?.text = name
        
        // set checkmark
        if indexPathUserSelected >= 0 {
            if indexPathUserSelected == indexPath.row {
                cell.accessoryType = .Checkmark
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if departments == nil {
            return 0
        } else {
            return departments.count
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
        
        choosedDepartment = departments[indexPath.row].code
        
        indexPathUserSelected = indexPath.row
    }
}
