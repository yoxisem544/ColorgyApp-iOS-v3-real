//
//  TestChatRoomViewController.swift
//  ColorgyCourse
//
//  Created by David on 2016/1/25.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

class TestChatRoomViewController: DLMessagesViewController {
	
	let s = SocketIOClient(socketURL: "52.68.177.186:1337", options: [.Log(false), .ForcePolling(true), .ConnectParams(["__sails_io_sdk_version":"0.11.0"])])
	let colorgySocket = ColorgySocket()
	var messages = [ChatMessage]()
	
	var params: [String : NSObject]!
	var userId: String!
	var chatroom: Chatroom!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		self.delegate = self
		print(self.params)
    }
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		colorgySocket.connectToServer(withParameters: params) { (chatroom, messages) -> Void in
			print(chatroom)
			print(messages.count)
			for m in messages {
				self.messages.append(m)
				self.messageRecieved()
			}
		}
		
		colorgySocket.onRecievingMessage { (messages) -> Void in
			for m in messages {
				self.messages.append(m)
				self.messageRecieved()
			}
		}
		
		colorgySocket.connect()
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return messages.count
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		if messages[indexPath.row].userId != userId {
			// incoming
			let cell = tableView.dequeueReusableCellWithIdentifier(DLMessageControllerIdentifier.DLIncomingMessageBubbleIdentifier, forIndexPath: indexPath) as! DLIncomingMessageBubble
			
			cell.textlabel.text = messages[indexPath.row].content
			cell.userImageView.image = UIImage(named: "ching.jpg")
			
			return cell
		} else {
			let cell = tableView.dequeueReusableCellWithIdentifier(DLMessageControllerIdentifier.DLOutgoingMessageBubbleIdentifier, forIndexPath: indexPath) as! DLOutgoingMessageBubble
			
			cell.textlabel.text = messages[indexPath.row].content
			
			return cell
		}
	}
}

extension TestChatRoomViewController : DLMessagesViewControllerDelegate {
	func DLMessagesViewControllerDidClickedMessageButton(withReturnMessage message: String?) {
		print(message)
		if let message = message {
			
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
			s.emitWithAck("post", postData)(timeoutAfter: 10, callback: { (res) -> Void in
				print(res)
			})
		}
	}
}
