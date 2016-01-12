//
//  SearchCourseCell.swift
//  ColorgyCourse
//
//  Created by David on 2015/8/31.
//  Copyright (c) 2015年 David. All rights reserved.
//

import UIKit

protocol SearchCourseCellDelegate {
    func searchCourseCell(didTapDeleteCourseButton course: Course, cell: SearchCourseCell)
    func searchCourseCell(didTapAddCourseButton course: Course, cell: SearchCourseCell)
    func searchCourseCell(didTapDeleteLocalCourseButton localCourse: LocalCourse, cell: SearchCourseCell)
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
        if course != nil {
            if hasEnrolledState {
                delegate?.searchCourseCell(didTapDeleteCourseButton: course, cell: self)
            } else {
                delegate?.searchCourseCell(didTapAddCourseButton: course, cell: self)
            }
        } else if localCourse != nil {
            delegate?.searchCourseCell(didTapDeleteLocalCourseButton: localCourse, cell: self)
        }
    }
    
    // public API
    var course: Course! {
        didSet {
            updateUI()
        }
    }
    
    var localCourse: LocalCourse! {
        didSet {
            updateUI()
        }
    }
    
    var delegate: SearchCourseCellDelegate!
    
    // private
    var hasEnrolledState: Bool = false {
        didSet {
            updateButtonTitle()
        }
    }
    
    func updateButtonTitle() {
        if hasEnrolledState {
            addCourseButton.setTitle("刪除", forState: UIControlState.Normal)
        } else {
            addCourseButton.setTitle("加入", forState: UIControlState.Normal)
        }
    }
    
    private func updateUI() {
        if course != nil {
            courseTitleLabel?.text = course.name
            lecturerNameLabel?.text = (course.lecturer != nil ? course.lecturer : " ")
            periodLabel?.text = course.periodsString
            locationLabel?.text = course.general_code
        } else if localCourse != nil {
            courseTitleLabel?.text = localCourse.name
            lecturerNameLabel?.text = localCourse.lecturer
            periodLabel?.text = localCourse.periodsString
            locationLabel?.text = "自訂課程"
            addCourseButton.setTitle("刪除", forState: UIControlState.Normal)
        }
    }

    override func layoutSubviews() {
        // configure button border
        self.addCourseButton?.layer.borderWidth = 1.0
        self.addCourseButton?.layer.borderColor = ColorgyColor.MainOrange.CGColor
        self.addCourseButton?.layer.cornerRadius = 4.0
        
        // bottom line 
//        self.bottomSeparatorLineView.backgroundColor = UIColor.clearColor()
        
        // cell configure
        self.selectionStyle = UITableViewCellSelectionStyle.None
    }
}
