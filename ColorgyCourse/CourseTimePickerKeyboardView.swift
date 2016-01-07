//
//  CourseTimePickerKeyboardView.swift
//  ColorgyCourse
//
//  Created by David on 2016/1/6.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

class CourseTimePickerKeyboardView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame.size.height = 216.0
        self.backgroundColor = UIColor.greenColor()
        let p = UIPickerView()
        print(p.frame)
        self.addSubview(p)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
