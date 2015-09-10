//
//  CourseUpdateHelper.swift
//  ColorgyCourse
//
//  Created by David on 2015/9/8.
//  Copyright (c) 2015年 David. All rights reserved.
//

import Foundation


class CourseUpdateHelper {
    private struct Key {
        static let needUpdateKey = "CourseNeedUpdateKey"
    }
    
    class func needUpdateCourse() {
        let ud = NSUserDefaults.standardUserDefaults()
        ud.setBool(true, forKey: Key.needUpdateKey)
        ud.synchronize()
    }
    
    class func finishUpdateCourse() {
        let ud = NSUserDefaults.standardUserDefaults()
        ud.setBool(false, forKey: Key.needUpdateKey)
        ud.synchronize()
    }
    
    class func shouldUpdateCourse() -> Bool {
        let ud = NSUserDefaults.standardUserDefaults()
        return ud.boolForKey(Key.needUpdateKey)
    }
    
    class func updateCourse(didUpdateCourse: () -> Void) {
        // check if need update
        if self.shouldUpdateCourse() {
            // get data from server
            downloadCourse({ (courses) -> Void in
                // parse

                // compare
                
                // maybe delete all and store
                CourseDB.deleteAllCourses()
                // store
                CourseDB.storeABunchOfCoursesToDB(courses)
                // setup notifications
    //            CourseNotification.registerForCourseNotification()
                
                // cancel need update
                self.finishUpdateCourse()
                
                // return a code block
                didUpdateCourse()
            }, failure: { () -> Void in
                
            })
        }
    }
    
    class func downloadCourse(success: (courses: [Course]) -> Void, failure: () -> Void) {
        let qos = Int(QOS_CLASS_USER_INITIATED.value)
        //        let qos = Int(QOS_CLASS_USER_INTERACTIVE.value)
        dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in
            var courses = [Course]()
            var counter = 0
            ColorgyAPI.getMeCourses({ (userCourseObjects) -> Void in
                if let userCourseObjects = userCourseObjects {
                    counter = userCourseObjects.count
                    for object in userCourseObjects {
                        ColorgyAPI.getCourseRawDataObjectWithCourseCode(object.course_code, completionHandler: { (courseRawDataObject) -> Void in
                            //                            let qos = Int(QOS_CLASS_USER_INTERACTIVE.value)
                            let qos = Int(QOS_CLASS_USER_INITIATED.value)
                            dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in
                                if let courseRawDataObject = courseRawDataObject {
                                    if let course = Course(rawData: courseRawDataObject) {
//                                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                            courses.append(course)
                                            var b = NSDate()
                                            println("counter is \(counter)")
                                            if counter == courses.count {
                                                success(courses: courses)
                                            }
                                            var now = NSDate().timeIntervalSinceDate(b)
                                            println(now*1000)
//                                        })
                                    }
                                } else {
                                    counter--
                                }
                            })
                        })
                    }
                }
                }, failure: { () -> Void in
                    
            })
        })
    }
}