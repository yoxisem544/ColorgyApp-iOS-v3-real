//
//  EditCourseViewController.swift
//  ColorgyCourse
//
//  Created by David on 2016/3/29.
//  Copyright © 2016年 David. All rights reserved.
//


import UIKit
import Fabric
import Crashlytics

protocol EditCourseViewControllerDelegate {
	func EditCourseViewControllerDidEditLocalCourse()
}

class EditCourseViewController: UIViewController {
	
	@IBOutlet weak var editCourseTableView: UITableView!
	
	var locationContents: [String?]?
	var timeContents: [String?]?
	var timePeriodsContents: [[Int]]?
	let timeAndLocationSection: Int = 1
	var courseName: String?
	var lecturerName: String?
	
	var course: Course? {
		didSet {
			print(course)
			courseName = course?.name
			lecturerName = course?.lecturer
		}
	}
	var localCourse: LocalCourse? {
		didSet {
			courseName = localCourse?.name
			lecturerName = localCourse?.lecturer
		}
	}
	
	var delegate: EditCourseViewControllerDelegate?
	
	var didEditCourse: Bool = false
	
	@IBAction func testLocalCourse() {
		let lc = LocalCourse(name: courseName, lecturer: lecturerName, timePeriodsContents: timePeriodsContents, locationContents: locationContents)
		print(lc)
		//        LocalCourseDB.deleteAllCourses()
		print(CourseNotification.checkNeedNotifiedLocalCourse(lc!))
		LocalCourseDB.storeLocalCourseToDB(lc)
	}
	
	@IBAction func createLocalCourseClicked() {
		alertCreating("小提醒", error: "我們會幫你建立一個新的自訂課程，然後把雲端上的資料刪除，如果要編輯課程，請按鍵立！") { () -> Void in
			if let lc = LocalCourse(name: self.courseName, lecturer: self.lecturerName, timePeriodsContents: self.timePeriodsContents, locationContents: self.locationContents) {
				print(lc)
				if let periods = lc.periods {
					print(periods.count)
					if periods.count >= 9 {
						self.alertCreating("小提醒", error: "課程最多只能有9節的時間，多的時間將不會存下來喔！如果還是想要建立課程的話，請按建立！", confirmBlock: { () -> Void in
							self.confirmCreateLocalCourse(lc)
						})
					} else {
						self.confirmCreateLocalCourse(lc)
					}
				} else {
					self.confirmCreateLocalCourse(lc)
				}
			} else {
				if self.courseName == nil || self.courseName == "" {
					// no name of course
					self.alertError("資料有問題", error: "建立課程需要最少輸入課程的名稱！")
				}
			}
		}
	}
	
	@IBAction func popBackToSearchView() {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	func confirmCreateLocalCourse(lc: LocalCourse) {
		
		// TODO: need loading view
		if course != nil {
			print(course)
			ColorgyAPI.DELETECourseToServer(course!.code, success: { (courseCode) -> Void in
				LocalCourseDB.storeLocalCourseToDB(lc)
				self.didEditCourse = true
				self.popBackToSearchView()
				}, failure: { () -> Void in
					self.alertError("出錯了！", error: "請檢查有沒有連結到網路唷！")
			})
		} else {
			// local course
			// need revise
			if let localCourse = localCourse {
				LocalCourseDB.deleteLocalCourseOnDB(localCourse)
			}
			LocalCourseDB.storeLocalCourseToDB(lc)
			self.didEditCourse = true
			popBackToSearchView()
		}
	}
	
	func alertCreating(title: String?, error: String?, confirmBlock: () -> Void) {
		let alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
		let ok = UIAlertAction(title: "建立", style: UIAlertActionStyle.Cancel) { (action: UIAlertAction) -> Void in
			confirmBlock()
		}
		let cancel = UIAlertAction(title: "重新輸入", style: UIAlertActionStyle.Default, handler: nil)
		alert.addAction(ok)
		alert.addAction(cancel)
		dispatch_async(dispatch_get_main_queue(), { () -> Void in
			self.presentViewController(alert, animated: true, completion: nil)
		})
	}
	
	func alertError(title: String?, error: String?) {
		let alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
		let ok = UIAlertAction(title: "知道了", style: UIAlertActionStyle.Default, handler: nil)
		alert.addAction(ok)
		dispatch_async(dispatch_get_main_queue(), { () -> Void in
			self.presentViewController(alert, animated: true, completion: nil)
		})
	}
	
	func createNewTimeAndLocationContent() {
		if locationContents != nil {
			locationContents?.append("")
			timeContents?.append("")
			timePeriodsContents?.append([1, 1, 1])
			editCourseTableView.reloadSections(NSIndexSet(index: timeAndLocationSection), withRowAnimation: .Fade)
			let indexPath = NSIndexPath(forRow: locationContents!.count - 1, inSection: timeAndLocationSection)
			editCourseTableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Middle, animated: true)
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		editCourseTableView.delegate = self
		editCourseTableView.dataSource = self
		
		editCourseTableView.estimatedRowHeight = UITableViewAutomaticDimension
		editCourseTableView.rowHeight = UITableViewAutomaticDimension
		
		editCourseTableView.backgroundColor = ColorgyColor.BackgroundColor
		view.backgroundColor = ColorgyColor.BackgroundColor
		
		initializeContents()
		
		editCourseTableView.keyboardDismissMode = .OnDrag
	}
	
	func initializeContents() {
		locationContents = []
		timeContents = []
		timePeriodsContents = []
		
		checkCourse()
	}
	
	func checkCourse() {
		if course != nil {
			guard let days = course?.days else { return }
			guard let periods = course?.periods else { return }
			guard let locations = course?.locations else { return }
			
			let x = handlePeriod(days, periods: periods, locations: locations)
			print(x)
			newData(x)
		} else if localCourse != nil {
			guard let days = localCourse?.days else { return }
			guard let periods = localCourse?.periods else { return }
			guard let locations = localCourse?.locations else { return }
			
			let x = handlePeriod(days, periods: periods, locations: locations)
			print(x)
			newData(x)
		}
	}
	
	func handlePeriod(days: [Int], periods: [Int], locations: [String]) -> [(day: Int, period: Int, location: String)] {
		
		var tempArray = [(day: Int, period: Int, location: String)]()
		
		if days.count == periods.count && days.count == locations.count {
			for (index, _) : (Int, Int) in days.enumerate() {
				tempArray.append((day: days[index], period: periods[index], location: locations[index]))
			}
		}
		
		return tempArray
	}
	
	func newData(data: [(day: Int, period: Int, location: String)]) {
		for d in data {
			locationContents?.append(d.location)
			timeContents?.append("")
			timePeriodsContents?.append([d.day, d.period, d.period])
		}
	}
	
	override func viewDidDisappear(animated: Bool) {
		super.viewDidDisappear(animated)
		unregisterNotification()
		if didEditCourse == true {
			delegate?.EditCourseViewControllerDidEditLocalCourse()
		}
	}
	
	func registerNotification() {
		// keyboard
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardDidShow), name: UIKeyboardDidShowNotification, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardDidHide), name: UIKeyboardDidHideNotification, object: nil)
	}
	
	func unregisterNotification() {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}
	
	func keyboardDidShow(notification: NSNotification) {
		if let kbSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() {
			print(kbSize)
			UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
				self.editCourseTableView.contentInset.bottom = kbSize.height
				}, completion: nil)
		}
	}
	
	func keyboardDidHide(notification: NSNotification) {
		UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
			self.editCourseTableView.contentInset = UIEdgeInsetsZero
			}, completion: nil)
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		self.inputView?.reloadInputViews()
		registerNotification()
	}
	
	struct Storyboard {
		static let nameAndLecturerIdentifier = "nameAndLecturerIdentifier"
		static let timeAndLocationIdentifier = "time location identifier"
		static let newTimeAndLocationIdentifier = "new time and location identifier"
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}

