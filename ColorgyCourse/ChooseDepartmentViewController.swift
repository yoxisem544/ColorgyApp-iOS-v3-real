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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        departmentTableView.delegate = self
        departmentTableView.dataSource = self
        
//        print(school)
        ColorgyAPI.getDepartments("NTUST", success: { () -> Void in
            print("DE!")
            }) { () -> Void in
                
        }
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
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
}
