//
//  NotificationTableViewController.swift
//  ColorgyCourse
//
//  Created by David on 2016/1/21.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics

class NotificationTableViewController: UITableViewController {
    
    @IBOutlet weak var courseNotificationLabel: UILabel!
    @IBOutlet weak var courseNotificationSwitch: UISwitch!
    @IBOutlet weak var notificationTimeTextField: UITextField!
    @IBOutlet weak var setNotificaionButton: UIButton!
    
    @IBAction func setNotificaionButtonClicked() {
        if let time = Int(notificationTimeTextField.text!) {
            if time >= 0 {
                UserSetting.setCourseNotificationTime(time: time)
                self.view.endEditing(true)
                courseNotificationLabel.text = "課前通知： \(time) 分鐘"
                if !courseNotificationSwitch.on {
                    // if its not on, turn it on
                    courseNotificationSwitch.setOn(true, animated: true)
                    UserSetting.setCourseNotification(turnIt: true)
                    print(UserSetting.isCourseNotificationOn())
                }
                CourseNotification.registerForCourseNotification()
            } else {
                showAlert("你設定的時間已經開始上課囉！！")
            }
        } else {
            showAlert("你輸入的時間有問題喔！")
        }
    }
	
	func flurryEventLog() {
		if Release().mode {
			let params: [String : AnyObject] = [
				"user_id": UserSetting.UserId() ?? -1,
				"user_orgazination": UserSetting.UserPossibleOrganization() ?? "no orgazination",
				"user_department": UserSetting.UserPossibleDepartment() ?? "no department",
				"local_course_notification": courseNotificationSwitch.on ? "On" : "Off",
				"notification_time": courseNotificationLabel.text ?? "no time"
			]
			Flurry.logEvent("v3.0: User Set Their Course Notification Setting", withParameters: params as [NSObject : AnyObject])
			Answers.logCustomEventWithName(AnswersLogEvents.userChangedCourseNotificationSetting, customAttributes: params)
		}
	}
	
    func showAlert(message: String) {
        let alert = UIAlertController(title: "咦？！", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let ok = UIAlertAction(title: "讓我改一下", style: UIAlertActionStyle.Default, handler: {(action) in
            self.notificationTimeTextField.text = "0"
        })
        alert.addAction(ok)
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.presentViewController(alert, animated: true, completion: nil)
        })
    }
    
    var time: Int = 10

    override func viewDidLoad() {
        super.viewDidLoad()

        time = UserSetting.getCourseNotificationTime()
        courseNotificationSwitch.on = false
        courseNotificationLabel.text = "課前通知： \(time) 分鐘"
        notificationTimeTextField.text = "\(time)"
        
        courseNotificationSwitch.addTarget(self, action: "courseNotificationSwitchValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
        
        tableView.keyboardDismissMode = .OnDrag
        
        navigationItem.title = "提醒設定"
		
		notificationTimeTextField.addTarget(self, action: "notificationTimeTextFieldEditingChanged", forControlEvents: UIControlEvents.EditingChanged)
		setNotificaionButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
    }
	
	func notificationTimeTextFieldEditingChanged() {
		print("notificationTimeTextFieldValueChanged")
		setNotificaionButton.setTitleColor(ColorgyColor.MainOrange, forState: .Normal)
	}
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        courseNotificationSwitch.setOn(UserSetting.isCourseNotificationOn(), animated: true)
    }
    
    func courseNotificationSwitchValueChanged(s: UISwitch) {
        UserSetting.setCourseNotification(turnIt: s.on)
        if s.on {
            CourseNotification.registerForCourseNotification()
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
