//
//  CourseDataFromServerDBManagedObject.swift
//  ColorgyCourse
//
//  Created by David on 2015/9/8.
//  Copyright (c) 2015年 David. All rights reserved.
//

import Foundation


//
//  CourseInDB.swift
//  ColorgyAPIHandler
//
//  Created by David on 2015/8/22.
//  Copyright (c) 2015年 David. All rights reserved.
//

import Foundation
import CoreData

class CourseDataFromServerDBManagedObject: NSManagedObject {
    
    @NSManaged var name: String?
    @NSManaged var lecturer: String?
    @NSManaged var credits: Int32
    @NSManaged var code: String?
    
    @NSManaged var id: Int32
    @NSManaged var type: String?
    @NSManaged var year: Int32
    @NSManaged var term: Int32
    
    @NSManaged var day_1: Int32
    @NSManaged var day_2: Int32
    @NSManaged var day_3: Int32
    @NSManaged var day_4: Int32
    @NSManaged var day_5: Int32
    @NSManaged var day_6: Int32
    @NSManaged var day_7: Int32
    @NSManaged var day_8: Int32
    @NSManaged var day_9: Int32
    
    @NSManaged var period_1: Int32
    @NSManaged var period_2: Int32
    @NSManaged var period_3: Int32
    @NSManaged var period_4: Int32
    @NSManaged var period_5: Int32
    @NSManaged var period_6: Int32
    @NSManaged var period_7: Int32
    @NSManaged var period_8: Int32
    @NSManaged var period_9: Int32
    
    @NSManaged var location_1: String?
    @NSManaged var location_2: String?
    @NSManaged var location_3: String?
    @NSManaged var location_4: String?
    @NSManaged var location_5: String?
    @NSManaged var location_6: String?
    @NSManaged var location_7: String?
    @NSManaged var location_8: String?
    @NSManaged var location_9: String?
    
    @NSManaged var general_code: String?
}
