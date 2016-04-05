//
//  EmailRegisterViewController.swift
//  ColorgyCourse
//
//  Created by David on 2016/3/21.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

class EmailRegisterViewController: UIViewController {
	
	private var containerView: UIScrollView!
	
	private var userNameInputField: UITextField!
	private var emailInputField: UITextField!
	private var passwordInputField: UITextField!
	private var confirmPasswordInputField: UITextField!
	
	private var registerButton: UIButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "註冊"
		
		automaticallyAdjustsScrollViewInsets = false
		
		configureContainerView()
		configureTextInput()
		configureButton()
		
		view.backgroundColor = ColorgyColor.BackgroundColor
	}
	
	private func configureTextInput() {
		let topMargin: CGFloat = 24.0
		let name = generateTextInputView("grayUserNameIcon", placeholder: "輸入名稱", keyboardType: .Default, isPassword: false)
		let a = generateTextInputView("grayEmailIcon", placeholder: "輸入信箱", keyboardType: .EmailAddress, isPassword: false)
		let b = generateTextInputView("grayPasswordIcon", placeholder: "輸入密碼", keyboardType: .Default, isPassword: true)
		let c = generateTextInputView("grayPasswordIcon", placeholder: "再次輸入密碼", keyboardType: .Default, isPassword: true)
		
		name._view.frame.origin.y = topMargin
		a._view.frame.origin.y = topMargin + (4 + 44) * 1
		b._view.frame.origin.y = topMargin + (4 + 44) * 2
		c._view.frame.origin.y = topMargin + (4 + 44) * 3
		
		userNameInputField = name.textField
		emailInputField = a.textField
		passwordInputField = b.textField
		confirmPasswordInputField = c.textField
		
		name._view.anchorViewTo(containerView)
		a._view.anchorViewTo(containerView)
		b._view.anchorViewTo(containerView)
		c._view.anchorViewTo(containerView)
	}
	
	// MARK: Button
	private func configureButton() {
		registerButton = UIButton(type: UIButtonType.System)
		registerButton.backgroundColor = ColorgyColor.MainOrange
		registerButton.tintColor = UIColor.whiteColor()
		registerButton.titleLabel?.font = UIFont.systemFontOfSize(14.0)
		registerButton.setTitle("註冊", forState: UIControlState.Normal)
		
		registerButton.layer.cornerRadius = 4.0
		
		registerButton.frame.size = CGSize(width: 249, height: 44)
		
		if let superview = confirmPasswordInputField.superview {
			registerButton.frame.origin.y = superview.frame.maxY + 36
			registerButton.center.x = containerView.contentSize.width / 2
		}
		
		registerButton.anchorViewTo(containerView)
		
		registerButton.addTarget(self, action: "registerButtonClicked", forControlEvents: UIControlEvents.TouchUpInside)
	}
	
	internal func registerButtonClicked() {
		// check first
		let validator = isAllForumValid()
		if validator.isValid {
			// then fire post to server
			let name = userNameInputField.text ?? ""
			let email = emailInputField.text ?? ""
			let p = passwordInputField.text ?? ""
			let p2 = confirmPasswordInputField.text ?? ""
			ColorgyAPI.registerUserWithName(name, email: email, password: p, passwordConfirm: p2, success: { () -> Void in
				ColorgyLogin.loginToColorgyWithUsername(username: email, password: p, success: { (result) -> Void in
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
					})
					}, failure: { () -> Void in
						let alert = ErrorAlertView.alertUserWithError("登入失敗，請確認帳號密碼無誤。如果忘記帳號密碼或新會員請用Facebook登入。")
						self.presentViewController(alert, animated: true, completion: nil)
				})
				}, failure: { () -> Void in
					let alert = ErrorAlertView.alertUserWithError("註冊失敗，可能信箱被使用過，請重新嘗試一次")
					self.presentViewController(alert, animated: true, completion: nil)
			})
		} else {
			let alert = ErrorAlertView.alertUserWithError(validator.error)
			presentViewController(alert, animated: true, completion: nil)
		}
	}
	
	private func isAllForumValid() -> (isValid: Bool, error: String?) {
		guard userNameInputField.text?.characters.count > 0 else { return (false, "名稱不能是空白") }
		guard emailInputField.text != nil else { return (false, "Email 有誤") }
		guard emailInputField.text!.isValidEmail else { return (false, "\(emailInputField.text!) 不是一個正確的信箱") }
		guard passwordInputField.text?.characters.count >= 8 else { return (false, "密碼要大於8個字") }
		guard confirmPasswordInputField.text == passwordInputField.text else { return (false, "確認密碼與原本的密碼不符，請重新輸入") }
		return (true, nil)
	}

	// MARK: Containor view
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
}
