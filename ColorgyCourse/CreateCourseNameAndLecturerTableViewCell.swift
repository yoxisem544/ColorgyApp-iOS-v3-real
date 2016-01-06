//
//  CreateCourseNameAndLecturerTableViewCell.swift
//  ColorgyCourse
//
//  Created by David on 2016/1/4.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

protocol CreateCourseNameAndLecturerTableViewCellDelegate {
    func contentUpdated(courseName: String?, lecturerName: String?)
}

class CreateCourseNameAndLecturerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lecturerTextField: UITextField!
    
    var delegate: CreateCourseNameAndLecturerTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .None
        nameTextField.addTarget(self, action: "nameTextFieldEditingChanged", forControlEvents: .EditingChanged)
        lecturerTextField.addTarget(self, action: "nameTextFieldEditingChanged", forControlEvents: .EditingChanged)
    }
    
    func nameTextFieldEditingChanged() {
        delegate?.contentUpdated(nameTextField.text, lecturerName: lecturerTextField.text)
    }
    
    func lecturerTextFieldEditingChanged() {
        delegate?.contentUpdated(nameTextField.text, lecturerName: lecturerTextField.text)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}