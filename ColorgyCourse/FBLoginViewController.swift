//
//  FBLoginViewController.swift
//  ColorgyCourse
//
//  Created by David on 2015/9/4.
//  Copyright (c) 2015年 David. All rights reserved.
//

import UIKit

class FBLoginViewController: UIViewController {

    
    @IBOutlet weak var FBloginButton: UIButton!
    @IBAction func FBloginButtonClicked(sender: UIButton) {
        // hide buttons
        hideButtons()
        // contiune login
        ColorgyLogin.loginToFacebook { (token) -> Void in
            if let token = token {
                ColorgyLogin.loginToColorgyWithToken(token, handler: { (response, error) -> Void in
                    if let response = response {
                        // login ok
                        UserSetting.storeLoginResult(result: response)
                        print(response)
                        // fetcg me api
                        ColorgyAPI.me({ (result) -> Void in
                            // check if user has a school or deparment
                            // log out result here
                            print(result)
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
                                        // ready to change view
                                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                        let vc = storyboard.instantiateViewControllerWithIdentifier("TabBarViewController") as! UITabBarController
                                        self.presentViewController(vc, animated: true, completion: nil)
                                        UserSetting.changeLoginStateSuccessfully()
                                    } else {
                                        // fail to get period data
                                        let alert = ErrorAlertView.alertUserWithError("讀取課程時間資料錯誤，請重新登入。或者為學校尚未開通使用！")
                                        self.presentViewController(alert, animated: true, completion: nil)
                                        self.showButtons()
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
                                self.showButtons()
                        })
                    } else {
//                        self.statusLabel.text = "login colorgy fail, \(error)"
                        let alert = ErrorAlertView.alertUserWithError("登入Colorgy錯誤，請重新登入。")
                        self.presentViewController(alert, animated: true, completion: nil)
                        self.showButtons()
                    }
                })
            } else {
//                self.statusLabel.text = "login fb fail"
                let alert = ErrorAlertView.alertUserWithError("登入Facebook錯誤，請重新登入。")
                self.presentViewController(alert, animated: true, completion: nil)
                self.showButtons()
            }
        }
    }
    func configureLoginButton() {
        EmailLoginButton.layer.borderColor = EmailLoginButton.tintColor?.CGColor
        EmailLoginButton.layer.borderWidth = 2.0
        EmailLoginButton.layer.cornerRadius = 2.0
    }
    @IBOutlet weak var EmailLoginButton: UIButton!
    @IBAction func EmailLoginButtonClicked(sender: UIButton) {
        self.performSegueWithIdentifier(Storyboard.emailLogin, sender: sender)
    }
    
    struct Storyboard {
        static let emailLogin = "To Email Login"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureLoginButton()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // Flurry
        if Release().mode {
            Flurry.logEvent("v3.0: User On FB Login View", timed: true)
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        if Release().mode {
            Flurry.endTimedEvent("v3.0: User On FB Login View", withParameters: nil)
        }
    }
    
    // MARK: - show/hide buttons
    func showButtons() {
        FBloginButton.hidden = false
        EmailLoginButton.hidden = false
    }
    
    func hideButtons() {
        FBloginButton.hidden = true
        EmailLoginButton.hidden = true
    }

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Storyboard.emailLogin {
            
        }
    }

}
