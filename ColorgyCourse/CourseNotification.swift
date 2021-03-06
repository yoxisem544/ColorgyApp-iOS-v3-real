//
//  CourseNotification.swift
//  ColorgyCourse
//
//  Created by David on 2015/9/7.
//  Copyright (c) 2015年 David. All rights reserved.
//

import Foundation

class CourseNotification {
    class func registerForCourseNotification() {
        // delete all
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        if UserSetting.isCourseNotificationOn() {
            // then register new one
			print(UserSetting.getPeriodData())
			CourseDB.getAllStoredCourses(complete: { (courses) -> Void in
				if let courses = courses {
					// get out all course stored in db
					for course in courses {
						let needNotifiedCourses = checkNeedNotifiedCourse(course)
						print(needNotifiedCourses)
						for needNotifiedCourse in needNotifiedCourses {
							setupNotificationWithMessage(course, day: needNotifiedCourse.day, session: needNotifiedCourse.period, index: needNotifiedCourse.index)
						}
					}
				}
				print(UIApplication.sharedApplication().scheduledLocalNotifications)
//				print("")
				LocalCourseDB.getAllStoredCourses(complete: { (localCourses) -> Void in
					if let localCourses = localCourses {
						// get out all course stored in db
						for course in localCourses {
							let needNotifiedCourses = checkNeedNotifiedLocalCourse(course)
							print(needNotifiedCourses)
							for needNotifiedCourse in needNotifiedCourses {
								setupNotificationWithMessage(course, day: needNotifiedCourse.day, session: needNotifiedCourse.period, index: needNotifiedCourse.index)
							}
						}
					}
//					print(UIApplication.sharedApplication().scheduledLocalNotifications)
//					print("")
				})
			})
        }
    }
    
    class func checkNeedNotifiedCourse(course: Course) -> [(day: Int, period: Int, index: Int)] {
        if course.sessionLength > 0 {
            // if course if more then one period per week
            var needNotifiedCourses: [(day: Int, period: Int, index: Int)] = []
            if let days = course.days {
                // loop thorugh days inside course
                if let periods = course.periods {
                    for sajk in days.enumerate() {
                        sajk.element
                    }
                    for dayOfCourse in days.enumerate() {
                        // check every index of course
                        let currentCourse = (day: dayOfCourse.element, period: periods[dayOfCourse.index])
                        // loop through all course and check
                        // rules: check day first, then check if previous session has same course
                        var needNotify = true
                        for indexLoop in 0..<periods.count {
                            let checkPointCourse = (day: days[indexLoop], period: periods[indexLoop])
                            // check if is the same day
                            if currentCourse.day == checkPointCourse.day {
                                // then check previous one
                                if checkPointCourse.period == (currentCourse.period - 1) {
                                    // if pervious one is same, then make then mark to false.
                                    needNotify = false
                                }
                            }
                        }
                        // check if need to append this current course index
                        if needNotify {
                            needNotifiedCourses.append((day: currentCourse.day, period: currentCourse.period, index: dayOfCourse.index))
                        }
                    }
                }
            }
            // prepare to return
//            print("course \(course)")
//            print("needNotifiedCourses \(needNotifiedCourses)")
            return needNotifiedCourses
        }
//        print("course \(course)")
//        print("needNotifiedCourses \([])")
        return []
    }
    
    class func checkNeedNotifiedLocalCourse(course: LocalCourse) -> [(day: Int, period: Int, index: Int)] {
        if course.sessionLength > 0 {
            // if course if more then one period per week
            var needNotifiedCourses: [(day: Int, period: Int, index: Int)] = []
            if let days = course.days {
                // loop thorugh days inside course
                if let periods = course.periods {
                    for sajk in days.enumerate() {
                        sajk.element
                    }
                    for dayOfCourse in days.enumerate() {
                        // check every index of course
                        let currentCourse = (day: dayOfCourse.element, period: periods[dayOfCourse.index])
                        // loop through all course and check
                        // rules: check day first, then check if previous session has same course
                        var needNotify = true
                        for indexLoop in 0..<periods.count {
                            let checkPointCourse = (day: days[indexLoop], period: periods[indexLoop])
                            // check if is the same day
                            if currentCourse.day == checkPointCourse.day {
                                // then check previous one
                                if checkPointCourse.period == (currentCourse.period - 1) {
                                    // if pervious one is same, then make then mark to false.
                                    needNotify = false
                                }
                            }
                        }
                        // check if need to append this current course index
                        if needNotify {
                            needNotifiedCourses.append((day: currentCourse.day, period: currentCourse.period, index: dayOfCourse.index))
                        }
                    }
                }
            }
            // prepare to return
            //            print("course \(course)")
            //            print("needNotifiedCourses \(needNotifiedCourses)")
            return needNotifiedCourses
        }
        //        print("course \(course)")
        //        print("needNotifiedCourses \([])")
        return []
    }
    
