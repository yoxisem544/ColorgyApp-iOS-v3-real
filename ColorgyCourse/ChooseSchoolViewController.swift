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

    var schools: [School]! {
        didSet {
            if schools == nil {
                ColorgyAPI.getSchools({ (schools) -> Void in
                    self.schools = schools
                    }) { () -> Void in
                        print("failllll...")
                }
            } else {
                // reload data
                self.schoolTableView.reloadData()
            }
        }
    }
    
    @IBAction func test() {
        ColorgyAPI.getSchools({ (schools) -> Void in
            print(schools)
            }) { () -> Void in
                print("failllll...")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        schoolTableView.delegate = self
        schoolTableView.dataSource = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if schools == nil {
            schools = nil
        }
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
        let name = (schools == nil ? "" : schools[indexPath.row].name)
        cell.textLabel?.text = "\(name)"
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if schools == nil {
            return 0
        } else {
            return schools.count
        }
    }
}