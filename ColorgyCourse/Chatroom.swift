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
	var totalMessageLength: Int
	var chatProgress: Int
	var moreMessage: Bool
	var targetAlias: String?
	var othersNickName: String? {
		get {
			return targetAlias
		}
	}
	var targetImage: String?
	var othersProfileImage: String? {
		get {
			return targetImage
		}
	}
	
	override var description: String { return "Chatroom: {\n\tchatroomId -> \(chatroomId)\n\tsocketId -> \(socketId)\n}" }
	
	convenience init?(json: JSON) {
		print(json)
		var _chatroomId: String?
		var _socketId: String?
		var _totalMessageLength: Int?
		var _chatProgress: Int?
		var _moreMessage: Bool?
		var _targetAlias: String?
		var _targetImage: String?
		
		for (_, json) : (String, JSON) in json {
			let result = json["body"]["result"]
//			if result["chatroomId"].string != nil {
//				chatroomId = result["chatroomId"].string!
//			}
//			if result["socketId"].string != nil {
//				socketId = result["socketId"].string!
//			}
			_chatroomId = result["chatroomId"].string
			_socketId = result["socketId"].string
			_totalMessageLength = result["totalMessageLength"].int
			_chatProgress = result["chatProgress"].int
			_moreMessage = result["moreMessage"].bool
			_targetAlias = result["targetAlias"].string
			_targetImage = result["targetImage"].string
		}
		
		self.init(chatroomId: _chatroomId, socketId: _socketId, totalMessageLength: _totalMessageLength, chatProgress: _chatProgress, moreMessage: _moreMessage, targetAlias: _targetAlias, targetImage: _targetImage)
	}
	
	init?(chatroomId: String?, socketId: String?, totalMessageLength: Int?, chatProgress: Int?, moreMessage: Bool?, targetAlias: String?, targetImage: String?) {
		
		self.chatroomId = String()
		self.socketId = String()
		self.totalMessageLength = Int()
		self.chatProgress = Int()
		self.moreMessage = Bool()
		
		super.init()
		
		guard chatroomId != nil else { return nil }
		guard socketId != nil else { return nil }
		guard totalMessageLength != nil else { return nil }
		guard chatProgress != nil else { return nil }
		guard moreMessage != nil else { return nil }
		
		// required
		self.chatroomId = chatroomId!
		self.socketId = socketId!
		self.totalMessageLength = totalMessageLength!
		self.chatProgress = chatProgress!
		self.moreMessage = moreMessage!
		
		// optional
		self.targetAlias = targetAlias
		self.targetImage = targetImage
	}
}