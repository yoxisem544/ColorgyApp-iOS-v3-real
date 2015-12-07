//
//  CourseRawDataArray.swift
//  ColorgyAPIHandler
//
//  Created by David on 2015/8/23.
//  Copyright (c) 2015年 David. All rights reserved.
//

import Foundation

/// This will help you to deal with whole bunch of json that is download from server.
class CourseRawDataArray {
    
    /// An array that contains parsed CourseRawDataObject that you can easily use with.
    ///
    /// check the count of this objects, might be nil
    var objects: [CourseRawDataObject]?
    
    /// Initialization: Create a Array that contains CourseRawDataObjects.
    ///
    /// You can get it from accessing this array's property: objects
    init(json: JSON?, process:(state: String) -> Void) {
        if let json = json {
            // init raw data array
            self.objects = [CourseRawDataObject]()
            if json.isArray {
                // an array of object
                for (index, sub_json) : (String, JSON) in json {
                    // loop through all the array
                    if let courseRawData = CourseRawDataObject(json: sub_json) {
                        process(state: "正在處理：\(index)/\(json.count)筆資料...")
                        self.objects?.append(courseRawData)
                    }
                }
                // if zero element, set it back to nil
                if self.objects?.count == 0 {
                    self.objects = nil
                }
            } else {
                // only one object
                if let courseRawData = CourseRawDataObject(json: json) {
                    self.objects?.append(courseRawData)
                }
                if self.objects?.count == 0 {
                    self.objects = nil
                }
            }
        }
    }
}