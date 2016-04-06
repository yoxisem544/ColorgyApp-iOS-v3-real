//
//  FriendListViewController.swift
//  ColorgyCourse
//
//  Created by David on 2016/2/2.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

class FriendListViewController: UIViewController {

	@IBOutlet weak var friendListTableView: UITableView!
	var historyChatrooms: [HistoryChatroom] = []
	var userId: String = ""
	let refreshContorl = UIRefreshControl()
	
	var currentPage = 0
	
	private var renewTimer: NSTimer!
	
	private var isListReloading: Bool = false
	
	private let failToLoadDataHintView = FailToLoadDataHintView(errorTitle: "⚠️ 資料下載錯誤...點擊重新下載...")
	private let noDataHintView = FailToLoadDataHintView(errorTitle: "哦！看起來你還沒有成功配對的聊天室喔！")
	
	private var hiList: [Hello] = []
	
//	private let newBackButton: UIBarButtonItem = UIBarButtonItem(title: "幹幹", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
	
	// MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		friendListTableView.delegate = self
		friendListTableView.dataSource = self
		friendListTableView.estimatedRowHeight = 120
		friendListTableView.rowHeight = UITableViewAutomaticDimension
		friendListTableView.separatorStyle = .None
		friendListTableView.backgroundColor = ColorgyColor.BackgroundColor
		
		refreshContorl.addTarget(self, action: #selector(pullToRefreshHi), forControlEvents: UIControlEvents.ValueChanged)
		refreshContorl.tintColor = ColorgyColor.MainOrange
		friendListTableView.addSubview(refreshContorl)
		friendListTableView.sendSubviewToBack(refreshContorl)
		
		view.addSubview(failToLoadDataHintView)
		failToLoadDataHintView.hidden = true
		failToLoadDataHintView.alpha = 0.1
		failToLoadDataHintView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(failToLoadDataHintViewDidTap)))
		
		view.addSubview(noDataHintView)
		noDataHintView.hidden = true
		
		title = "好朋友"
