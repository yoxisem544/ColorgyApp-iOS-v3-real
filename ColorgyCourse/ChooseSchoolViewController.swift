//
//  ChooseSchoolViewController.swift
//  ColorgyCourse
//
//  Created by David on 2015/11/19.
//  Copyright © 2015年 David. All rights reserved.
//

import UIKit

class ChooseSchoolViewController: UIViewController {
    
    @IBOutlet weak var schoolTableView: UITableView!
    
    @IBAction func test() {
        ColorgyAPI.getSchools({ () -> Void in
            
            }) { () -> Void in
                
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        schoolTableView.delegate = self
        schoolTableView.dataSource = self
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
    
    struct Storyboard {
        static let cellIdentifier = "ChooseSchoolIdentifer"
    }

}

extension ChooseSchoolViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.cellIdentifier, forIndexPath: indexPath)
        cell.textLabel?.text = "\(indexPath.row)"
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
}