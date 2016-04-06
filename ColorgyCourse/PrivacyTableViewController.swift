//
//  PrivacyTableViewController.swift
//  ColorgyCourse
//
//  Created by David on 2016/1/20.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics

class PrivacyTableViewController: UITableViewController {
    
    @IBOutlet weak var publicTimeTableSwitch: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
 
        publicTimeTableSwitch.addTarget(self, action: #selector(publicTimeTableSwitchValueChanged), forControlEvents: UIControlEvents.ValueChanged)
        publicTimeTableSwitch.enabled = false
        publicTimeTableSwitch.on = false
        
        navigationItem.title = "隱私設定"
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        checkPrivacyState()
    }
    
    func checkPrivacyState() {
        ColorgyAPI.GETMEPrivacySetting(success: { (isTimeTablePublic) -> Void in
            self.publicTimeTableSwitch.enabled = true
            self.publicTimeTableSwitch.setOn(isTimeTablePublic, animated: true)
            }) { () -> Void in
                let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * 1.5))
                dispatch_after(delay, dispatch_get_main_queue(), { () -> Void in
                    self.checkPrivacyState()
                })
        }
    }
    
    func publicTimeTableSwitchValueChanged(publicSwitch: UISwitch) {
        print(publicSwitch.on)
        ColorgyAPI.PATCHMEPrivacySetting(trunIt: publicSwitch.on, success: { () -> Void in
			let params: [String : AnyObject] = [
				"user_id": UserSetting.UserId() ?? -1,
				"user_orgazination": UserSetting.UserPossibleOrganization() ?? "no orgazination",
				"user_department": UserSetting.UserPossibleDepartment() ?? "no department",
				"privacy_setting": self.publicTimeTableSwitch.on ? "On" : "Off"
			]
			Flurry.logEvent("v3.0: User Change Their Privacy Setting", withParameters: params as [NSObject : AnyObject])
			Answers.logCustomEventWithName(AnswersLogEvents.userChangedPrivacySetting, customAttributes: params)
            }) { () -> Void in

        }
    }

    // MARK: - Table view data source
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let line = UIView(frame: CGRectMake(0, 0, self.view.frame.width, 1))
        line.backgroundColor = UIColor.clearColor()
        return line
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 2.0
    }
}
