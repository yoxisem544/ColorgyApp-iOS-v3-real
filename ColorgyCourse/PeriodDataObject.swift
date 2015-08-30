//
//  PeriodDataObject.swift
//  ColorgyAPIHandler
//
//  Created by David on 2015/8/26.
//  Copyright (c) 2015年 David. All rights reserved.
//

import Foundation

class PeriodDataObject: Printable {
    
    // 1. properties
    var code: String
    var order: Int
    var id: Int
    var _type: String
    var time: String
    
    // dictionary
    var dictionary: [String : String] {
        get {
            var dict = [
                PeriodKey.code: self.code,
                PeriodKey.order: "\(self.order)",
                PeriodKey.id: "\(self.id)",
                PeriodKey._type: self._type,
                PeriodKey.time: self.time
            ]
            return dict
        }
    }
    
    private struct PeriodKey {
        static let code = "code"
        static let order = "order"
        static let id = "id"
        static let _type = "_type"
        static let time = "time"
    }
    
    var description: String { return "{\n\tcode: \(code)\n\torder: \(order)\n\tid: \(id)\n\t_type: \(_type)\n\ttime: \(time)\n}" }
    
    // 2. init
    init?(json: JSON?) {
        code = ""
        order = 0
        id = 0
        _type = ""
        time = ""
        if let json = json {
            if let code = json[PeriodKey.code].string {
                self.code = code
            } else {
                return nil
            }
            if let order = json[PeriodKey.order].int {
                self.order = order
            } else {
                return nil
            }
            if let id = json[PeriodKey.id].int {
                self.id = id
            } else {
                return nil
            }
            if let _type = json[PeriodKey._type].string {
                self._type = _type
            } else {
                return nil
            }
            if let time = json[PeriodKey.time].string {
                self.time = time
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    // 3. methods
    class func generatePeriodDataObjects(json: JSON?) -> [PeriodDataObject]? {
        if let json = json {
            if json.isArray {
                var objects = [PeriodDataObject]()
                for (index: String, json: JSON) in json {
                    if let object = PeriodDataObject(json: json) {
                        objects.append(object)
                    }
                }
                return objects
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}