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
		loadFriend()
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
				print(targets)
				let sortedTargets = targets.sort({ (room1: HistoryChatroom, room2: HistoryChatroom) -> Bool in
					return room1.updatedAt.timeIntervalSince1970() < room2.updatedAt.timeIntervalSince1970()
				})
				self.historyChatrooms = sortedTargets
				self.friendListTableView.reloadData()
				}, failure: { () -> Void in
					
			})
			}, failure: { () -> Void in
				
		})
	}
	
	func pullToRefreshHi(refresh: UIRefreshControl) {
		ColorgyChatAPI.checkUserAvailability({ (user) -> Void in
			self.userId = user.userId
			ColorgyChatAPI.getHistoryTarget(user.userId, gender: Gender.Unspecified, page: 0, success: { (targets) -> Void in
				let sortedTargets = targets.sort({ (room1: HistoryChatroom, room2: HistoryChatroom) -> Bool in
					return room1.updatedAt.timeIntervalSince1970() < room2.updatedAt.timeIntervalSince1970()
				})
				self.historyChatrooms = sortedTargets
				self.friendListTableView.reloadData()
				refresh.endRefreshing()
				}, failure: { () -> Void in
					refresh.endRefreshing()
			})
		}, failure: { () -> Void in
			refresh.endRefreshing()
		})
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