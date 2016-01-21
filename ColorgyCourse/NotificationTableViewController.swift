//
//  NotificationTableViewController.swift
//  ColorgyCourse
//
//  Created by David on 2016/1/21.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

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
            } else {
                showAlert("你設定的時間已經開始上課囉！！")
            }
        } else {
            showAlert("你輸入的時間有問題喔！")
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

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        time = UserSetting.getCourseNotificationTime()
        courseNotificationSwitch.on = false
        courseNotificationLabel.text = "課前通知： \(time) 分鐘"
        notificationTimeTextField.text = "\(time)"
        
        courseNotificationSwitch.addTarget(self, action: "courseNotificationSwitchValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
        
        tableView.keyboardDismissMode = .OnDrag
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        courseNotificationSwitch.setOn(UserSetting.isCourseNotificationOn(), animated: true)
    }
    
    func courseNotificationSwitchValueChanged(s: UISwitch) {
        UserSetting.setCourseNotification(turnIt: s.on)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
