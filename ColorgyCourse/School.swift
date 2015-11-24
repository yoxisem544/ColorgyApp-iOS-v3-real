//
//  Schools.swift
//  ColorgyCourse
//
//  Created by David on 2015/11/24.
//  Copyright © 2015年 David. All rights reserved.
//

import Foundation

class School: CustomStringConvertible {
    var code: String
    var name: String
    var short_name: String
    var id: String
    var _type: String
    
    private struct SchoolKey {
        static let code = "code"
        static let name = "name"
        static let short_name = "short_name"
        static let id = "id"
        static let _type = "_type"
    }
    
    var description: String {
        return "{\n\tcode = \(code)\n\tname = \(name)\n\tshort_name = \(short_name)\n\tid = \(id)\n\t_type = \(_type)\n}"
    }
    init?(json: JSON) {
        
        code = ""
        name = ""
        short_name = ""
        id = ""
        _type = ""

        if let code = json[SchoolKey.code].string {
            self.code = code
        } else {
            return nil
        }
        if let name = json[SchoolKey.name].string {
            self.name = name
        } else {
            return nil
        }
        if let short_name = json[SchoolKey.short_name].string {
            self.short_name = short_name
        } else {
            return nil
        }
        if let id = json[SchoolKey.id].string {
            self.id = id
        } else {
            return nil
        }
        if let _type = json[SchoolKey._type].string {
            self._type = _type
        } else {
            return nil
        }
    }
    
    class func generateSchoolsWithJSON(json: JSON?) -> [School] {
        var objects = [School]()
        
        if let json = json {
            if json.isArray {
                for (index, json) : (String, JSON) in json {
                    if let school = School(json: json) {
                        objects.append(school)
                    }
                }
            } else {
                if let school = School(json: json) {
                    objects.append(school)
                }
            }
        }
        
        return objects
    }
}