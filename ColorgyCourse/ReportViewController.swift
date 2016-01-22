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
    
    @IBAction func closeButtonClicked() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func sendButtonClicked() {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let reportProblem: [String?] = ["沒有我的學校", "沒有我的系所", "找不到我的課", "課程資訊錯誤", "其他"]
        let fuckContent: [String?] = ["鞭打工程師", "幫工程師加油"]
        reportView = ReportFormView(headerTitleText: "dkskjds", checkListTitleLabelText: "dsjkdkjsdkj", checkListContents: reportProblem, problemDescriptionLabelText: "sdkjiu298", emailTitleLabelText: "ds89sd89", fuckContents: fuckContent, footerTitleLabelText: "98ds98d")
        reportView.frame.size.height -= 64
        reportView.frame.origin.y = 64
        self.view.addSubview(reportView)
        
        reportView.keyboardDismissMode = .Interactive
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        registerKeyboardNotification()
        testFunction()
    }
    
    func testFunction() {
        let q = dispatch_get_global_queue(Int(QOS_CLASS_USER_INTERACTIVE.rawValue), 0)
        
        func heyHelloA() {
            dispatch_sync(q) { () -> Void in
                print("a")
            }
        }
        
        func heyHelloB() {
            dispatch_sync(q) { () -> Void in
                print("b")
            }
        }
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            heyHelloA()
        }
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            heyHelloB()
        }
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            heyHelloA()
        }
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            heyHelloB()
        }
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            heyHelloA()
        }
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            heyHelloB()
        }
        
        print("yo")
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
