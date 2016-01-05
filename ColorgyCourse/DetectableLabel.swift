//
//  DetectableLabel.swift
//  ColorgyCourse
//
//  Created by David on 2016/1/5.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

protocol DetectableLabelDelegate {
    func textChanging(text: String?)
}

class DetectableLabel: UILabel {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    var delegate: DetectableLabelDelegate?
    
    override var text: String? {
        didSet {
            delegate?.textChanging(text)
        }
    }

}
