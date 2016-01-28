//
//  ColorgySocket.swift
//  ColorgyCourse
//
//  Created by David on 2016/1/26.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

class ColorgySocket : NSObject {
	
	internal let socket = SocketIOClient(socketURL: "52.68.177.186:1337", options: [.Log(false), .ForcePolling(true), .ConnectParams(["__sails_io_sdk_version":"0.11.0"])])
	internal var chatroom: Chatroom!
	
	func test() {
		
	}
	
	func connectToServer(withParameters parameters: [String : NSObject]!, registerToChatroom: (chatroom: Chatroom, messages: [ChatMessage]) -> Void) {
		self.socket.on("connect") { (response: [AnyObject], ack: SocketAckEmitter) -> Void in
			self.socket.emitWithAck("post", parameters)(timeoutAfter: 1000, callback: { (responseOnEmit) -> Void in
				let chatroom = Chatroom(json: JSON(responseOnEmit))
				self.chatroom = chatroom
				print(chatroom)
				let chatMessages = ChatMessage.generateMessagesOnConnent(JSON(responseOnEmit))
				registerToChatroom(chatroom: chatroom, messages: chatMessages)
			})
		}
	}
	
	func connectToServer(withParameters parameters: [String : NSObject]!, registerToChatroom: (chatroom: Chatroom) -> Void, withMessages: (messages: [ChatMessage]) -> Void) {
		self.socket.on("connect") { (response: [AnyObject], ack: SocketAckEmitter) -> Void in
			self.socket.emitWithAck("post", parameters)(timeoutAfter: 1000, callback: { (responseOnEmit) -> Void in
				
				dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INTERACTIVE.rawValue), 0)) { () -> Void in
					let chatroom = Chatroom(json: JSON(responseOnEmit))
					dispatch_async(dispatch_get_main_queue(), { () -> Void in
						self.chatroom = chatroom
						registerToChatroom(chatroom: self.chatroom)
					})
				}
				
				ChatMessage.generateMessagesOnConnent(JSON(responseOnEmit), complete: { (messages) -> Void in
					withMessages(messages: messages)
				})
			})
		}
	}
	
	func connectToServer(withParameters parameters: [String : NSObject]!, registerToChatroom: (chatroom: Chatroom) -> Void, withSectionMessage: (message: ChatMessage) -> Void) {
		self.socket.on("connect") { (response: [AnyObject], ack: SocketAckEmitter) -> Void in
			self.socket.emitWithAck("post", parameters)(timeoutAfter: 1000, callback: { (responseOnEmit) -> Void in
				
				dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INTERACTIVE.rawValue), 0)) { () -> Void in
					let chatroom = Chatroom(json: JSON(responseOnEmit))
					dispatch_async(dispatch_get_main_queue(), { () -> Void in
						self.chatroom = chatroom
						registerToChatroom(chatroom: self.chatroom)
					})
				}

				ChatMessage.generateMessagesOnConnent(JSON(responseOnEmit), withSectionMessage: { (message) -> Void in
					withSectionMessage(message: message)
				})
			})
		}
	}
	
	func onRecievingMessage(messagesRecieved messagesRecieved: (messages: [ChatMessage]) -> Void) {
		self.socket.on("chatroom") { (response, ack: SocketAckEmitter) -> Void in
			let ms = ChatMessage.generateMessages(JSON(response))
			messagesRecieved(messages: ms)
		}
	}
	
	func connect() {
		self.socket.connect()
	}
	
	func sendTextMessage(message: String, withUserId userId: String) {
		let postData: [String : NSObject]! = [
			"method": "post",
			"headers": [],
			"data": [
				"chatroomId": chatroom.chatroomId,
				"userId": userId,
				"socketId": chatroom.socketId,
				"type": "text",
				"content": ["text": message]
			],
			"url": "/chatroom/send_message"
		]
		//			s.emit("post", withItems: postData as! [AnyObject])
		self.socket.emitWithAck("post", postData)(timeoutAfter: 10, callback: { (res) -> Void in
			print(res)
		})
	}
}