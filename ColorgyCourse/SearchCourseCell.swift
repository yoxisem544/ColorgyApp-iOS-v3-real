//
//  SearchCourseCell.swift
//  ColorgyCourse
//
//  Created by David on 2015/8/31.
//  Copyright (c) 2015年 David. All rights reserved.
//

import UIKit

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

    override func layoutSubviews() {
        // configure button border
        self.addCourseButton?.layer.borderWidth = 1.0
        self.addCourseButton?.layer.borderColor = UIColor(red: 248/255.0, green: 150/255.0, blue: 128/255.0, alpha: 1).CGColor
        self.addCourseButton?.layer.cornerRadius = 4.0
        
        // bottom line 
        self.bottomSeparatorLineView.backgroundColor = UIColor.clearColor()
        
        // cell configure
        self.selectionStyle = UITableViewCellSelectionStyle.None
    }
}
