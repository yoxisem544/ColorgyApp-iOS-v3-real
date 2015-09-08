//
//  ServerCourseDB.swift
//  ColorgyCourse
//
//  Created by David on 2015/9/8.
//  Copyright (c) 2015年 David. All rights reserved.
//

import Foundation
import CoreData

class ServerCourseDB {
    /// This method will delete all courses stored in data base.
    class func deleteAllCourses() {
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext {
            let fetchRequest = NSFetchRequest(entityName: "CourseDataFromServer")
            var e: NSError?
            var coursesInDB: [CourseDataFromServerDBManagedObject] = managedObjectContext.executeFetchRequest(fetchRequest, error: &e) as! [CourseDataFromServerDBManagedObject]
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
}