//
//  UserCourseObjectArray.swift
//  ColorgyAPIHandler
//
//  Created by David on 2015/8/23.
//  Copyright (c) 2015年 David. All rights reserved.
//

import Foundation

class UserCourseObjectArray {
    
    var objects: [UserCourseObject]?
    
    init(json: JSON?) {
        if let json = json {
            // init array of objects
            self.objects = [UserCourseObject]()
            println("json is array? \(json.isArray)")
            if json.isArray {
                // loop
                for (index: String, json: JSON) in json {
                    if let object = UserCourseObject(json: json) {
                        self.objects?.append(object)
                    }
                }
                if self.objects?.count == 0 {
                    self.objects = nil
                }
            } else {
                if let object = UserCourseObject(json: json) {
                    self.objects?.append(object)
                }
                if self.objects?.count == 0 {
                    self.objects = nil
                }
            }
        }
    }
}