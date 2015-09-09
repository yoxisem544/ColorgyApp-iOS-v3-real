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
        // then register new one
        if let objects = CourseDB.getAllStoredCoursesObject() {
            var courses = [Course]()
            for object in objects {
                if let course = Course(courseDBManagedObject: object) {
                    courses.append(course)
                }
            }
            // get out all course stored in db
            for course in courses {
                var needNotifiedCourses = checkNeedNotifiedCourse(course)
                for needNotifiedCourse in needNotifiedCourses {
                    setupNotificationWithMessage(course, day: needNotifiedCourse.day, session: needNotifiedCourse.period, index: needNotifiedCourse.index)
                }
            }
            
            println(UIApplication.sharedApplication().scheduledLocalNotifications)
        }
    }
    
    class func checkNeedNotifiedCourse(course: Course) -> [(day: Int, period: Int, index: Int)] {
        if course.sessionLength > 0 {
            // if course if more then one period per week
            var needNotifiedCourses: [(day: Int, period: Int, index: Int)] = []
            if let days = course.days {
                // loop thorugh days inside course
                if let periods = course.periods {
                    for (index: Int, day: Int) in enumerate(days) {
                        // check every index of course
                        let currentCourse = (day: day, period: periods[index])
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
                            needNotifiedCourses.append((day: currentCourse.day, period: currentCourse.period, index: index))
                        }
                    }
                }
            }
            // prepare to return
            println("course \(course)")
            println("needNotifiedCourses \(needNotifiedCourses)")
            return needNotifiedCourses
        }
        println("course \(course)")
        println("needNotifiedCourses \([])")
        return []
    }
    
    class func setupNotificationWithMessage(course: Course, day: Int, session: Int, index: Int) {
        
        let ud = NSUserDefaults.standardUserDefaults()
        let periodData = UserSetting.getPeriodData()
        var calendar = NSCalendar.currentCalendar()
        var component = NSDateComponents()
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
                if let startTimeHour = startTime.componentsSeparatedByString(":").first?.toInt() {
                    if let startTimeMinute = startTime.componentsSeparatedByString(":").last?.toInt() {
                        component.hour = startTimeHour
                        component.minute = startTimeMinute - 10
                        if (startTimeMinute - 10) < 0 {
                            // less then 10 mins
                            component.hour = startTimeHour - 1
                            component.minute = (startTimeMinute - 10) + 60
                        }
                        // got hour and minute
                        component.second = 0
                        calendar.timeZone = NSTimeZone.defaultTimeZone()
                        var dateToFire = calendar.dateFromComponents(component)
                        println("day: \(day), session: \(session) on component \(component)")
                        // set up local notification
                        let localNotification = UILocalNotification()
                        localNotification.timeZone = NSTimeZone.defaultTimeZone()
                        localNotification.fireDate = dateToFire
                        localNotification.repeatInterval = NSCalendarUnit.WeekCalendarUnit
                        let location = course.locations?[index] ?? ""
                        var message = "\(startTime) 在 \(location) 上 \(course.name)"
                        println(message)
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