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
    /// general code of this course, might be nil
    var general_code: String?
    
    var description: String { return "{\n\tcode: \(code)\n\tname: \(name)\n\tyear: \(year)\n\tterm: \(term)\n\tlecturer: \(lecturer)\n\tcredits: \(credits)\n\t_type: \(_type)\n\tdays: \(days)\n\tperiods: \(periods)\n\tlocations: \(locations)\n\tgeneral_code: \(general_code)\n}" }
    
    private init?(code: String?, name: String?, year: Int?, term: Int?, lecturer: String?, credits: Int?, _type: String?, days: [Int]?, periods: [Int]?, locations: [String]?, general_code: String?) {
        // optional part
        self.days = days
        self.periods = periods
        self.locations = locations
        self._type = _type
        self.lecturer = lecturer
        self.credits = credits
        // new part
        self.general_code = general_code
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
        // new part
        var general_code: String? = nil
        
        if let rawData = rawData {
            code = rawData.code
            name = rawData.name
            year = rawData.year
            term = rawData.term
            lecturer = rawData.lecturer
            credits = rawData.credits
            _type = rawData.type
            general_code = rawData.general_code
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
        self.init(code: code, name: name, year: year, term: term, lecturer: lecturer, credits: credits, _type: _type, days: days, periods: periods, locations: locations, general_code: general_code)
    }
    
    private struct Key {
        // required
        static let name = "name"
        static let code = "code"
        static let year = "year"
        static let term = "term"
        
        // optional
        static let credits = "credits"
        static let lecturer = "lecturer"
        // caution key is _type in json
        static let type = "_type"
        static let id = "id"
        
        static let day_1 = "day_1"
        static let day_2 = "day_2"
        static let day_3 = "day_3"
        static let day_4 = "day_4"
        static let day_5 = "day_5"
        static let day_6 = "day_6"
        static let day_7 = "day_7"
        static let day_8 = "day_8"
        static let day_9 = "day_9"
        static let period_1 = "period_1"
        static let period_2 = "period_2"
        static let period_3 = "period_3"
        static let period_4 = "period_4"
        static let period_5 = "period_5"
        static let period_6 = "period_6"
        static let period_7 = "period_7"
        static let period_8 = "period_8"
        static let period_9 = "period_9"
        static let location_1 = "location_1"
        static let location_2 = "location_2"
        static let location_3 = "location_3"
        static let location_4 = "location_4"
        static let location_5 = "location_5"
        static let location_6 = "location_6"
        static let location_7 = "location_7"
        static let location_8 = "location_8"
        static let location_9 = "location_9"
        
        static let general_code = "general_code"
    }
    
    convenience init?(dictionary: [String : AnyObject]?) {
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
        var general_code: String? = nil
        
        if let dictionary = dictionary {
            // not a array
            code = dictionary[Key.code] as? String
            name = dictionary[Key.name] as? String
            year = dictionary[Key.year] as? Int
            term = dictionary[Key.term] as? Int
            lecturer = dictionary[Key.lecturer] as? String
            credits = dictionary[Key.credits] as? Int
            _type = dictionary[Key.type] as? String
            // new part
            general_code = dictionary[Key.general_code] as? String
            days = [Int]()
            periods = [Int]()
            locations = [String]()
            // prepare data...
            var daysRawData = [dictionary[Key.day_1] ,dictionary[Key.day_2] ,dictionary[Key.day_3] ,dictionary[Key.day_4] ,dictionary[Key.day_5] ,dictionary[Key.day_6] ,dictionary[Key.day_7] ,dictionary[Key.day_8] ,dictionary[Key.day_9]]
            var periodsRawData = [dictionary[Key.period_1] ,dictionary[Key.period_2] ,dictionary[Key.period_3] ,dictionary[Key.period_4] ,dictionary[Key.period_5] ,dictionary[Key.period_6] ,dictionary[Key.period_7] ,dictionary[Key.period_8] ,dictionary[Key.period_9]]
            var locationsRawData = [dictionary[Key.location_1] ,dictionary[Key.location_2] ,dictionary[Key.location_3] ,dictionary[Key.location_4] ,dictionary[Key.location_5] ,dictionary[Key.location_6] ,dictionary[Key.location_7] ,dictionary[Key.location_8] ,dictionary[Key.location_9]]
            // loop
            for index in 0..<9 {
                if let day = daysRawData[index]  as? Int {
                    days?.append(day)
                }
                if let period = periodsRawData[index]  as? Int {
                    periods?.append(period)
                    // TODO: i put this part inside this is, location wont be nil
                    // but period and day will be nil
                    // so i make this inside to prevent generating "" string
                    if let location = locationsRawData[index]  as? String {
                        locations?.append(location)
                    }
                }
            }
        }
        
        self.init(code: code, name: name, year: year, term: term, lecturer: lecturer, credits: credits, _type: _type, days: days, periods: periods, locations: locations, general_code: general_code)
    }

    convenience init?(courseDBManagedObject: CourseDBManagedObject?) {
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
        var general_code: String? = nil
        
        if let courseDBManagedObject = courseDBManagedObject {
            // not a array
            code = courseDBManagedObject.code
            name = courseDBManagedObject.name
            year = Int(courseDBManagedObject.year)
            term = Int(courseDBManagedObject.term)
            lecturer = courseDBManagedObject.lecturer
            credits = Int(courseDBManagedObject.credits)
            _type = courseDBManagedObject.type
            // new part
            general_code = courseDBManagedObject.general_code
            days = [Int]()
            periods = [Int]()
            locations = [String]()
            // prepare data...
            var daysRawData = [courseDBManagedObject.day_1 ,courseDBManagedObject.day_2 ,courseDBManagedObject.day_3 ,courseDBManagedObject.day_4 ,courseDBManagedObject.day_5 ,courseDBManagedObject.day_6 ,courseDBManagedObject.day_7 ,courseDBManagedObject.day_8 ,courseDBManagedObject.day_9]
            var periodsRawData = [courseDBManagedObject.period_1 ,courseDBManagedObject.period_2 ,courseDBManagedObject.period_3 ,courseDBManagedObject.period_4 ,courseDBManagedObject.period_5 ,courseDBManagedObject.period_6 ,courseDBManagedObject.period_7 ,courseDBManagedObject.period_8 ,courseDBManagedObject.period_9]
            var locationsRawData = [courseDBManagedObject.location_1 ,courseDBManagedObject.location_2 ,courseDBManagedObject.location_3 ,courseDBManagedObject.location_4 ,courseDBManagedObject.location_5 ,courseDBManagedObject.location_6 ,courseDBManagedObject.location_7 ,courseDBManagedObject.location_8 ,courseDBManagedObject.location_9]
            // loop
            for index in 0..<9 {
                let day = Int(daysRawData[index])
                // day must not be 0
                if day != 0 {
                    days?.append(day)
                    
                    let period = Int(periodsRawData[index])
                    periods?.append(period)

                    if let location = locationsRawData[index] {
                        locations?.append(location)
                    }
                }
            }
        }
        
        self.init(code: code, name: name, year: year, term: term, lecturer: lecturer, credits: credits, _type: _type, days: days, periods: periods, locations: locations, general_code: general_code)
    }
    
    // dont know if always have data in to this init? considering....
//    convenience init?(courseObject: CourseDBManagedObject) {
//        
//    }
    
    // functions?
    class func generateCourseArrayWithRawDataObjects(rawDataObjects: [CourseRawDataObject]) -> [Course]? {
        var befor = NSDate()
        if rawDataObjects.count != 0 {
            var courses = [Course]()
            for rawDataObject in rawDataObjects {
                if let course = Course(rawData: rawDataObject) {
                    courses.append(course)
                }
            }
            var now = NSDate().timeIntervalSinceDate(befor)
            println(now*1000)
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
    
    class func generateCourseArrayWithDictionaries(dictionaries: [[String : AnyObject]]?) -> [Course]? {
        var befor = NSDate()
        if let dictionaries = dictionaries {
            var courses = [Course]()
            
            for dictionary in dictionaries {
                if let course = Course(dictionary: dictionary) {
                    courses.append(course)
                }
            }
            
            var now = NSDate().timeIntervalSinceDate(befor)
            println("PPPP is \(now*1000)")
            // check length
            if courses.count == 0 {
                return nil
            } else {
                return courses
            }

        } else {
            return nil
        }
    }
    
    var periodsString: String {
        get {
            let weekdays = ["", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
            var temp = ""
            if (days?.count != 0) && (periods?.count != 0) && days != nil && periods != nil {
                for index in 0..<periods!.count {
                    // cause day is 1~7
                    temp += weekdays[days![index]] + "\(periods![index])"
                }
            }
            return temp
        }
    }
    
    var sessionLength: Int {
        get {
            if let count = locations?.count {
                return count
            }
            return 0
        }
    }
}