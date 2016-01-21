//
//  PrivacyTableViewController.swift
//  ColorgyCourse
//
//  Created by David on 2016/1/20.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

class PrivacyTableViewController: UITableViewController {
    
    @IBOutlet weak var publicTimeTableSwitch: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        publicTimeTableSwitch.addTarget(self, action: "publicTimeTableSwitchValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
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
            
            }) { () -> Void in
                
        }
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


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
