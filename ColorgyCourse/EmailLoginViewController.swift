//
//  EmailLoginViewController.swift
//  ColorgyCourse
//
//  Created by David on 2015/9/4.
//  Copyright (c) 2015年 David. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics

class EmailLoginViewController: UIViewController {
	
	private var containerView: UIScrollView!
	
	private var emailInputField: UITextField!
	private var passwordInputField: UITextField!
	
	private var loginButton: UIButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// register for keyboard notification
		//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidHide:", name: UIKeyboardDidHideNotification, object: nil)
		//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
		
		title = "登入"
		
		automaticallyAdjustsScrollViewInsets = false
		
		configureContainerView()
		configureTextInput()
		configureButton()
		
		view.backgroundColor = ColorgyColor.BackgroundColor
		
		// tap to dismiss keyboard
		let tapGes = UITapGestureRecognizer(target: self, action: #selector(tap))
		self.view.addGestureRecognizer(tapGes)
		
		// test region
		if !Release.mode {
			emailInputField.text = "colorgy-test-account-300@test.colorgy.io"
			passwordInputField.text = "colorgy-test-account-300"
		}
	}
	
	func tap() {
		emailInputField.resignFirstResponder()
		passwordInputField.resignFirstResponder()
	}
	
	func keyboardDidHide(notification: NSNotification) {
		UIView.animateWithDuration(0.2, animations: { () -> Void in
			self.view.frame.origin = CGPointZero
		})
	}
	
	//    func keyboardDidShow(notification: NSNotification) {
	//        let userInfo = notification.userInfo ?? [:]
	//        let keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue().size
	//        let offset = (self.view.frame.height - keyboardSize.height) / 2
	//        UIView.animateWithDuration(0.2, animations: { () -> Void in
	//            self.view.frame.origin.y = -(self.emailInputField.frame.origin.y - offset)
	//        })
	//    }
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		// Flurry
		if Release.mode {
			Flurry.logEvent("v3.0: User On Email Login View", timed: true)
		}
	}
	
	override func viewDidDisappear(animated: Bool) {
		super.viewDidDisappear(animated)
		if Release.mode {
			Flurry.endTimedEvent("User On Email Login View", withParameters: nil)
		}
	}
	
	func emailLoginButtonClicked() {
		Mixpanel.sharedInstance().track(MixpanelEvents.ClickEmailLogin)
		// hide keyboard
		emailInputField.resignFirstResponder()
		passwordInputField.resignFirstResponder()
		self.view.endEditing(true)
		hideButtons()
		if canLogin() {
			let username = emailInputField.text ?? ""
			let password = passwordInputField.text ?? ""
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
								if Release.mode {
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
								UserSetting.registerCourseNotification()
							} else {
								// fail to get period data
								//                                        let alert = ErrorAlertView.alertUserWithError("讀取課程時間資料錯誤，請重新登入。或者為學校尚未開通使用！")
								//                                        self.presentViewController(alert, animated: true, completion: nil)
								//                                        self.showButtons()
								UserSetting.storeFakePeriodsData()
								if Release.mode {
									Flurry.logEvent("v3.0: User login using FB, but has no period data")
									Answers.logCustomEventWithName(AnswersLogEvents.userLoginWithFacebook, customAttributes: nil)
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
					let alert = ErrorAlertView.alertUserWithError("登入失敗，請確認帳號密碼無誤。如果忘記帳號密碼或新會員請用Facebook登入。")
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
		if emailInputField.text != "" {
			if passwordInputField.text?.characters.count >= 8 {
				return true
			}
		}
		return false
	}
	
	@IBAction func closeButtonClicked(sender: AnyObject) {
		self.view.endEditing(true)
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	
	private func configureTextInput() {
		let topMargin: CGFloat = 24.0
		let a = generateTextInputView("grayEmailIcon", placeholder: "輸入信箱", keyboardType: .EmailAddress, isPassword: false)
		let b = generateTextInputView("grayPasswordIcon", placeholder: "輸入密碼", keyboardType: .Default, isPassword: true)
		
		a._view.frame.origin.y = topMargin
		b._view.frame.origin.y = topMargin + (4 + 44)
		
		emailInputField = a.textField
		passwordInputField = b.textField
		
		a._view.anchorViewTo(containerView)
		b._view.anchorViewTo(containerView)
	}
	
	private func configureButton() {
		loginButton = UIButton(type: UIButtonType.System)
		loginButton.backgroundColor = ColorgyColor.MainOrange
		loginButton.tintColor = UIColor.whiteColor()
		loginButton.titleLabel?.font = UIFont.systemFontOfSize(14.0)
		loginButton.setTitle("登入", forState: UIControlState.Normal)
		
		loginButton.layer.cornerRadius = 4.0
		
		loginButton.frame.size = CGSize(width: 249, height: 44)
		
		if let superview = passwordInputField.superview {
			loginButton.frame.origin.y = superview.frame.maxY + 36
			loginButton.center.x = containerView.contentSize.width / 2
		}
		
		loginButton.anchorViewTo(containerView)
		
		loginButton.addTarget(self, action: #selector(emailLoginButtonClicked), forControlEvents: UIControlEvents.TouchUpInside)
	}
	
	private func configureContainerView() {
		containerView = UIScrollView(frame: CGRect(x: 0, y: 64, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height))
		containerView.contentSize = containerView.frame.size
		containerView.anchorViewTo(view)
	}
	
	private func generateTextInputView(imageName: String, placeholder: String?, keyboardType: UIKeyboardType, isPassword: Bool) -> (_view: UIView, textField: UITextField) {
		
		let _view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 44))
		let placeholderImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 18, height: 16))
		let inputTextField = UITextField(frame: CGRect(x: 0, y: 0, width: 100, height: 26))
		
		// configure _view
		_view.backgroundColor = UIColor.whiteColor()
		
		// configure placeholder image _view
		placeholderImageView.image = UIImage(named: imageName)
		
		// configure text input _view
		inputTextField.placeholder = placeholder
		
		// arrange
		placeholderImageView.frame.origin.x = 36
		placeholderImageView.center.y = _view.bounds.midY - 1
		
		let trailingSpace: CGFloat = 8.0
		let imageAndTextFieldGap: CGFloat = 12.0
		inputTextField.frame.size.width = UIScreen.mainScreen().bounds.width - imageAndTextFieldGap - placeholderImageView.frame.maxX - trailingSpace
		inputTextField.center.y = _view.bounds.midY
		inputTextField.frame.origin.x = placeholderImageView.frame.maxX + imageAndTextFieldGap
		
		inputTextField.keyboardType = keyboardType
		inputTextField.secureTextEntry = isPassword
		
		// anchor _view
		inputTextField.anchorViewTo(_view)
		placeholderImageView.anchorViewTo(_view)
		
		return (_view, inputTextField)
	}
	
	func showButtons() {
		loginButton.enabled = true
	}
	
	func hideButtons() {
		loginButton.enabled = false
	}
}

extension EmailLoginViewController : UITextFieldDelegate {
	
}
