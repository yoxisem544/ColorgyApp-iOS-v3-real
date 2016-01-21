//
//  PersonalSettingsViewController.swift
//  ColorgyCourse
//
//  Created by David on 2015/9/7.
//  Copyright (c) 2015年 David. All rights reserved.
//

import UIKit

class PersonalSettingsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.backgroundColor = UIColor.whiteColor()
        let statusBarBackgroundView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, 20))
        statusBarBackgroundView.backgroundColor = UIColor.whiteColor()
        self.navigationController?.view.addSubview(statusBarBackgroundView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == Storyboard.privacySegueIdentifier {
            
        }
    }
    
    struct Storyboard {
        static let privacySegueIdentifier = "privacy segue"
        static let notificationTimeSegueIdentifier = "to notification time segue"
    }
    func goToNotificationTimeControl() {
        performSegueWithIdentifier(Storyboard.notificationTimeSegueIdentifier, sender: nil)
    }
    func goToPrivacyControl() {
        performSegueWithIdentifier(Storyboard.privacySegueIdentifier, sender: nil)
    }
    
    func goToFanPage() {
        let alert = UIAlertController(title: "你正準備離開ColorgyTable", message: "你現在要前往我們的粉絲專頁！\n如果喜歡這個App，請幫我們按讚加油打氣！", preferredStyle: UIAlertControllerStyle.Alert)
        let ok = UIAlertAction(title: "好", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
            if UIApplication.sharedApplication().canOpenURL(NSURL(string: "fb://profile/1529686803975150")!) {
                UIApplication.sharedApplication().openURL(NSURL(string: "fb://profile/1529686803975150")!)
            } else {
                UIApplication.sharedApplication().openURL(NSURL(string: "https://www.facebook.com/1529686803975150")!)
            }
            // Flurry
            if Release().mode {
                Flurry.logEvent("v3.0: User goto FB fan page using app.")
            }
        })
        let cancel = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
        alert.addAction(ok)
        alert.addAction(cancel)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func alertLogout() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let alert = UIAlertController(title: "準備登出", message: "確定要登出嗎？登出將會移除手機上的資料，不會影響存在網路上的資料！", preferredStyle: UIAlertControllerStyle.Alert)
            let ok = UIAlertAction(title: "好", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
                LogoutHelper.logoutPrepare(success: { () -> Void in
                    UserSetting.deleteAllUserSettings()
                    ServerCourseDB.deleteAllCourses()
                    CourseDB.deleteAllCourses()
                    // Flurry
                    if Release().mode {
                        Flurry.logEvent("v3.0: User Logout App")
                    }
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewControllerWithIdentifier("Main Login View") as! FBLoginViewController
                    self.presentViewController(vc, animated: true, completion: nil)
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
                        } else {
                            let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * 0.5))
                            dispatch_after(delay, dispatch_get_main_queue(), { () -> Void in
                                let alert = UIAlertController(title: "登出失敗", message: "請檢查網路有沒有暢通～再重新試一次唷！", preferredStyle: UIAlertControllerStyle.Alert)
                                let ok = UIAlertAction(title: "好", style: UIAlertActionStyle.Cancel, handler: nil)
                                alert.addAction(ok)
                                self.presentViewController(alert, animated: true, completion: nil)
                            })
                        }
                })
            })
            let cancel = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
            alert.addAction(ok)
            alert.addAction(cancel)
            self.presentViewController(alert, animated: true, completion: nil)
        })
    }

}

extension PersonalSettingsTableViewController {
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == 0 {
            
        } else if indexPath.section == 1 {
            goToNotificationTimeControl()
        } else if indexPath.section == 2 {
            goToPrivacyControl()
        } else if indexPath.section == 3 {
            goToFanPage()
        } else if indexPath.section == 4 {
            alertLogout()
        }
    }
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let line = UIView(frame: CGRectMake(0, 0, self.view.frame.width, 1))
        line.backgroundColor = UIColor.clearColor()
        return line
    }
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 2.0
    }
}
