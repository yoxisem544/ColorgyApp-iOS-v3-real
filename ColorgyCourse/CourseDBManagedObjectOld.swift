//
//  CourseDBManagedObjectOld.swift
//  ColorgyCourse
//
//  Created by David on 2015/9/5.
//  Copyright (c) 2015年 David. All rights reserved.
//

import Foundation
import CoreData

class CourseDBManagedObjectOld: NSManagedObject {
    
    @NSManaged var name: String!
    @NSManaged var lecturer: String!
    @NSManaged var credits: Int32
    @NSManaged var uuid: String!
    
    @NSManaged var id: Int32
    @NSManaged var type: String
    @NSManaged var year: Int32
    @NSManaged var term: Int32
    
    @NSManaged var day_1: String!
    @NSManaged var day_2: String!
    @NSManaged var day_3: String!
    @NSManaged var day_4: String!
    @NSManaged var day_5: String!
    @NSManaged var day_6: String!
    @NSManaged var day_7: String!
    @NSManaged var day_8: String!
    @NSManaged var day_9: String!
    
    @NSManaged var period_1: String!
    @NSManaged var period_2: String!
    @NSManaged var period_3: String!
    @NSManaged var period_4: String!
    @NSManaged var period_5: String!
    @NSManaged var period_6: String!
    @NSManaged var period_7: String!
    @NSManaged var period_8: String!
    @NSManaged var period_9: String!
    
    @NSManaged var location_1: String!
    @NSManaged var location_2: String!
    @NSManaged var location_3: String!
    @NSManaged var location_4: String!
    @NSManaged var location_5: String!
    @NSManaged var location_6: String!
    @NSManaged var location_7: String!
    @NSManaged var location_8: String!
    @NSManaged var location_9: String!
    
    class func deleteAll() {
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Course")
        do {
            let coursesInDBOld = try managedObjectContext.executeFetchRequest(fetchRequest) as! [CourseDBManagedObjectOld]
            for course in coursesInDBOld {
                managedObjectContext.deleteObject(course)
                do {
                    try managedObjectContext.save()
                } catch {
                    print(ColorgyErrorType.DBFailure.saveFail)
                }
            }
        } catch {
           print("fail to execute fetch request")
        }
//            var coursesInDBOld: [CourseDBManagedObjectOld] = managedObjectContext.executeFetchRequest(fetchRequest, error: &e) as! [CourseDBManagedObjectOld]
//            for course in coursesInDBOld {
//                managedObjectContext.deleteObject(course)
//                if managedObjectContext.save(&e) != true {
//                    print(ColorgyErrorType.DBFailure.saveFail)
//                }
//            }
        
    }
}