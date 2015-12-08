//
//  Department.swift
//  ColorgyCourse
//
//  Created by David on 2015/11/24.
//  Copyright © 2015年 David. All rights reserved.
//

import Foundation

class Department : CustomStringConvertible {
    var code: String
    var name: String
    var short_name: String
    var id: String
    var _type: String
    
    private struct DepartmentKey {
        static let code = "code"
        static let name = "name"
        static let short_name = "short_name"
        static let id = "id"
        static let _type = "_type"
    }
    
    var description: String { return "{\n\tcode = \(code)\n\tname = \(name)\n\tshort_name = \(short_name)\n\tid = \(id)\n\t_type = \(_type)\n}" }
    
    init?(json: JSON) {
        code = ""
        name = ""
        short_name = ""
        id = ""
        _type = ""
        
        if let code = json[DepartmentKey.code].string {
            self.code = code
        } else {
            return nil
        }
        if let name = json[DepartmentKey.name].string {
            self.name = name
        } else {
            return nil
        }
        if let short_name = json[DepartmentKey.short_name].string {
            self.short_name = short_name
        } else {
            return nil
        }
        if let id = json[DepartmentKey.id].string {
            self.id = id
        } else {
            return nil
        }
        if let _type = json[DepartmentKey._type].string {
            self._type = _type
        } else {
            return nil
        }
    }
    
    class func generateDepartments(json: JSON?) -> [Department] {
        var objects = [Department]()
        
        if let json = json {
            for (key, json) : (String, JSON) in json {
                if key == "departments" {
                    print(json)
                    if json.isArray {
                        for (_, json) : (String, JSON) in json {
                            if let department = Department(json: json) {
                                objects.append(department)
                            }
                        }
                    } else {
                        if let department = Department(json: json) {
                            objects.append(department)
                        }
                    }
                }
            }
        }
        
        return objects
    }
}