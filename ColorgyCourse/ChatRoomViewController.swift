//
//  ChatRoomViewController.swift
//  ColorgyCourse
//
//  Created by David on 2016/1/25.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit
import Photos
import AudioToolbox

class ChatRoomViewController: DLMessagesViewController {
	
	/// Will be initialize once only, when enter this controller
	/// This socket will save the connection state.
	private let colorgySocket = ColorgySocket()
	/// Can check if need to disconnect the socket or not
	private var shouldDisconnectSocket: Bool = true
	/// messages of this controller
	/// just append a new message to it if you recieved a new message
	private var messages: [ChatMessage] = [ChatMessage]()
	/// image cache
	private var imagesCache: [UIImage] = [UIImage]()
	/// Parameter to create a new Chatroom
	private var params: [String : NSObject]!
	
	/// **Need accesstoken to create chatroom**
	var accessToken: String!
	/// **Need chatroomId to create chatroom**
	var chatroomId: String!
	/// **Need userId to create chatroom**
	var userId: String!
	/// **Need uuid to create chatroom**
	var uuid: String!
	/// **Need history chatroom to check blur percentage
	var historyChatroom: HistoryChatroom!
	
	// You can track user's current chatrom by this property.
	private var chatroom: Chatroom?
	
	// Floating option view
	private let floatingOptionView = FloatingOptionView()
	private var dropDownButton: UIBarButtonItem!
	
	// for user profile image
	private var userProfileImage: UIImage? = UIImage()
	private var userProfileImageString: String = "" {
		didSet {
			if chatroom != nil {
				loadUserProfileImage(chatroom!.chatProgress)
			}
		}
	}
	private var yourFriend: ChatUserInformation?
	
	// request more data
	private var isRequestingForMoreData: Bool = false
	private var historyMessagesCount: Int = 0
	private let requestMoreMessageRefreshControl: UIRefreshControl = UIRefreshControl()
	
	private let newBackButton: UIBarButtonItem = UIBarButtonItem(title: "幹幹", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
	private var unreadMessages = 0
	var friendViewControllerReference: FriendListViewController?
	
	// MARK: Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		// the delegate here is from DLMessageView
		// set it to current class
		self.delegate = self
		
		configureFloatingOptionView()
		
		checkAndStartSocket()
		
		addRightNavButton()
		
		title = historyChatroom.name
		
		configureRefreshControl()
		
//		navigationController?.navigationBar.topItem?.backBarButtonItem = newBackButton
		if let vcs = navigationController?.viewControllers {
			if vcs.count > 1 {
				if let vc = vcs[1] as? FriendListViewController {
					print("yo looooo")
					friendViewControllerReference = vc
				}
			}
		}
	}
	
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		loadUserAbout()
		
		colorgySocket.connect()
		
