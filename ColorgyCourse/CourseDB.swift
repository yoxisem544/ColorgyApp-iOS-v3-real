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
    
    // delete all
    /// This method will delete all courses stored in data base.
    class func deleteAllCourses() {
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext {
            let fetchRequest = NSFetchRequest(entityName: "Course")
            var e: NSError?
            var coursesInDB: [CourseDBManagedObject] = managedObjectContext.executeFetchRequest(fetchRequest, error: &e) as! [CourseDBManagedObject]
            if e != nil {
                println(ColorgyErrorType.DBFailure.fetchFail)
            } else {
                // nothing wrong
                for courseObject in coursesInDB {
                    managedObjectContext.deleteObject(courseObject)
                }
                managedObjectContext.save(&e)
                if e != nil {
                    println(ColorgyErrorType.DBFailure.saveFail)
                }
            }
        }
    }
    // delete specific course using code: String
    /// You can delete a course with a specific course code.
    ///
    /// :param: code: a specific course code
    class func deleteCourseWithCourseCode(code: String) {
        if let courseObjects = CourseDB.getAllStoredCoursesObject() {
            for courseObject in courseObjects {
                if courseObject.uuid == code {
                    if let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext {
                        var e: NSError?
                        managedObjectContext.deleteObject(courseObject)
                        if managedObjectContext.save(&e) != true {
                            println(ColorgyErrorType.DBFailure.saveFail)
                        }
                    }
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
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext {
            let fetchRequest = NSFetchRequest(entityName: "Course")
            var e: NSError?
            var coursesInDB: [CourseDBManagedObject] = managedObjectContext.executeFetchRequest(fetchRequest, error: &e) as! [CourseDBManagedObject]
            if e != nil {
                println(ColorgyErrorType.DBFailure.fetchFail)
            } else if coursesInDB.count == 0 {
                // return nil if element in array is zero.
                return nil
            } else {
                return coursesInDB
            }
        }
        return nil
    }
    
    // fake data
    class func storeFakeData() {
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext {
            var courseObject = NSEntityDescription.insertNewObjectForEntityForName("Course", inManagedObjectContext: managedObjectContext) as! CourseDBManagedObject
            // assign data
            courseObject.name = "自動化工程"
            courseObject.lecturer = "蔡明忠"
            courseObject.year = 2015
            courseObject.term = 1
            courseObject.uuid = "1041-AC5007701"
            courseObject.credits = 3
            
            // save
            var e: NSError?
            if managedObjectContext.save(&e) != true {
                println(ColorgyErrorType.DBFailure.saveFail)
            }
        }
    }
}