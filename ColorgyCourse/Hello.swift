//
//  Hello.swift
//  ColorgyCourse
//
//  Created by David on 2016/2/8.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

class Hello: NSObject {
	var userId: String
	var targetId: String
	var message: String
	var status: HiStatus
	
	convenience init?(json: JSON) {
		var _userId: String?
		var _targetId: String?
		var _message: String?
		var _status: String?
		
		_userId = json["userId"].string
		_targetId = json["targetId"].string
		_message = json["message"].string
		_status = json["status"].string
		
		self.init(userId: _userId, targetId: _targetId, message: _message, status: _status)
	}
	
	init?(userId: String?, targetId: String?, message: String?, status: String?) {
		self.userId = String()
		self.targetId = String()
		self.message = String()
		self.status = HiStatus.Pending
		super.init()
		
		// check if there is an error
		guard userId != nil else { return nil }
		guard targetId != nil else { return nil }
		guard message != nil else { return nil }
		guard status != nil else { return nil }
		
		// if no error
		self.userId = userId!
		self.targetId = targetId!
		self.message = message!
		
		if status == HiStatus.Pending.rawValue {
			self.status = HiStatus.Pending
		} else if status == HiStatus.Accepted.rawValue {
			self.status = HiStatus.Accepted
		} else if status == HiStatus.Rejected.rawValue {
			self.status = HiStatus.Rejected
		} else {
			print("fail to generate hello model, because of HiStatus error")
			return nil
		}
		
	}
	
	
}