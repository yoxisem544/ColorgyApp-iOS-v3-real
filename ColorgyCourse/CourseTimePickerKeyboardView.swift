//
//  CourseTimePickerKeyboardView.swift
//  ColorgyCourse
//
//  Created by David on 2016/1/6.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

class CourseTimePickerKeyboardView: UIView {
    
    private var pickerView: UIPickerView?
    private var content: [[Int]]?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame.size.height = 216.0
        self.backgroundColor = UIColor.greenColor()
        
        initializeContent()
        
        pickerView = UIPickerView()
        pickerView?.delegate = self
        pickerView?.center = self.center
        
        self.addSubview(pickerView!)
    }
    
    func initializeContent() {
        content = [[1,2,3,4,5,6,7], [1,2,3,4,5,6,7], [1,2,3,4,5,6,7,8,9]]
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CourseTimePickerKeyboardView : UIPickerViewDataSource {
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if content != nil {
            return content![component].count
        } else {
            return 0
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if content != nil {
            switch component {
            case 0:
                return String(content![component][row])
            case 1:
                return String(content![component][row])
            default:
                return String(content![component][row])
            }
        } else {
            return ""
        }
    }
}

extension CourseTimePickerKeyboardView : UIPickerViewDelegate {
    
}