//		navigationController?.navigationBar.topItem?.backBarButtonItem = newBackButton
//		print(navigationController?.navigationBar.topItem?.backBarButtonItem)
    }
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		checkRefreshToken()
		
		loadFriend()
		renewChatroom(every: 16.0)
	}
	
	func checkRefreshToken() {
		// refresh token
		ColorgyAPI.me({ (result) -> Void in
			// no need to refresh
			}) { () -> Void in
				// fail to get me, need to refresh
				ColorgyAPITrafficControlCenter.refreshAccessToken({ (loginResult) -> Void in
					self.hideHintFailView()
					self.loadFriend()
					}, failure: { () -> Void in
						
				})
		}
	}
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		hidesBottomBarWhenPushed = false
	}
	
	override func viewDidDisappear(animated: Bool) {
		super.viewDidDisappear(animated)
		renewTimer.invalidate()
	}
	
	// MARK: update back button title 
	func updateBackButtonTitle(title: String) {
		let newBackButton = UIBarButtonItem(title: title, style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
		navigationItem.backBarButtonItem = newBackButton
		print(navigationItem)
	}
	
	func restoreBackButton() {
		navigationItem.backBarButtonItem = nil
	}
	
	// MARK: about failToLoadDataHintView
	func failToLoadDataHintViewDidTap() {
		hideHintFailView()
		refreshChatroom()
	}
	
	// MARK: hint view
	func hideHintFailView() {
		UIView.animateWithDuration(0.3, animations: { () -> Void in
			self.failToLoadDataHintView.alpha = 0.1
			}) { (finished: Bool) -> Void in
				if finished {
					self.failToLoadDataHintView.hidden = true
				}
		}
	}
	
	func showHintFailView() {
		print("showHintFailView")
		self.failToLoadDataHintView.hidden = false
		UIView.animateWithDuration(0.3, animations: { () -> Void in
			self.failToLoadDataHintView.alpha = 1.0
			})
	}
	
	func hideNoRoomView() {
		UIView.animateWithDuration(0.3, animations: { () -> Void in
			self.noDataHintView.alpha = 0.1
			}) { (finished: Bool) -> Void in
				if finished {
					self.noDataHintView.hidden = true
				}
		}
	}
	
	func showNoRoomView() {
		self.noDataHintView.hidden = false
		UIView.animateWithDuration(0.3, animations: { () -> Void in
			self.noDataHintView.alpha = 1.0
		})
	}
	
	// MARK: Refresh
	func renewChatroom(every second: NSTimeInterval) {
		renewTimer = NSTimer(timeInterval: second, target: self, selector: #selector(refreshChatroom), userInfo: nil, repeats: true)
		renewTimer.fire()
		NSRunLoop.currentRunLoop().addTimer(renewTimer, forMode: NSRunLoopCommonModes)
	}
	
	func loadHi() {
		ColorgyChatAPI.checkUserAvailability({ (user) -> Void in
			ColorgyChatAPI.getHiList(user.userId, success: { (hiList) -> Void in
//				print(hiList)
				self.hideHintFailView()
				self.hiList = hiList
				self.friendListTableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.None)
				}, failure: { () -> Void in
					self.showHintFailView()
			})
			}, failure: { () -> Void in
				self.showHintFailView()
		})
	}
	
	func refreshChatroom() {
		loadFriend()
		loadHi()
	}
	
	func loadFriend() {
		ColorgyChatAPI.checkUserAvailability({ (user) -> Void in
			// get userId
			self.userId = user.userId
			print(self.userId)
			print("自己的id")
			ColorgyChatAPI.getHistoryTarget(user.userId, gender: Gender.Unspecified, page: 0, success: { (targets) -> Void in
//				print(targets)
				print("房間數 \(targets.count)")
//				self.removeChatroom(targets)
				self.hideHintFailView()
				self.reloadFriendListV3(targets)
				if targets.count == 0 {
					// need to show hint
					self.showNoRoomView()
				} else {
					self.hideNoRoomView()
				}
				}, failure: { () -> Void in
					self.showHintFailView()
					self.hideNoRoomView()
			})
			}, failure: { () -> Void in
				self.showHintFailView()
				self.hideNoRoomView()
		})
	}
	
	func removeChatroom(rooms: [HistoryChatroom]) {
		for room in rooms {
			ColorgyChatAPI.checkUserAvailability({ (user) -> Void in
				ColorgyChatAPI.removeChatroom(user.userId, chatroomId: room.chatroomId, success: { () -> Void in
					
					}, failure: { () -> Void in
					
				})
				}, failure: { () -> Void in
					
			})
		}
	}
	
	func pullToRefreshHi(refresh: UIRefreshControl) {
		ColorgyChatAPI.checkUserAvailability({ (user) -> Void in
			self.userId = user.userId
			ColorgyChatAPI.getHistoryTarget(user.userId, gender: Gender.Unspecified, page: 0, success: { (targets) -> Void in
				self.hideHintFailView()
				if targets.count == 0 {
					// need to show hint
					self.showNoRoomView()
				} else {
					self.hideNoRoomView()
				}
				self.reloadFriendListV3(targets)
				refresh.endRefreshing()
				}, failure: { () -> Void in
					refresh.endRefreshing()
					self.showHintFailView()
					self.hideNoRoomView()
			})
		}, failure: { () -> Void in
			refresh.endRefreshing()
			self.showHintFailView()
			self.hideNoRoomView()
		})
	}
	
	func reloadFriendListV3(list: [HistoryChatroom]) {
		didReceiveNewMessage(list)
		historyChatrooms = list.sort({ (r1: HistoryChatroom, r2: HistoryChatroom) -> Bool in
			return r1.lastContentTime.timeIntervalSince1970() > r2.lastContentTime.timeIntervalSince1970()
		})
		friendListTableView.reloadData()
	}
	
	func didReceiveNewMessage(list: [HistoryChatroom]) {
		for (index, list) : (Int, HistoryChatroom) in list.enumerate() {
			for (index, historyChatroom) : (Int, HistoryChatroom) in historyChatrooms.enumerate() {
				if historyChatroom.chatroomId == list.chatroomId {
					// check room id
					if historyChatroom.lastContent != list.lastContent {
						return
					}
				}
			}
		}
	}
	
	func delay(time: Double, complete: () -> Void) {
		let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * time))
		dispatch_after(delay, dispatch_get_main_queue(), { () -> Void in
			complete()
		})
	}
	
	func reloadFriendListV2(list: [HistoryChatroom]) {
		if !isListReloading {
			// 開始更新
			isListReloading = true
			// 開執行序
			let qos = Int(QOS_CLASS_USER_INTERACTIVE.rawValue)
            dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in
				let sortedList = list.sort { (r1: HistoryChatroom, r2: HistoryChatroom) -> Bool in
					// 越新的秒數越多，所以應該由大到小排列才會是從新到舊
					return r1.lastContentTime.timeIntervalSince1970() > r2.lastContentTime.timeIntervalSince1970()
				}
				if !self.doesRooms(sortedList, equalsTo: self.historyChatrooms) {
					//		更新邏輯 ->
					//		看new list 有沒有old沒有的，加入
					for room in sortedList {
						// 跟舊的比較
						if !self.doesContainsRoom(room, inRooms: self.historyChatrooms).doesContain {
							// 如果沒有，就加入
							dispatch_async(dispatch_get_main_queue(), { () -> Void in
								self.friendListTableView.beginUpdates()
								self.historyChatrooms.append(room)
								let rows = self.friendListTableView.numberOfRowsInSection(1)
								self.friendListTableView.insertRowsAtIndexPaths([NSIndexPath(forRow: rows, inSection: 1)], withRowAnimation: UITableViewRowAnimation.Fade)
								self.friendListTableView.endUpdates()
							})
							NSThread.sleepForTimeInterval(0.01)
						}
					}
					//		看old有沒有多餘的，刪除
					// 檢查多餘的，把他去除
					for room in self.historyChatrooms {
						if !self.doesContainsRoom(room, inRooms: sortedList).doesContain {
							// 新的表中，沒有舊的的話，移除
							if let index = self.historyChatrooms.indexOf(room) {
								dispatch_async(dispatch_get_main_queue(), { () -> Void in
									self.friendListTableView.beginUpdates()
									self.historyChatrooms.removeAtIndex(index)
									dispatch_async(dispatch_get_main_queue(), { () -> Void in
									self.friendListTableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 1)], withRowAnimation: UITableViewRowAnimation.Fade)
										self.friendListTableView.endUpdates()
									})
								})
							}
							NSThread.sleepForTimeInterval(0.01)
						}
					}
					// 更新內容
					self.updateRooms(withNewRooms: sortedList)
					//		檢查長度，兩者應該要一樣
					if sortedList.count == self.historyChatrooms.count {
						//		一樣->
						//		開始移動
						// 先檢查id是否有衝突
						if self.doesRoomsHaveDifferentRooms(sortedList, otherRooms: self.historyChatrooms) {
							// 如果一樣，則開始比較兩個list的chatroomId是不是完全一樣
							while !self.doesRooms(sortedList, equalsTo: self.historyChatrooms) {
								for (index, oldRoom) : (Int, HistoryChatroom) in self.historyChatrooms.enumerate() {
									// 找出新的index
									if let newIndex = self.doesContainsRoom(oldRoom, inRooms: sortedList).atIndex {
										// get new index, check if its the same
										// 如果新的跟舊的不一樣，表示需要移動
										if index != newIndex {
											//								dispatch_async(dispatch_get_main_queue(), { () -> Void in
											print("need to move")
											print("\(index) need to move to \(newIndex)")
											dispatch_async(dispatch_get_main_queue(), { () -> Void in
												self.historyChatrooms.removeAtIndex(index)
												self.friendListTableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 1)], withRowAnimation: UITableViewRowAnimation.Fade)
												self.historyChatrooms.insert(oldRoom, atIndex: newIndex)
												self.friendListTableView.insertRowsAtIndexPaths([NSIndexPath(forRow: newIndex, inSection: 1)], withRowAnimation: UITableViewRowAnimation.Fade)
											})
											//								})
											// 移動後重新開始
											NSThread.sleepForTimeInterval(0.01)
											break
										}
									}
								}
							}
						} else {
							// TODO: id 有衝突怎麼辦？
						}
						
					} else {
						//		重新下載，或者取消，不要遞回
					}
				} else {
					// update content
					self.updateRooms(withNewRooms: sortedList)
				}
				// 完畢之後
				dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.isListReloading = false
                })
            })
		}
	}
	
	func doesRoomsHaveDifferentRooms(rooms: [HistoryChatroom], otherRooms: [HistoryChatroom]) -> Bool {
		if rooms.count != otherRooms.count {
			return false
		} else {
			// same length
			var isTheSame = true
			for room in rooms {
				if !doesContainsRoom(room, inRooms: otherRooms).doesContain {
					isTheSame = false
				}
			}
			return isTheSame
		}
	}
	
	func trimRooms(withNewRooms newRooms: [HistoryChatroom]) {
		for room in historyChatrooms {
			if doesContainsRoom(room, inRooms: newRooms).doesContain {
				// 新的表中，沒有舊的的話，移除
				if let index = historyChatrooms.indexOf(room) {
					historyChatrooms.removeAtIndex(index)
				}
			}
		}
	}
	
	func updateRooms(withNewRooms newRooms: [HistoryChatroom]) {
		for (index, oldRoom) : (Int, HistoryChatroom) in historyChatrooms.enumerate() {
			for newRoom in newRooms {
				if oldRoom.chatroomId == newRoom.chatroomId {
					// update content
					historyChatrooms[index] = newRoom
					if newRoom.lastContent != oldRoom.lastContent {
						historyChatrooms[index].unread = true
					}
					dispatch_async(dispatch_get_main_queue(), { () -> Void in
						self.friendListTableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 1)], withRowAnimation: UITableViewRowAnimation.None)
					})

				}
			}
		}
	}
	
	func doesContainsRoom(room: HistoryChatroom, inRooms rooms: [HistoryChatroom]) -> (doesContain: Bool, atIndex: Int?) {
		
		for (index, roomToMatch) : (Int, HistoryChatroom) in rooms.enumerate() {
			if roomToMatch.chatroomId == room.chatroomId {
				return (true, index)
			}
		}
		
		return (false, nil)
	}
	
	func doesRooms(rooms: [HistoryChatroom], equalsTo anotherRooms: [HistoryChatroom]) -> Bool {
		
		var isEqual = true
		
		if rooms.count != anotherRooms.count {
			isEqual = false
		} else {
			// if length is equal, check chatroom id
			for (index, room) : (Int, HistoryChatroom) in rooms.enumerate() {
				if room.chatroomId != anotherRooms[index].chatroomId {
					isEqual = false
				}
			}
		}
		
		return isEqual
	}
	
	// MARK: Storyboard
	struct Storyboard {
		static let FriendListCellIdentifier = "Friend List Cell"
		static let GotoChatroomSegueIdentifier = "goto chatroom"
		static let SayHelloCellIdentifier = "hello counts cell"
		static let SayHelloSegue = "to say hi segue"
	}
	
	// MARK: Navigation
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == Storyboard.GotoChatroomSegueIdentifier {
			let vc = segue.destinationViewController as! ChatRoomViewController
			vc.friendViewControllerReference = self
			if let historyChatroom = sender as? HistoryChatroom {
				vc.userId = userId
				vc.chatroomId = historyChatroom.chatroomId
				vc.historyChatroom = historyChatroom
				if let accessToken = UserSetting.UserAccessToken() {
					vc.accessToken = accessToken
				} else {
					print("enter chatroom without accesstoken")
				}
				if let uuid = UserSetting.UserUUID() {
					vc.uuid = uuid
				} else {
					print("enter chatroom without uuid")
				}
			}
		} else if segue.identifier == Storyboard.SayHelloSegue {
			let vc = segue.destinationViewController as! SayHelloViewController
			vc.hiList = hiList
		}
	}
}