    class func setupNotificationWithMessage(course: Course, day: Int, session: Int, index: Int) {
        
        let periodData = UserSetting.getPeriodData()
        let calendar = NSCalendar.currentCalendar()
        let component = NSDateComponents()
        component.year = 2014
        component.month = 12
        component.day = day
        var time: String?
        for period in periodData {
            if period["order"] == "\(session)" {
                time = period["time"]
            }
        }
        if let time = time {
            if let startTime = time.componentsSeparatedByString("-").first {
                // if get start time
                // if there is no first time component, set string to -, then convertion will fail.
                if let startTimeHour = Int(startTime.componentsSeparatedByString(":").first ?? "-") {
                    if let startTimeMinute = Int(startTime.componentsSeparatedByString(":").last ?? "-") {
                        let notificationTime = UserSetting.getCourseNotificationTime()
                        let notitficationHour = notificationTime / 60
                        let notificationMinute = notificationTime % 60
                        component.hour = startTimeHour - notitficationHour
                        component.minute = startTimeMinute - notificationMinute
                        if (startTimeMinute - notificationMinute) < 0 {
                            // less then 10 mins
                            component.hour = startTimeHour - notitficationHour - 1
                            component.minute = (startTimeMinute - notificationMinute) + 60
                        }
                        // got hour and minute
                        component.second = 0
                        calendar.timeZone = NSTimeZone.defaultTimeZone()
                        let dateToFire = calendar.dateFromComponents(component)
//                        print("day: \(day), session: \(session) on component \(component)")
                        // set up local notification
                        let localNotification = UILocalNotification()
                        localNotification.timeZone = NSTimeZone.defaultTimeZone()
                        localNotification.fireDate = dateToFire
//                        localNotification.repeatInterval = NSCalendarUnit.WeekCalendarUnit
                        // TODO: week???
                        localNotification.repeatInterval = NSCalendarUnit.WeekOfYear
						let location = course.locations?[index] ?? ""
                        let message = "\(startTime) 在 \(location) 上 \(course.name)"
//                        print(message)
                        localNotification.alertBody = message
                        localNotification.soundName = "default"
                        
                        let currentBadgeCount = UIApplication.sharedApplication().applicationIconBadgeNumber
                        localNotification.applicationIconBadgeNumber = currentBadgeCount + 1
                        
                        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
                    }
                }
            }
        }
    }
    
    class func setupNotificationWithMessage(localCourse: LocalCourse, day: Int, session: Int, index: Int) {
        
        let periodData = UserSetting.getPeriodData()
        let calendar = NSCalendar.currentCalendar()
        let component = NSDateComponents()
        component.year = 2014
        component.month = 12
        component.day = day
        var time: String?
        for period in periodData {
            if period["order"] == "\(session)" {
                time = period["time"]
            }
        }
        if let time = time {
            if let startTime = time.componentsSeparatedByString("-").first {
                // if get start time
                // if there is no first time component, set string to -, then convertion will fail.
                if let startTimeHour = Int(startTime.componentsSeparatedByString(":").first ?? "-") {
                    if let startTimeMinute = Int(startTime.componentsSeparatedByString(":").last ?? "-") {
                        let notificationTime = UserSetting.getCourseNotificationTime()
                        let notitficationHour = notificationTime / 60
                        let notificationMinute = notificationTime % 60
                        component.hour = startTimeHour - notitficationHour
                        component.minute = startTimeMinute - notificationMinute
                        if (startTimeMinute - notificationMinute) < 0 {
                            // less then 10 mins
                            component.hour = startTimeHour - notitficationHour - 1
                            component.minute = (startTimeMinute - notificationMinute) + 60
                        }
                        // got hour and minute
                        component.second = 0
                        calendar.timeZone = NSTimeZone.defaultTimeZone()
                        let dateToFire = calendar.dateFromComponents(component)
                        //                        print("day: \(day), session: \(session) on component \(component)")
                        // set up local notification
                        let localNotification = UILocalNotification()
                        localNotification.timeZone = NSTimeZone.defaultTimeZone()
                        localNotification.fireDate = dateToFire
                        //                        localNotification.repeatInterval = NSCalendarUnit.WeekCalendarUnit
                        // TODO: week???
                        localNotification.repeatInterval = NSCalendarUnit.WeekOfYear
                        let location = localCourse.locations?[index] ?? ""
                        let message = "\(startTime) 在 \(location) 上 \(localCourse.name)"
                        print(message)
                        localNotification.alertBody = message
                        localNotification.soundName = "default"
                        
                        let currentBadgeCount = UIApplication.sharedApplication().applicationIconBadgeNumber
                        localNotification.applicationIconBadgeNumber = currentBadgeCount + 1
                        
                        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
                    }
                }
            }
        }
    }
}