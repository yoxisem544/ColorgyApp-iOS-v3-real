//
//  CourseDetailHeaderView.swift
//  ColorgyCourse
//
//  Created by David on 2015/9/1.
//  Copyright (c) 2015年 David. All rights reserved.
//

import UIKit

class CourseDetailHeaderView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var lecturerLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var creditsLabel: UILabel!
    @IBOutlet weak var periodsLabel: UILabel!
    
    // public api
    var course: Course! {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        titleLabel?.text = course?.name
        lecturerLabel?.text = course?.lecturer
        codeLabel?.text = course?.general_code
        creditsLabel?.text = "\((course?.credits ?? 0))"
        periodsLabel?.text = course?.periodsString
    }

}
