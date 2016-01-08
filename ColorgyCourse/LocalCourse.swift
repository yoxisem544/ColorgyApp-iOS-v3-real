//
//  LocalCourse.swift
//  ColorgyCourse
//
//  Created by David on 2016/1/4.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

class LocalCourse : CustomStringConvertible {
    
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
    
    init?(code: String?, name: String?, year: Int?, term: Int?, lecturer: String?, credits: Int?, _type: String?, days: [Int]?, periods: [Int]?, locations: [String]?, general_code: String?) {
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
        // just need course name, lecturer, time, day and location.
        // day, time and location is optional
        // but course name is required.
        guard name != nil else { return nil }
        self.name = name!
    }
    
    convenience init?(name: String?, lecturer: String?, timePeriodsContents: [[Int]]?, locationContents: [String?]?) {
        
        // create a day, period, locatoin array here
        print(timePeriodsContents)
        guard timePeriodsContents != nil else { return nil }
        guard locationContents != nil else { return nil }
        // content must be the same length
        guard timePeriodsContents!.count == locationContents!.count else { return nil }
        
        var days: [Int] = []
        var periods: [Int] = []
        var locations: [String] = []
        
        // check if this course doesnt have time and location
        print(timePeriodsContents)
        if timePeriodsContents! != [[]] {
            // loop the time content
            for (timePeriodsIndex, timePeriods) : (Int, [Int]) in timePeriodsContents!.enumerate() {
                guard timePeriods.count == 3 else { return nil }
                // check the period spacing between two points
                // type: [day], [period], [location]
                for index in 0...(timePeriods[2] - timePeriods[1]) {
                    // cause the starting point is [0, 0, 0]
                    // so must +1 to match the data type, which starting from 1.
                    // ex. day is 1~7
                    days.append(timePeriods[0] + 1)
                    periods.append(timePeriods[1] + index + 1)
                    // if no location string, pass in ""
                    locations.append(locationContents![timePeriodsIndex] ?? "")
                }
            }
        }
        
        self.init(code: nil, name: name, year: nil, term: nil, lecturer: lecturer, credits: nil, _type: nil, days: days, periods: periods, locations: locations, general_code: nil)
    }
    
    convenience init?(localCourseDBManagedObject: LocalCourseDBManagedObject?) {
        if let lcObject = localCourseDBManagedObject {
            var code: String? = lcObject.code
            var name: String? = lcObject.name
            var year: Int? = Int(lcObject.year)
            var term: Int? = Int(lcObject.term)
            var lecturer: String? = lcObject.lecturer
            var credits: Int? = Int(lcObject.credits)
            var _type: String? = lcObject.type
//            var days: [Int]? = lcObject.days
//            var periods: [Int]? = lcObject.periods
//            var locations: [String] = lcObject.locations
            var general_code: String? = lcObject.general_code
            
            var days = [Int]()
            var periods = [Int]()
            var locations = [String]()
            // prepare data...
            var daysRawData = [lcObject.day_1 ,lcObject.day_2 ,lcObject.day_3 ,lcObject.day_4 ,lcObject.day_5 ,lcObject.day_6 ,lcObject.day_7 ,lcObject.day_8 ,lcObject.day_9]
            var periodsRawData = [lcObject.period_1 ,lcObject.period_2 ,lcObject.period_3 ,lcObject.period_4 ,lcObject.period_5 ,lcObject.period_6 ,lcObject.period_7 ,lcObject.period_8 ,lcObject.period_9]
            var locationsRawData = [lcObject.location_1 ,lcObject.location_2 ,lcObject.location_3 ,lcObject.location_4 ,lcObject.location_5 ,lcObject.location_6 ,lcObject.location_7 ,lcObject.location_8 ,lcObject.location_9]
            // loop
            for index in 0..<9 {
                let day = Int(daysRawData[index])
                // day must not be 0
                if day != 0 {
                    days.append(day)
                    
                    let period = Int(periodsRawData[index])
                    periods.append(period)
                    
                    if let location = locationsRawData[index] {
                        locations.append(location)
                    } else {
                        locations.append("")
                    }
                }
            }
            
            guard name != nil else { return nil }
            
            self.init(code: code , name: name, year: year , term: term , lecturer: lecturer , credits: credits , _type: _type , days: days , periods: periods , locations: locations , general_code: general_code )
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