//
//  DateExtension.swift
//  ColorgyCourse
//
//  Created by David on 2016/1/29.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

extension NSDate {
	var year: String {
		let formatter = NSDateFormatter()
		//        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
		formatter.dateFormat = "yyyy"
		return formatter.stringFromDate(self)
	}
	
	var month: String {
		let formatter = NSDateFormatter()
		//        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
		formatter.dateFormat = "MM"
		return formatter.stringFromDate(self)
	}
	
	var day: String {
		let formatter = NSDateFormatter()
		//        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
		formatter.dateFormat = "dd"
		return formatter.stringFromDate(self)
	}
	
	var hour: String {
		let formatter = NSDateFormatter()
		//        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
		formatter.dateFormat = "HH"
		return formatter.stringFromDate(self)
	}
	
	var minute: String {
		let formatter = NSDateFormatter()
		//        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
		formatter.dateFormat = "mm"
		return formatter.stringFromDate(self)
	}
	
	var second: String {
		let formatter = NSDateFormatter()
		//        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
		formatter.dateFormat = "ss"
		return formatter.stringFromDate(self)
	}
}