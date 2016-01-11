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
            var invalidSchool = [String]()
            var validSchool = [String]()
            // get schools
            ColorgyAPI.getSchools({ (schools) -> Void in
                for s in schools {
                    ColorgyAPI.getSchoolPeriodDataWithSchool(s.code, completionHandler: { (periodDataObjects) -> Void in
                        if let periodDataObjects = periodDataObjects {
                            if periodDataObjects.count > 0 {
                                print("\(s.name) has time.")
                                print(periodDataObjects)
                                let time = periodDataObjects[0].time
                                if time != "" {
                                    validSchool.append(s.name)
                                } else {
                                    invalidSchool.append(s.name)
                                }
                            } else {
                                invalidSchool.append(s.name)
                            }
                        } else {
                            invalidSchool.append(s.name)
                        }
                        print("有時間的：\(validSchool)")
                        print("沒時間的：\(invalidSchool)")
                    })
                }
                print("")
                // loop period data
                }, failure: { () -> Void in
                    
            })
        }
    }
    
    class func testGetDepartment(school: String) {
        if !Release().mode {
            ColorgyAPI.getDepartments(school, success: { (departments) -> Void in
                print(departments)
                }, failure: { () -> Void in
                    
            })
        }
    }
}