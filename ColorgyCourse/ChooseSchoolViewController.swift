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
    
    var searchControl = UISearchController()

    var schools: [School]! {
        didSet {
            if schools == nil {
                ColorgyAPI.getSchools({ (schools) -> Void in
                    self.schools = schools
                    }, failure: { () -> Void in
                        print("failllll...")
                        // try again
                        self.schools = nil
                })
            } else {
                // reload data
                self.schoolTableView.reloadData()
            }
        }
    }
    
    var filteredSchools: [School] = []
    
    
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
        
        searchControl = UISearchController(searchResultsController: nil)
        searchControl.searchResultsUpdater = self
        searchControl.searchBar.sizeToFit()
        searchControl.dimsBackgroundDuringPresentation = false
        
        schoolTableView.tableHeaderView = searchControl.searchBar
        searchControl.searchBar.placeholder = "搜尋學校"
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if schools == nil {
            schools = nil
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == Storyboard.showDepartmentSegue {
            let destinationVC = segue.destinationViewController as! ChooseDepartmentViewController
            destinationVC.school = sender as! String
        }
    }

    
    struct Storyboard {
        static let cellIdentifier = "ChooseSchoolIdentifer"
        static let cantFindSchoolIdentifier = "cant find school identifier"
        static let showDepartmentSegue = "show department"
    }

}

extension ChooseSchoolViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if !searchControl.active {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.cantFindSchoolIdentifier, forIndexPath: indexPath)
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.cellIdentifier, forIndexPath: indexPath)
                let name = (schools == nil ? "" : schools[indexPath.row - 1].name)
                let code = (schools == nil ? "" : schools[indexPath.row - 1].code.uppercaseString + " ")
                cell.textLabel?.text = "\(code)\(name)"
            
                return cell
            }
        } else {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.cantFindSchoolIdentifier, forIndexPath: indexPath)
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.cellIdentifier, forIndexPath: indexPath)
                print("indexPath.row")
                print(indexPath.row)
                print(filteredSchools.count)
                let name = filteredSchools[indexPath.row - 1].name
                let code = filteredSchools[indexPath.row - 1].code.uppercaseString
                cell.textLabel?.text = "\(code)\(name)"
                
                return cell
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !searchControl.active {
            if schools == nil {
                return 1
            } else {
                return schools.count + 1
            }
        } else {
            if searchControl.searchBar.text == "" {
                return 0
            } else {
                print("returning number of rows")
                return filteredSchools.count + 1
            }
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if !searchControl.active {
            if indexPath == 0 {
                print("need to perform segue.....")
            } else {
                if let schoolCode = schools?[indexPath.row - 1].code {
                    let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * 0.3))
                    dispatch_after(delay, dispatch_get_main_queue(), { () -> Void in
                        self.performSegueWithIdentifier(Storyboard.showDepartmentSegue, sender: schoolCode)
                        tableView.deselectRowAtIndexPath(indexPath, animated: true)
                    })
                }
            }
        } else {
            if indexPath == 0 {
                print("need to perform segue.....")
            } else {
                let schoolCode = filteredSchools[indexPath.row - 1].code
                let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * 0.3))
                dispatch_after(delay, dispatch_get_main_queue(), { () -> Void in
                    self.performSegueWithIdentifier(Storyboard.showDepartmentSegue, sender: schoolCode)
                    tableView.deselectRowAtIndexPath(indexPath, animated: true)
                })
            }
        }
        
        // deactive search bar
        deactiveSearchBar()
        
    }
    
    func deactiveSearchBar() {
        searchControl.active = false
    }
}

extension ChooseSchoolViewController : UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        if searchController.active {
            filterContentForSearchText(searchController.searchBar.text!)
        } else {
            schoolTableView.reloadData()
        }
    }
    
    func filterContentForSearchText(searchText: String) {
        
        filteredSchools = []
        
        guard schools != nil else { return }
        
        if searchText != "" {
            let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
            dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in
                
                for s in self.schools {
                    var isMatch = false
                    if s.name.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch) != nil {
                        isMatch = true
                    }
                    if s.code.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil, locale: nil) != nil {
                        isMatch = true
                    }
                    if isMatch {
                        self.filteredSchools.append(s)
                    }
                }
                // after filtering, return to main queue
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    print(self.filteredSchools)
                    self.schoolTableView.reloadData()
                    print("reload after filtering")
                })
            })
        } else {
            schoolTableView.reloadData()
        }
    }
}