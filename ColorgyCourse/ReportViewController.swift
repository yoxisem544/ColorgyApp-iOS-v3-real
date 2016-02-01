//
//  ReportViewController.swift
//  ColorgyCourse
//
//  Created by David on 2016/1/22.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

protocol ReportViewControllerDelegate {
	func reportViewControllerSuccessfullySentReport()
}

class ReportViewController: UIViewController {
	
	var reportView: ReportFormView!
	
	var headerTitle: String! = "謝謝大大水水們的回報，我們會更努力的！"
	var reportProblemTitle: String! = "遇到的問題（必填）"
	var reportProblemInitialSelectionTitle: String!
	var reportProblem: [String?]!
	var problemDescription: String! = "問題描述（選填）"
	
	var finalQuestionTitle: String! = "最後（選填）"
	var fuckContent: [String?]!
	
	var reportProblemType: String?
	var reportProblemDescription: String?
	var reportEmail: String?
	var reportLastQuestion: String?
	
	var delegate: ReportViewControllerDelegate?
	
	
	@IBAction func closeButtonClicked() {
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	@IBAction func sendButtonClicked() {
		if reportProblemType != nil {
			ColorgyAPI.POSTUserFeedBack(reportEmail ?? "no email", feedbackType: reportProblemType!, feedbackDescription: reportProblemDescription ?? "no description", success: { () -> Void in
				self.dismissViewControllerAnimated(true, completion: { () -> Void in
					if Release().mode {
						let params = [
							"user_id": UserSetting.UserId() ?? -1,
							"user_organization": UserSetting.UserPossibleOrganization() ?? "no organization",
							"user_department": UserSetting.UserPossibleDepartment() ?? "no department",
							"feedback_type": self.reportProblemType ?? "no type",
							"feedback_description": self.reportProblemDescription ?? "no description",
							"feedback_email": self.reportEmail ?? "no email",
							"feedback_last_question": self.reportLastQuestion ?? "no last question"
						]
						Flurry.logEvent("v3.0: User Send Feedback", withParameters: params as [NSObject : AnyObject])
					}
					self.delegate?.reportViewControllerSuccessfullySentReport()
				})
				}, failure: { () -> Void in
					let alert = ErrorAlertView.alertUserWithError("傳送失敗，請檢查您的網路是否暢通！")
					self.presentViewController(alert, animated: true, completion: nil)
			})
		} else {
			let alert = ErrorAlertView.alertUserWithError("請選擇遇到的問題！")
			presentViewController(alert, animated: true, completion: nil)
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		if reportProblem == nil {
			reportProblem = ["沒有我的學校", "沒有我的系所", "找不到我的課", "課程資訊錯誤", "其他"]
		}
		
		if fuckContent == nil {
			fuckContent = ["鞭打工程師", "幫工程師加油"]
		}
		
		reportView = ReportFormView(headerTitleText: headerTitle, problemPickerTitleLabelText: reportProblemTitle, problemPickerTextFieldText: reportProblemInitialSelectionTitle, problemPickerContents: reportProblem, problemDescriptionLabelText: problemDescription, emailTitleLabelText: "常用信箱", fuckContents: fuckContent, footerTitleLabelText: finalQuestionTitle)
		
		// set initial problem
		reportProblemType = reportProblemInitialSelectionTitle
		
		reportView.frame.size.height -= 64
		reportView.frame.origin.y = 64
		self.view.addSubview(reportView)
		
		reportView.keyboardDismissMode = .OnDrag
		
		reportView.formDelegate = self
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		registerKeyboardNotification()
	}
	
	func registerKeyboardNotification() {
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
	}
	
	func keyboardWillShow(notification: NSNotification) {
		if let kbRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey])?.CGRectValue {
			reportView.contentInset.bottom = kbRect.height
		}
	}
	
	func keyboardWillHide(notification: NSNotification) {
		reportView.contentInset.bottom = UIEdgeInsetsZero.bottom
	}
	
	override func viewDidDisappear(animated: Bool) {
		super.viewDidDisappear(animated)
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}
	
}

extension ReportViewController : ReportFormViewDelegate {
	
	func reportFormViewContentUpdate(problemType: String?, problemDescription: String?, email: String?, lastQuestion: String?) {
		print("problemType \(problemType)")
		print("problemDescription \(problemDescription)")
		print("email \(email)")
		print("lastQuestion \(lastQuestion)")
		
		self.reportProblemType = problemType
		self.reportProblemDescription = problemDescription
		self.reportEmail = email
		self.reportLastQuestion = lastQuestion
	}
}
