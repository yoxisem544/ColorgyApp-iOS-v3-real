//
//  TimeTableViewController.swift
//  ColorgyCourse
//
//  Created by David on 2015/9/5.
//  Copyright (c) 2015年 David. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics

class TimeTableViewController: UIViewController {
    
    var timetableView: TimeTableView!
    let navHeight: CGFloat = 64.0
    let tabBarHeight: CGFloat = 49.0
    
    var courses: [Course]!

    @IBAction func addCourseButtonClicked(sender: AnyObject) {
        if Release.mode {
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
	
	func showHintView() {
		let hintView = UIView(frame: UIScreen.mainScreen().bounds)
		let path = UIBezierPath(rect: hintView.frame)
		let circleSize: CGFloat = 32
		let circlePath = UIBezierPath(roundedRect: CGRectMake(UIScreen.mainScreen().bounds.width - circleSize - 10, 25, circleSize, circleSize), cornerRadius: circleSize / 2)
		path.appendPath(circlePath)
		path.usesEvenOddFillRule = true
		
		let fillLayer = CAShapeLayer()
		fillLayer.path = path.CGPath
		fillLayer.fillRule = kCAFillRuleEvenOdd
		fillLayer.fillColor = UIColor.blackColor().CGColor
		fillLayer.opacity = 0.8
		
		hintView.layer.addSublayer(fillLayer)
		
		let title = UILabel(frame: UIScreen.mainScreen().bounds)
		title.frame.size.height = 25
		title.frame.size.width -= circleSize * 2
		title.textColor = UIColor.whiteColor()
		title.textAlignment = .Right
		title.text = "開始加課"
		title.font = UIFont.systemFontOfSize(24)
		
		let content = UILabel(frame: UIScreen.mainScreen().bounds)
		content.frame.size.height = 500
		content.frame.size.width = content.frame.width * 0.7
		content.textColor = UIColor.whiteColor()
		content.textAlignment = .Center
		content.text = "按上面可以開始選課，如果系統內沒有你的課程，沒關係！現在可以手動新增課程了～\n\n若你想鞭打/鼓勵工程師 !要他們快點新增我尊貴的學校科系請至\n「更多」>「問題回報」"
		content.font = UIFont.systemFontOfSize(16)
		content.numberOfLines = 0
		
		title.center.y = 25 + circleSize / 2
		content.center = hintView.center

		hintView.addSubview(title)
		hintView.addSubview(content)
		
		hintView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "tapToDismissHintView:"))
		
		tabBarController?.view.addSubview(hintView)
	}
	
	func tapToDismissHintView(gesture: UITapGestureRecognizer) {
		if let view = gesture.view {
			print(view)
			UIView.animateWithDuration(0.4, animations: { () -> Void in
				view.alpha = 0
				}, completion: { (finised) -> Void in
					if finised {
						view.removeFromSuperview()
						HintViewSettings.setTimetableHintViewShown()
					}
			})
		}
	}
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if Release.mode {
            Flurry.logEvent("v3.0: User Using User Timetable", timed: true)
			Answers.logCustomEventWithName(AnswersLogEvents.userUsingTimetable, customAttributes: nil)
        } else {
            Flurry.logEvent("test: Using User Timetable", timed: true)
        }
        
        // check token
        checkToken()
        
        // get courses from db
        getAndSetDataToTimeTable()
		
		if !HintViewSettings.isTimetableHintViewShown() {
			showHintView()
		}
		
		Mixpanel.sharedInstance().track(MixpanelEvents.GetIntoTableView)
//		for i in 1...100 {
//			print("firing \(i)")
//			dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_DEFAULT.rawValue), 0), { () -> Void in
//				print("execing \(i)")
//				CourseUpdateHelper.needUpdateCourse()
//				CourseUpdateHelper.updateCourse({ () -> Void in
//					self.getAndSetDataToTimeTable()
//				})
//				print("job in async \(i)")
//			})
//		}
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        if Release.mode {
            Flurry.endTimedEvent("User Using User Timetable", withParameters: nil)
        } else {
            Flurry.logEvent("test: Using User Timetable", timed: true)
        }
		// recover tab bar
		hidesBottomBarWhenPushed = false
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
                                        let vc = storyboard.instantiateViewControllerWithIdentifier("Main Login View") as! UINavigationController
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
					Mixpanel.sharedInstance().track(MixpanelEvents.SuccessShowTableCourses)
				})
			})
			LocalCourseDB.getAllStoredCourses(complete: { (localCourses) -> Void in
				if let localCourses = localCourses {
					for c in localCourses {
						tempedLocalCourses.append(c)
					}
				}
				print(localCourses)
				// finished loading localc course
				// setup notification
				dispatch_async(dispatch_get_main_queue(), { () -> Void in
					print(self.timetableView.localCourse?.count)
					self.timetableView.localCourse = localCourses
					Mixpanel.sharedInstance().track(MixpanelEvents.SuccessShowTableCourses)
				})
				//					CourseNotification.registerForCourseNotification()
			})
        })
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Timetable Show Detail Info" {
			// prepare for view
            let destinationVC = segue.destinationViewController as! DetailCourseViewController
            if sender != nil {
                if sender!.isKindOfClass(Course) {
                    destinationVC.course = sender as! Course
                } else if sender!.isKindOfClass(LocalCourse) {
                    destinationVC.localCourse = sender as! LocalCourse
                }
            }
		} else if segue.identifier == "Show Add Course" {
			// showing add course view
			// need to hide tab bar here
			hidesBottomBarWhenPushed = true
		}
    }
}
// MARK: - TimeTableViewDelegate
extension TimeTableViewController : TimeTableViewDelegate {
    
    func timeTableView(userDidTapOnLocalCourseCell cell: CourseCellView) {
        print(cell.localCourseInfo)
        self.performSegueWithIdentifier("Timetable Show Detail Info", sender: cell.localCourseInfo)
    }
    
    func timeTableView(userDidTapOnCourseCell cell: CourseCellView) {
        if Release.mode {
            Flurry.logEvent("v3.0: User Tap on Course on Their Timetable")
        }
        self.performSegueWithIdentifier("Timetable Show Detail Info", sender: cell.courseInfo)
    }
    
    func timeTableViewDidScroll(scrollView: UIScrollView) {
        
    }
    
    
}
