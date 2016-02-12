//
//  TimeStamp.swift
//  ColorgyCourse
//
//  Created by David on 2016/2/12.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

class TimeStamp : NSObject {
	
	var year: Int
	var month: Int
	var date: Int
	var hour: Int
	var minute: Int
	var second: Int
	var millisecond: Int
	
	override var description: String {
		return "TimeStamp: (\(year)-\(month)-\(date) \(hour):\(minute):\(second)'\(millisecond))"
	}
	
	override init() {
		self.year = Int()
		self.month = Int()
		self.date = Int()
		self.hour = Int()
		self.minute = Int()
		self.second = Int()
		self.millisecond = Int()
		super.init()
	}
	
	init?(timeStampString: String) {
		
		self.year = Int()
		self.month = Int()
		self.date = Int()
		self.hour = Int()
		self.minute = Int()
		self.second = Int()
		self.millisecond = Int()
		
		super.init()
		
		var _year: Int?
		var _month: Int?
		var _date: Int?
		var _hour: Int?
		var _minute: Int?
		var _second: Int?
		var _millisecond: Int?
		
		let trimLastCharaterStrings = timeStampString.characters.split("Z").map(String.init)
		if let string = trimLastCharaterStrings.first {
			let splitDayAndHourStrings = string.characters.split("T").map(String.init)
			if splitDayAndHourStrings.count == 2 {
				let yearMonthDayString = splitDayAndHourStrings[0]
				let yearMonthDayStrings = yearMonthDayString.characters.split("-").map(String.init)
				if yearMonthDayStrings.count == 3 {
					_year = Int(yearMonthDayStrings[0])
					_month = Int(yearMonthDayStrings[1])
					_date = Int(yearMonthDayStrings[2])
				}
				
				let hourString = splitDayAndHourStrings[1]
				let hourStrings = hourString.characters.split(":").map(String.init)
				if hourStrings.count == 3 {
					_hour = Int(hourStrings[0])
					_minute = Int(hourStrings[1])
					if let secondAndMillisecond = Double(hourStrings[2]) {
						_second = Int(secondAndMillisecond / 1.0)
						_millisecond = Int(secondAndMillisecond % 1.0 * 1000)
					}
				}
			}
		}
		
		guard _year != nil else { return nil }
		guard _month != nil else { return nil }
		guard _date != nil else { return nil }
		guard _hour != nil else { return nil }
		guard _minute != nil else { return nil }
		guard _second != nil else { return nil }
		guard _millisecond != nil else { return nil }
		
		self.year = _year!
		self.month = _month!
		self.date = _date!
		self.hour = _hour!
		self.minute = _minute!
		self.second = _second!
		self.millisecond = _millisecond!
	}
	
	func nsdateValue() -> NSDate? {
		let formatter = NSDateFormatter()
		formatter.dateFormat = "yyyy-MM-dd-HH-mm-ss-SSS"
		let dateString = "\(year)-\(month)-\(date)-\(hour)-\(minute)-\(second)-\(millisecond)"
		print(dateString)
		return formatter.dateFromString(dateString)
	}
	
	func timeIntervalSince1970() -> NSTimeInterval? {
		if let nsdate = self.nsdateValue() {
			return nsdate.timeIntervalSince1970
		} else {
			return nil
		}
	}
}