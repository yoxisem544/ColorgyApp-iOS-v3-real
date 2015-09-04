//
//  ErrorAlertView.swift
//  ColorgyCourse
//
//  Created by David on 2015/9/4.
//  Copyright (c) 2015年 David. All rights reserved.
//

import Foundation

class ErrorAlertView {
    class func alertUserWithError(error: String) -> UIAlertController {
        let alert = UIAlertController(title: "錯誤", message: error, preferredStyle: UIAlertControllerStyle.Alert)
        let ok = UIAlertAction(title: "好", style: UIAlertActionStyle.Default, handler: nil)
        alert.addAction(ok)
        
        return alert
    }
}