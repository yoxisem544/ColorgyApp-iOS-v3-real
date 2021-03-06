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
	var createdAt: TimeStamp
	var chatProgress: Int?
	
	var mediaImage: UIImage!
	
	struct MessageType {
		static let Text = "text"
		static let Image = "image"
		static let Sticker = "sticker"
	}
	
	struct ContentKey {
		static let Text = "text"
		static let Image = "imgSrc"
		static let Sticker = "stickerId"
	}
	
	override var description: String { return "ChatMessage: {\n\tid => \(id)\n\ttype => \(type)\n\tcontent => \(content)\n\tuserId => \(userId)\n\tcreatedAt => \(createdAt)\n\tchatProgress => \(chatProgress)\n}" }
	
	convenience init?(onMessage json: JSON) {

		var id: String?
		var type: String?
		var content: String?
		var userId: String?
		var createdAt: String?
		var chatProgress: Int?
		
		if json["id"].string != nil {
			id = json["id"].string!
		}
		if json["data"]["type"].string != nil {
			type = json["data"]["type"].string!
		}
		
		if type == ChatMessage.MessageType.Text {
			if json["data"]["content"]["text"].string != nil {
				content = json["data"]["content"][ChatMessage.ContentKey.Text].string!
			}
		} else if type == ChatMessage.MessageType.Image {
			if json["data"]["content"]["imgSrc"].string != nil {
				content = json["data"]["content"][ChatMessage.ContentKey.Image].string!
			}
		} else if type == ChatMessage.MessageType.Sticker {
			if json["data"]["content"]["stickerId"].string != nil {
				content = json["data"]["content"][ChatMessage.ContentKey.Sticker].string!
			}
		}

		if json["data"]["userId"].string != nil {
			userId = json["data"]["userId"].string!
		}
		if json["data"]["createdAt"].string != nil {
			createdAt = json["data"]["createdAt"].string!
		}
		chatProgress = json["data"]["chatProgress"].int
		
		self.init(id: id, type: type, content: content, userId: userId, createdAt: createdAt, chatProgress: chatProgress)
	}
	
	convenience init?(onRequestingMoreMessage json: JSON) {
		
		var id: String?
		var type: String?
		var content: String?
		var userId: String?
		var createdAt: String?
		var chatProgress: Int?
		
		if json["id"].string != nil {
			id = json["id"].string!
		}
		if json["type"].string != nil {
			type = json["type"].string!
		}
		
		if type == ChatMessage.MessageType.Text {
			if json["content"]["text"].string != nil {
				content = json["content"][ChatMessage.ContentKey.Text].string!
			}
		} else if type == ChatMessage.MessageType.Image {
			if json["content"]["imgSrc"].string != nil {
				content = json["content"][ChatMessage.ContentKey.Image].string!
			}
		} else if type == ChatMessage.MessageType.Sticker {
			if json["content"]["stickerId"].string != nil {
				content = json["content"][ChatMessage.ContentKey.Sticker].string!
			}
		}

		if json["userId"].string != nil {
			userId = json["userId"].string!
		}
		if json["createdAt"].string != nil {
			createdAt = json["createdAt"].string!
		}
		
		self.init(id: id, type: type, content: content, userId: userId, createdAt: createdAt, chatProgress: 1)
	}
	
	convenience init?(onConnect json: JSON) {

		var id: String?
		var type: String?
		var content: String?
		var userId: String?
		var createdAt: String?
		var chatProgress: Int?
		
		if json["id"].string != nil {
			id = json["id"].string!
		}
		if json["type"].string != nil {
			type = json["type"].string!
		}
		
		if type == ChatMessage.MessageType.Text {
			if json["content"]["text"].string != nil {
				content = json["content"][ChatMessage.ContentKey.Text].string!
			}
		} else if type == ChatMessage.MessageType.Image {
			if json["content"]["imgSrc"].string != nil {
				content = json["content"][ChatMessage.ContentKey.Image].string!
			}
		} else if type == ChatMessage.MessageType.Sticker {
			if json["content"]["stickerId"].string != nil {
				content = json["content"][ChatMessage.ContentKey.Sticker].string!
			}
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
		chatProgress = json["data"]["chatProgress"].int
		
		self.init(id: id, type: type, content: content, userId: userId, createdAt: createdAt, chatProgress: chatProgress)
	}
	
	internal init?(id: String?, type: String?, content: String?, userId: String?, createdAt: String?, chatProgress: Int?) {
		
		self.id = ""
		self.type = ""
		self.content = ""
		self.userId = ""
		self.createdAt = TimeStamp()
		self.chatProgress = Int()
		
		super.init()
		
		guard id != nil else { return nil }
		guard type != nil else { return nil }
		guard content != nil else { return nil }
		guard userId != nil else { return nil }
		guard createdAt != nil else { return nil }
		guard let createdAtTimeStamp = TimeStamp(timeStampString: createdAt!) else { return nil }
		
		self.id = id!
		self.type = type!
		self.content = content!
		self.userId = userId!
		self.createdAt = createdAtTimeStamp
		self.chatProgress = chatProgress
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
	
	class func generateMessagesOnRequestingMoreMessage(json: JSON) -> [ChatMessage] {
		var messages = [ChatMessage]()
		//		print(json)
		for (_, json) : (String, JSON) in json["messageList"] {
			if let message = ChatMessage(onRequestingMoreMessage: json) {
				messages.append(message)
			}
		}
		return messages
	}
	
	class func generateMessagesOnConnent(json: JSON, complete: (messages: [ChatMessage]) -> Void) {
		var messages = [ChatMessage]()
		dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INTERACTIVE.rawValue), 0)) { () -> Void in
			if let (_, json) = json.first {
				//			print(json["body"]["result"]["messageList"].count)
				for (_, json) : (String, JSON) in json["body"]["result"]["messageList"] {
					if let message = ChatMessage(onConnect: json) {
						messages.append(message)
					}
				}
				dispatch_async(dispatch_get_main_queue(), { () -> Void in
					complete(messages: messages)
				})
			}
		}
	}
}