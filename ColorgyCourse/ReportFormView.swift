//
//  ReportFormView.swift
//  ColorgyCourse
//
//  Created by David on 2016/1/22.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

protocol ReportFormViewDelegate {
	func reportFormViewContentUpdate(problemType: String?, problemDescription: String?, email: String?, lastQuestion: String?)
}

/// This is a view for Reporting Colorgy
class ReportFormView: UIScrollView {
	
	/*
	// Only override drawRect: if you perform custom drawing.
	// An empty implementation adversely affects performance during animation.
	override func drawRect(rect: CGRect) {
	// Drawing code
	}
	*/
	
	var formDelegate: ReportFormViewDelegate?
	
	// each height of title, fix to 42pt
	private let titleHeight: CGFloat = 42
	// bottom padding of each view
	private let bottomPadding: CGFloat = 12
	
	// header view, its blue
	private var headerView: UIView!
	
	// lets user to choose their problem
	// will show keyboard
	private var problemPickerView: UIView!
	private var problemPickerTextField: OneWayInputReportTextField!
	private var problemPickerContents: [String?] = []
	
	private var problemDescriptionView: UIView!
	private let problemDescriptionTextViewGap: CGFloat = 0
	private var problemDescriptionTextView: UITextView!
	
	private var emailView: UIView!
	private var emailTextField: ReportFormTextField!
	
	private var footerView: UIView!
	private var fuckDeveloperTextField: OneWayInputReportTextField!
	private var fuckContents: [String?] = []
	
