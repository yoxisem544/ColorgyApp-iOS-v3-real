//
//  ChatUser.swift
//  ColorgyCourse
//
//  Created by David on 2016/1/29.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

class ChatUser : NSObject {
	
	var status: String
	var userId: String
	
	override var description: String {
		return "ChatUser: {\n\tstatus => \(status)\n\tuserId => \(userId)\n}"
	}
	
	convenience init?(json: JSON) {
		
		var _status: String?
		var _userId: String?

		_userId = json["userId"].string
		_status = json["status"].int != nil ? "\(json["status"].int!)" : ""
		
		guard _status != nil else { return nil }
		guard _userId != nil else { return nil }
		
		self.init(userId: _userId!, status: _status!)
	}
	
	init(userId: String, status: String) {
		self.userId = userId
		self.status = status
	}
}