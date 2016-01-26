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

	func connectToServer(withParameters parameters: [String : NSObject]!, registerToChatroom: (chatroom: Chatroom, messages: [ChatMessage]) -> Void) {
		self.socket.on("connect") { (response: [AnyObject], ack: SocketAckEmitter) -> Void in
			self.socket.emitWithAck("post", parameters)(timeoutAfter: 1000, callback: { (responseOnEmit) -> Void in
				let chatroom = Chatroom(json: JSON(responseOnEmit))
				print(chatroom)
				let chatMessages = ChatMessage.generateMessagesOnConnent(JSON(responseOnEmit))
				registerToChatroom(chatroom: chatroom, messages: chatMessages)
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
}