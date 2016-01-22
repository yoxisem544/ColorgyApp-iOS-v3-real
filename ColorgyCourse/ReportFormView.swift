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
    
    private var headerView: UIView!
    
    private var checkListView: UIView!
    
    private var problemDescriptionView: UIView!
    private let problemDescriptionTextViewGap: CGFloat = 8
    
    private var emailView: UIView!
    
    private var footerView: UIView!
    
    // need first part, second part, third part, header
    init(headerTitleText: String?, checkListTitleLabelText: String?, problemDescriptionLabelText: String?, emailTitleLabelText: String?, footerTitleLabelText: String?) {
        super.init(frame: UIScreen.mainScreen().bounds)
        
        // configure header view
        headerView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 44))
        headerView.backgroundColor = ColorgyColor.waterBlue
        let headerTitleLabel = UILabel(frame: headerView.frame)
        headerTitleLabel.text = headerTitleText
        headerTitleLabel.textColor = UIColor.whiteColor()
        headerTitleLabel.textAlignment = .Center
        // add subview
        headerView.addSubview(headerTitleLabel)
        
        // configure check list view
        checkListView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 44 * 2 + problemDescriptionTextViewGap))
        checkListView.backgroundColor = UIColor.whiteColor()
        let checkListTitleLabelPadding: CGFloat = 16
        let checkListTitleLabel = UILabel(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width - 2 * checkListTitleLabelPadding, 44))
        checkListTitleLabel.text = checkListTitleLabelText
        // text field
        let checkListTextField = OneWayInputTextField()
        checkListTextField.frame.size.height = 44
        checkListTextField.frame.size.width = checkListTitleLabel.frame.width
        checkListTextField.placeholder = "請選擇遇到的問題..."
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
        let problemDescriptionLabel = UILabel(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width - 2 * checkListTitleLabelPadding, 44))
        problemDescriptionLabel.text = problemDescriptionLabelText
        // content text view
        let problemDescriptionTextView = UITextView(frame: CGRectMake(0, 0, problemDescriptionLabel.frame.width, problemDescriptionView.frame.height - problemDescriptionLabel.frame.height - 16))
        // arrange
        problemDescriptionTextView.frame.origin.y = problemDescriptionLabel.bounds.maxY + problemDescriptionTextViewGap
        problemDescriptionTextView.backgroundColor = UIColor.redColor()
        problemDescriptionLabel.backgroundColor = UIColor.greenColor()
        problemDescriptionTextView.center.x = problemDescriptionView.center.x
        problemDescriptionLabel.center.x = problemDescriptionView.center.x
        // add to subview
        problemDescriptionView.addSubview(problemDescriptionLabel)
        problemDescriptionView.addSubview(problemDescriptionTextView)
        
        // configure email view
        emailView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 44 * 2 + problemDescriptionTextViewGap * 2))
        emailView.backgroundColor = UIColor.whiteColor()
        let emailTitleLabel = UILabel(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width - 2 * checkListTitleLabelPadding, 44))
        emailTitleLabel.text = emailTitleLabelText
        // text field
        let emailTextField = UITextField(frame: emailTitleLabel.frame)
        emailTextField.placeholder = "請填常用的email..."
        emailTextField.layer.borderColor = UIColor.lightGrayColor().CGColor
        emailTextField.layer.borderWidth = 1
        // arrange view
        emailTitleLabel.center.x = emailView.center.x
        emailTextField.center.x = emailTitleLabel.center.x
        emailTextField.frame.origin.y = emailTitleLabel.frame.maxY + problemDescriptionTextViewGap
        emailView.addSubview(emailTitleLabel)
        emailView.addSubview(emailTextField)
        
        // configure footer view
        footerView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 44 * 2))
        footerView.backgroundColor = UIColor.whiteColor()
        let footerTitleLabel = UILabel(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width - 2 * checkListTitleLabelPadding, 44))
        footerTitleLabel.text = footerTitleLabelText
        // insert check list
        // arrange view
        footerTitleLabel.center.x = footerView.center.x
        // add subview
        footerView.addSubview(footerTitleLabel)
        
        
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
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
