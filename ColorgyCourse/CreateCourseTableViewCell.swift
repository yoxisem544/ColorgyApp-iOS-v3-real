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
                let title = "創建\"\(courseName!)\"哦哦哦哦！" as NSString
                let attributedString = NSMutableAttributedString(string: title as String)
                let black = [NSForegroundColorAttributeName: UIColor.blackColor()]
                let white = [NSForegroundColorAttributeName: UIColor.whiteColor()]
                attributedString.addAttributes(white, range: title.rangeOfString(title as String))
                attributedString.addAttributes(black, range: title.rangeOfString(courseName!))
                cellTitle.attributedText = attributedString
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
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "tapOnCreateCourseCellView"))
    }
    
    func tapOnCreateCourseCellView() {
        delegate?.didTapOnCreateCourseCell(courseName)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

protocol CreateCourseTableViewCellDelegate {
    func didTapOnCreateCourseCell(courseName: String?)
}
