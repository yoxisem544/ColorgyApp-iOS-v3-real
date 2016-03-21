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
		let a = generateTextInputView("grayEmailIcon", placeholder: "輸入信箱", keyboardType: .EmailAddress, isPassword: false)
		let b = generateTextInputView("grayPasswordIcon", placeholder: "輸入密碼", keyboardType: .Default, isPassword: true)
		let c = generateTextInputView("grayPasswordIcon", placeholder: "再次輸入密碼", keyboardType: .Default, isPassword: true)
		
		a._view.frame.origin.y = topMargin
		b._view.frame.origin.y = topMargin + (4 + 44)
		c._view.frame.origin.y = topMargin + (4 + 44) * 2
		
		emailInputField = a.textField
		passwordInputField = b.textField
		confirmPasswordInputField = c.textField
		
		a._view.anchorViewTo(containerView)
		b._view.anchorViewTo(containerView)
		c._view.anchorViewTo(containerView)
	}
	
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
}
