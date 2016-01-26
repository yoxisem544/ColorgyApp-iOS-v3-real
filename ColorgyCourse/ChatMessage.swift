//
//  ChatMessage.swift
//  ColorgyChat_SocketIO_testing
//
//  Created by David on 2016/1/25.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

class ChatMessage: NSObject {
	
	var id: String
	var type: String
	var content: String
	var userId: String
	var createdAt: String
	
	override var description: String { return "message: {\n\tid => \(id)\n\ttype => \(type)\n\tcontent => \(content)\n\tuserId => \(userId)\n\tcreatedAt => \(createdAt)\n}" }
	
	convenience init?(onMessage json: JSON) {
		
		var id: String?
		var type: String?
		var content: String?
		var userId: String?
		var createdAt: String?
		
		if json["id"].string != nil {
			id = json["id"].string!
		}
		if json["data"]["type"].string != nil {
			type = json["data"]["type"].string!
		}
		
		if type == "text" {
			if json["data"]["content"]["text"].string != nil {
				content = json["data"]["content"]["text"].string!
			}
		} else if type == "image" {
			if json["data"]["content"]["imgSrc"].string != nil {
				content = json["data"]["content"]["imgSrc"].string!
			}
		} else if type == "sticker" {
			if json["data"]["content"]["stickerId"].string != nil {
				content = json["data"]["content"]["stickerId"].string!
			}
		}
		
		if json["data"]["content"]["text"].string != nil {
			content = json["data"]["content"]["text"].string!
		}
		if json["data"]["userId"].string != nil {
			userId = json["data"]["userId"].string!
		}
		if json["data"]["createdAt"].string != nil {
			createdAt = json["data"]["createdAt"].string!
		}
		
		self.init(id: id, type: type, content: content, userId: userId, createdAt: createdAt)
	}
	
	convenience init?(onConnect json: JSON) {
		var id: String?
		var type: String?
		var content: String?
		var userId: String?
		var createdAt: String?
		if json["id"].string != nil {
			id = json["id"].string!
		}
		if json["type"].string != nil {
			type = json["type"].string!
		}
		
		if type == "text" {
			if json["content"]["text"].string != nil {
				content = json["content"]["text"].string!
			}
		} else if type == "image" {
			if json["content"]["imgSrc"].string != nil {
				content = json["content"]["imgSrc"].string!
			}
		} else if type == "sticker" {
			if json["content"]["stickerId"].string != nil {
				content = json["content"]["stickerId"].string!
			}
		}

		if json["content"]["text"].string != nil {
			content = json["content"]["text"].string!
		}
		if json["content"]["image"] != nil {
			print(json["content"]["image"])
		}
		if json["userId"].string != nil {
			userId = json["userId"].string!
		}
		if json["createdAt"].string != nil {
			createdAt = json["createdAt"].string!
		}
		
		self.init(id: id, type: type, content: content, userId: userId, createdAt: createdAt)
	}
	
	internal init?(id: String?, type: String?, content: String?, userId: String?, createdAt: String?) {
		
		self.id = ""
		self.type = ""
		self.content = ""
		self.userId = ""
		self.createdAt = ""
		
		super.init()
		
		guard id != nil else { return nil }
		guard type != nil else { return nil }
		guard content != nil else { return nil }
		guard userId != nil else { return nil }
		guard createdAt != nil else { return nil }
		
		self.id = id!
		self.type = type!
		self.content = content!
		self.userId = userId!
		self.createdAt = createdAt!
	}
	
	class func generateMessages(json: JSON) -> [ChatMessage] {
		var messages = [ChatMessage]()
//		print(json)
		for (_, json) : (String, JSON) in json {
			if let message = ChatMessage(onMessage: json) {
				messages.append(message)
			}
		}
		return messages
	}
	
	class func generateMessagesOnConnent(json: JSON) -> [ChatMessage] {
		var messages = [ChatMessage]()
		if let (_, json) = json.first {
//			print(json["body"]["result"]["messageList"].count)
			for (_, json) : (String, JSON) in json["body"]["result"]["messageList"] {
				if let message = ChatMessage(onConnect: json) {
					messages.append(message)
				}
			}
		}
		return messages
	}
}