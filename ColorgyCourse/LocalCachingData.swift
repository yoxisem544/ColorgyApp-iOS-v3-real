//
//  LocalCachingData.swift
//  ColorgyAPIHandler
//
//  Created by David on 2015/8/24.
//  Copyright (c) 2015年 David. All rights reserved.
//

import Foundation

/// Lets you easily get local course caching data
/// 
/// You can get it as:
///
/// - **jsonFormat**: json format of local caching data
/// - **courseRawDataObjects**: An array of CourseRawDataObject
/// - **courses**: An array of Course
/// - **archivedJSON**: NSData of local caching data
class LocalCachingData {
    
    // 1. properties
    /// json format of local course caching data.
    /// Might be nil if there is something wrong with this data
    class var jsonFormat: JSON? {
        if let data = LocalCachingData.JSONRawData {
            // create a json using data.
            let json = JSON(data: data)
            if json.isUnknownType {
                return nil
            }
            return json
        }
        return nil
    }
    /// Get local caching data out with an array of [CourseRawDataObject]?
    ///
    /// [CourseRawDataObject]? might be nil
    class var courseRawDataObjects: [CourseRawDataObject]? {
        if let data = NSUserDefaults.standardUserDefaults().objectForKey(UserSettingKey.localCourseCachingData) as? NSData {
            let json = JSON(data: data)
            if json.isUnknownType {
                return nil
            }
            if let objects = CourseRawDataArray(json: json).objects {
                if objects.count == 0 {
                    return nil
                }
                return objects
            }
        }
        return nil
    }
    /// Get local caching data out with an array of [Course]?
    ///
    /// Might be nil
    class var courses: [Course]? {
        if let objects = LocalCachingData.courseRawDataObjects {
            if objects.count == 0 {
                return nil
            }
            return Course.generateCourseArrayWithRawDataObjects(objects)
        }
        return nil
    }
    /// A raw data of local caching course. If you want to use it, then you must transform it first.
    ///
    /// This data is NSData? type
    class var JSONRawData: NSData? {
        if let data = NSUserDefaults.standardUserDefaults().objectForKey(UserSettingKey.localCourseCachingData) as? NSData {
            return data
        }
        return nil
    }
    // 2. init
    
    // 3. methods
    // need to save to UserSetting
    // need to grab out as a json
    // need to grab out as a CourseRawData
    // need to grab out as a Course
}