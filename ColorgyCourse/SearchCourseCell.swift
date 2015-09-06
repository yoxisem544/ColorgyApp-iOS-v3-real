//
//  SearchCourseCell.swift
//  ColorgyCourse
//
//  Created by David on 2015/8/31.
//  Copyright (c) 2015年 David. All rights reserved.
//

import UIKit

protocol SearchCourseCellDelegate {
    func searchCourseCell(didTapDeleteCourseButton course: Course)
    func searchCourseCell(didTapAddCourseButton course: Course)
}

class SearchCourseCell: UITableViewCell {

    @IBOutlet weak var courseTitleLabel: UILabel!
    @IBOutlet weak var addCourseButton: UIButton!
    // -------------------------------------------------------
    @IBOutlet weak var lecturerImageView: UIImageView!
    @IBOutlet weak var lecturerNameLabel: UILabel!
    @IBOutlet weak var periodImageView: UIImageView!
    @IBOutlet weak var periodLabel: UILabel!
    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    // -------------------------------------------------------
    @IBOutlet weak var sideColorHintView: UIView!
    // -------------------------------------------------------
    @IBOutlet weak var middleSeparatorLineView: UIView!
    @IBOutlet weak var bottomSeparatorLineView: UIView!
    
    @IBAction func AddButtonClicked(sender: AnyObject) {
        if hasEnrolledState {
            delegate?.searchCourseCell(didTapDeleteCourseButton: course)
        } else {
            delegate?.searchCourseCell(didTapAddCourseButton: course)
        }
    }
    
    // public API
    var course: Course! {
        didSet {
            updateUI()
            checkIfEnrolled()
        }
    }
    
    var delegate: SearchCourseCellDelegate!
    
    // private
    var hasEnrolledState: Bool = false {
        didSet {
            updateButtonTitle()
        }
    }
    
    private func checkIfEnrolled() {
        if let courses = CourseDB.getAllStoredCoursesObject() {
            for course in courses {
                // find if match
                println("course.code \(course.code) == self.course.code \(self.course.code)")
                if course.code == self.course.code {
                    hasEnrolledState = true
                }
            }
        }
    }
    
    private func updateButtonTitle() {
        if hasEnrolledState {
            addCourseButton.setTitle("刪除", forState: UIControlState.Normal)
        } else {
            addCourseButton.setTitle("加入", forState: UIControlState.Normal)
        }
    }
    
    private func updateUI() {
        courseTitleLabel?.text = course.name
        lecturerNameLabel?.text = course.lecturer
        periodLabel?.text = course.periodsString
        locationLabel?.text = course.general_code
    }

    override func layoutSubviews() {
        // configure button border
        self.addCourseButton?.layer.borderWidth = 1.0
        self.addCourseButton?.layer.borderColor = UIColor(red: 248/255.0, green: 150/255.0, blue: 128/255.0, alpha: 1).CGColor
        self.addCourseButton?.layer.cornerRadius = 4.0
        
        // bottom line 
//        self.bottomSeparatorLineView.backgroundColor = UIColor.clearColor()
        
        // cell configure
        self.selectionStyle = UITableViewCellSelectionStyle.None
    }
}
