//
//  CourseTimePickerKeyboardView.swift
//  ColorgyCourse
//
//  Created by David on 2016/1/6.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

protocol CourseTimePickerKeyboardViewDelegate {
    func contentUpdated(weekday: String, periods: [Int])
}

class CourseTimePickerKeyboardView: UIView {
    
    private var pickerView: UIPickerView?
    private var content: [[String]]?
    private var pickerViewContentPosition = [0, 0, 0]
    private let weekdays = ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"]
    
    var keyboardInitialState: [Int]?
    
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
        // first column is weekdays 1-7
        // second column is for period
        // third column is for period
        content = [weekdays, trimmedPeriodData(), trimmedPeriodDataWithPrefix()]
    }
    
    private func trimmedPeriodData() -> [String] {
        let periodData = UserSetting.getPeriodData()
        var trimmedPeriodData = [String]()
        for period in periodData {
            trimmedPeriodData.append(period["code"]!)
        }
        return trimmedPeriodData
    }
    
    private func trimmedPeriodDataWithPrefix() -> [String] {
        let periodData = UserSetting.getPeriodData()
        var trimmedPeriodData = [String]()
        for period in periodData {
            trimmedPeriodData.append("到\(period["code"]!)")
        }
        return trimmedPeriodData
    }

//    private func generatePeriodDescriptionStringWithPeriod(period: [Int]) -> String {
//        // 0 -> weekdays
//        // 1 -> starting period
//        // 2 -> ending period
//        guard content != nil else { return "" }
//        
//        if period[1] == period[2] {
//            // if ending and starting point is the same
//            return "\(weekdays[period[0]]) \(content![1][period[1]])節"
//        } else {
//            return "\(weekdays[period[0]]) \(content![1][period[1]])節 ~ \(content![1][period[2]])節"
//        }
//    }
    
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
            // check if the period is not valid
            // check which column is user selecting
            if component == 1 {
                if pickerViewContentPosition[1] > pickerViewContentPosition[2] {
                    // let ending position equal to starting position
                    pickerViewContentPosition[2] = pickerViewContentPosition[1]
                    // animate it
                    pickerView.selectRow(pickerViewContentPosition[2], inComponent: 2, animated: true)
                }
            } else if component == 2 {
                if pickerViewContentPosition[2] < pickerViewContentPosition[1] {
                    // let ending position equal to starting position
                    pickerViewContentPosition[1] = pickerViewContentPosition[2]
                    // animate it
                    pickerView.selectRow(pickerViewContentPosition[1], inComponent: 1, animated: true)
                }
            }

            delegate?.contentUpdated(content![0][pickerViewContentPosition[0]], periods: pickerViewContentPosition)
        }
    }
}