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
        let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
        dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in
            // initiate a course array and a counter to check the counts of all downloaded course
            var courses = [Course]()
            var counter = 0
            // start to get course from server
            ColorgyAPI.getMeCourses({ (userCourseObjects) -> Void in
                // if successfully get course.
                if let userCourseObjects = userCourseObjects {
                    // get the count of downloaded courses
                    counter = userCourseObjects.count
                    // loop it
                    for object in userCourseObjects {
                        // cause the downloaded courses only have code, so need to download the complete course data using the code.
                        ColorgyAPI.getCourseRawDataObjectWithCourseCode(object.course_code, success: { (courseRawDataObject) -> Void in
                            // get into queue, not blocking the main thread.
                            let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
                            dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in
                                // this part will tranform rawData into Course object.
                                if let course = Course(rawData: courseRawDataObject) {
                                    // if course object is created, append it to the array
                                    courses.append(course)
                                    let b = NSDate()
                                    print("counter is \(counter)")
                                    // if this is the last object to be created, call success callback.
                                    if counter == courses.count {
                                        success(courses: courses)
                                    }
                                    let now = NSDate().timeIntervalSinceDate(b)
                                    print(now*1000)
                                }
                            })
                            }, failure: { () -> Void in
                                // if fail to get course, decrease one job to be download....
                                counter--
                        })
                    }
                }
                }, failure: { () -> Void in
                    
            })
        })
    }
}