// MARK: - Table View Delegate and DataSource
extension FriendListViewController : UITableViewDataSource, UITableViewDelegate {
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 2
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 0 {
			return 1
		} else {
			return historyChatrooms.count
		}
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		if indexPath.section == 0 {
			let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.SayHelloCellIdentifier, forIndexPath: indexPath) as! SayHelloCountsCell
			
			cell.countsLabel.text = "\(hiList.count)"
			
			return cell
		} else {
			let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.FriendListCellIdentifier, forIndexPath: indexPath) as! FriendListTableViewCell
			
			cell.userId = userId
			cell.historyChatroom = historyChatrooms[indexPath.row]
			
			return cell
		}
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if indexPath.section == 0 {
			// goto say hello list
			performSegueWithIdentifier(Storyboard.SayHelloSegue, sender: nil)
		} else {
			hidesBottomBarWhenPushed = true
			performSegueWithIdentifier(Storyboard.GotoChatroomSegueIdentifier, sender: historyChatrooms[indexPath.row])
		}
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		if indexPath.section == 0 {
			return 51
		} else {
			return 82
		}
	}
}

// MARK: - ScorllViewDelegate
extension FriendListViewController : UIScrollViewDelegate {
	func scrollViewDidScroll(scrollView: UIScrollView) {
		if scrollView == friendListTableView {
			if (scrollView.contentOffset.y + scrollView.frame.height) >= scrollView.contentSize.height {
//				print("scrolling at the end of scrollView")
			}
		}
	}
	
	func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
		if scrollView == friendListTableView {
			print("scrollViewWillBeginDecelerating")
			if (scrollView.contentOffset.y + scrollView.frame.height) >= scrollView.contentSize.height {
				print("need more data, loading page \(currentPage + 1)")
			}
		}
	}
}