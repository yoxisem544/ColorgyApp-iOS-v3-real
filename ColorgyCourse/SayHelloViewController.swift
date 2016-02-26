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
	
	private let failToLoadDataHintView = FailToLoadDataHintView(errorTitle: "⚠️ 資料下載錯誤...請下拉畫面重新讀取...")

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
		
		view.addSubview(failToLoadDataHintView)
		failToLoadDataHintView.hidden = true
		failToLoadDataHintView.alpha = 0.1
    }
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		loadHi()
	}
	
	override func viewDidDisappear(animated: Bool) {
		super.viewDidDisappear(animated)
	}
	
	// MARK: show report view
	func showChatReportController(title: String?, canSkip: Bool, type: String?) {
		
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let reportController = storyboard.instantiateViewControllerWithIdentifier("chat report") as! ChatReportViewController
		reportController.canSkipContent = canSkip
		reportController.titleOfReport = title
		reportController.reportType = type
		reportController.delegate = self
		let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * 0.3))
		dispatch_after(delay, dispatch_get_main_queue(), { () -> Void in
			self.presentViewController(reportController, animated: true, completion: nil)
		})
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
	
	// MARK: hint view
	func showHintFailView() {
		self.failToLoadDataHintView.hidden = false
		UIView.animateWithDuration(0.3, animations: { () -> Void in
			self.failToLoadDataHintView.alpha = 1.0
		})
	}
	
	// MARK: loading
	func loadHi() {
		ColorgyChatAPI.checkUserAvailability({ (user) -> Void in
			ColorgyChatAPI.getHiList(user.userId, success: { (hiList) -> Void in
				print(hiList)
				self.hideHintFailView()
				self.hiList = hiList
				self.sayHelloTableView.reloadData()
				}, failure: { () -> Void in
					self.showHintFailView()
			})
			}, failure: { () -> Void in
				self.showHintFailView()
		})
	}
	
	func moreOptions(hi: Hello?) {
		let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
		let block = UIAlertAction(title: "封鎖", style: UIAlertActionStyle.Default) { (action: UIAlertAction) -> Void in
			self.showChatReportController("封鎖用戶", canSkip: true, type: "block")
		}
		let report = UIAlertAction(title: "檢舉", style: UIAlertActionStyle.Default) { (action: UIAlertAction) -> Void in
			self.showChatReportController("檢舉用戶", canSkip: false, type: "report")
		}
		let cancel = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
		alert.addAction(report)
		alert.addAction(block)
		alert.addAction(cancel)
		dispatch_async(dispatch_get_main_queue()) { () -> Void in
			self.presentViewController(alert, animated: true, completion: nil)
		}
	}

	struct Storyboard {
		static let SayHelloCellIdentifier = "Say Hello Cell"
	}
	
	func reloadHi() {
		ColorgyChatAPI.checkUserAvailability({ (user) -> Void in
			ColorgyChatAPI.getHiList(user.userId, success: { (hiList) -> Void in
				self.hideHintFailView()
				self.hiList = hiList
				self.sayHelloTableView.reloadData()
				}, failure: { () -> Void in
					self.showHintFailView()
			})
			}) { () -> Void in
				self.showHintFailView()
		}
	}
	
	func pullToRefreshHi(refresh: UIRefreshControl) {
		ColorgyChatAPI.checkUserAvailability({ (user) -> Void in
			ColorgyChatAPI.getHiList(user.userId, success: { (hiList) -> Void in
				self.hideHintFailView()
				self.hiList = hiList
				self.sayHelloTableView.reloadData()
				refresh.endRefreshing()
				}, failure: { () -> Void in
					refresh.endRefreshing()
					self.showHintFailView()
			})
			}) { () -> Void in
				refresh.endRefreshing()
				self.showHintFailView()
		}
	}
}

// MARK: - UITableViewDelegate, UITableViewDataSource
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

// MARK: - SayHelloTableViewCellDelegate
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
	
	func sayHelloTableViewCellMoreActionButtonClicked(hi: Hello) {
		moreOptions(hi)
	}
}

extension SayHelloViewController : ChatReportViewControllerDelegate {
	func chatReportViewController(didSubmitReportUserContent title: String?, description: String?, hi: Hello?) {
		print("didSubmitReportUserContent")
		if let hi = hi {
			ColorgyChatAPI.checkUserAvailability({ (user) -> Void in
				let targetId = (user.userId == hi.userId ? hi.targetId : hi.userId)
				ColorgyChatAPI.reportUser(user.userId, targetId: targetId, type: title, reason: description, success: { () -> Void in
					
					}, failure: { () -> Void in
					
				})
				}, failure: { () -> Void in
					
			})
		}
	}
	
	func chatReportViewController(didSubmitBlockUserContent title: String?, description: String?, hi: Hello?) {
		print("didSubmitBlockUserContent")
		if let hi = hi {
			ColorgyChatAPI.checkUserAvailability({ (user) -> Void in
				let targetId = (user.userId == hi.userId ? hi.targetId : hi.userId)
				ColorgyChatAPI.blockUser(user.userId, targetId: targetId, success: { () -> Void in
					
					}, failure: { () -> Void in
						
				})
				}, failure: { () -> Void in
					
			})
		}
	}
}