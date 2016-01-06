//
//  ContinueAddTimeAndLocationTableViewCell.swift
//  ColorgyCourse
//
//  Created by David on 2016/1/6.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

protocol ContinueAddTimeAndLocationTableViewCellDelegate {
    func didTapOnAddButton()
}

class ContinueAddTimeAndLocationTableViewCell: UITableViewCell {

    @IBOutlet weak var continueAddButton: UIButton!
    @IBAction func didTapOnButton() {
        delegate?.didTapOnAddButton()
    }
    
    var delegate: ContinueAddTimeAndLocationTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        continueAddButton.layer.borderColor = ColorgyColor.MainOrange.CGColor
        continueAddButton.layer.borderWidth = 2.0
        continueAddButton.layer.cornerRadius = 2.0
        self.selectionStyle = .None
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
