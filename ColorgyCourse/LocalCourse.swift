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
                for index in 0...(timePeriods[1] - timePeriods[2]) {
                    days.append(timePeriods[0])
                    periods.append(timePeriods[1] + index)
                    // if no location string, pass in ""
                    locations.append(locationContents![timePeriodsIndex] ?? "")
                }
            }
        }
        
        self.init(code: nil, name: name, year: nil, term: nil, lecturer: lecturer, credits: nil, _type: nil, days: days, periods: periods, locations: locations, general_code: nil)
    }
}