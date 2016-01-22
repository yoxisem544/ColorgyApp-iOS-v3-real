//
//  ReportFormKeyboard.swift
//  ColorgyCourse
//
//  Created by David on 2016/1/22.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

protocol ReportFormKeyboardDelegate {
    
}

class ReportFormKeyboard: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    private var pickerView: UIPickerView!
    private var contents: [String?] = []
    
    var delegate: ReportFormKeyboardDelegate?
    
    init(contents: [String?]) {
        super.init(frame: UIScreen.mainScreen().bounds)
        self.frame.size.height = 216
        self.backgroundColor = UIColor.whiteColor()
        
        // initialize contents
        self.contents = contents
        
        pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.center = self.center
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension ReportFormKeyboard : UIPickerViewDataSource {
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return contents[row]
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return contents.count
    }
}

extension ReportFormKeyboard : UIPickerViewDelegate {
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(contents[row])
    }
}
