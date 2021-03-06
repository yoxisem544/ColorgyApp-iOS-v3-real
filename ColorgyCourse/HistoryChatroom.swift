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
	var image: String
	var lastAnswer: String?
	var lastAnsweredDate: TimeStamp?
	var name: String
	var lastContent: String
	var lastContentTime: TimeStamp
	var lastSpeaker: String
	var updatedAt: TimeStamp
	var unread: Bool = false
	var blurImage: String
	
	override var description: String {
		return "HistoryChatroom: {\n\tchatProgress -> \(chatProgress)\n\tgender -> \(gender)\n\tfriendId -> \(friendId)\n\tchatroomId -> \(chatroomId)\n\timage -> \(image)\n\tlastAnswer -> \(lastAnswer)\n\tlastAnswerDate -> \(lastAnsweredDate)\n\tname -> \(name)\n\tlastContent -> \(lastContent)\n\tlastContentTime -> \(lastContentTime)\n\tlastSpeaker -> \(lastSpeaker)\n\tupdatedAt -> \(updatedAt)\n\tunread -> \(unread)\n\tblurImage -> \(blurImage)\n}"
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
		var _lastContent: String?
		var _lastSpeaker: String?
		var _updatedAt: String?
		var _lastContentTime: String?
		var _blurImage: String?
		
		_chatProgress = json["chatProgress"].int
		_gender = json["gender"].string
		_friendId = json["friendId"].string
		_chatroomId = json["chatroomId"].string
		_image = json["image"].string
		_lastAnswer = json["lastAnswer"].string
		_lastAnswerDate = json["lastAnsweredDate"].string
		_name = json["name"].string
		_lastContent = json["lastContent"].string
		_lastSpeaker = json["lastSpeaker"].string
		_updatedAt = json["updatedAt"].string
		_lastContentTime = json["lastContentTime"].string
		_blurImage = json["blurImage"].string
		
		self.init(chatProgress: _chatProgress, gender: _gender, friendId: _friendId, chatroomId: _chatroomId, image: _image, lastAnswer: _lastAnswer, lastAnsweredDate: _lastAnswerDate, name: _name, lastContent: _lastContent, lastSpeaker: _lastSpeaker, updatedAt: _updatedAt, lastContentTime: _lastContentTime, blurImage: _blurImage)
	}
	
	init?(chatProgress: Int?, gender: String?, friendId: String?, chatroomId: String?, image: String?, lastAnswer: String?, lastAnsweredDate: String?, name: String?, lastContent: String?, lastSpeaker: String?, updatedAt: String?, lastContentTime: String?, blurImage: String?) {
		
		self.chatProgress = Int()
		self.gender = String()
		self.friendId = String()
		self.chatroomId = String()
		self.image = String()
		self.lastAnswer = String()
		self.lastAnsweredDate = TimeStamp()
		self.name = String()
		self.lastSpeaker = String()
		self.image = String()
		self.lastContent = String()
		self.updatedAt = TimeStamp()
		self.lastContentTime = TimeStamp()
		self.blurImage = String()
		
		super.init()
		
		// check error
		guard chatProgress != nil else { return nil }
		guard chatProgress != nil else { return nil }
		guard gender != nil else { return nil }
		guard friendId != nil else { return nil }
		guard chatroomId != nil else { return nil }
		guard name != nil else { return nil }
		guard lastSpeaker != nil else { return nil }
		guard image != nil else { return nil }
		guard lastContent != nil else { return nil }
		guard updatedAt != nil else { return nil }
		guard let updatedAtTimeStamp = TimeStamp(timeStampString: updatedAt!) else { return nil }
		guard lastContentTime != nil else { return nil }
		guard blurImage != nil else { return nil }
		
		// required
		self.chatProgress = chatProgress!
		self.gender = gender!
		self.friendId = friendId!
		self.chatroomId = chatroomId!
		self.name = name!
		self.lastSpeaker = lastSpeaker!
		self.image = image!
		self.lastContent = lastContent!
		self.updatedAt = updatedAtTimeStamp
		self.lastContentTime = TimeStamp(timeStampString: lastContentTime!) ?? TimeStamp()
		self.blurImage = blurImage!
		
		// optional
		self.lastAnswer = lastAnswer
		self.lastAnsweredDate = TimeStamp(timeStampString: lastAnsweredDate ?? "")
	}
	
	class func generateHistoryChatrooms(json: JSON) -> [HistoryChatroom] {
		let json = json["result"]
		var rooms = [HistoryChatroom]()
		
		let before = NSDate()
		if json.isArray {
			for (_, json) : (String, JSON) in json {
				if let r = HistoryChatroom(json: json) {
					rooms.append(r)
				}
			}
		}
		let now = NSDate()
		print("time to create history room ---> \(now.timeIntervalSinceDate(before))")
		
		return rooms
	}
}