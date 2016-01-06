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
    func contentUpdatedAtIndex(index: Int, time: String?, location: String?)
    func didPressDeleteButtonAtIndex(index: Int)
}

class TimeAndLocationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var timeBackgroundView: UIView!
    @IBOutlet weak var locationBackgroundView: UIView!
    @IBOutlet weak var timeTextField: UITextField! {
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
    
    @IBAction func deleteButtonClicked() {
        if cellIndex != nil {
            delegate?.didPressDeleteButtonAtIndex(cellIndex!)
        }
    }
    
    var cellIndex: Int?
    
    var delegate: TimeAndLocationTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .None
        timeBackgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "tapOnTimeView"))
        locationBackgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "tapOnLocationView"))
        locationTextField.addTarget(self, action: "locationTextFieldContentChaning", forControlEvents: .EditingChanged)
        timeTextField.addTarget(self, action: "timeTextFieldContentChanging", forControlEvents: .EditingChanged)
        print("awake")
        print("this is cell \(cellIndex)")
    }
    
    func locationTextFieldContentChaning() {
        delegate?.contentUpdatedAtIndex(cellIndex!, time: timeTextField?.text, location: locationTextField?.text)
    }
    
    func timeTextFieldContentChanging() {
        delegate?.contentUpdatedAtIndex(cellIndex!, time: timeTextField?.text, location: locationTextField?.text)
    }
    
    func tapOnTimeView() {
        delegate?.didTapOnTimeView()
    }
    
    func tapOnLocationView() {
        delegate?.didTapOnLocationView()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}