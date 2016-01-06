//
//  OneWayInputTextField.swift
//  ColorgyCourse
//
//  Created by David on 2016/1/6.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

class OneWayInputTextField: UITextField {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override func addGestureRecognizer(gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer.isKindOfClass(UILongPressGestureRecognizer) {
            gestureRecognizer.enabled = false
        }
        super.addGestureRecognizer(gestureRecognizer)
        return
    }
    
    override func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
        if (action == "paste:" || action == "copy:" || action == "select:" || action == "selectAll:") {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
    
    override func caretRectForPosition(position: UITextPosition) -> CGRect {
        return CGRectZero
    }

}