//
//  OneWayInputReportTextField.swift
//  ColorgyCourse
//
//  Created by David on 2016/1/22.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

/// This text field is for ReportForm
///
/// This TextField implement init(frame:)
///
/// So you can not use it on storyboard
class OneWayInputReportTextField: UITextField {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
	
	// disable long press gesture
    override func addGestureRecognizer(gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer.isKindOfClass(UILongPressGestureRecognizer) {
            gestureRecognizer.enabled = false
        }
        super.addGestureRecognizer(gestureRecognizer)
        return
    }
	
	// disable pop menu actions
    override func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
        if (action == #selector(NSObject.paste(_:)) || action == #selector(NSObject.copy(_:)) || action == #selector(NSObject.select(_:)) || action == #selector(NSObject.selectAll(_:))) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
	
	// this is for textfield inset
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10, 10)
    }
	
	// this is for textfield inset
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10, 10)
    }
    
    override func caretRectForPosition(position: UITextPosition) -> CGRect {
        return CGRectZero
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
