//
//  ChatReportViewController.swift
//  ColorgyCourse
//
//  Created by David on 2016/2/18.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

protocol ChatReportViewControllerDelegate {
	func chatReportViewController(didSubmitBlockUserContent title: String?, description: String?, hi: Hello?)
	func chatReportViewController(didSubmitReportUserContent title: String?, description: String?, hi: Hello?)
}

class ChatReportViewController: UIViewController {
	
	var skipButton: UIBarButtonItem!
	@IBOutlet weak var submitButton: UIBarButtonItem!
	@IBOutlet weak var navItem: UINavigationItem!
	
	var reportView: ChatReportView!
	
	/// report or block
	var reportType: String!
	
	var encounteredProblems: [String?]!
	
	var canSkipContent: Bool = false
	
	var titleOfReport: String!

	var delegate: ChatReportViewControllerDelegate?
	
	var hi: Hello!
	
	private var problem: String?
	internal var problemDescription: String?
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		if encounteredProblems == nil {
			encounteredProblems = ["感覺被騷擾", "對方有不正當的言談", "對話涉及言語攻擊", "太色啦Q__Q", "其他原因"]
		}
		reportView = ChatReportView(headerTitleText: "有什麼問題儘管回報吧！", problemPickerTitleLabelText: "你遇到的問題", problemPickerContents: encounteredProblems, problemDescriptionLabelText: "請敘述當時遇到的情況")
	
		reportView.frame.origin.y = 64
		reportView.formDelegate = self
		view.addSubview(reportView)
		
		reportView.keyboardDismissMode = .OnDrag
		
		if titleOfReport != nil {
			navItem.title = titleOfReport
		}
		
		if canSkipContent {
			skipButton = UIBarButtonItem(title: "略過", style: UIBarButtonItemStyle.Plain, target: self, action: "skipReport")
			navItem.leftBarButtonItem = skipButton
		}
    }
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		registerKeyboardNotification()
	}
	
	override func viewDidDisappear(animated: Bool) {
		super.viewDidDisappear(animated)
		NSNotificationCenter.defaultCenter().removeObserver(self)
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
	
	func skipReport() {
		dismissViewControllerAnimated(true, completion: nil)
		if reportType == "report" {
			delegate?.chatReportViewController(didSubmitReportUserContent: nil, description: nil, hi: hi)
		} else if reportType == "block" {
			delegate?.chatReportViewController(didSubmitBlockUserContent: nil, description: nil, hi: hi)
		}
	}
	
	@IBAction func submitReportButtonClicked() {
		dismissViewControllerAnimated(true, completion: nil)
		if reportType == "report" {
			delegate?.chatReportViewController(didSubmitReportUserContent: self.problem, description: self.problemDescription, hi: hi)
		} else if reportType == "block" {
			delegate?.chatReportViewController(didSubmitBlockUserContent: self.problem, description: self.problemDescription, hi: hi)
		}
	}
}

extension ChatReportViewController : ChatReportViewDelegate {
	func chatReportView(contentUpdated problem: String?, description: String?) {
		print(problem)
		print(description)
		self.problem = problem
		self.problemDescription = description
	}
}
