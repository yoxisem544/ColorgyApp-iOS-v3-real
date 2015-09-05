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
                        // fetcg me api
                        ColorgyAPI.me({ (result) -> Void in
                            // store usr settings
//                            self.statusLabel.text = "setting me api result"
                            UserSetting.storeAPIMeResult(result: result)
//                            self.statusLabel.text = "generateAndStoreDeviceUUID"
                            UserSetting.generateAndStoreDeviceUUID()
                            
                            // get period data
                            ColorgyAPI.getSchoolPeriodData({ (periodDataObjects) -> Void in
                                if let periodDataObjects = periodDataObjects {
                                    UserSetting.storePeriodsData(periodDataObjects)
                                    // ready to change view
                                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                    let vc = storyboard.instantiateViewControllerWithIdentifier("TabBarViewController") as! UITabBarController
                                    self.presentViewController(vc, animated: true, completion: nil)
                                    UserSetting.changeLoginStateSuccessfully()
                                } else {
                                    // fail to get period data
                                    let alert = ErrorAlertView.alertUserWithError("讀取課程時間資料錯誤，請重新登入。")
                                    self.presentViewController(alert, animated: true, completion: nil)
                                    self.showButtons()
                                }
                            })
                            }, failure: { () -> Void in
//                                self.statusLabel.text = "fail get me api"
                                let alert = ErrorAlertView.alertUserWithError("讀取個人資料錯誤，請重新登入。")
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