		registerNotification()
	}
	
	override func viewDidDisappear(animated: Bool) {
		super.viewDidDisappear(animated)
		if shouldDisconnectSocket {
			colorgySocket.disconnect()
			friendViewControllerReference?.restoreBackButton()
		}
		
		unregisterNotification()
	}
	
	// MARK: sound and vibrate
	func vibrate() {
		AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
	}
	
	// MARK: notification
	func registerNotification() {
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "messageRecievedNotification", name: ColorgyNotification.didRecievedMessageNotification.rawValue, object: nil)
	}
	
	func unregisterNotification() {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}
	
	func messageRecievedNotification() {
		print("yo lo")
		unreadMessages += 1
		friendViewControllerReference?.updateBackButtonTitle("(\(unreadMessages))好朋友")
	}
	
	// MARK: yolo
	func configureRefreshControl() {
		requestMoreMessageRefreshControl.addTarget(self, action: "needsToRefresh:", forControlEvents: UIControlEvents.ValueChanged)
		requestMoreMessageRefreshControl.tintColor = ColorgyColor.MainOrange
		bubbleTableView.addSubview(requestMoreMessageRefreshControl)
	}
	
	func needsToRefresh(control: UIRefreshControl) {
		requestMoreData { () -> Void in
			control.endRefreshing()
		}
	}
	
	// load user about
	func loadUserAbout() {
		ColorgyChatAPI.getUser(historyChatroom.friendId, success: { (user) -> Void in
			print(user)
			self.yourFriend = user
			}, failure: { () -> Void in
				self.delay(1.0, complete: { () -> Void in
					self.loadUserAbout()
				})
		})
	}
	
	func delay(time: Double, complete: () -> Void) {
		let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * time))
		dispatch_after(delay, dispatch_get_main_queue(), { () -> Void in
			complete()
		})
	}
	
	// MARK: Configuration
	func addRightNavButton() {
		dropDownButton = UIBarButtonItem(image: UIImage(named: "chatDropDownIcon"), style: UIBarButtonItemStyle.Done, target: self, action: "toggleDropDownMenu")
		navigationItem.rightBarButtonItem = dropDownButton
	}
	
	func toggleDropDownMenu() {
		if floatingOptionView.isShown {
			// hide it
			floatingOptionView.isShown = false
			dropDownButton.image = UIImage(named: "chatDropDownIcon")
			UIView.animateWithDuration(0.25, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
				self.floatingOptionView.frame.origin.y -= self.floatingOptionView.frame.height
				}, completion: nil)
		} else {
			// show it
			floatingOptionView.isShown = true
			dropDownButton.image = UIImage(named: "chatPullUpIcon")
			UIView.animateWithDuration(0.25, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
				self.floatingOptionView.frame.origin.y += self.floatingOptionView.frame.height
				}, completion: nil)
		}
	}
	
	// MARK: Alerts
	func showChatReportController(title: String?, canSkip: Bool, type: String?) {
		
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let reportController = storyboard.instantiateViewControllerWithIdentifier("chat report") as! ChatReportViewController
		reportController.canSkipContent = canSkip
		reportController.titleOfReport = title
		reportController.reportType = type
		reportController.delegate = self
		let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * 1.0))
		dispatch_after(delay, dispatch_get_main_queue(), { () -> Void in
			self.presentViewController(reportController, animated: true, completion: nil)
		})
	}
	
	func showAlertWithTitle(title: String?, message: String?, confirmHandler: () -> Void) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
		let ok = UIAlertAction(title: "確定", style: UIAlertActionStyle.Destructive) { (action: UIAlertAction) -> Void in
			confirmHandler()
		}
		let cancel = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
		alert.addAction(cancel)
		alert.addAction(ok)
		dispatch_async(dispatch_get_main_queue()) { () -> Void in
			self.presentViewController(alert, animated: true, completion: nil)
		}
	}
	
	func showAlertWithErrorMessage(title: String?, message: String?) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
		let ok = UIAlertAction(title: "確定", style: UIAlertActionStyle.Default, handler: nil)
		alert.addAction(ok)
		dispatch_async(dispatch_get_main_queue()) { () -> Void in
			self.presentViewController(alert, animated: true, completion: nil)
		}
	}
	
	func showUpdateNickNameView() {
		let alert = UIAlertController(title: "幫他取名字", message: "此修改暱稱只有你看的到。", preferredStyle: UIAlertControllerStyle.Alert)
		alert.addTextFieldWithConfigurationHandler { (tf: UITextField) -> Void in
			tf.placeholder = "來個煞氣a名字‼️（最長8個字）"
		}
		let ok = UIAlertAction(title: "確定", style: UIAlertActionStyle.Default, handler: {(action) -> Void in
			if let name = alert.textFields?.first?.text {
				if name.characters.count > 8 {
					let errorAlert = UIAlertController(title: "哦！不行歐～", message: "名字長度最常只能是8個字歐！", preferredStyle: UIAlertControllerStyle.Alert)
					let ok = UIAlertAction(title: "好歐", style: UIAlertActionStyle.Default, handler: nil)
					errorAlert.addAction(ok)
					dispatch_async(dispatch_get_main_queue()) { () -> Void in
						self.presentViewController(errorAlert, animated: true, completion: nil)
					}
				} else {
					let errorAlert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.Alert)
					let ok = UIAlertAction(title: "好歐", style: UIAlertActionStyle.Default, handler: nil)
					errorAlert.addAction(ok)
					ColorgyChatAPI.checkUserAvailability({ (user) -> Void in
						ColorgyChatAPI.updateOthersNickName(user.userId, chatroomId: self.historyChatroom.chatroomId, nickname: name, success: { () -> Void in
							errorAlert.title = "成功！"
							errorAlert.message = "他的暱稱現在是\(name)！"
							self.title = name
							dispatch_async(dispatch_get_main_queue()) { () -> Void in
								self.presentViewController(errorAlert, animated: true, completion: nil)
							}
							}, failure: { () -> Void in
								errorAlert.title = "失敗！"
								errorAlert.message = "請檢查網路是否暢通～"
								dispatch_async(dispatch_get_main_queue()) { () -> Void in
									self.presentViewController(errorAlert, animated: true, completion: nil)
								}
						})
						}, failure: { () -> Void in
							errorAlert.title = "失敗！"
							errorAlert.message = "請檢查網路是否暢通～"
							dispatch_async(dispatch_get_main_queue()) { () -> Void in
								self.presentViewController(errorAlert, animated: true, completion: nil)
							}
					})
				}
			}
		})
		let cancel = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
		alert.addAction(ok)
		alert.addAction(cancel)
		dispatch_async(dispatch_get_main_queue()) { () -> Void in
			self.presentViewController(alert, animated: true, completion: nil)
		}
	}
	
	func loadUserProfileImage(percentage: Int) {

		let qos = Int(QOS_CLASS_USER_INTERACTIVE.rawValue)
		dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in
			
			// get image from cache
			let sc = SDImageCache()
			var imageFromCache = sc.imageFromDiskCacheForKey(self.userProfileImageString)
			
			if imageFromCache == nil  {
				// load image if its nil
				if self.userProfileImageString.isValidURLString {
					print(self.userProfileImageString)
					UIImageView().sd_setImageWithURL(self.userProfileImageString.url, completed: { (image: UIImage!, error: NSError!, cacheType: SDImageCacheType, url: NSURL!) -> Void in
						self.loadUserProfileImage(percentage)
					})
				}
			} else {
				let radius = (33 - CGFloat(percentage < 98 ? percentage : 98) % 33) / 33.0 * 4.0
				print(radius)
				let blurImage = UIImage.gaussianBlurImage(imageFromCache, radius: radius)
				dispatch_async(dispatch_get_main_queue(), { () -> Void in
					self.userProfileImage = blurImage
					self.bubbleTableView.reloadData()
				})
			}
		
		})
	}
	
	func openPhotoBrowserWithImage(image: UIImage) {
		var images = [SKPhoto]()
		let photo = SKPhoto.photoWithImage(UIImage(named: "1.jpg")!)// add some UIImage
		//    for img in imagesCache {
		//      images.append(SKPhoto.photoWithImage(img))
		//    }
		//    SKPhoto.photoWithImageURL("")
		//    images.append(photo)
		//    images.append(photo)
		//    images.append(photo)
		images.append(SKPhoto.photoWithImage(image))
		
		// create PhotoBrowser Instance, and present.
		let browser = SKPhotoBrowser(photos: images)
		browser.initializePageIndex(0)
		browser.delegate = self
		presentViewController(browser, animated: true, completion: {})
	}
	
	// MARK: Socket
	func checkAndStartSocket() {
		
		guard accessToken != nil else {
			print("fail to initialize chat room, no accesstoken")
			return
		}
		guard chatroomId != nil else {
			print("fail to initialize chat room, no chatroomId")
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
				"chatroomId": chatroomId,
				"userId": userId,
				"uuid": uuid
			],
			"url": "/chatroom/establish_connection"
		]
		
		print(self.params)
		
		// register for connect event
		colorgySocket.connectToServer(withParameters: params, registerToChatroom: { (chatroom) -> Void in
			self.chatroom = chatroom
			self.userProfileImageString = self.chatroom?.targetImage ?? ""
			print(self.chatroom)
			// TODO: handle not connect condition
			}, withMessages: { (messages) -> Void in
				print("message count \(messages.count)")
				for m in messages {
					self.messages.append(m)
					//        self.messageRecieved()
					self.messageRecievedButDontReload()
					// get percentage
					m.chatProgress = self.historyChatroom.chatProgress
				}
				self.recievingABunchMessages()
				// set count when connected
				self.historyMessagesCount = self.messages.count
		})
		
		// register for recieving message event
		colorgySocket.onRecievingMessage { (messages) -> Void in
			print(messages.count)
			for m in messages {
				self.messages.append(m)
				self.messageRecieved()
				print(m)
				print("訊息延遲....")
				print(m.createdAt.timeStampString())
				if let p = m.chatProgress {
					print("update progress \(p)")
					self.chatroom?.chatProgress = p
				}
				// vibrate
				if m.userId != self.userId {
					self.vibrate()
				}
			}
		}
		
		colorgySocket.onUpdateUserAvatar { (user1, user2) -> Void in
			let thisUser = (user1.id == self.userId ? user2 : user1)
			self.userProfileImageString = thisUser.imageId
		}
		
		colorgySocket.connect()
	}
	
	func configureFloatingOptionView() {
		let barHeight = (navigationController != nil ? navigationController!.navigationBar.frame.height : 0) + 20
		print(barHeight)
		floatingOptionView.frame.origin.y = barHeight - floatingOptionView.frame.height
		view.addSubview(floatingOptionView)
		floatingOptionView.delegate = self
	}
	
	func requestMoreData(complete: () -> Void) {
		if !isRequestingForMoreData && (chatroom != nil) {
			print("loading")
			isRequestingForMoreData = true
			
			// check content size
			print("bubbleTableView content size \(bubbleTableView.contentSize)\nbubbleTableView content bounds \(bubbleTableView.bounds)")
			if bubbleTableView.contentSize.height >= bubbleTableView.bounds.height {
				// check page
				ColorgyChatAPI.checkUserAvailability({ (user) -> Void in
					ColorgyChatAPI.moreMessage(user.userId, chatroom: self.chatroom!, historyMessagesCount: self.historyMessagesCount, success: { (messages) -> Void in
						self.historyMessagesCount += messages.count
						print(messages.count)
						for m in messages {
							self.messages.insert(m, atIndex: 0)
							self.recieveMessageAndInsertAtFront()
						}
						
						self.doneRequestingMessages()
						complete()
						}, failure: { () -> Void in
							self.doneRequestingMessages()
							complete()
					})
					}, failure: { () -> Void in
						self.doneRequestingMessages()
						complete()
				})
			} else {
				// height not ok
				complete()
			}
		} else {
			// can not fetch
			complete()
		}
	}
	
	func doneRequestingMessages() {
		isRequestingForMoreData = false
	}
	
	// MARK: - Scroll view delegate
	
	
	// MARK: - TableView Delegate and DataSource
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return messages.count
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		if messages[indexPath.row].userId != userId {
			// incoming
			if messages[indexPath.row].type == ChatMessage.MessageType.Text {
				let cell = tableView.dequeueReusableCellWithIdentifier(DLMessageControllerIdentifier.DLIncomingMessageBubbleIdentifier, forIndexPath: indexPath) as! DLIncomingMessageBubble
				
//				cell.userImageView.sd_setImageWithURL(userProfileImageString.url, placeholderImage: nil)
				cell.userImageView.image = userProfileImage
				cell.message = messages[indexPath.row]
				cell.delegate = self
				
				return cell
			} else if messages[indexPath.row].type == ChatMessage.MessageType.Image {
				let cell = tableView.dequeueReusableCellWithIdentifier(DLMessageControllerIdentifier.DLIncomingPhotoBubbleIdentifier, forIndexPath: indexPath) as! DLIncomingPhotoBubble
				
//				cell.userImageView.sd_setImageWithURL(userProfileImageString.url, placeholderImage: nil)
				cell.userImageView.image = userProfileImage
				cell.message = messages[indexPath.row]
				cell.delegate = self
				
				return cell
			} else if messages[indexPath.row].type == ChatMessage.MessageType.Sticker {
				let cell = tableView.dequeueReusableCellWithIdentifier(DLMessageControllerIdentifier.DLIncomingMessageBubbleIdentifier, forIndexPath: indexPath) as! DLIncomingMessageBubble
				
				cell.message = messages[indexPath.row]
				cell.delegate = self
				
				return cell
			} else {
				let cell = tableView.dequeueReusableCellWithIdentifier(DLMessageControllerIdentifier.DLIncomingMessageBubbleIdentifier, forIndexPath: indexPath) as! DLIncomingMessageBubble
				
				cell.message = messages[indexPath.row]
				cell.delegate = self
				
				return cell
			}
		} else {
			if messages[indexPath.row].type == ChatMessage.MessageType.Text {
				let cell = tableView.dequeueReusableCellWithIdentifier(DLMessageControllerIdentifier.DLOutgoingMessageBubbleIdentifier, forIndexPath: indexPath) as! DLOutgoingMessageBubble
				
				cell.message = messages[indexPath.row]
				
				return cell
			} else if messages[indexPath.row].type == ChatMessage.MessageType.Image {
				let cell = tableView.dequeueReusableCellWithIdentifier(DLMessageControllerIdentifier.DLOutgoingPhotoBubbleIdentifier, forIndexPath: indexPath) as! DLOutgoingPhotoBubble
				
				cell.message = messages[indexPath.row]
				cell.delegate = self
				
				return cell
			} else if messages[indexPath.row].type == ChatMessage.MessageType.Sticker {
				let cell = tableView.dequeueReusableCellWithIdentifier(DLMessageControllerIdentifier.DLOutgoingPhotoBubbleIdentifier, forIndexPath: indexPath) as! DLOutgoingPhotoBubble
				
				cell.message = messages[indexPath.row]
				
				return cell
			} else {
				let cell = tableView.dequeueReusableCellWithIdentifier(DLMessageControllerIdentifier.DLOutgoingPhotoBubbleIdentifier, forIndexPath: indexPath) as! DLOutgoingPhotoBubble
				
				cell.message = messages[indexPath.row]
				
				return cell
			}
		}
	}
	
	// MARK: - UIImagePickerController
	func openImagePicker() {
		if PHPhotoLibrary.authorizationStatus() == .Authorized {
			let imagePickerController = ImagePickerSheetController(mediaType: ImagePickerMediaType.Image)
			
			imagePickerController.addAction(ImagePickerAction(title: "照片圖庫", secondaryTitle: { NSString.localizedStringWithFormat(NSLocalizedString("你已經選了 %lu 張照片", comment: "Action Title"), $0) as String}, style: ImagePickerActionStyle.Default, handler: { (action: ImagePickerAction) -> () in
				print("go to photo library")
				self.shouldDisconnectSocket = false
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

// MARK: - DLMessagesViewControllerDelegate
extension ChatRoomViewController : DLMessagesViewControllerDelegate {
	func DLMessagesViewControllerDidClickedMessageButton(withReturnMessage message: String?) {
		print(message)
		if let message = message {
			colorgySocket.sendTextMessage(message, withUserId: userId)
		}
	}
	
	func DLMessagesViewControllerDidClickedCameraButton() {
		openImagePicker()
	}
	
	func DLMessagesViewControllerDidTapOnBubbleTableView() {
		if floatingOptionView.isShown {
			toggleDropDownMenu()
		}
	}
}

// MARK: - UIImagePickerControllerDelegate
extension ChatRoomViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
		shouldDisconnectSocket = true
		sendImage(image)
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	func imagePickerControllerDidCancel(picker: UIImagePickerController) {
		shouldDisconnectSocket = true
		dismissViewControllerAnimated(true, completion: nil)
	}
}

// MARK: - DLMessageDelegate
extension ChatRoomViewController : DLMessageDelegate {
	func DLMessage(didTapOnUserImageView image: UIImage?, message: ChatMessage) {
		print("did tap on user image \(image)")
		self.dismissKeyboard()
		let sc = SDImageCache()
		let _img = sc.imageFromDiskCacheForKey(userProfileImageString)
		// FIXME: user image view
		navigationController?.view?.addSubview(UserDetailInformationView(withBlurPercentage: message.chatProgress, withUserImage: _img, user: yourFriend))
	}
	
	func DLMessage(didTapOnSentImageView imageView: UIImageView?) {
		print("didTapOnSentImageView")
		if let image = imageView?.image {
			openPhotoBrowserWithImage(image)
		}
	}
}

// MARK: - SKPhotoBrowserDelegate
extension ChatRoomViewController : SKPhotoBrowserDelegate {
	func didShowPhotoAtIndex(index: Int) {
		print(index)
	}
}

extension ChatRoomViewController : FloatingOptionViewDelegate {
	func floatingOptionViewShouldLeaveChatroom() {
		print("floatingOptionViewShouldLeaveChatroom")
//		showChatReportController("檢舉用戶", canSkip: false, type: "report")
		showAlertWithTitle("你確定要離開他？", message: "不再收到對方訊息，聊天記錄也將消失。", confirmHandler: { () -> Void in
			ColorgyChatAPI.checkUserAvailability({ (user) -> Void in
				ColorgyChatAPI.leaveChatroom(user.userId, chatroomId: self.historyChatroom.chatroomId, success: { () -> Void in
					self.navigationController?.popViewControllerAnimated(true)
					}, failure: { () -> Void in
						print(self.historyChatroom)
						self.showAlertWithErrorMessage("錯誤", message: "請檢查網路是否暢通，然後再試一次！")
				})
				}, failure: { () -> Void in
					self.showAlertWithErrorMessage("錯誤", message: "請檢查網路是否暢通，然後再試一次！")
			})
		})
	}
	
	func floatingOptionViewShouldBlockUser() {
		print("floatingOptionViewShouldBlockUser")
		showAlertWithTitle("你確定要封鎖他？", message: "封鎖後再也遇不到對方，所有的聊天紀錄都將刪除。", confirmHandler: { () -> Void in
			self.showChatReportController("封鎖用戶", canSkip: true, type: "block")
		})
	}
	
	func floatingOptionViewShouldNameUser() {
		print("floatingOptionViewShouldNameUser")
		showUpdateNickNameView()
	}
}

extension ChatRoomViewController : ChatReportViewControllerDelegate {
	func chatReportViewController(didSubmitReportUserContent title: String?, description: String?, hi: Hello?) {
		// submit a request
		ColorgyChatAPI.checkUserAvailability({ (user) -> Void in
			ColorgyChatAPI.reportUser(user.userId, targetId: self.historyChatroom.friendId, type: title, reason: description, success: { () -> Void in
				// wait after callback
				self.navigationController?.popViewControllerAnimated(true)
				}, failure: { () -> Void in
					self.showAlertWithErrorMessage("錯誤", message: "請檢查網路是否暢通，然後再試一次！")
			})
			}) { () -> Void in
				self.showAlertWithErrorMessage("錯誤", message: "請檢查網路是否暢通，然後再試一次！")
		}
	}
	
	func chatReportViewController(didSubmitBlockUserContent title: String?, description: String?, hi: Hello?) {
		
		// submit a request
		ColorgyChatAPI.checkUserAvailability({ (user) -> Void in
			ColorgyChatAPI.reportUser(user.userId, targetId: self.historyChatroom.friendId, type: title, reason: description, success: { () -> Void in
				
				}, failure: { () -> Void in
					
			})
			ColorgyChatAPI.blockUser(user.userId, targetId: self.historyChatroom.friendId, success: { () -> Void in
				ColorgyChatAPI.leaveChatroom(user.userId, chatroomId: self.historyChatroom.chatroomId, success: { () -> Void in
					// wait after callback
					self.navigationController?.popViewControllerAnimated(true)
					}, failure: { () -> Void in
						self.showAlertWithErrorMessage("錯誤", message: "請檢查網路是否暢通，然後再試一次！出現此錯誤是已經封鎖使用者但是尚未離開聊天室，請回報BUG。")
				})
				}, failure: { () -> Void in
					self.showAlertWithErrorMessage("錯誤", message: "請檢查網路是否暢通，然後再試一次！")
			})
			}) { () -> Void in
				self.showAlertWithErrorMessage("錯誤", message: "請檢查網路是否暢通，然後再試一次！")
		}
	}
}