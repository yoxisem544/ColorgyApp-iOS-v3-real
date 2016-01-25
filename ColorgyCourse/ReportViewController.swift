//
//  ReportViewController.swift
//  ColorgyCourse
//
//  Created by David on 2016/1/22.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

class ReportViewController: UIViewController {
    
    var reportView: ReportFormView!
	
	var headerTitle: String! = "謝謝大大水水們的回報，我們會更努力的！"
	var reportProblemTitle: String! = "遇到的問題（必填）"
	var reportProblem: [String?]!
	var problemDescription: String! = "問題描述（選填）"
	
	var finalQuestionTitle: String! = "最後（選填）"
    var fuckContent: [String?]!
	
	
    @IBAction func closeButtonClicked() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func sendButtonClicked() {
        
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
		
        reportView = ReportFormView(headerTitleText: headerTitle, problemPickerTitleLabelText: reportProblemTitle, problemPickerContents: reportProblem, problemDescriptionLabelText: problemDescription, emailTitleLabelText: "常用信箱", fuckContents: fuckContent, footerTitleLabelText: finalQuestionTitle)
        reportView.frame.size.height -= 64
        reportView.frame.origin.y = 64
        self.view.addSubview(reportView)
        
        reportView.keyboardDismissMode = .Interactive
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
