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
	
	struct Storyboard {
		static let FriendListCellIdentifier = "Friend List Cell"
	}
}


extension FriendListViewController : UITableViewDataSource, UITableViewDelegate {
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 10
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.FriendListCellIdentifier, forIndexPath: indexPath) as! FriendListTableViewCell
		return cell
	}
}