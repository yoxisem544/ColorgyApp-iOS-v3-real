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
	
	/// Will be initialize once only, when enter this controller
	/// This socket will save the connection state.
	private let colorgySocket = ColorgySocket()
	/// messages of this controller
	/// just append a new message to it if you recieved a new message
	private var messages = [ChatMessage]()
	/// Parameter to create a new Chatroom
	private var params: [String : NSObject]!
	
	/// **Need accesstoken to create chatroom**
	var accessToken: String!
	/// **Need friendId to create chatroom**
	var friendId: String!
	/// **Need userId to create chatroom**
	var userId: String!
	/// **Need uuid to create chatroom**
	var uuid: String!
	
	// You can track user's current chatrom by this property.
	private var chatroom: Chatroom?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		// the delegate here is from DLMessageView
		// set it to current class
		self.delegate = self
		
		checkAndStartSocket()
    }
	
	func checkAndStartSocket() {
		
		guard accessToken != nil else {
			print("fail to initialize chat room, no accesstoken")
			return
		}
		guard friendId != nil else {
			print("fail to initialize chat room, no friendId")
			return
		}
		guard userId != nil else {
			print("fail to initialize chat room, no userId")
			return
		}
		guard uuid != nil else {
			print("fail to initialize chat room, no uuid")
			return
		}
		
		// configure parameters
		params = [
			"method": "post",
			"headers": [],
			"data": [
				"accessToken": accessToken,
				"friendId": friendId,
				"userId": userId,
				"uuid": uuid
			],
			"url": "/chatroom/establish_connection"
		]
		
		print(self.params)
		
		// register for connect event
		colorgySocket.connectToServer(withParameters: params, registerToChatroom: { (chatroom) -> Void in
			self.chatroom = chatroom
			print(self.chatroom)
			// TODO: handle not connect condition
			}, withMessages: { (messages) -> Void in
				print(messages)
				for m in messages {
					self.messages.append(m)
					//				self.messageRecieved()
					self.messageRecievedButDontReload()
				}
				self.recievingABunchMessages()
		})
		
		// register for recieving message event
		colorgySocket.onRecievingMessage { (messages) -> Void in
			print(messages.count)
			for m in messages {
				self.messages.append(m)
				self.messageRecieved()
			}
		}
		
		//		colorgySocket.connect()
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)

	}
	
	override func viewDidDisappear(animated: Bool) {
		super.viewDidDisappear(animated)
	}
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return messages.count
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		if messages[indexPath.row].userId != userId {
			// incoming
			if messages[indexPath.row].type == "text" {
				let cell = tableView.dequeueReusableCellWithIdentifier(DLMessageControllerIdentifier.DLIncomingMessageBubbleIdentifier, forIndexPath: indexPath) as! DLIncomingMessageBubble
				
				cell.textlabel.text = messages[indexPath.row].content
				cell.userImageView.image = UIImage(named: "ching.jpg")
				cell.delegate = self
				
				return cell
			} else if messages[indexPath.row].type == "image" {
				let cell = tableView.dequeueReusableCellWithIdentifier(DLMessageControllerIdentifier.DLIncomingPhotoBubbleIdentifier, forIndexPath: indexPath) as! DLIncomingPhotoBubble
				
				if messages[indexPath.row].content.isValidURLString {
					cell.contentImageView.sd_setImageWithURL(NSURL(string: messages[indexPath.row].content)!, placeholderImage: nil)
				}
				cell.userImageView.image = UIImage(named: "ching.jpg")
				cell.delegate = self
				
				return cell
			} else if messages[indexPath.row].type == "sticker" {
				let cell = tableView.dequeueReusableCellWithIdentifier(DLMessageControllerIdentifier.DLIncomingMessageBubbleIdentifier, forIndexPath: indexPath) as! DLIncomingMessageBubble
				cell.delegate = self
				return cell
			} else {
				print(messages[indexPath.row].type)
				print(messages)
				let cell = tableView.dequeueReusableCellWithIdentifier(DLMessageControllerIdentifier.DLIncomingMessageBubbleIdentifier, forIndexPath: indexPath) as! DLIncomingMessageBubble
				cell.delegate = self
				return cell
			}
		} else {
			if messages[indexPath.row].type == "text" {
				let cell = tableView.dequeueReusableCellWithIdentifier(DLMessageControllerIdentifier.DLOutgoingMessageBubbleIdentifier, forIndexPath: indexPath) as! DLOutgoingMessageBubble
				
				cell.textlabel.text = messages[indexPath.row].content
				
				return cell
			} else if messages[indexPath.row].type == "image" {
				let cell = tableView.dequeueReusableCellWithIdentifier(DLMessageControllerIdentifier.DLOutgoingPhotoBubbleIdentifier, forIndexPath: indexPath) as! DLOutgoingPhotoBubble

				if messages[indexPath.row].content.isValidURLString {
					cell.contentImageView.sd_setImageWithURL(NSURL(string: messages[indexPath.row].content)!, placeholderImage: nil)
				}
				
				return cell
			} else if messages[indexPath.row].type == "sticker" {
				let cell = tableView.dequeueReusableCellWithIdentifier(DLMessageControllerIdentifier.DLOutgoingPhotoBubbleIdentifier, forIndexPath: indexPath) as! DLOutgoingPhotoBubble
				
				return cell
			} else {
				print(messages[indexPath.row].type)
				print(messages)
				let cell = tableView.dequeueReusableCellWithIdentifier(DLMessageControllerIdentifier.DLOutgoingPhotoBubbleIdentifier, forIndexPath: indexPath) as! DLOutgoingPhotoBubble
				
				return cell
			}
		}
	}
	
	func openImagePicker() {
		if PHPhotoLibrary.authorizationStatus() == .Authorized {
			let imagePickerController = ImagePickerSheetController(mediaType: ImagePickerMediaType.Image)
			
			imagePickerController.addAction(ImagePickerAction(title: "照片圖庫", secondaryTitle: { NSString.localizedStringWithFormat(NSLocalizedString("你已經選了 %lu 張照片", comment: "Action Title"), $0) as String}, style: ImagePickerActionStyle.Default, handler: { (action: ImagePickerAction) -> () in
				print("go to photo library")
				self.dismissKeyboard()
				let controller = UIImagePickerController()
				controller.delegate = self
				controller.sourceType = .PhotoLibrary
				self.presentViewController(controller, animated: true, completion: nil)
				}, secondaryHandler: { (action: ImagePickerAction, counts: Int) -> () in
					print(imagePickerController.selectedImageAssets.count)
					for asset in imagePickerController.selectedImageAssets {
						
						let options = PHImageRequestOptions()
						options.deliveryMode = .FastFormat
							
						PHImageManager.defaultManager().requestImageDataForAsset(asset, options: options, resultHandler: { (data: NSData?, string: String?, orientation: UIImageOrientation, info: [NSObject : AnyObject]?) -> Void in
							print(string)
							print(orientation)
							if let data = data {
								if let image = UIImage(data: data) {
									self.sendImage(image)
								}
							}
						})
					}
			}))
			
			imagePickerController.addAction(ImagePickerAction(title: "取消", handler: { (action: ImagePickerAction) -> () in
				print("hihi")
			}))
			
			presentViewController(imagePickerController, animated: true, completion: nil)
		} else if PHPhotoLibrary.authorizationStatus() == .Denied {
			needPermission()
		} else if PHPhotoLibrary.authorizationStatus() == .NotDetermined {
			PHPhotoLibrary.requestAuthorization({ (status: PHAuthorizationStatus) -> Void in
				let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * 1.0))
                dispatch_after(delay, dispatch_get_main_queue(), { () -> Void in
                    self.openImagePicker()
                })
			})
		} else {
			needPermission()
		}
	}
	
	func sendImage(image: UIImage) {
		ColorgyChatAPI.uploadImage(image, success: { (result) -> Void in
			print(result)
			self.colorgySocket.sendPhotoMessage(result, withUserId: self.userId)
			}) { () -> Void in
				print("fail to upload image")
		}
	}
	
	func needPermission() {
		let alert = UIAlertController(title: "需要存取照片權限", message: "如果要上傳照片，請至\"設定\">\"Colorgy\"的APP中打開存取照片的權限。", preferredStyle: UIAlertControllerStyle.Alert)
		let ok = UIAlertAction(title: "前往設定", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) -> Void in
			UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
			print(UIApplicationOpenSettingsURLString)
		})
		let cancel = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
		alert.addAction(ok)
		alert.addAction(cancel)
		presentViewController(alert, animated: true, completion: nil)
	}
}

extension TestChatRoomViewController : DLMessagesViewControllerDelegate {
	func DLMessagesViewControllerDidClickedMessageButton(withReturnMessage message: String?) {
		print(message)
		if let message = message {
			colorgySocket.sendTextMessage(message, withUserId: userId)
		}
		if let m = ChatMessage.fakeData() {
			self.messages.append(m)
			self.messageRecieved()
		}
	}
	
	func DLMessagesViewControllerDidClickedCameraButton() {
		openImagePicker()
	}
}

extension TestChatRoomViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
		dismissViewControllerAnimated(true, completion: nil)
		sendImage(image)
	}
}

extension TestChatRoomViewController : DLIncomingMessageDelegate {
	func DLIncomingMessageDidTapOnUserImageView(image: UIImage?) {
		if let image = image {
			print("did tap on user image \(image)")
			self.dismissKeyboard()
			navigationController?.view?.addSubview(UserDetailInformationView(withBlurPercentage: 0.59, withUserImage: image))
		}
	}
}