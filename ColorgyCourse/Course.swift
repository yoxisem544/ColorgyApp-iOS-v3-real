//
//  File.swift
//  ColorgyAPIHandler
//
//  Created by David on 2015/8/22.
//  Copyright (c) 2015年 David. All rights reserved.
//

import Foundation

/// Course is a object that you can easily handle with the complex courses.
///
/// - Must use CourseRawData to create
///
class Course: Printable {
    

    // properties
    // what do we need of a course?
    /// Used to course code, every course has a unique code to access with.
    var code: String
    /// Course's name
    var name: String
    /// Course's year. Format: 2015, 1945, etc.
    var year: Int
    /// Course's term. Format: 1 for first semester, 2 for second semester.
    var term: Int
    /// Name of course's teacher, professor.
    var lecturer: String?
    /// Credits of course
    var credits: Int?
    /// _type of course, like "ntust_course"
    var _type: String?
    // how to configure location period ?
    /// Weekdays of course. Its an array. Wont contain nil object.
    var days: [Int]?
    /// Periods of course. Its an array. Wont contain nil object.
    var periods: [Int]?
    /// Location of course. Its an array. Wont contain nil object.
    var locations: [String]?
    
    var description: String { return "{\n\tcode: \(code)\n\tname: \(name)\n\tyear: \(year)\n\tterm: \(term)\n\tlecturer: \(lecturer)\n\tcredits: \(credits)\n\t_type: \(_type)\n\tdays: \(days)\n\tperiods: \(periods)\n\tlocations: \(locations)\n}" }
    
    private init?(code: String?, name: String?, year: Int?, term: Int?, lecturer: String?, credits: Int?, _type: String?, days: [Int]?, periods: [Int]?, locations: [String]?) {
        // optional part
        self.days = days
        self.periods = periods
        self.locations = locations
        self._type = _type
        self.lecturer = lecturer
        self.credits = credits
        // required part
        self.code = ""
        self.name = ""
        self.year = Int()
        self.term = Int()
        if let code = code {
            self.code = code
        } else {
            return nil
        }
        if let name = name {
            self.name = name
        } else {
            return nil
        }
        if let year = year {
            self.year = year
        } else {
            return nil
        }
        if let term = term {
            self.term = term
        } else {
            return nil
        }
    }
    
    /// create Course using CourseRawDataObject
    /// if CourseRawDataObject is something wrong, then this will not be created, and return nil
    ///
    /// :param: rawData: pass in a CourseRawDataObject
    ///
    /// :returns: Course
    convenience init?(rawData: CourseRawDataObject?) {
        // what do we need of a course?
        var code: String? = nil
        var name: String? = nil
        var year: Int? = nil
        var term: Int? = nil
        var lecturer: String? = nil
        var credits: Int? = nil
        var _type: String? = nil
        // how to configure location period ?
        var days: [Int]? = nil
        var periods: [Int]? = nil
        var locations: [String]? = nil
        if let rawData = rawData {
            code = rawData.uuid
            name = rawData.name
            year = rawData.year
            term = rawData.term
            lecturer = rawData.lecturer
            credits = rawData.credits
            _type = rawData.type
            if rawData.sessionLength() > 0 {
                // init days, periods, locations array.
                days = [Int]()
                periods = [Int]()
                locations = [String]()
                // prepare data...
                var daysRawData = [rawData.day_1 ,rawData.day_2 ,rawData.day_3 ,rawData.day_4 ,rawData.day_5 ,rawData.day_6 ,rawData.day_7 ,rawData.day_8 ,rawData.day_9]
                var periodsRawData = [rawData.period_1 ,rawData.period_2 ,rawData.period_3 ,rawData.period_4 ,rawData.period_5 ,rawData.period_6 ,rawData.period_7 ,rawData.period_8 ,rawData.period_9]
                var locationsRawData = [rawData.location_1 ,rawData.location_2 ,rawData.location_3 ,rawData.location_4 ,rawData.location_5 ,rawData.location_6 ,rawData.location_7 ,rawData.location_8 ,rawData.location_9]
                // loop
                for index in 0..<rawData.sessionLength() {
                    if let day = daysRawData[index] {
                        days?.append(day)
                    }
                    if let period = periodsRawData[index] {
                        periods?.append(period)
                    }
                    if let location = locationsRawData[index] {
                        locations?.append(location)
                    }
                }
            }
        }
        self.init(code: code, name: name, year: year, term: term, lecturer: lecturer, credits: credits, _type: _type, days: days, periods: periods, locations: locations)
    }

    // dont know if always have data in to this init? considering....
//    convenience init?(courseObject: CourseDBManagedObject) {
//        
//    }
    
    // functions?
    class func generateCourseArrayWithRawDataObjects(rawDataObjects: [CourseRawDataObject]) -> [Course]? {
        if rawDataObjects.count != 0 {
            var courses = [Course]()
            for rawDataObject in rawDataObjects {
                if let course = Course(rawData: rawDataObject) {
                    courses.append(course)
                }
            }
            // check array length
            if courses.count == 0 {
                // if this array contains on element, return nil
                return nil
            } else {
                return courses
            }
        } else {
             return nil
        }
    }
}