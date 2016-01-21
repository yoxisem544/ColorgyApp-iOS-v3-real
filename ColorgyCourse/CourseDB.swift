//
//  CourseDataBase.swift
//  ColorgyAPIHandler
//
//  Created by David on 2015/8/22.
//  Copyright (c) 2015年 David. All rights reserved.
//

import Foundation
import CoreData

class CourseDB {
    
    static let entityName = "CourseDBManagedObject"
    
    // delete all
    /// This method will delete all courses stored in data base.
    class func deleteAllCourses() {
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: entityName)
        do {
            let coursesInDB: [CourseDBManagedObject] = try managedObjectContext.executeFetchRequest(fetchRequest) as! [CourseDBManagedObject]
            for courseObject in coursesInDB {
                managedObjectContext.deleteObject(courseObject)
            }
            dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                do {
                    try managedObjectContext.save()
                } catch {
                    print(ColorgyErrorType.DBFailure.saveFail)
                }
            })
        } catch {
            print(ColorgyErrorType.DBFailure.fetchFail)
        }
    }
    // delete specific course using code: String
    /// You can delete a course with a specific course code.
    ///
    /// :param: code: a specific course code
    class func deleteCourseWithCourseCode(code: String) {
        if let courseObjects = CourseDB.getAllStoredCoursesObject() {
            for courseObject in courseObjects {
                if courseObject.code == code {
                    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
                    managedObjectContext.deleteObject(courseObject)
                    dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                        do {
                            try managedObjectContext.save()
                        } catch {
                            print(ColorgyErrorType.DBFailure.saveFail)
                        }
                    })
                }
            }
        }
    }
    
    // store course with a object??? maybe call this a courseRawData
    
    // get out all courses
    /// You can get all courses stored in data base.
    /// @link hello
    ///
    /// :returns: [CourseDBManagedObject]?
    class func getAllStoredCoursesObject() -> [CourseDBManagedObject]? {
        // TODO: we dont want to take care of dirty things, so i think i need to have a course class to handle this.
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: entityName)
        do {
            let coursesInDB: [CourseDBManagedObject] = try managedObjectContext.executeFetchRequest(fetchRequest) as! [CourseDBManagedObject]
            if coursesInDB.count == 0 {
                // return nil if element in array is zero.
                return nil
            } else {
                return coursesInDB
            }
        } catch {
            print(ColorgyErrorType.DBFailure.fetchFail)
            return nil
        }
        
    }
    
    /// store a course to DB
    class func storeCourseToDB(course: Course?) {
        // TODO: we dont want to take care of dirty things, so i think i need to have a course class to handle this.
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let courseObject = NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: managedObjectContext) as! CourseDBManagedObject
        if let course = course {
            
            courseObject.code = course.code
            courseObject.name = course.name
            courseObject.lecturer = course.lecturer
            courseObject.code = course.code
            
            //                courseObject.id = course.id
            courseObject.type = course._type
            courseObject.year = Int32(course.year)
            courseObject.term = Int32(course.term)
            if let credits = course.credits {
                courseObject.credits = Int32(credits)
            }
            
            courseObject.general_code = course.general_code
            //                courseObject.color_of_cell
            
            // prepare
            // this part seemed cant use this to store things.
            // must store it seperatly.
            //            var daysRawData = [courseObject.day_1 ,courseObject.day_2 ,courseObject.day_3 ,courseObject.day_4 ,courseObject.day_5 ,courseObject.day_6 ,courseObject.day_7 ,courseObject.day_8 ,courseObject.day_9]
            //            var periodsRawData = [courseObject.period_1 ,courseObject.period_2 ,courseObject.period_3 ,courseObject.period_4 ,courseObject.period_5 ,courseObject.period_6 ,courseObject.period_7 ,courseObject.period_8 ,courseObject.period_9]
            //            var locationsRawData = [courseObject.location_1 ,courseObject.location_2 ,courseObject.location_3 ,courseObject.location_4 ,courseObject.location_5 ,courseObject.location_6 ,courseObject.location_7 ,courseObject.location_8 ,courseObject.location_9]
            // loop
            //                if (course.days?.count > 0) && (course.periods?.count > 0) {
            //                    println("course.sessionLength \(course.sessionLength)")
            //                    for index in 0..<course.sessionLength {
            //                        println("index \(index)")
            //                        println("daysRawData[index] \(daysRawData[index])")
            //                        println("Int32(course.days![index]) \(Int32(course.days![index]))")
            //                        println("daysRawData[index] \(daysRawData[index])")
            //                        daysRawData[index] = Int32(course.days![index])
            //                        periodsRawData[index] = Int32(course.periods![index])
            //                        locationsRawData[index] = course.locations?[index]
            //                    }
            //                }
            
            //
            if (course.days?.count > 0) && (course.periods?.count > 0) {
                if course.days?.count >= 1 && course.periods?.count >= 1 {
                    courseObject.day_1 = Int32(course.days![1 - 1])
                    courseObject.period_1 = Int32(course.periods![1 - 1])
                    courseObject.location_1 = course.locations?[1 - 1]
                }
                print("Int32(course.days![1 - 1]) \(Int32(course.days![1 - 1]))")
                print("Int32(course.periods![1 - 1]) \(Int32(course.periods![1 - 1]))")
                print("courseObject.day_1 \(courseObject.day_1)")
                print("courseObject.period_1 \(courseObject.period_1)")
                print("courseObject.location_1 \(courseObject.location_1)")
                if course.days?.count >= 2 && course.periods?.count >= 2 {
                    courseObject.day_2 = Int32(course.days![2 - 1])
                    courseObject.period_2 = Int32(course.periods![2 - 1])
                    courseObject.location_2 = course.locations?[2 - 1]
                }
                if course.days?.count >= 3 && course.periods?.count >= 3 {
                    courseObject.day_3 = Int32(course.days![3 - 1])
                    courseObject.period_3 = Int32(course.periods![3 - 1])
                    courseObject.location_3 = course.locations?[3 - 1]
                }
                if course.days?.count >= 4 && course.periods?.count >= 4 {
                    courseObject.day_4 = Int32(course.days![4 - 1])
                    courseObject.period_4 = Int32(course.periods![4 - 1])
                    courseObject.location_4 = course.locations?[4 - 1]
                }
                if course.days?.count >= 5 && course.periods?.count >= 5 {
                    courseObject.day_5 = Int32(course.days![5 - 1])
                    courseObject.period_5 = Int32(course.periods![5 - 1])
                    courseObject.location_5 = course.locations?[5 - 1]
                }
                if course.days?.count >= 6 && course.periods?.count >= 6 {
                    courseObject.day_6 = Int32(course.days![6 - 1])
                    courseObject.period_6 = Int32(course.periods![6 - 1])
                    courseObject.location_6 = course.locations?[6 - 1]
                }
                if course.days?.count >= 7 && course.periods?.count >= 7 {
                    courseObject.day_7 = Int32(course.days![7 - 1])
                    courseObject.period_7 = Int32(course.periods![7 - 1])
                    courseObject.location_7 = course.locations?[7 - 1]
                }
                if course.days?.count >= 8 && course.periods?.count >= 8 {
                    courseObject.day_8 = Int32(course.days![8 - 1])
                    courseObject.period_8 = Int32(course.periods![8 - 1])
                    courseObject.location_8 = course.locations?[8 - 1]
                }
                if course.days?.count >= 9 && course.periods?.count >= 9 {
                    courseObject.day_9 = Int32(course.days![9 - 1])
                    courseObject.period_9 = Int32(course.periods![9 - 1])
                    courseObject.location_9 = course.locations?[9 - 1]
                }
                
            }
            
            // save
            // TODO: fuck the nil
            dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                do {
                    try managedObjectContext.save()
                } catch {
                    print(ColorgyErrorType.DBFailure.saveFail)
                }
            })
        }
    }
    
    /// store a course to DB
    class func storeABunchOfCoursesToDB(courses: [Course]?) {
        // TODO: we dont want to take care of dirty things, so i think i need to have a course class to handle this.
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        //        let courseObject = NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: managedObjectContext) as! CourseDBManagedObject
        if let courses = courses {
            for course in courses {
                let courseObject = NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: managedObjectContext) as! CourseDBManagedObject
                courseObject.code = course.code
                courseObject.name = course.name
                courseObject.lecturer = course.lecturer
                courseObject.code = course.code
                
                //                courseObject.id = course.id
                courseObject.type = course._type
                courseObject.year = Int32(course.year)
                courseObject.term = Int32(course.term)
                if let credits = course.credits {
                    courseObject.credits = Int32(credits)
                }
                
                courseObject.general_code = course.general_code
                //                courseObject.color_of_cell
                
                // prepare
                // this part seemed cant use this to store things.
                // must store it seperatly.
                //            var daysRawData = [courseObject.day_1 ,courseObject.day_2 ,courseObject.day_3 ,courseObject.day_4 ,courseObject.day_5 ,courseObject.day_6 ,courseObject.day_7 ,courseObject.day_8 ,courseObject.day_9]
                //            var periodsRawData = [courseObject.period_1 ,courseObject.period_2 ,courseObject.period_3 ,courseObject.period_4 ,courseObject.period_5 ,courseObject.period_6 ,courseObject.period_7 ,courseObject.period_8 ,courseObject.period_9]
                //            var locationsRawData = [courseObject.location_1 ,courseObject.location_2 ,courseObject.location_3 ,courseObject.location_4 ,courseObject.location_5 ,courseObject.location_6 ,courseObject.location_7 ,courseObject.location_8 ,courseObject.location_9]
                // loop
                //                if (course.days?.count > 0) && (course.periods?.count > 0) {
                //                    println("course.sessionLength \(course.sessionLength)")
                //                    for index in 0..<course.sessionLength {
                //                        println("index \(index)")
                //                        println("daysRawData[index] \(daysRawData[index])")
                //                        println("Int32(course.days![index]) \(Int32(course.days![index]))")
                //                        println("daysRawData[index] \(daysRawData[index])")
                //                        daysRawData[index] = Int32(course.days![index])
                //                        periodsRawData[index] = Int32(course.periods![index])
                //                        locationsRawData[index] = course.locations?[index]
                //                    }
                //                }
                
                //
                if (course.days?.count > 0) && (course.periods?.count > 0) {
                    if course.days?.count >= 1 && course.periods?.count >= 1 {
                        courseObject.day_1 = Int32(course.days![1 - 1])
                        courseObject.period_1 = Int32(course.periods![1 - 1])
                        courseObject.location_1 = course.locations?[1 - 1]
                    }
                    print("Int32(course.days![1 - 1]) \(Int32(course.days![1 - 1]))")
                    print("Int32(course.periods![1 - 1]) \(Int32(course.periods![1 - 1]))")
                    print("courseObject.day_1 \(courseObject.day_1)")
                    print("courseObject.period_1 \(courseObject.period_1)")
                    print("courseObject.location_1 \(courseObject.location_1)")
                    if course.days?.count >= 2 && course.periods?.count >= 2 {
                        courseObject.day_2 = Int32(course.days![2 - 1])
                        courseObject.period_2 = Int32(course.periods![2 - 1])
                        courseObject.location_2 = course.locations?[2 - 1]
                    }
                    if course.days?.count >= 3 && course.periods?.count >= 3 {
                        courseObject.day_3 = Int32(course.days![3 - 1])
                        courseObject.period_3 = Int32(course.periods![3 - 1])
                        courseObject.location_3 = course.locations?[3 - 1]
                    }
                    if course.days?.count >= 4 && course.periods?.count >= 4 {
                        courseObject.day_4 = Int32(course.days![4 - 1])
                        courseObject.period_4 = Int32(course.periods![4 - 1])
                        courseObject.location_4 = course.locations?[4 - 1]
                    }
                    if course.days?.count >= 5 && course.periods?.count >= 5 {
                        courseObject.day_5 = Int32(course.days![5 - 1])
                        courseObject.period_5 = Int32(course.periods![5 - 1])
                        courseObject.location_5 = course.locations?[5 - 1]
                    }
                    if course.days?.count >= 6 && course.periods?.count >= 6 {
                        courseObject.day_6 = Int32(course.days![6 - 1])
                        courseObject.period_6 = Int32(course.periods![6 - 1])
                        courseObject.location_6 = course.locations?[6 - 1]
                    }
                    if course.days?.count >= 7 && course.periods?.count >= 7 {
                        courseObject.day_7 = Int32(course.days![7 - 1])
                        courseObject.period_7 = Int32(course.periods![7 - 1])
                        courseObject.location_7 = course.locations?[7 - 1]
                    }
                    if course.days?.count >= 8 && course.periods?.count >= 8 {
                        courseObject.day_8 = Int32(course.days![8 - 1])
                        courseObject.period_8 = Int32(course.periods![8 - 1])
                        courseObject.location_8 = course.locations?[8 - 1]
                    }
                    if course.days?.count >= 9 && course.periods?.count >= 9 {
                        courseObject.day_9 = Int32(course.days![9 - 1])
                        courseObject.period_9 = Int32(course.periods![9 - 1])
                        courseObject.location_9 = course.locations?[9 - 1]
                    }
                    
                }
            }
        }
        // save
        // TODO: fuck the nil
        dispatch_sync(dispatch_get_main_queue(), { () -> Void in
            do {
                try managedObjectContext.save()
            } catch {
                print(ColorgyErrorType.DBFailure.saveFail)
            }
        })
    }
    
    // fake data
    class func storeFakeData() {
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let courseObject = NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: managedObjectContext) as! CourseDBManagedObject
        // assign data
        courseObject.name = "自動化工程"
        courseObject.lecturer = "蔡明忠"
        courseObject.year = 2015
        courseObject.term = 1
        courseObject.code = "1041-AC5007701"
        courseObject.credits = 3
        
        // save
        dispatch_sync(dispatch_get_main_queue(), { () -> Void in
            do {
                try managedObjectContext.save()
            } catch {
                print(ColorgyErrorType.DBFailure.saveFail)
            }
        })
    }
    
    // MARK: - for server db
    
    
}