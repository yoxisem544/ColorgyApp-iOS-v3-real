//
//  ReportFormTextField.swift
//  ColorgyCourse
//
//  Created by David on 2016/1/22.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

class ReportFormTextField: UITextField {


    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        self.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 2
    }

    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10, 10)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10, 10)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
