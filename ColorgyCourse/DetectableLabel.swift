//
//  DetectableLabel.swift
//  ColorgyCourse
//
//  Created by David on 2016/1/5.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

class DetectableLabel: UILabel {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override var text: String? {
        didSet {
            print("text \(text) is changing")
        }
    }

}
