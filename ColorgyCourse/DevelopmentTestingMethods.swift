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
}