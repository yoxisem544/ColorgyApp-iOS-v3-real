//
//  ChatUser.swift
//  ColorgyCourse
//
//  Created by David on 2016/1/29.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

class ChatUser : NSObject {
	var error: String
	var status: String
	var userId: String
	
	override var description: String {
		return "ChatUser: {\n\terror => \(error)\n\tstatus => \(status)\n\tuserId => \(userId)\n}"
	}
	
	convenience init?(json: JSON) {
		
		var _error: String?
		var _status: String?
		var _userId: String?
		
		print(json)
		
		for (key, json) in json {
			if key == "error" {
				if let e = json.string {
					_error = e
				}
			}
			if key == "status" {
				if let s = json.string {
					_status = s
				}
			}
			if key == "userId" {
				if let u = json.string {
					_userId = u
				}
			}
		}
		
		guard _error != nil else { return nil }
		guard _status != nil else { return nil }
		guard _userId != nil else { return nil }
		
		self.init(userId: _userId!, status: _status!, error: _error!)
	}
	
	init(userId: String, status: String, error: String) {
		self.userId = userId
		self.status = status
		self.error = error
	}
}