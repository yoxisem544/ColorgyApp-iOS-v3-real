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
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		friendListTableView.delegate = self
		friendListTableView.dataSource = self
		friendListTableView.estimatedRowHeight = 120
		friendListTableView.rowHeight = UITableViewAutomaticDimension
		friendListTableView.separatorStyle = .None
		friendListTableView.backgroundColor = ColorgyColor.BackgroundColor
    }
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
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
				self.historyChatrooms = targets
				self.friendListTableView.reloadData()
				}, failure: { () -> Void in
					
			})
			}) { () -> Void in
				
		}
	}
	
	struct Storyboard {
		static let FriendListCellIdentifier = "Friend List Cell"
	}
}


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
}