	///
	init(headerTitleText: String?, problemPickerTitleLabelText: String?, problemPickerTextFieldText: String?, problemPickerContents: [String?], problemDescriptionLabelText: String?, emailTitleLabelText: String?, fuckContents: [String?], footerTitleLabelText: String?) {
		super.init(frame: UIScreen.mainScreen().bounds)
		
		// configure header view
		headerView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, titleHeight))
		headerView.backgroundColor = ColorgyColor.waterBlue
		let headerTitleLabel = UILabel(frame: headerView.frame)
		headerTitleLabel.frame.size.width -= 50
		headerTitleLabel.minimumScaleFactor = 0.6
		headerTitleLabel.adjustsFontSizeToFitWidth = true
		headerTitleLabel.text = headerTitleText
		headerTitleLabel.textColor = UIColor.whiteColor()
		headerTitleLabel.textAlignment = .Center
		let headerImageView = UIImageView(frame: CGRectMake(0, 0, 21, 21))
		headerImageView.image = UIImage(named: "Speaker")
		headerImageView.frame.origin.x = 16
		headerImageView.center.y = headerView.center.y
		headerTitleLabel.frame.origin.x = headerImageView.frame.maxX + 8
		// add subview
		headerView.addSubview(headerTitleLabel)
		headerView.addSubview(headerImageView)
		
		// configure check list view
		problemPickerView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, titleHeight * 2 + bottomPadding))
		problemPickerView.backgroundColor = UIColor.whiteColor()
		let problemPickerTitleLabelPadding: CGFloat = 16
		let problemPickerTitleLabel = UILabel(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width - 2 * problemPickerTitleLabelPadding, titleHeight))
		problemPickerTitleLabel.text = problemPickerTitleLabelText
		// text field
		problemPickerTextField = OneWayInputReportTextField(frame: problemPickerTitleLabel.frame)
		problemPickerTextField.layer.borderColor = UIColor.lightGrayColor().CGColor
		problemPickerTextField.layer.borderWidth = 1.0
		problemPickerTextField.layer.cornerRadius = 2
		problemPickerTextField.placeholder = "請選擇遇到的問題..."
		problemPickerTextField.text = problemPickerTextFieldText
		problemPickerTextField.delegate = self
		self.problemPickerContents = problemPickerContents
		// arrange view
		problemPickerTitleLabel.center.x = problemPickerView.center.x
		problemPickerTextField.center.x = problemPickerTitleLabel.center.x
		problemPickerTextField.frame.origin.y = problemPickerTitleLabel.frame.maxY + problemDescriptionTextViewGap
		// add subview
		problemPickerView.addSubview(problemPickerTitleLabel)
		problemPickerView.addSubview(problemPickerTextField)
		
		// configure problem description view
		let problemDescriptionViewHeight: CGFloat = 160
		problemDescriptionView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, problemDescriptionViewHeight))
		problemDescriptionView.backgroundColor = UIColor.whiteColor()
		let problemDescriptionLabel = UILabel(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width - 2 * problemPickerTitleLabelPadding, titleHeight))
		problemDescriptionLabel.text = problemDescriptionLabelText
		// content text view
		problemDescriptionTextView = UITextView(frame: CGRectMake(0, 0, problemDescriptionLabel.frame.width, problemDescriptionView.frame.height - problemDescriptionLabel.frame.height - 16))
		problemDescriptionTextView.layer.cornerRadius = 2.0
		problemDescriptionTextView.layer.borderWidth = 1.0
		problemDescriptionTextView.layer.borderColor = UIColor.lightGrayColor().CGColor
		// arrange
		problemDescriptionTextView.frame.origin.y = problemDescriptionLabel.bounds.maxY + problemDescriptionTextViewGap
		//        problemDescriptionTextView.backgroundColor = UIColor.redColor()
		//        problemDescriptionLabel.backgroundColor = UIColor.greenColor()
		problemDescriptionTextView.center.x = problemDescriptionView.center.x
		problemDescriptionLabel.center.x = problemDescriptionView.center.x
		// add to subview
		problemDescriptionView.addSubview(problemDescriptionLabel)
		problemDescriptionView.addSubview(problemDescriptionTextView)
		problemDescriptionTextView.delegate = self
		problemDescriptionTextView.textColor = UIColor.lightGrayColor()
		problemDescriptionTextView.text = "對不起造成您的不便！我們將用最快速度修正您回報的問題。"
		
		// configure email view
		emailView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, titleHeight * 2 + bottomPadding))
		emailView.backgroundColor = UIColor.whiteColor()
		let emailTitleLabel = UILabel(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width - 2 * problemPickerTitleLabelPadding, titleHeight))
		emailTitleLabel.text = emailTitleLabelText
		// text field
		emailTextField = ReportFormTextField(frame: emailTitleLabel.frame)
		emailTextField.placeholder = "感謝您的意見，我們會盡快改善"
		// arrange view
		emailTitleLabel.center.x = emailView.center.x
		emailTextField.center.x = emailTitleLabel.center.x
		emailTextField.frame.origin.y = emailTitleLabel.frame.maxY + problemDescriptionTextViewGap
		emailView.addSubview(emailTitleLabel)
		emailView.addSubview(emailTextField)
		emailTextField.addTarget(self, action: "emailTextFieldValueChanged:", forControlEvents: UIControlEvents.EditingChanged)
		// insert email
		if UserSetting.UserEmail() != nil {
			emailTextField.text = UserSetting.UserEmail()
		}
		if UserSetting.UserFBEmail() != nil {
			emailTextField.text = UserSetting.UserFBEmail()
		}
		
		// configure footer view
		footerView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, titleHeight * 2 + bottomPadding))
		footerView.backgroundColor = UIColor.whiteColor()
		let footerTitleLabel = UILabel(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width - 2 * problemPickerTitleLabelPadding, titleHeight))
		footerTitleLabel.text = footerTitleLabelText
		// insert check list
		fuckDeveloperTextField = OneWayInputReportTextField(frame: footerTitleLabel.frame)
		fuckDeveloperTextField.layer.borderColor = UIColor.lightGrayColor().CGColor
		fuckDeveloperTextField.layer.borderWidth = 1.0
		fuckDeveloperTextField.layer.cornerRadius = 2
		fuckDeveloperTextField.placeholder = "什麼都可以呦：）"
		fuckDeveloperTextField.delegate = self
		self.fuckContents = fuckContents
		// arrange view
		footerTitleLabel.center.x = footerView.center.x
		fuckDeveloperTextField.center.x = footerTitleLabel.center.x
		fuckDeveloperTextField.frame.origin.y = footerTitleLabel.frame.maxY
		// add subview
		footerView.addSubview(footerTitleLabel)
		footerView.addSubview(fuckDeveloperTextField)
		
		
		// arrange views
		let viewSpacing: CGFloat = 15.0
		problemPickerView.frame.origin.y = headerView.frame.maxY + viewSpacing
		problemDescriptionView.frame.origin.y = problemPickerView.frame.maxY + viewSpacing
		emailView.frame.origin.y = problemDescriptionView.frame.maxY + viewSpacing
		footerView.frame.origin.y = emailView.frame.maxY + viewSpacing
		
		// add to scroll view
		self.addSubview(headerView)
		self.addSubview(problemPickerView)
		self.addSubview(problemDescriptionView)
		self.addSubview(emailView)
		self.addSubview(footerView)
		
		// view background
		self.backgroundColor = ColorgyColor.BackgroundColor
		
		// expand scroll view content
		self.contentSize = CGSize(width: self.frame.width, height: footerView.frame.maxY)
	}
	
	internal func emailTextFieldValueChanged(textField: UITextField) {
		formDelegate?.reportFormViewContentUpdate(problemPickerTextField.text, problemDescription: problemDescriptionTextView.text, email: emailTextField.text, lastQuestion: fuckDeveloperTextField.text)
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}

