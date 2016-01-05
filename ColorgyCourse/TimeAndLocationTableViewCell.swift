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
}

class TimeAndLocationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var timeBackgroundView: UIView!
    @IBOutlet weak var locationBackgroundView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var locationTextField: UITextField!
    
    var time: String?
    var location: String?
    var cellIndex: Int?
    
    var delegate: TimeAndLocationTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .None
        timeBackgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "tapOnTimeView"))
        locationBackgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "tapOnLocationView"))
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
