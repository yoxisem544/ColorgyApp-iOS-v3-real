//
//  HistoryChatroom.swift
//  ColorgyCourse
//
//  Created by David on 2016/2/8.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

class HistoryChatroom : NSObject {
	
	var chatProgress: Int
	var gender: String
	var friendId: String
	var chatroomId: String
	var image: String?
	var lastAnswer: String?
	var lastAnswerDate: TimeStamp?
	var name: String
	
	override var description: String {
		return "HistoryChatroom: {\n\tchatProgress -> \(chatProgress)\n\tgender -> \(gender)\n\tfriendId -> \(friendId)\n\tchatroomId -> \(chatroomId)\n\timage -> \(image)\n\tlastAnswer -> \(lastAnswer)\n\tlastAnswerDate -> \(lastAnswerDate)\n\tname -> \(name)\n}"
	}
	
	convenience init?(json: JSON) {
		
		var _chatProgress: Int?
		var _gender: String?
		var _friendId: String?
		var _chatroomId: String?
		var _image: String?
		var _lastAnswer: String?
		var _lastAnswerDate: String?
		var _name: String?

		_chatProgress = json["chatProgress"].int
		_gender = json["gender"].string
		_friendId = json["friendId"].string
		_chatroomId = json["chatroomId"].string
		_image = json["image"].string
		_lastAnswer = json["lastAnswer"].string
		_lastAnswerDate = json["lastAnswerDate"].string
		_name = json["name"].string
		
		self.init(chatProgress: _chatProgress, gender: _gender, friendId: _friendId, chatroomId: _chatroomId, image: _image, lastAnswer: _lastAnswer, lastAnswerDate: _lastAnswerDate, name: _name)
	}
	
	init?(chatProgress: Int?, gender: String?, friendId: String?, chatroomId: String?, image: String?, lastAnswer: String?, lastAnswerDate: String?, name: String?) {
		
		self.chatProgress = Int()
		self.gender = String()
		self.friendId = String()
		self.chatroomId = String()
		self.image = String()
		self.lastAnswer = String()
		self.lastAnswerDate = TimeStamp()
		self.name = String()
		
		super.init()
		
		// check error
		guard chatProgress != nil else { return nil }
		guard chatProgress != nil else { return nil }
		guard gender != nil else { return nil }
		guard friendId != nil else { return nil }
		guard chatroomId != nil else { return nil }
		guard name != nil else { return nil }
		
		// required
		self.chatProgress = chatProgress!
		self.chatProgress = chatProgress!
		self.gender = gender!
		self.friendId = friendId!
		self.chatroomId = chatroomId!
		self.name = name!
		
		// optional
		self.image = image
		self.lastAnswer = lastAnswer
		self.lastAnswerDate = TimeStamp(timeStampString: lastAnswerDate!)
	}
	
	class func generateHistoryChatrooms(json: JSON) -> [HistoryChatroom] {
		let json = json["result"]
		var rooms = [HistoryChatroom]()
		
		if json.isArray {
			for (_, json) : (String, JSON) in json {
				if let r = HistoryChatroom(json: json) {
					rooms.append(r)
				}
			}
		}
		
		return rooms
	}
}