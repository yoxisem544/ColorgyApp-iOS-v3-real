//
//  CourseRawData.swift
//  ColorgyAPIHandler
//
//  Created by David on 2015/8/23.
//  Copyright (c) 2015年 David. All rights reserved.
//

import Foundation

/// This is a course raw data representation of a parsed json.
///
/// Pass in a json, then it will generate a CourseRawDataObject.
///
/// This object make it easier to deal with json formate data.
///
/// This json is from school API, not user API.
class CourseRawDataObject: Printable {
    
    // 1. properties
    // cache data from server
    // required
    var name: String
    var uuid: String
    var year: Int
    var term: Int
    
    // optional
    var credits: Int?
    var lecturer: String?
    var type: String?
    var id: Int?
    
    var day_1: Int?
    var day_2: Int?
    var day_3: Int?
    var day_4: Int?
    var day_5: Int?
    var day_6: Int?
    var day_7: Int?
    var day_8: Int?
    var day_9: Int?
    var period_1: Int?
    var period_2: Int?
    var period_3: Int?
    var period_4: Int?
    var period_5: Int?
    var period_6: Int?
    var period_7: Int?
    var period_8: Int?
    var period_9: Int?
    var location_1: String?
    var location_2: String?
    var location_3: String?
    var location_4: String?
    var location_5: String?
    var location_6: String?
    var location_7: String?
    var location_8: String?
    var location_9: String?
    
    var description: String { return  "{\n\tname: \(name)\n\tuuid: \(uuid)\n\tyear: \(year)\n\tterm: \(term)\n\tcredits: \(credits)\n\tlecturer: \(lecturer)\n\ttype: \(type)\n\tid: \(id)\n\tday_1: \(day_1)\n\tday_2: \(day_2)\n\tday_3: \(day_3)\n\tday_4: \(day_4)\n\tday_5: \(day_5)\n\tday_6: \(day_6)\n\tday_7: \(day_7)\n\tday_8: \(day_8)\n\tday_9: \(day_9)\n\tperiod_1: \(period_1)\n\tperiod_2: \(period_2)\n\tperiod_3: \(period_3)\n\tperiod_4: \(period_4)\n\tperiod_5: \(period_5)\n\tperiod_6: \(period_6)\n\tperiod_7: \(period_7)\n\tperiod_8: \(period_8)\n\tperiod_9: \(period_9)\n\tlocation_1: \(location_1)\n\tlocation_2: \(location_2)\n\tlocation_3: \(location_3)\n\tlocation_4: \(location_4)\n\tlocation_5: \(location_5)\n\tlocation_6: \(location_6)\n\tlocation_7: \(location_7)\n\tlocation_8: \(location_8)\n\tlocation_9: \(location_9)\n}" }
    
    private struct rawDataKey {
        // required
        static let name = "name"
        // TODO: uuid <-> code, this is not good
        static let uuid = "code"
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
    }
    
    // 2. init
    /// Initialization of CourseRawDataObject.
    /// You need to pass in a json, then will return a CourseRawDataObject?
    /// 
    /// :param: json: a json from server. This json is from **school API**, not user API.
    init?(json: JSON?) {
        self.name = ""
        self.uuid = ""
        self.year = Int()
        self.term = Int()
        if let json = json {
            // fail if this is a array of json
            if !json.isArray {
                // required part
                if let name = json[rawDataKey.name].string {
                    self.name = name
                } else {
                    return nil
                }
                if let uuid = json[rawDataKey.uuid].string {
                    self.uuid = uuid
                } else {
                    return nil
                }
                // TODO: test if it will return int
                if let year = json[rawDataKey.year].int {
                    self.year = year
                } else {
                    return nil
                }
                if let term = json[rawDataKey.term].int {
                    self.term = term
                } else {
                    return nil
                }
                // optional
                if let credits = json[rawDataKey.credits].int {
                    self.credits = credits
                }
                if let lecturer = json[rawDataKey.lecturer].string {
                    self.lecturer = lecturer
                }
                if let type = json[rawDataKey.type].string {
                    self.type = type
                }
                if let id = json[rawDataKey.id].int {
                    self.id = id
                }
                // day, period, location
                if let day_1 = json[rawDataKey.day_1].int {
                    self.day_1 = day_1
                }
                if let day_2 = json[rawDataKey.day_2].int {
                    self.day_2 = day_2
                }
                if let day_3 = json[rawDataKey.day_3].int {
                    self.day_3 = day_3
                }
                if let day_4 = json[rawDataKey.day_4].int {
                    self.day_4 = day_4
                }
                if let day_5 = json[rawDataKey.day_5].int {
                    self.day_5 = day_5
                }
                if let day_6 = json[rawDataKey.day_6].int {
                    self.day_6 = day_6
                }
                if let day_7 = json[rawDataKey.day_7].int {
                    self.day_7 = day_7
                }
                if let day_8 = json[rawDataKey.day_8].int {
                    self.day_8 = day_8
                }
                if let day_9 = json[rawDataKey.day_9].int {
                    self.day_9 = day_9
                }
                if let period_1 = json[rawDataKey.period_1].int {
                    self.period_1 = period_1
                }
                if let period_2 = json[rawDataKey.period_2].int {
                    self.period_2 = period_2
                }
                if let period_3 = json[rawDataKey.period_3].int {
                    self.period_3 = period_3
                }
                if let period_4 = json[rawDataKey.period_4].int {
                    self.period_4 = period_4
                }
                if let period_5 = json[rawDataKey.period_5].int {
                    self.period_5 = period_5
                }
                if let period_6 = json[rawDataKey.period_6].int {
                    self.period_6 = period_6
                }
                if let period_7 = json[rawDataKey.period_7].int {
                    self.period_7 = period_7
                }
                if let period_8 = json[rawDataKey.period_8].int {
                    self.period_8 = period_8
                }
                if let period_9 = json[rawDataKey.period_9].int {
                    self.period_9 = period_9
                }
                // location_
                if let location_1 = json[rawDataKey.location_1].string {
                    self.location_1 = location_1
                }
                if let location_2 = json[rawDataKey.location_2].string {
                    self.location_2 = location_2
                }
                if let location_3 = json[rawDataKey.location_3].string {
                    self.location_3 = location_3
                }
                if let location_4 = json[rawDataKey.location_4].string {
                    self.location_4 = location_4
                }
                if let location_5 = json[rawDataKey.location_5].string {
                    self.location_5 = location_5
                }
                if let location_6 = json[rawDataKey.location_6].string {
                    self.location_6 = location_6
                }
                if let location_7 = json[rawDataKey.location_7].string {
                    self.location_7 = location_7
                }
                if let location_8 = json[rawDataKey.location_8].string {
                    self.location_8 = location_8
                }
                if let location_9 = json[rawDataKey.location_9].string {
                    self.location_9 = location_9
                }
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    // 3. methods.
    /// This method can get the counts of days, periods and locations array's length.
    ///
    /// :returns: Count of days, periods and locations array.
    func sessionLength() -> Int {
        if self.day_1 == nil {
            return 0
        }
        if self.day_2 == nil {
            return 1
        }
        if self.day_3 == nil {
            return 2
        }
        if self.day_4 == nil {
            return 3
        }
        if self.day_5 == nil {
            return 4
        }
        if self.day_6 == nil {
            return 5
        }
        if self.day_7 == nil {
            return 6
        }
        if self.day_8 == nil {
            return 7
        }
        if self.day_9 == nil {
            return 8
        }
        return 9

    }
    
}