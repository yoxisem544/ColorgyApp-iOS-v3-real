//
//  LocalCourseManagedObject.swift
//  ColorgyCourse
//
//  Created by David on 2016/1/4.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation
import CoreData

class LocalCourseDBManagedObject : NSManagedObject {
    
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
    @NSManaged var color_of_cell: String?
    
    override var description: String { return "{\n\tcode: \(code)\n\tname: \(name)\n\tyear: \(year)\n\tterm: \(term)\n\tlecturer: \(lecturer)\n\tcredits: \(credits)\n\t_type: \(type)\n\tday_1: \(day_1)\n\tday_2: \(day_2)\n\tday_3: \(day_3)\n\tday_4: \(day_4)\n\tday_5: \(day_5)\n\tday_6: \(day_6)\n\tday_7: \(day_7)\n\tday_8: \(day_8)\n\tday_9: \(day_9)\n\tperiod_1: \(period_1)\n\tperiod_2: \(period_2)\n\tperiod_3: \(period_3)\n\tperiod_4: \(period_4)\n\tperiod_5: \(period_5)\n\tperiod_6: \(period_6)\n\tperiod_7: \(period_7)\n\tperiod_8: \(period_8)\n\tperiod_9: \(period_9)\n\tlocation_1: \(location_1)\n\tlocation_2: \(location_2)\n\tlocation_3: \(location_3)\n\tlocation_4: \(location_4)\n\tlocation_5: \(location_5)\n\tlocation_6: \(location_6)\n\tlocation_7: \(location_7)\n\tlocation_8: \(location_8)\n\tlocation_9: \(location_9)\n\tgeneral_code: \(general_code)\n}" }
}