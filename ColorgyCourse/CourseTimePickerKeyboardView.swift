//
//  CourseTimePickerKeyboardView.swift
//  ColorgyCourse
//
//  Created by David on 2016/1/6.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

protocol CourseTimePickerKeyboardViewDelegate {
    func contentUpdated(weekday: Int, fromStartingPeriod startingPeriod: Int, toEndingPeriod endingPeriod: Int)
}

class CourseTimePickerKeyboardView: UIView {
    
    private var pickerView: UIPickerView?
    private var content: [[Int]]?
    private var pickerViewContentPosition = [0, 0, 0]
    
    var delegate: CourseTimePickerKeyboardViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame.size.height = 216.0
        self.backgroundColor = UIColor.whiteColor()
        
        initializeContent()
        
        pickerView = UIPickerView()
        pickerView?.delegate = self
        pickerView?.center = self.center
        
        self.addSubview(pickerView!)
    }
    
    private func initializeContent() {
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
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if content != nil {
            pickerViewContentPosition[component] = row
            delegate?.contentUpdated(content![0][pickerViewContentPosition[0]], fromStartingPeriod: content![1][pickerViewContentPosition[1]], toEndingPeriod: content![2][pickerViewContentPosition[2]])
        }
    }
}