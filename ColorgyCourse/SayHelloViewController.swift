//
//  SayHelloViewController.swift
//  ColorgyCourse
//
//  Created by David on 2016/2/2.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

class SayHelloViewController: UIViewController {
	
	@IBOutlet weak var sayHelloTableView: UITableView!
	var hiList: [Hello] = []
	let refreshContorl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		sayHelloTableView.delegate = self
		sayHelloTableView.dataSource = self
		sayHelloTableView.estimatedRowHeight = 132
		sayHelloTableView.rowHeight = UITableViewAutomaticDimension
		sayHelloTableView.separatorStyle = .None
		sayHelloTableView.backgroundColor = ColorgyColor.BackgroundColor
		
		refreshContorl.addTarget(self, action: "pullToRefreshHi:", forControlEvents: UIControlEvents.ValueChanged)
		refreshContorl.tintColor = ColorgyColor.MainOrange
		sayHelloTableView.addSubview(refreshContorl)
    }
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		loadHi()
	}
	
	func loadHi() {
		ColorgyChatAPI.checkUserAvailability({ (user) -> Void in
			ColorgyChatAPI.getHiList(user.userId, success: { (hiList) -> Void in
				print(hiList)
				self.hiList = hiList
				self.sayHelloTableView.reloadData()
				}, failure: { () -> Void in
					
			})
			}, failure: { () -> Void in
				
		})
	}

	struct Storyboard {
		static let SayHelloCellIdentifier = "Say Hello Cell"
	}
	
	func reloadHi() {
		ColorgyChatAPI.checkUserAvailability({ (user) -> Void in
			ColorgyChatAPI.getHiList(user.userId, success: { (hiList) -> Void in
				self.hiList = hiList
				self.sayHelloTableView.reloadData()
				}, failure: { () -> Void in
					
			})
			}) { () -> Void in
				
		}
	}
	
	func pullToRefreshHi(refresh: UIRefreshControl) {
		ColorgyChatAPI.checkUserAvailability({ (user) -> Void in
			ColorgyChatAPI.getHiList(user.userId, success: { (hiList) -> Void in
				self.hiList = hiList
				self.sayHelloTableView.reloadData()
				refresh.endRefreshing()
				}, failure: { () -> Void in
					refresh.endRefreshing()
			})
			}) { () -> Void in
				refresh.endRefreshing()
		}
	}
}


extension SayHelloViewController : UITableViewDelegate, UITableViewDataSource {
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return hiList.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.SayHelloCellIdentifier, forIndexPath: indexPath) as! SayHelloTableViewCell
		
		cell.hello = hiList[indexPath.row]
		cell.delegate = self
		
		return cell
	}
}

extension SayHelloViewController : SayHelloTableViewCellDelegate {
	
	func sayHelloTableViewCellAcceptHelloButtonClicked(hi: Hello) {
		print("sayHelloTableViewCellAcceptHelloButtonClicked")
		ColorgyChatAPI.checkUserAvailability({ (user) -> Void in
			ColorgyChatAPI.acceptHi(user.userId, hiId: hi.id, success: { () -> Void in
				self.reloadHi()
				}, failure: { () -> Void in
					
			})
			}, failure: { () -> Void in
				
		})
	}
	
	func sayHelloTableViewCellRejectHelloButtonClicked(hi: Hello) {
		print("sayHelloTableViewCellRejectHelloButtonClicked")
		ColorgyChatAPI.checkUserAvailability({ (user) -> Void in
			ColorgyChatAPI.rejectHi(user.userId, hiId: hi.id, success: { () -> Void in
				self.reloadHi()
				}, failure: { () -> Void in
					
			})
			}, failure: { () -> Void in
				
		})
	}
	
	func sayHelloTableViewCellMoreActionButtonClicked() {
		
	}
}