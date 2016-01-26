//
//  TimeTableViewController.swift
//  ColorgyCourse
//
//  Created by David on 2015/9/5.
//  Copyright (c) 2015年 David. All rights reserved.
//

import UIKit

class TimeTableViewController: UIViewController {
    
    var timetableView: TimeTableView!
    let navHeight: CGFloat = 64.0
    let tabBarHeight: CGFloat = 49.0
    
    var courses: [Course]!

    @IBAction func addCourseButtonClicked(sender: AnyObject) {
        if Release().mode {
            Flurry.logEvent("v3.0: User Tap Add Button To Search Course View")
        }
        self.performSegueWithIdentifier("Show Add Course", sender: sender)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // timetableview
        timetableView = TimeTableView(frame: CGRectMake(0, navHeight, self.view.frame.width, self.view.frame.height - navHeight - tabBarHeight))
        self.view.addSubview(timetableView)
        timetableView.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if Release().mode {
            Flurry.logEvent("v3.0: User Using User Timetable", timed: true)
        } else {
            Flurry.logEvent("test: Using User Timetable", timed: true)
        }
        
        // check token
        checkToken()
        
        // get courses from db
        getAndSetDataToTimeTable()
		
		for i in 1...100 {
			print("firing \(i)")
			dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_DEFAULT.rawValue), 0), { () -> Void in
				print("execing \(i)")
				CourseUpdateHelper.needUpdateCourse()
				CourseUpdateHelper.updateCourse({ () -> Void in
					self.getAndSetDataToTimeTable()
				})
				print("job in async \(i)")
			})
		}
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        if Release().mode {
            Flurry.endTimedEvent("User Using User Timetable", withParameters: nil)
        } else {
            Flurry.logEvent("test: Using User Timetable", timed: true)
        }
    }
    
    private func checkToken() {
        ColorgyAPI.checkIfTokenHasExpired(unexpired: { () -> Void in
            // if accesstoken work, update course
            CourseUpdateHelper.updateCourse({ () -> Void in
                // TODO: what i do here?
                // here is from CourseDB
				dispatch_async(SERIAL_QUEUE, { () -> Void in
					self.getAndSetDataToTimeTable()
				})
            })
            // update push notification device token
            ColorgyAPI.PUTdeviceToken(success: { () -> Void in
                print("putting device token")
                }, failure: { () -> Void in
                    print("fail putting device token")
            })
            }, expired: { () -> Void in
                NetwrokQualityDetector.isNetworkStableToUse(stable: { () -> Void in
                    ColorgyAPITrafficControlCenter.refreshAccessToken({ (loginResult) -> Void in
                        // if user get a new token
                        // load data again
						dispatch_async(SERIAL_QUEUE, { () -> Void in
							self.getAndSetDataToTimeTable()
						})
                        print(UserSetting.UserAccessToken())
                        }, failure: { () -> Void in
                            if !ColorgyAPITrafficControlCenter.isRefershTokenRefreshable() {
                                let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * 0.5))
                                dispatch_after(delay, dispatch_get_main_queue(), { () -> Void in
                                    let alert = UIAlertController(title: "驗證過期", message: "請重新登入", preferredStyle: UIAlertControllerStyle.Alert)
                                    let ok = UIAlertAction(title: "好", style: UIAlertActionStyle.Cancel, handler: {(hey) -> Void in
                                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                        let vc = storyboard.instantiateViewControllerWithIdentifier("Main Login View") as! FBLoginViewController
                                        self.presentViewController(vc, animated: true, completion: nil)
                                    })
                                    alert.addAction(ok)
                                    self.presentViewController(alert, animated: true, completion: nil)
                                })
                            }
                    })
                }, unstable: { () -> Void in
                    // not good network, dont update
                })
        })
    }
    
    private func getAndSetDataToTimeTable() {
        let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
        dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in
            // server
            var tempedCourses = [Course]()
            // local
            var tempedLocalCourses = [LocalCourse]()
            // server
			CourseDB.getAllStoredCourses(complete: { (courses) -> Void in
				if let courses = courses {
					for c in courses {
						tempedCourses.append(c)
					}
				}
				// load course, then load local course
				dispatch_async(dispatch_get_main_queue(), { () -> Void in
					print(self.timetableView.courses?.count)
					self.timetableView.courses = courses
				})
				LocalCourseDB.getAllStoredCourses(complete: { (localCourses) -> Void in
					if let localCourses = localCourses {
						for c in localCourses {
							tempedLocalCourses.append(c)
						}
					}
					// finished loading localc course
					// setup notification
					dispatch_async(dispatch_get_main_queue(), { () -> Void in
						print(self.timetableView.localCourse?.count)
						self.timetableView.localCourse = localCourses
					})
				})
			})
//            CourseDB.getAllStoredCoursesObject(complete: { (courseDBManagedObjects) -> Void in
//                if let objects = courseDBManagedObjects {
//                    print(objects.count)
//                    for obj in objects {
//                        if let course = Course(courseDBManagedObject: obj) {
//                            courses.append(course)
//                        }
//                    }
//
//                    // load course, then load local course
//                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                        print(self.timetableView.courses?.count)
//                        self.timetableView.courses = courses
//                    })
//                    LocalCourseDB.getAllStoredCoursesObject(complete: { (localCourseDBManagedObjects) -> Void in
//                        if let objects = localCourseDBManagedObjects {
//                            for o in objects {
//                                if let localc = LocalCourse(localCourseDBManagedObject: o) {
//                                    localCourses.append(localc)
//                                }
//                            }
//
//                            // finished loading localc course
//                            // setup notification
//                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                                print(self.timetableView.localCourse?.count)
//                                self.timetableView.localCourse = localCourses
//                            })
//                        }
//                    })
//                }
//            })
        })
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Timetable Show Detail Info" {
            let destinationVC = segue.destinationViewController as! DetailCourseViewController
            if sender != nil {
                if sender!.isKindOfClass(Course) {
                    destinationVC.course = sender as! Course
                } else if sender!.isKindOfClass(LocalCourse) {
                    destinationVC.localCourse = sender as! LocalCourse
                }
            }
            
        }
    }
}

extension TimeTableViewController : TimeTableViewDelegate {
    
    func timeTableView(userDidTapOnLocalCourseCell cell: CourseCellView) {
        print(cell.localCourseInfo)
        self.performSegueWithIdentifier("Timetable Show Detail Info", sender: cell.localCourseInfo)
    }
    
    func timeTableView(userDidTapOnCourseCell cell: CourseCellView) {
        if Release().mode {
            Flurry.logEvent("v3.0: User Tap on Course on Their Timetable")
        }
        self.performSegueWithIdentifier("Timetable Show Detail Info", sender: cell.courseInfo)
    }
    
    func timeTableViewDidScroll(scrollView: UIScrollView) {
        
    }
    
    
}
