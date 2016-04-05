//
//  StringExtension.swift
//  ColorgyAPIHandler
//
//  Created by David on 2015/8/24.
//  Copyright (c) 2015年 David. All rights reserved.
//

import Foundation

extension String {
    var stringWithNoSpaceAndNewLine: String {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
    
    var isValidURLString: Bool {
        return (NSURL(string: self) != nil)
    }
    
    var uuidEncode: String {
        if let name = UIDevice.currentDevice().name.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true) {
            return ("\(name)").stringByReplacingOccurrencesOfString(" ", withString: "").stringByReplacingOccurrencesOfString("<", withString: "").stringByReplacingOccurrencesOfString(">", withString: "")
        }
        return "no user device name".stringByReplacingOccurrencesOfString(" ", withString: "").stringByReplacingOccurrencesOfString("<", withString: "").stringByReplacingOccurrencesOfString(">", withString: "")
    }
	
	var intValue: Int? {
		return Int(self)
	}
	
	var url: NSURL {
		if self.isValidURLString {
			return NSURL(string: self)!
		} else {
			return NSURL(string: "")!
		}
	}
	
	var isValidEmail: Bool {
		let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
		let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
		return emailTest.evaluateWithObject(self)
	}
}