//
//  TimeAndLocationTableViewCell.swift
//  ColorgyCourse
//
//  Created by David on 2016/1/4.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

protocol TimeAndLocationTableViewCellDelegate {
    func didTapOnTimeView()
    func didTapOnLocationView()
    func contentUpdatedAtIndex(index: Int, periodDescription: String?, periods: [Int], location: String?)
    func didPressDeleteButtonAtIndex(index: Int)
}

class TimeAndLocationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var timeBackgroundView: UIView!
    @IBOutlet weak var locationBackgroundView: UIView!
    @IBOutlet weak var timeTextField: OneWayInputTextField! {
        didSet {
//            if cellIndex != nil {
//                delegate?.contentUpdatedAtIndex(cellIndex!, time: timeLabel?.text, location: locationTextField?.text)
//                print("yoyoyoyo")
//            }
        }
    }
    @IBOutlet weak var locationTextField: UITextField! {
        didSet {
//            if cellIndex != nil {
//                delegate?.contentUpdatedAtIndex(cellIndex!, time: timeLabel?.text, location: locationTextField?.text)
//                print("yoyoyoyo")
//            }
        }
    }
    
    @IBOutlet weak var deleteButton: UIButton!
    
    func hideDeleteButton() {
        deleteButton.hidden = true
    }
    
    @IBAction func deleteButtonClicked() {
        if cellIndex != nil {
            delegate?.didPressDeleteButtonAtIndex(cellIndex!)
        }
    }
    
    var periods: [Int] = [0, 0, 0]
    var cellIndex: Int?
    
    var delegate: TimeAndLocationTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .None
        timeBackgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "tapOnTimeView"))
        locationBackgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "tapOnLocationView"))
        locationTextField.addTarget(self, action: "locationTextFieldContentChanging", forControlEvents: .EditingChanged)
        locationTextField.delegate = self
        timeTextField.addTarget(self, action: "timeTextFieldContentChanging", forControlEvents: .EditingChanged)
        timeTextField.delegate = self
//        timeTextField.addGestureRecognizer(UIGestureRecognizer(target: self, action: "gestureRecognizer:"))
        print(timeTextField.gestureRecognizers)
        print("awake")
        print("this is cell \(cellIndex)")
    }
    
//    func gestureRecognizer(gesture: UIGestureRecognizer) {
//        if gesture.isKindOfClass(UILongPressGestureRecognizer) {
//            gesture.enabled = false
//        }
//        super.addGestureRecognizer(gesture)
//    }
    
    func locationTextFieldContentChanging() {
        delegate?.contentUpdatedAtIndex(cellIndex!, periodDescription: timeTextField.text,periods: periods, location: locationTextField?.text)
    }
    
    func timeTextFieldContentChanging() {
        delegate?.contentUpdatedAtIndex(cellIndex!, periodDescription: timeTextField.text, periods: periods, location: locationTextField?.text)
    }
    
    func tapOnTimeView() {
        delegate?.didTapOnTimeView()
        timeTextField.becomeFirstResponder()
    }
    
    func tapOnLocationView() {
        delegate?.didTapOnLocationView()
        locationTextField.becomeFirstResponder()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension TimeAndLocationTableViewCell : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if textField == locationTextField {
            
        } else if textField == timeTextField {
            let inputView = CourseTimePickerKeyboardView(frame: UIScreen.mainScreen().bounds)
            inputView.delegate = self
            timeTextField.inputView = inputView
            timeTextField.reloadInputViews()
        }
        return true
    }
}

extension TimeAndLocationTableViewCell : CourseTimePickerKeyboardViewDelegate {

    func contentUpdated(weekday: String, periods: [Int], withGeneratedText text: String) {
        print(text)
        timeTextField.text = text
        self.periods = periods
        delegate?.contentUpdatedAtIndex(cellIndex!, periodDescription: text, periods: periods, location: locationTextField.text)
    }
}