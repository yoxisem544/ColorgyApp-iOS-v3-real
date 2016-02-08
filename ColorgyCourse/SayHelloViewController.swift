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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		sayHelloTableView.delegate = self
		sayHelloTableView.dataSource = self
		sayHelloTableView.estimatedRowHeight = 132
		sayHelloTableView.rowHeight = UITableViewAutomaticDimension
		sayHelloTableView.separatorStyle = .None
		sayHelloTableView.backgroundColor = ColorgyColor.BackgroundColor
    }
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		loadHi()
	}
	
	func loadHi() {
		ColorgyChatAPI.checkUserAvailability({ (user) -> Void in
			ColorgyChatAPI.getHiList(user.userId, success: { (hiList) -> Void in
				print(hiList)
				}, failure: { () -> Void in
					
			})
			}, failure: { () -> Void in
				
		})
	}

	struct Storyboard {
		static let SayHelloCellIdentifier = "Say Hello Cell"
	}
}


extension SayHelloViewController : UITableViewDelegate, UITableViewDataSource {
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 10
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.SayHelloCellIdentifier, forIndexPath: indexPath) as! SayHelloTableViewCell
		return cell
	}
}