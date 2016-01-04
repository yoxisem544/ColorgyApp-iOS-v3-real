//
//  CreateCourseTableViewCell.swift
//  ColorgyCourse
//
//  Created by David on 2016/1/4.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

class CreateCourseTableViewCell: UITableViewCell {
    
    var courseName: String? {
        didSet {
            if courseName == nil {
                cellTitle.text = "創建哦哦哦哦！"
            } else {
                cellTitle.text = "創建\"\(courseName!)\"哦哦哦哦！"
            }
        }
    }
    @IBOutlet weak var cellTitle: UILabel!
    
    var delegate: CreateCourseTableViewCellDelegate?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print("create did layout subviews")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .None
    }
    
    func tapOnCreateCourseCellView() {
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

protocol CreateCourseTableViewCellDelegate {
    func didTapOnCreateCourseCell(courseName: String)
}
