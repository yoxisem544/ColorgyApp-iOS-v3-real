//
//  LocalCourseDB.swift
//  ColorgyCourse
//
//  Created by David on 2016/1/4.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation
import CoreData

class LocalCourseDB {
    
    static let entityName = "LocalCourseDBManagedObject"
    
    // delete all
    /// This method will delete all courses stored in data base.
    class func deleteAllCourses() {
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: entityName)
        do {
            let coursesInDB: [LocalCourseDBManagedObject] = try managedObjectContext.executeFetchRequest(fetchRequest) as! [LocalCourseDBManagedObject]
            for courseObject in coursesInDB {
                managedObjectContext.deleteObject(courseObject)
            }
            do {
                try managedObjectContext.save()
            } catch {
                print(ColorgyErrorType.DBFailure.saveFail)
            }
        } catch {
            print(ColorgyErrorType.DBFailure.fetchFail)
        }
    }
    
    // get out all courses
    /// You can get all local courses stored in data base.
    /// @link hello
    ///
    /// :returns: [LocalCourseDBManagedObject]?
    class func getAllStoredCoursesObject() -> [LocalCourseDBManagedObject]? {
        // TODO: we dont want to take care of dirty things, so i think i need to have a course class to handle this.
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: entityName)
        do {
            let coursesInDB: [LocalCourseDBManagedObject] = try managedObjectContext.executeFetchRequest(fetchRequest) as! [LocalCourseDBManagedObject]
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
}