extension ReportFormView : UITextFieldDelegate {
	func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
		
		if textField == problemPickerTextField {
			let keyboard = ReportFormKeyboard(contents: problemPickerContents)
			keyboard.delegate = self
			textField.inputView = keyboard
			textField.reloadInputViews()
		} else if textField == fuckDeveloperTextField {
			let keyboard = ReportFormKeyboard(contents: fuckContents)
			keyboard.delegate = self
			textField.inputView = keyboard
			textField.reloadInputViews()
		}
		
		return true
	}
}

extension ReportFormView : ReportFormKeyboardDelegate {
	func reportFormKeyboard(contentUpdate text: String?) {
		if problemPickerTextField.isFirstResponder() {
			problemPickerTextField.text = text
			formDelegate?.reportFormViewContentUpdate(problemPickerTextField.text, problemDescription: problemDescriptionTextView.text, email: emailTextField.text, lastQuestion: fuckDeveloperTextField.text)
		} else if fuckDeveloperTextField.isFirstResponder() {
			fuckDeveloperTextField.text = text
			formDelegate?.reportFormViewContentUpdate(problemPickerTextField.text, problemDescription: problemDescriptionTextView.text, email: emailTextField.text, lastQuestion: fuckDeveloperTextField.text)
		}
	}
}

extension ReportFormView : UITextViewDelegate {
	func textViewDidChange(textView: UITextView) {
		if textView == problemDescriptionTextView {
			print((textView.text))
			formDelegate?.reportFormViewContentUpdate(problemPickerTextField.text, problemDescription: problemDescriptionTextView.text, email: emailTextField.text, lastQuestion: fuckDeveloperTextField.text)
		}
	}
	
	func textViewShouldBeginEditing(textView: UITextView) -> Bool {
		if textView == problemDescriptionTextView {
			if textView.textColor == UIColor.lightGrayColor() {
				textView.text = ""
				textView.textColor = UIColor.blackColor()
			}
		}
		return true
	}
	
	func textViewShouldEndEditing(textView: UITextView) -> Bool {
		if textView == problemDescriptionTextView {
			if textView.text == "" {
				textView.textColor = UIColor.lightGrayColor()
				textView.text = "對不起造成您的不便！我們將用最快速度修正您回報的問題。"
			}
		}
		
		return true
	}
}
