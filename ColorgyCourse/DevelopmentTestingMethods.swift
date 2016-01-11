//
//  DevelopmentTestingMethods.swift
//  ColorgyCourse
//
//  Created by David on 2016/1/8.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

class DevelopmentTestingMethods {
    
    class func deleteAllCourses() {
        if !Release().mode {
            CourseDB.deleteAllCourses()
        }
    }
    
    class func enrollAllCoursesInDB() {
        if !Release().mode {
            if let objects = ServerCourseDB.getAllStoredCoursesObject() {
                // get courses
                // tranfrom into course
                var courses = [Course]()
                for o in objects {
                    if let c = Course(courseDataFromServerDBManagedObject: o) {
                        courses.append(c)
                    }
                }
                CourseDB.storeABunchOfCoursesToDB(courses)
            }
        }
    }
    
    class func logCoursesSessionLength() {
        if !Release().mode {
            var failCounter = 0
            if let ob = ServerCourseDB.getAllStoredCoursesObject() {
                var cs = [Course]()
                for o in ob {
                    if let c = Course(courseDataFromServerDBManagedObject: o) {
                        cs.append(c)
                    }
                }
                for c in cs {
//                    print("*** course: \(c.name) day length: \(c.days?.count) \nlocation length : \(c.locations?.count) \nperiods length: \(c.periods?.count) ***")
//                    print("day == location ? \(c.days?.count == c.locations?.count)")
//                    print("period == location ? \(c.periods?.count == c.locations?.count)")
//                    print("day == period ? \(c.days?.count == c.periods?.count)")
                    if !(c.days?.count == c.locations?.count) && (c.periods?.count == c.locations?.count) && (c.days?.count == c.periods?.count) {
                        print("*** course: \(c.name) day length: \(c.days?.count) \nlocation length : \(c.locations?.count) \nperiods length: \(c.periods?.count) ***")
                        failCounter++
                    }
                }
                print(cs.count)
                print(failCounter)
                print(failCounter)
            }
        }
    }
    
    class func changeSchool(school: String) {
        if !Release().mode {
            ColorgyAPI.PATCHUserInfo(school, department: "000", year: "2012", success: { () -> Void in
                print("to \(school)")
                print("to \(school)")
                }, failure: { () -> Void in
                    print("fail")
                    print("to \(school)")
            })
        }
    }
    
    class func testSchoolPeriods() {
        if !Release().mode {
            // get schools
            ColorgyAPI.getSchools({ (schools) -> Void in
                print(schools)
                for s in schools {
                    ColorgyAPI.getSchoolPeriodDataWithSchool(s.code, completionHandler: { (periodDataObjects) -> Void in
                        print(periodDataObjects)
                    })
                }
                print("")
                // loop period data
                }, failure: { () -> Void in
                    
            })
        }
    }
}