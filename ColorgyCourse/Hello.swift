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
	var id: String
	var name: String?
	
	override var description: String {
		return "Hello: {\n\tuserId -> \(userId)\n\ttargetId -> \(targetId)\n\tmessage -> \(message)\n\tstatus -> \(status)\n\tid -> \(id)\n\tname -> \(name)\n}"
	}
	
	convenience init?(json: JSON) {
		var _userId: String?
		var _targetId: String?
		var _message: String?
		var _status: String?
		var _id: String?
		var _name: String?
		
		_userId = json["userId"].string
		_targetId = json["targetId"].string
		_message = json["message"].string
		_status = json["status"].string
		_id = json["id"].string
		_name = json["name"].string
		
		self.init(userId: _userId, targetId: _targetId, message: _message, status: _status, id: _id, name: _name)
	}
	
	init?(userId: String?, targetId: String?, message: String?, status: String?, id: String?, name: String?) {
		self.userId = String()
		self.targetId = String()
		self.message = String()
		self.status = HiStatus.Pending
		self.id = String()
		super.init()
		
		// check if there is an error
		guard userId != nil else { return nil }
		guard targetId != nil else { return nil }
		guard message != nil else { return nil }
		guard status != nil else { return nil }
		guard id != nil else { return nil }
		
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
		
		self.id = id!
		self.name = name
	}
	
	class func generateHiList(json: JSON) -> [Hello] {
		let json = json["result"]
		var hiList = [Hello]()
		print(json)
		if json.isArray {
			for (_, json) : (String, JSON) in json {
				if let h = Hello(json: json) {
					hiList.append(h)
				}
			}
		}
		
		return hiList
	}
}