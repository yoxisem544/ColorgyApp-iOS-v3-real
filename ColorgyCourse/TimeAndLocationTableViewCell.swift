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
    func shouldUpdateContentAtIndex(index: Int, time: String?, location: String?)
}

class TimeAndLocationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var timeBackgroundView: UIView!
    @IBOutlet weak var locationBackgroundView: UIView!
    @IBOutlet weak var timeLabel: DetectableLabel! {
        didSet {
            if cellIndex != nil {
                delegate?.shouldUpdateContentAtIndex(cellIndex!, time: timeLabel?.text, location: locationTextField?.text)
                print("yoyoyoyo")
            }
        }
    }
    @IBOutlet weak var locationTextField: UITextField! {
        didSet {
            if cellIndex != nil {
                delegate?.shouldUpdateContentAtIndex(cellIndex!, time: timeLabel?.text, location: locationTextField?.text)
                print("yoyoyoyo")
            }
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
        print("awake")
        
    }
    
    func locationTextFieldContentChaning() {
        delegate?.shouldUpdateContentAtIndex(cellIndex!, time: timeLabel?.text, location: locationTextField?.text)
    }
    
    func tapOnTimeView() {
        print("on time")
        delegate?.didTapOnTimeView()
    }
    
    func tapOnLocationView() {
        print("on location")
        delegate?.didTapOnLocationView()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
