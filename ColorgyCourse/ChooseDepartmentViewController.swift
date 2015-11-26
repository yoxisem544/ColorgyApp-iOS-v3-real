//
//  ChooseDepartmentViewController.swift
//  ColorgyCourse
//
//  Created by David on 2015/11/24.
//  Copyright © 2015年 David. All rights reserved.
//

import UIKit

class ChooseDepartmentViewController: UIViewController {
    
    @IBOutlet weak var departmentTableView: UITableView!
    var school: String!
    var indexPathUserSelected: Int = -1
    var departments: [Department]! {
        didSet {
            if departments == nil {
                ColorgyAPI.getDepartments(school, success: { (departments) -> Void in
                    self.departments = departments
                    print(departments)
                    }, failure: { () -> Void in
                        // try again
                    self.departments = nil
                })
            } else {
                // reload table view
                departmentTableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        departmentTableView.delegate = self
        departmentTableView.dataSource = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        departments = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    struct Storyboard {
        static let segueIdentifier = "ChooseDepartmentIdentifer"
    }
    
    @IBAction func backButtonClicked() {
        dismissViewControllerAnimated(true, completion: nil)
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

extension ChooseDepartmentViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.segueIdentifier, forIndexPath: indexPath)
        cell.accessoryType = .None
        let name = (departments == nil ? "" : departments[indexPath.row].name)
        cell.textLabel?.text = name
        
        // set checkmark
        if indexPathUserSelected >= 0 {
            if indexPathUserSelected == indexPath.row {
                cell.accessoryType = .Checkmark
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if departments == nil {
            return 0
        } else {
            return departments.count
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPathUserSelected >= 0 {
            let previousCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: indexPathUserSelected, inSection: 0))
            previousCell?.accessoryType = .None
        }
        
        print(indexPath.row)
        let thisCell = tableView.cellForRowAtIndexPath(indexPath)
        thisCell?.accessoryType = .Checkmark
        
        indexPathUserSelected = indexPath.row
    }
}
