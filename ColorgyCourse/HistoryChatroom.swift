//
//  HistoryChatroom.swift
//  ColorgyCourse
//
//  Created by David on 2016/2/8.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

class HistoryChatroom : NSObject {
	
	var id: String
	var chatProgress: Int
	var chatId1: String
	var chatId2: String
	var aliasId1: String
	var aliasId2: String
	var imageId1: String?
	var imageId2: String?
	var lastSpeaker: String?
	var updateAt: String?
	
	override var description: String {
		return "HistoryChatroom: {\n\tid -> \(id)\n\tchatProgress -> \(chatProgress)\n\tchatId1 -> \(chatId1)\n\tchatId2 -> \(chatId2)\n\taliasId1 -> \(aliasId1)\n\taliasId2 -> \(aliasId2)\n\timageId1 -> \(imageId1)\n\timageId2 -> \(imageId2)\n\tlastSpeaker -> \(lastSpeaker)\n\tupdateAt -> \(updateAt)\n}"
	}
	
	convenience init?(json: JSON) {
		
		var _id: String?
		var _chatProgress: Int?
		var _chatId1: String?
		var _chatId2: String?
		var _aliasId1: String?
		var _aliasId2: String?
		var _imageId1: String?
		var _imageId2: String?
		var _lastSpeaker: String?
		var _updateAt: String?
		
		_id = json["id"].string
		_chatProgress = json["chatProgress"].int
		_chatId1 = json["chatId1"].string
		_chatId2 = json["chatId2"].string
		_aliasId1 = json["aliasId1"].string
		_aliasId2 = json["aliasId2"].string
		_imageId1 = json["imageId1"].string
		_imageId2 = json["imageId2"].string
		_lastSpeaker = json["lastSpeaker"].string
		_updateAt = json["updateAt"].string
		
		self.init(id: _id, chatProgress: _chatProgress, chatId1: _chatId1, chatId2: _chatId2, aliasId1: _aliasId1, aliasId2: _aliasId2, imageId1: _imageId1, imageId2: _imageId2, lastSpeaker: _lastSpeaker, updateAt: _updateAt)
	}
	
	init?(id: String?, chatProgress: Int?, chatId1: String?, chatId2: String?, aliasId1: String?, aliasId2: String?, imageId1: String?, imageId2: String?, lastSpeaker: String?, updateAt: String?) {
		
		self.id = String()
		self.chatProgress = Int()
		self.chatId1 = String()
		self.chatId2 = String()
		self.aliasId1 = String()
		self.aliasId2 = String()
		
		super.init()
		
		// check error
		guard id != nil else { return nil }
		guard chatProgress != nil else { return nil }
		guard chatId1 != nil else { return nil }
		guard chatId2 != nil else { return nil }
		guard aliasId1 != nil else { return nil }
		guard aliasId2 != nil else { return nil }
		
		// required
		self.id = id!
		self.chatProgress = chatProgress!
		self.chatId1 = chatId1!
		self.chatId2 = chatId2!
		self.aliasId1 = aliasId1!
		self.aliasId2 = aliasId2!
		
		// optional
		self.imageId1 = imageId1
		self.imageId2 = imageId2
		self.lastSpeaker = lastSpeaker
		self.updateAt = updateAt
	}
}