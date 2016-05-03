//
//  FBLoginViewController.swift
//  ColorgyCourse
//
//  Created by David on 2015/9/4.
//  Copyright (c) 2015年 David. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics

class FBLoginViewController: UIViewController {

    
    @IBOutlet weak var FBloginButton: UIButton!
    @IBAction func FBloginButtonClicked(sender: UIButton) {
		Mixpanel.sharedInstance().track(MixpanelEvents.ClickFacebookLogin)
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
                                // self.statusLabel.text = "setting me api result"
                                UserSetting.storeAPIMeResult(result: result)
                                // self.statusLabel.text = "generateAndStoreDeviceUUID"
                                UserSetting.generateAndStoreDeviceUUID()
                                // set state refresh can use
                                ColorgyAPITrafficControlCenter.setRefreshStateToCanRefresh()
								
								Mixpanel.sharedInstance().track(MixpanelEvents.FacebookLoginSuccess)
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
//                                        let alert = ErrorAlertView.alertUserWithError("讀取課程時間資料錯誤，請重新登入。或者為學校尚未開通使用！")
//                                        self.presentViewController(alert, animated: true, completion: nil)
//                                        self.showButtons()
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
                                let vc = storyboard.instantiateViewControllerWithIdentifier("A1") as! UINavigationController
                                self.presentViewController(vc, animated: true, completion: nil)
                            }
                            }, failure: { () -> Void in
//                                self.statusLabel.text = "fail get me api"
                                let alert = ErrorAlertView.alertUserWithError("讀取個人資料錯誤，請重新登入。如果你是第一次登入，請至Colorgy網頁填寫你的學校！如果有不清楚的地方請到粉專詢問！")
                                self.presentViewController(alert, animated: true, completion: nil)
                                self.showButtons()
								Mixpanel.sharedInstance().track(MixpanelEvents.FacebookLoginFail)
                        })
                    } else {
//                        self.statusLabel.text = "login colorgy fail, \(error)"
						if let code = error as? Int {
							let alert = ErrorAlertView.alertUserWithError("登入Colorgy錯誤，錯誤代碼：\(code)。請給我們一點時間修復！造成您的不便我們深感抱歉！😖")
							self.presentViewController(alert, animated: true, completion: nil)
							self.showButtons()
							Mixpanel.sharedInstance().track(MixpanelEvents.FacebookLoginFail)
						} else {
							let alert = ErrorAlertView.alertUserWithError("登入Colorgy錯誤，請重新登入。\n如果一直無法登入，請嘗試按兩下Home鍵，把APP退出後重新開啟APP。")
							self.presentViewController(alert, animated: true, completion: nil)
							self.showButtons()
							Mixpanel.sharedInstance().track(MixpanelEvents.FacebookLoginFail)
						}
                    }
                })
            } else {
//                self.statusLabel.text = "login fb fail"
                let alert = ErrorAlertView.alertUserWithError("登入Facebook錯誤。\n如果一直無法登入，請嘗試按兩下Home鍵，把APP退出後重新開啟APP。")
                self.presentViewController(alert, animated: true, completion: nil)
                self.showButtons()
				Mixpanel.sharedInstance().track(MixpanelEvents.FacebookLoginFail)
            }
        }
    }
    func configureLoginButton() {
        EmailLoginButton.layer.cornerRadius = 4.0
		emailRegisterButton.layer.cornerRadius = 4.0
    }
    @IBOutlet weak var EmailLoginButton: UIButton!
	@IBOutlet weak var emailRegisterButton: UIButton!
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
		
		navigationController?.navigationBarHidden = true
    }
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
	}
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        Analytics.stopTrackingOnFBLoginView()
		navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        Analytics.stopTrackingOnFBLoginView()
    }
    
    // MARK: - show/hide buttons
    func showButtons() {
        FBloginButton.hidden = false
        EmailLoginButton.hidden = false
		emailRegisterButton.hidden = false
    }
    
    func hideButtons() {
        FBloginButton.hidden = true
        EmailLoginButton.hidden = true
		emailRegisterButton.hidden = true
    }

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Storyboard.emailLogin {
            navigationController?.setNavigationBarHidden(false, animated: true)
		} else {
			navigationController?.setNavigationBarHidden(false, animated: true)
		}
    }

}
