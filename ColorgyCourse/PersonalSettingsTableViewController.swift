//
//  PersonalSettingsViewController.swift
//  ColorgyCourse
//
//  Created by David on 2015/9/7.
//  Copyright (c) 2015年 David. All rights reserved.
//

import UIKit

class PersonalSettingsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.backgroundColor = UIColor.whiteColor()
        let statusBarBackgroundView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, 20))
        statusBarBackgroundView.backgroundColor = UIColor.whiteColor()
        self.navigationController?.view.addSubview(statusBarBackgroundView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PersonalSettingsTableViewController : UITableViewDelegate {
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println(indexPath)
    }
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let line = UIView(frame: CGRectMake(0, 0, self.view.frame.width, 1))
        line.backgroundColor = UIColor.clearColor()
        return line
    }
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 2.0
    }
}
