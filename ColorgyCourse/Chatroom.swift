//
//  Chatroom.swift
//  ColorgyCourse
//
//  Created by David on 2016/1/25.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

class Chatroom : NSObject {
	
	var chatroomId: String
	var socketId: String
	
	override var description: String { return "Chatroom: {\n\tchatroomId -> \(chatroomId)\n\tsocketId -> \(socketId)\n}" }
	
	convenience init?(json: JSON) {
		print(json)
		var chatroomId = String()
		var socketId = String()
		for (_, json) : (String, JSON) in json {
			let result = json["body"]["result"]
			if result["chatroomId"].string != nil {
				chatroomId = result["chatroomId"].string!
			}
			if result["socketId"].string != nil {
				socketId = result["socketId"].string!
			}
		}
		self.init(chatroomId: chatroomId, socketId: socketId)
		guard self.socketId != String() else { return nil }
		guard self.chatroomId != String() else { return nil }
	}
	
	init(chatroomId: String, socketId: String) {
		self.chatroomId = chatroomId
		self.socketId = socketId
	}
}