//
//  ColorgySocket.swift
//  ColorgyCourse
//
//  Created by David on 2016/1/26.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

class ColorgySocket : NSObject {
	
	internal let socket = SocketIOClient(socketURL: "http://chat.colorgy.io:80", options: [.Log(false), .ForcePolling(true), .ConnectParams(["__sails_io_sdk_version":"0.11.0"])])
	internal var chatroom: Chatroom?
	internal var didConnectToSocketOnce: Bool = false
	
	func connectToServer(withParameters parameters: [String : NSObject]!, registerToChatroom: (chatroom: Chatroom?, messages: [ChatMessage]) -> Void) {
		self.socket.on("connect") { (response: [AnyObject], ack: SocketAckEmitter) -> Void in
			self.socket.emitWithAck("post", parameters)(timeoutAfter: 1000, callback: { (responseOnEmit) -> Void in
				let chatroom = Chatroom(json: JSON(responseOnEmit))
				self.chatroom = chatroom
				print(chatroom)
				if !self.didConnectToSocketOnce {
					let chatMessages = ChatMessage.generateMessagesOnConnent(JSON(responseOnEmit))
					registerToChatroom(chatroom: chatroom, messages: chatMessages)
					self.didConnectToSocketOnce = true
				}
			})
		}
	}
	
	func connectToServer(withParameters parameters: [String : NSObject]!, registerToChatroom: (chatroom: Chatroom?) -> Void, withMessages: (messages: [ChatMessage]) -> Void) {
		self.socket.on("connect") { (response: [AnyObject], ack: SocketAckEmitter) -> Void in
			self.socket.emitWithAck("post", parameters)(timeoutAfter: 1000, callback: { (responseOnEmit) -> Void in

				dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INTERACTIVE.rawValue), 0)) { () -> Void in
					let chatroom = Chatroom(json: JSON(responseOnEmit))
					dispatch_async(dispatch_get_main_queue(), { () -> Void in
						self.chatroom = chatroom
						registerToChatroom(chatroom: self.chatroom)
					})
					
					if chatroom != nil {
						if !self.didConnectToSocketOnce {
							ChatMessage.generateMessagesOnConnent(JSON(responseOnEmit), complete: { (messages) -> Void in
								withMessages(messages: messages)
							})
							self.didConnectToSocketOnce = true
						}
					}
				}
			})
		}
	}
	
	func connectToServer(withParameters parameters: [String : NSObject]!, registerToChatroom: (chatroom: Chatroom?) -> Void, withSectionMessage: (message: ChatMessage) -> Void) {
		self.socket.on("connect") { (response: [AnyObject], ack: SocketAckEmitter) -> Void in
			self.socket.emitWithAck("post", parameters)(timeoutAfter: 1000, callback: { (responseOnEmit) -> Void in

				dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INTERACTIVE.rawValue), 0)) { () -> Void in
					let chatroom = Chatroom(json: JSON(responseOnEmit))
					dispatch_async(dispatch_get_main_queue(), { () -> Void in
						self.chatroom = chatroom
						registerToChatroom(chatroom: self.chatroom)
					})
					
					if chatroom != nil {
						if !self.didConnectToSocketOnce {
							ChatMessage.generateMessagesOnConnent(JSON(responseOnEmit), withSectionMessage: { (message) -> Void in
								withSectionMessage(message: message)
							})
							self.didConnectToSocketOnce = true
						}
					}
				}
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
	
	func disconnect() {
		self.socket.disconnect()
	}
	
	func sendTextMessage(message: String, withUserId userId: String) {
		if let chatroom = self.chatroom {
			let postData: [String : NSObject]! = [
				"method": "post",
				"headers": [],
				"data": [
					"chatroomId": chatroom.chatroomId,
					"userId": userId,
					"socketId": chatroom.socketId,
					"type": ChatMessage.MessageType.Text,
					"content": [ChatMessage.ContentKey.Text: message]
				],
				"url": "/chatroom/send_message"
			]
			print(postData)
			//			s.emit("post", withItems: postData as! [AnyObject])
			self.socket.emitWithAck("post", postData)(timeoutAfter: 10, callback: { (res) -> Void in
				print(res)
			})
		}
	}
	
	func sendPhotoMessage(imageUrl: String, withUserId userId: String) {
		if let chatroom = self.chatroom {
			let postData: [String : NSObject]! = [
				"method": "post",
				"headers": [],
				"data": [
					"chatroomId": chatroom.chatroomId,
					"userId": userId,
					"socketId": chatroom.socketId,
					"type": ChatMessage.MessageType.Image,
					"content": [ChatMessage.ContentKey.Image: imageUrl]
				],
				"url": "/chatroom/send_message"
			]
			//			s.emit("post", withItems: postData as! [AnyObject])
			self.socket.emitWithAck("post", postData)(timeoutAfter: 10, callback: { (res) -> Void in
				print(res)
			})
		}
	}
}