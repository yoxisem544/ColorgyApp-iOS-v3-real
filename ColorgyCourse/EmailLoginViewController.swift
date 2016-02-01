//
//  EmailLoginViewController.swift
//  ColorgyCourse
//
//  Created by David on 2015/9/4.
//  Copyright (c) 2015年 David. All rights reserved.
//

import UIKit

class EmailLoginViewController: UIViewController {

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var emailLoginTextField: UITextField!
    @IBOutlet weak var passwordLoginTextField: UITextField!
    
    private func configureTextFields() {
        emailLoginTextField.backgroundColor = UIColor(red: 250/255.0, green: 247/255.0, blue: 245/255.0, alpha: 1)
        passwordLoginTextField.backgroundColor = UIColor(red: 250/255.0, green: 247/255.0, blue: 245/255.0, alpha: 1)
        emailLoginTextField.layer.cornerRadius = 2.0
        passwordLoginTextField.layer.cornerRadius = 2.0
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // test region
        if !Release().mode {
            emailLoginTextField.text = "test-cyu-student-1d1e@test.colorgy.io"
            passwordLoginTextField.text = "test-cyu-student-1d1e"
        }

        // Do any additional setup after loading the view.
        configureTextFields()
        configureLoginButton()
        
        // delegate
        emailLoginTextField.delegate = self
        emailLoginTextField.returnKeyType = UIReturnKeyType.Next
        passwordLoginTextField.delegate = self
        passwordLoginTextField.returnKeyType = UIReturnKeyType.Go
        
        // register for keyboard notification
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidHide:", name: UIKeyboardDidHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
        
        // tap to dismiss keyboard
        let tap = UITapGestureRecognizer(target: self, action: "tap")
        self.view.addGestureRecognizer(tap)
    }
    
    func tap() {
        emailLoginTextField.resignFirstResponder()
        passwordLoginTextField.resignFirstResponder()
    }
    
    func keyboardDidHide(notification: NSNotification) {
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.view.frame.origin = CGPointZero
        })
    }
    
    func keyboardDidShow(notification: NSNotification) {
        let userInfo = notification.userInfo ?? [:]
        let keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue().size
        let offset = (self.view.frame.height - keyboardSize.height) / 2
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.view.frame.origin.y = -(self.emailLoginTextField.frame.origin.y - offset)
        })
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // Flurry
        if Release().mode {
            Flurry.logEvent("v3.0: User On Email Login View", timed: true)
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        if Release().mode {
            Flurry.endTimedEvent("User On Email Login View", withParameters: nil)
        }
    }

    @IBOutlet weak var emailLoginButton: UIButton!
    func configureLoginButton() {
        emailLoginButton.layer.borderColor = emailLoginButton.tintColor?.CGColor
        emailLoginButton.layer.borderWidth = 2.0
        emailLoginButton.layer.cornerRadius = 2.0
    }
    @IBAction func emailLoginButtonClicked(sender: AnyObject) {
        // hide keyboard
        emailLoginTextField.resignFirstResponder()
        passwordLoginTextField.resignFirstResponder()
        self.view.endEditing(true)
        hideButtons()
        if canLogin() {
            let username = emailLoginTextField.text ?? ""
            let password = passwordLoginTextField.text ?? ""
            ColorgyLogin.loginToColorgyWithUsername(username: username, password: password, success: { (result) -> Void in
                UserSetting.storeLoginResult(result: result)
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
								UserSetting.registerCourseNotification()
							} else {
								// fail to get period data
								//                                        let alert = ErrorAlertView.alertUserWithError("讀取課程時間資料錯誤，請重新登入。或者為學校尚未開通使用！")
								//                                        self.presentViewController(alert, animated: true, completion: nil)
								//                                        self.showButtons()
								UserSetting.storeFakePeriodsData()
								if Release().mode {
									Flurry.logEvent("v3.0: User login using FB, but has no period data")
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
				})
            }, failure: { () -> Void in
                let alert = ErrorAlertView.alertUserWithError("登入失敗，請確認帳號密碼無誤。如果忘記帳號密碼請至Colorgy網頁查詢。")
                self.presentViewController(alert, animated: true, completion: nil)
                self.showButtons()
            })
        } else {
            let alert = ErrorAlertView.alertUserWithError("請確定密碼大於8碼，且是有效的Email。")
            self.presentViewController(alert, animated: true, completion: nil)
            self.showButtons()
        }
		
    }
	
    func canLogin() -> Bool {
        if emailLoginTextField.text != "" {
            if passwordLoginTextField.text?.characters.count >= 8 {
                return true
            }
        }
        return false
    }
	
    @IBAction func closeButtonClicked(sender: AnyObject) {
        self.view.endEditing(true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
	
    func hideButtons() {
        emailLoginButton.hidden = true
		
        emailLoginTextField.hidden = true
        passwordLoginTextField.hidden = true
        closeButton.hidden = true
    }
	
    func showButtons() {
        emailLoginButton.hidden = false
		
        emailLoginTextField.hidden = false
        passwordLoginTextField.hidden = false
        closeButton.hidden = false
    }
	


}

extension EmailLoginViewController : UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == emailLoginTextField {
            passwordLoginTextField.becomeFirstResponder()
        } else if textField == passwordLoginTextField {
            passwordLoginTextField.resignFirstResponder()
            self.emailLoginButtonClicked(self.emailLoginButton)
        }
        
        return true
    }
}
