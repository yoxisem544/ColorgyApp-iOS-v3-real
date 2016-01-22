//
//  ReportFormView.swift
//  ColorgyCourse
//
//  Created by David on 2016/1/22.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

class ReportFormView: UIScrollView {
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    
    let titleHeight: CGFloat = 42
    let bottomPadding: CGFloat = 12
    
    private var headerView: UIView!
    
    private var checkListView: UIView!
    private var checkListTextField: OneWayInputReportTextField!
    private var checkListContents: [String?] = []
    
    private var problemDescriptionView: UIView!
    private let problemDescriptionTextViewGap: CGFloat = 0
    
    private var emailView: UIView!
    
    private var footerView: UIView!
    private var fuckDeveloperTextField: OneWayInputReportTextField!
    private var fuckContents: [String?] = []
    
    // need first part, second part, third part, header
    init(headerTitleText: String?, checkListTitleLabelText: String?, checkListContents: [String?], problemDescriptionLabelText: String?, emailTitleLabelText: String?, fuckContents: [String?], footerTitleLabelText: String?) {
        super.init(frame: UIScreen.mainScreen().bounds)
        
        // configure header view
        headerView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, titleHeight))
        headerView.backgroundColor = ColorgyColor.waterBlue
        let headerTitleLabel = UILabel(frame: headerView.frame)
        headerTitleLabel.text = headerTitleText
        headerTitleLabel.textColor = UIColor.whiteColor()
        headerTitleLabel.textAlignment = .Center
        let headerImageView = UIImageView(frame: CGRectMake(0, 0, 21, 21))
        headerImageView.image = UIImage(named: "Speaker")
        headerImageView.frame.origin.x = 16
        headerImageView.center.y = headerView.center.y
        // add subview
        headerView.addSubview(headerTitleLabel)
        headerView.addSubview(headerImageView)
        
        // configure check list view
        checkListView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, titleHeight * 2 + bottomPadding))
        checkListView.backgroundColor = UIColor.whiteColor()
        let checkListTitleLabelPadding: CGFloat = 16
        let checkListTitleLabel = UILabel(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width - 2 * checkListTitleLabelPadding, titleHeight))
        checkListTitleLabel.text = checkListTitleLabelText
        // text field
        checkListTextField = OneWayInputReportTextField(frame: checkListTitleLabel.frame)
        checkListTextField.layer.borderColor = UIColor.lightGrayColor().CGColor
        checkListTextField.layer.borderWidth = 1.0
        checkListTextField.layer.cornerRadius = 2
        checkListTextField.placeholder = "請選擇遇到的問題..."
        checkListTextField.delegate = self
        self.checkListContents = checkListContents
        // arrange view
        checkListTitleLabel.center.x = checkListView.center.x
        checkListTextField.center.x = checkListTitleLabel.center.x
        checkListTextField.frame.origin.y = checkListTitleLabel.frame.maxY + problemDescriptionTextViewGap
        // add subview
        checkListView.addSubview(checkListTitleLabel)
        checkListView.addSubview(checkListTextField)
        
        // configure problem description view
        let problemDescriptionViewHeight: CGFloat = 160
        problemDescriptionView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, problemDescriptionViewHeight))
        problemDescriptionView.backgroundColor = UIColor.whiteColor()
        let problemDescriptionLabel = UILabel(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width - 2 * checkListTitleLabelPadding, titleHeight))
        problemDescriptionLabel.text = problemDescriptionLabelText
        // content text view
        let problemDescriptionTextView = UITextView(frame: CGRectMake(0, 0, problemDescriptionLabel.frame.width, problemDescriptionView.frame.height - problemDescriptionLabel.frame.height - 16))
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
        
        // configure email view
        emailView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, titleHeight * 2 + bottomPadding))
        emailView.backgroundColor = UIColor.whiteColor()
        let emailTitleLabel = UILabel(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width - 2 * checkListTitleLabelPadding, titleHeight))
        emailTitleLabel.text = emailTitleLabelText
        // text field
        let emailTextField = ReportFormTextField(frame: emailTitleLabel.frame)
        emailTextField.placeholder = "請填常用的email..."
        // arrange view
        emailTitleLabel.center.x = emailView.center.x
        emailTextField.center.x = emailTitleLabel.center.x
        emailTextField.frame.origin.y = emailTitleLabel.frame.maxY + problemDescriptionTextViewGap
        emailView.addSubview(emailTitleLabel)
        emailView.addSubview(emailTextField)
        
        // configure footer view
        footerView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, titleHeight * 2 + bottomPadding))
        footerView.backgroundColor = UIColor.whiteColor()
        let footerTitleLabel = UILabel(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width - 2 * checkListTitleLabelPadding, titleHeight))
        footerTitleLabel.text = footerTitleLabelText
        // insert check list
        fuckDeveloperTextField = OneWayInputReportTextField(frame: footerTitleLabel.frame)
        fuckDeveloperTextField.layer.borderColor = UIColor.lightGrayColor().CGColor
        fuckDeveloperTextField.layer.borderWidth = 1.0
        fuckDeveloperTextField.layer.cornerRadius = 2
        fuckDeveloperTextField.placeholder = "安安幾歲給虧嗎？"
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
        checkListView.frame.origin.y = headerView.frame.maxY + viewSpacing
        problemDescriptionView.frame.origin.y = checkListView.frame.maxY + viewSpacing
        emailView.frame.origin.y = problemDescriptionView.frame.maxY + viewSpacing
        footerView.frame.origin.y = emailView.frame.maxY + viewSpacing
        
        // add to scroll view
        self.addSubview(headerView)
        self.addSubview(checkListView)
        self.addSubview(problemDescriptionView)
        self.addSubview(emailView)
        self.addSubview(footerView)
        
        // view background
        self.backgroundColor = ColorgyColor.BackgroundColor
        
        // expand scroll view content
        self.contentSize = CGSize(width: self.frame.width, height: footerView.frame.maxY)
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
        
        if textField == checkListTextField {
            let keyboard = ReportFormKeyboard(contents: checkListContents)
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
        if checkListTextField.isFirstResponder() {
            checkListTextField.text = text
        } else if fuckDeveloperTextField.isFirstResponder() {
            fuckDeveloperTextField.text = text
        }
    }
}
