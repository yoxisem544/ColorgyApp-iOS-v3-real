//
//  TestChatRoomViewController.swift
//  ColorgyCourse
//
//  Created by David on 2016/1/25.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit
import Photos

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
		
//		colorgySocket.connectToServer(withParameters: params) { (chatroom, messages) -> Void in
//			print(chatroom)
//			print(messages.count)
//			self.chatroom = chatroom
//			for m in messages {
//				self.messages.append(m)
//				self.messageRecieved()
//			}
//		}
		
		colorgySocket.connectToServer(withParameters: params, registerToChatroom: { (chatroom) -> Void in
			self.chatroom = chatroom
		}, withMessages: { (messages) -> Void in
			for m in messages {
				self.messages.append(m)
//				self.messageRecieved()
				self.messageRecievedButDontReload()
			}
			self.recievingABunchMessages()
		})
		
//		colorgySocket.connectToServer(withParameters: params, registerToChatroom: { (chatroom) -> Void in
//			self.chatroom = chatroom
//			}, withSectionMessage: { (message) -> Void in
//				self.messages.append(message)
//				self.messageRecieved()
//		})
		
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
//			let cell = tableView.dequeueReusableCellWithIdentifier(DLMessageControllerIdentifier.DLOutgoingMessageBubbleIdentifier, forIndexPath: indexPath) as! DLOutgoingMessageBubble
//			
//			cell.textlabel.text = messages[indexPath.row].content
//			
//			return cell
			let cell = tableView.dequeueReusableCellWithIdentifier(DLMessageControllerIdentifier.DLOutgoingPhotoBubbleIdentifier, forIndexPath: indexPath) as! DLOutgoingPhotoBubble
			
//			cell.textlabel.text = messages[indexPath.row].content
			cell.contentImageView.image = UIImage(named: "ching.jpg")
//			cell.userImageView.image = UIImage(named: "ching.jpg")
			
			return cell
		}
	}
}

extension TestChatRoomViewController : DLMessagesViewControllerDelegate {
	func DLMessagesViewControllerDidClickedMessageButton(withReturnMessage message: String?) {
		print(message)
		if let message = message {
			colorgySocket.sendTextMessage(message, withUserId: userId)
		}
	}
	
	func openImagePicker() {
		if PHPhotoLibrary.authorizationStatus() == .Authorized {
			let imagePickerController = ImagePickerSheetController(mediaType: ImagePickerMediaType.Image)
			imagePickerController.addAction(ImagePickerAction(title: "取消", handler: { (action: ImagePickerAction) -> () in
				print("hihi")
			}))
			presentViewController(imagePickerController, animated: true, completion: nil)
		} else if PHPhotoLibrary.authorizationStatus() == .Denied {
			needPermission()
		} else if PHPhotoLibrary.authorizationStatus() == .NotDetermined {
			PHPhotoLibrary.requestAuthorization({ (status: PHAuthorizationStatus) -> Void in
				self.openImagePicker()
			})
		} else {
			needPermission()
		}
	}
	
	func needPermission() {
		let alert = UIAlertController(title: "需要存取照片權限", message: "如果要上傳照片，請至\"設定\">\"Colorgy\"的APP中打開存取照片的權限。", preferredStyle: UIAlertControllerStyle.Alert)
		let ok = UIAlertAction(title: "設定", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) -> Void in
			UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
			print(UIApplicationOpenSettingsURLString)
		})
		let cancel = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
		alert.addAction(ok)
		alert.addAction(cancel)
		presentViewController(alert, animated: true, completion: nil)
	}
	
	func DLMessagesViewControllerDidClickedCameraButton() {
		openImagePicker()
	}
}
