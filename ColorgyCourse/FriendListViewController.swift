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
		
		refreshContorl.addTarget(self, action: "pullToRefreshHi:", forControlEvents: UIControlEvents.ValueChanged)
		refreshContorl.tintColor = ColorgyColor.MainOrange
		friendListTableView.addSubview(refreshContorl)
    }
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
//		loadFriend()
		renewChatroom(every: 18.0)
	}
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		hidesBottomBarWhenPushed = false
		renewTimer.invalidate()
	}
	
	// MARK: Refresh
	func renewChatroom(every second: NSTimeInterval) {
		renewTimer = NSTimer(timeInterval: second, target: self, selector: "refreshChatroom", userInfo: nil, repeats: true)
		renewTimer.fire()
		NSRunLoop.currentRunLoop().addTimer(renewTimer, forMode: NSRunLoopCommonModes)
	}
	
	func refreshChatroom() {
		loadFriend()
	}
	
	func loadFriend() {
		ColorgyChatAPI.checkUserAvailability({ (user) -> Void in
			// get userId
			self.userId = user.userId
			print(self.userId)
			print("自己的id")
			ColorgyChatAPI.getHistoryTarget(user.userId, gender: Gender.Unspecified, page: 0, success: { (targets) -> Void in
				print("房間數 \(targets.count)")
				self.reloadFriendList(targets)
				}, failure: { () -> Void in
					
			})
			}, failure: { () -> Void in
				
		})
	}
	
	func pullToRefreshHi(refresh: UIRefreshControl) {
		ColorgyChatAPI.checkUserAvailability({ (user) -> Void in
			self.userId = user.userId
			ColorgyChatAPI.getHistoryTarget(user.userId, gender: Gender.Unspecified, page: 0, success: { (targets) -> Void in
				self.reloadFriendList(targets)
				refresh.endRefreshing()
				}, failure: { () -> Void in
					refresh.endRefreshing()
			})
		}, failure: { () -> Void in
			refresh.endRefreshing()
		})
	}
	
	func reloadFriendList(list: [HistoryChatroom]) {
		let qos = Int(QOS_CLASS_USER_INTERACTIVE.rawValue)
		dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in
			var mappedOldList = list
			print("not sorted")
			for l in list {
				print(l.name)
				print(l.lastContentTime.timeStampString())
			}
			print("sorted")
			let sortedList = list.sort { (r1: HistoryChatroom, r2: HistoryChatroom) -> Bool in
				print("time of r1 \(r1.lastContentTime.timeIntervalSince1970())")
				print("time of r2 \(r2.lastContentTime.timeIntervalSince1970())")
				// 越新的秒數越多，所以應該由大到小排列才會是從新到舊
				return r1.lastContentTime.timeIntervalSince1970() > r2.lastContentTime.timeIntervalSince1970()
			}
			for l in sortedList {
				print(l.name)
				print(l.lastContentTime.timeStampString())
			}
			// check the count of two arrays
			if self.doesRooms(sortedList, equalsTo: self.historyChatrooms) {
				print("sortedList")
				print(sortedList)
				print("self.historyChatrooms")
				print(self.historyChatrooms)
			}
			if self.historyChatrooms.count != sortedList.count {
				for room in sortedList {
					if !self.doesContainsRoom(room, inRooms: self.historyChatrooms).doesContain {
						dispatch_async(dispatch_get_main_queue(), { () -> Void in
							self.historyChatrooms.append(room)
							let rows = self.friendListTableView.numberOfRowsInSection(0)
							self.friendListTableView.insertRowsAtIndexPaths([NSIndexPath(forRow: rows, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Fade)
						})
					}
					//        if !self.historyChatrooms.contains(room) {
					//          self.historyChatrooms.append(room)
					//          let rows = friendListTableView.numberOfRowsInSection(0)
					//          friendListTableView.insertRowsAtIndexPaths([NSIndexPath(forRow: rows, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Fade)
					//        }
				}
			}
			if self.historyChatrooms.count != sortedList.count {
				print("still not same length")
				// sort the current one
				self.reloadFriendList(self.historyChatrooms)
			} else {
				print("number of rows \(self.friendListTableView.numberOfRowsInSection(0))")
				if sortedList != self.historyChatrooms {
					print("sortedList")
					print(sortedList)
					print("self.historyChatrooms")
					print(self.historyChatrooms)
				}
				while !self.doesRooms(sortedList, equalsTo: self.historyChatrooms) {
					for (index, oldRoom) : (Int, HistoryChatroom) in self.historyChatrooms.enumerate() {
						if let newIndex = self.doesContainsRoom(oldRoom, inRooms: sortedList).atIndex {
							// get new index, check if its the same
							if index != newIndex {
								dispatch_async(dispatch_get_main_queue(), { () -> Void in
									print("need to move")
									print("\(index) need to move to \(newIndex)")
									self.historyChatrooms.removeAtIndex(index)
									self.friendListTableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Fade)
									self.historyChatrooms.insert(oldRoom, atIndex: newIndex)
									self.friendListTableView.insertRowsAtIndexPaths([NSIndexPath(forRow: newIndex, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Fade)
								})
								break
							}
						}
					}
				}
				//    while sortedList != self.historyChatrooms {
				//      for (index, oldRoom) : (Int, HistoryChatroom) in self.historyChatrooms.enumerate() {
				//        if let newIndex = doesContainsRoom(oldRoom, inRooms: sortedList).atIndex {
				//          // get new index, check if its the same
				//          if index != newIndex {
				//            print("need to move")
				//            print("\(index) need to move to \(newIndex)")
				//            self.historyChatrooms.removeAtIndex(index)
				//            friendListTableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Fade)
				//            self.historyChatrooms.insert(oldRoom, atIndex: newIndex)
				//            friendListTableView.insertRowsAtIndexPaths([NSIndexPath(forRow: newIndex, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Fade)
				//            break
				//          }
				//        }
				//      }
				//      for (index, oldRoom) : (Int, HistoryChatroom) in self.historyChatrooms.enumerate() {
				//        if let newIndex = sortedList.indexOf(oldRoom) {
				//          // get new index, check if its the same
				//          if index != newIndex {
				//            print("need to move")
				//            print("\(index) need to move to \(newIndex)")
				//            self.historyChatrooms.removeAtIndex(index)
				//            friendListTableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Fade)
				//            self.historyChatrooms.insert(oldRoom, atIndex: newIndex)
				//            friendListTableView.insertRowsAtIndexPaths([NSIndexPath(forRow: newIndex, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Fade)
				//            break
				//          }
				//        }
				//      }
				//    }
			}
			dispatch_async(dispatch_get_main_queue(), { () -> Void in
				self.historyChatrooms = sortedList
				self.friendListTableView.reloadData()
			})
		})
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
	}
	
	// MARK: Navigation
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == Storyboard.GotoChatroomSegueIdentifier {
			let vc = segue.destinationViewController as! ChatRoomViewController
			if let historyChatroom = sender as? HistoryChatroom {
				vc.userId = userId
				vc.friendId = historyChatroom.friendId
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
		}
	}
}

// MARK: - Table View Delegate and DataSource
extension FriendListViewController : UITableViewDataSource, UITableViewDelegate {
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return historyChatrooms.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.FriendListCellIdentifier, forIndexPath: indexPath) as! FriendListTableViewCell
		
		cell.userId = userId
		cell.historyChatroom = historyChatrooms[indexPath.row]
		
		return cell
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		hidesBottomBarWhenPushed = true
		performSegueWithIdentifier(Storyboard.GotoChatroomSegueIdentifier, sender: historyChatrooms[indexPath.row])
	}
}

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
				ColorgyChatAPI.checkUserAvailability({ (user) -> Void in
					ColorgyChatAPI.getHistoryTarget(user.userId, gender: Gender.Unspecified, fromPage: 0, toPage: 10, complete: { (targets) -> Void in
						print(targets.count)
					})
					}, failure: { () -> Void in
						print("fail to refresh friend list")
				})
			}
		}
	}
}