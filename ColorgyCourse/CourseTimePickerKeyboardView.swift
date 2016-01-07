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
        pickerView = UIPickerView()
        pickerView?.delegate = self
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
    
}

extension CourseTimePickerKeyboardView : UIPickerViewDelegate {
    
}