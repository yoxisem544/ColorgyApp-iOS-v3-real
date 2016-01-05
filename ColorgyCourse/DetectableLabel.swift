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

    var delegate: DetectableLabelDelegate?
    
    override var text: String? {
        didSet {
            delegate?.textChanging(text)
        }
    }

}