extension EditCourseViewController : UITableViewDataSource, UITableViewDelegate {
	// MARK: - Table view data source
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 3
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case 0: // name and lecturer
			return 1
		case 1: // time and location
			if locationContents != nil {
				return locationContents!.count
			} else {
				return 10
			}
		case 2: // footer
			return 1
		default:
			return 0
		}
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		switch indexPath.section {
		case 0: // name and lecturer
			let c = tableView.dequeueReusableCellWithIdentifier(Storyboard.nameAndLecturerIdentifier, forIndexPath: indexPath) as! CreateCourseNameAndLecturerTableViewCell
			
			c.nameTextField.text = courseName
			c.lecturerTextField.text = lecturerName
			c.delegate = self
			
			return c
		case 1: // time and location
			let c = tableView.dequeueReusableCellWithIdentifier(Storyboard.timeAndLocationIdentifier, forIndexPath: indexPath) as! TimeAndLocationTableViewCell
			
			c.delegate = self
			c.cellIndex = indexPath.row
			c.timeTextField?.text = timeContents![indexPath.row]
			c.locationTextField?.text = locationContents![indexPath.row]
			c.periods = timePeriodsContents![indexPath.row]
			
			return c
		case 2: // footer
			let c = tableView.dequeueReusableCellWithIdentifier(Storyboard.newTimeAndLocationIdentifier, forIndexPath: indexPath) as! ContinueAddTimeAndLocationTableViewCell
			
			c.delegate = self
			
			return c
		default:
			return tableView.dequeueReusableCellWithIdentifier(Storyboard.newTimeAndLocationIdentifier, forIndexPath: indexPath) as! ContinueAddTimeAndLocationTableViewCell
		}
		
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		switch indexPath.section {
		case 0:
			return 88.0
		case 1:
			return 122.0
		case 2:
			return 122.0
		default:
			return 44.0
		}
	}
}

// MARK: - TimeAndLocationTableViewCellDelegate
extension EditCourseViewController : TimeAndLocationTableViewCellDelegate {
	func didTapOnLocationView() {
		print("yo")
	}
	
	func didTapOnTimeView() {
		print("yooo")
	}
	
	func contentUpdatedAtIndex(index: Int, periodDescription: String?, periods: [Int], location: String?) {
		locationContents?[index] = location
		timeContents?[index] = periodDescription
		timePeriodsContents?[index] = periods
		print(periods)
	}
	
	func didPressDeleteButtonAtIndex(index: Int) {
		locationContents?.removeAtIndex(index)
		timeContents?.removeAtIndex(index)
		timePeriodsContents?.removeAtIndex(index)
		editCourseTableView.reloadSections(NSIndexSet(index: timeAndLocationSection), withRowAnimation: .Fade)
	}
}

// MARK: - CreateCourseNameAndLecturerTableViewCellDelegate
extension EditCourseViewController : CreateCourseNameAndLecturerTableViewCellDelegate {
	func contentUpdated(courseName: String?, lecturerName: String?) {
		self.courseName = courseName
		self.lecturerName = lecturerName
	}
}

// MARK: - ContinueAddTimeAndLocationTableViewCellDelegate
extension EditCourseViewController : ContinueAddTimeAndLocationTableViewCellDelegate {
	func didTapOnAddButton() {
		if locationContents != nil {
			if locationContents!.count < 9 {
				// limit the content length to 9
				createNewTimeAndLocationContent()
			}
		}
	}
}