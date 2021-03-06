//
//  ColorgyAPIHandler.swift
//  ColorgyAPIHandler
//
//  Created by David on 2015/8/22.
//  Copyright (c) 2015年 David. All rights reserved.
//

import Foundation
import Fabric
import Crashlytics

class ColorgyAPI : NSObject {
    
    // what do i need here?
    // need to
    
    // MARK: - push notification device token
    // push notification device token
    class func PUTdeviceToken(success success: () -> Void, failure: () -> Void) {
        
        guard !ColorgyAPITrafficControlCenter.isTokenRefreshing() else {
            print(ColorgyErrorType.TrafficError.stillRefreshing)
            failure()
            return
        }
        guard let token = UserSetting.getPushNotificationDeviceToken() else {
            failure()
            return
        }
        guard let accesstoken = UserSetting.UserAccessToken() else {
            failure()
            return
        }
        
        let afManager = AFHTTPSessionManager(baseURL: nil)
        afManager.requestSerializer = AFJSONRequestSerializer()
        afManager.responseSerializer = AFJSONResponseSerializer()
        
        // need uuid, device name, device type, device token
        let params = [
            "user_device": [
                "type": "ios",
                "name": UIDevice.currentDevice().name,
                "device_id": "\(token)"
            ]
        ]
        
        var uuid = UserSetting.getDeviceUUID()
        if uuid == nil {
            UserSetting.generateAndStoreDeviceUUID()
            uuid = UserSetting.getDeviceUUID()
        }
        
        print(params)
        
        if let uuid = uuid {
            let url = "https://colorgy.io:443/api/v1/me/devices/\(uuid).json?access_token=\(accesstoken)"
            print(uuid)
            print(params)
            print(accesstoken)
            // queue job
            ColorgyAPITrafficControlCenter.queueNewBackgroundJob()
            afManager.PUT(url, parameters: params, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                print("Success")
                // job ended
                ColorgyAPITrafficControlCenter.unqueueBackgroundJob()
                success()
                }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                    print("fail \(error.localizedDescription)")
                    // job ended
                    ColorgyAPITrafficControlCenter.unqueueBackgroundJob()
                    failure()
            })
        } else {
            failure()
        }
        
    }
    
    /// Get all the token stored in server
    class func GETdeviceToken(success success: (devices: [[String : String]]) -> Void, failure: () -> Void) {
        
        guard !ColorgyAPITrafficControlCenter.isTokenRefreshing() else {
            print(ColorgyErrorType.TrafficError.stillRefreshing)
            failure()
            return
        }
        guard UserSetting.getPushNotificationDeviceToken() != nil else {
            failure()
            return
        }
        guard let accesstoken = UserSetting.UserAccessToken() else {
            failure()
            return
        }
        
        let afManager = AFHTTPSessionManager(baseURL: nil)
        afManager.requestSerializer = AFJSONRequestSerializer()
        afManager.responseSerializer = AFJSONResponseSerializer()
        
        // queue job
        ColorgyAPITrafficControlCenter.queueNewBackgroundJob()
        let url = "https://colorgy.io:443/api/v1/me/devices.json?access_token=\(accesstoken)"
        afManager.GET(url, parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            // job ended
            ColorgyAPITrafficControlCenter.unqueueBackgroundJob()
            if let response = response {
                let json = JSON(response)
                var devices = [[String : String]]()
                
                for (_, json) : (String, JSON) in json {
                    if let name = json["name"].string {
                        if let uuid = json["uuid"].string {
                            devices.append(["name": name, "uuid": uuid])
                        }
                    }
                }
                
                success(devices: devices)
            } else {
                failure()
            }
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                // job ended
                ColorgyAPITrafficControlCenter.unqueueBackgroundJob()
                print(error)
                failure()
        })
        
    }
    
    /// Delete a uuid and push notification token set.
    /// Always call this in background worker.
    class func DELETEdeviceTokenAndPushNotificationPare(success success: () -> Void, failure: () -> Void) {
        
        guard !ColorgyAPITrafficControlCenter.isTokenRefreshing() else {
            print(ColorgyErrorType.TrafficError.stillRefreshing)
            failure()
            return
        }
        guard let accesstoken = UserSetting.UserAccessToken() else {
            print(ColorgyErrorType.noAccessToken)
            failure()
            return
        }
        guard let uuid = UserSetting.getDeviceUUID() else {
            print("no need delete uuid token pare")
            failure()
            return
        }
        let url = "https://colorgy.io:443/api/v1/me/devices/\(uuid).json?access_token=\(accesstoken)"
        guard url.isValidURLString else {
            print(ColorgyErrorType.invalidURLString)
            failure()
            return
        }
        
        let afManager = AFHTTPSessionManager(baseURL: nil)
        afManager.requestSerializer = AFJSONRequestSerializer()
        afManager.responseSerializer = AFJSONResponseSerializer()
        
        print(uuid)
        // queue job
        ColorgyAPITrafficControlCenter.queueNewBackgroundJob()
        afManager.DELETE(url, parameters: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            // job ended
            ColorgyAPITrafficControlCenter.unqueueBackgroundJob()
            success()
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                // job ended
                ColorgyAPITrafficControlCenter.unqueueBackgroundJob()
                failure()
        })
    }
    
    /// Delete a uuid and push notification token set.
    /// Always call this in background worker.
    class func DELETEdeviceTokenAndPushNotificationPareUsingUUID(uuid: String?, success: () -> Void, failure: () -> Void) {
        
        guard !ColorgyAPITrafficControlCenter.isTokenRefreshing() else {
            print(ColorgyErrorType.TrafficError.stillRefreshing)
            failure()
            return
        }
        guard let accesstoken = UserSetting.UserAccessToken() else {
            print(ColorgyErrorType.noAccessToken)
            failure()
            return
        }
        guard let uuid = uuid else {
            print("no need delete uuid token pare")
            failure()
            return
        }
        let url = "https://colorgy.io:443/api/v1/me/devices/\(uuid).json?access_token=\(accesstoken)"
        guard url.isValidURLString else {
            print(ColorgyErrorType.invalidURLString)
            failure()
            return
        }
        
        let afManager = AFHTTPSessionManager(baseURL: nil)
        afManager.requestSerializer = AFJSONRequestSerializer()
        afManager.responseSerializer = AFJSONResponseSerializer()
        
        print(uuid)
        // queue job
        ColorgyAPITrafficControlCenter.queueNewBackgroundJob()
        afManager.DELETE(url, parameters: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            // job ended
            ColorgyAPITrafficControlCenter.unqueueBackgroundJob()
            success()
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                // job ended
                ColorgyAPITrafficControlCenter.unqueueBackgroundJob()
                failure()
        })
    }
    
    // MARK: - check if token expired
    /// Check if token has expired
    class func checkIfTokenHasExpired(unexpired unexpired: () -> Void, expired: () -> Void) {
        ColorgyAPI.me({ (result) -> Void in
            // still working
            unexpired()
            }, failure: { () -> Void in
                expired()
        })
    }
    
    // MARK: - course API
    // download whole bunch of courses data
    /// Get courses from server.
    ///
    /// :param: count: Pass the count you want to download. nil, 0, -1~ for all course.
    /// :returns: courseRawDataObjects: A parsed [CourseRawDataObject]? array. Might be nil or 0 element.
    class func getSchoolCourseData(count: Int?, year: Int, term: Int, success: (courses: [Course], json: JSON) -> Void, failure: (failInfo: String?) -> Void, processing: (processTitle: String, processState: String) -> Void) {
        
        let afManager = AFHTTPSessionManager(baseURL: nil)
        afManager.requestSerializer = AFJSONRequestSerializer()
        afManager.responseSerializer = AFJSONResponseSerializer()
        
        guard !ColorgyAPITrafficControlCenter.isTokenRefreshing() else {
            print(ColorgyErrorType.TrafficError.stillRefreshing)
            failure(failInfo: nil)
            return
        }
        guard let organization = UserSetting.UserPossibleOrganization() else {
            failure(failInfo: nil)
            print(ColorgyErrorType.noOrganization)
            return
        }
        guard let accesstoken = UserSetting.UserAccessToken() else {
            failure(failInfo: nil)
            print(ColorgyErrorType.noAccessToken)
            return
        }
        let coursesCount = count ?? 20000
        let url = "https://colorgy.io:443/api/v1/\(organization.lowercaseString)/courses.json?per_page=\(String(coursesCount))&&&filter%5Byear%5D=\(year)&filter%5Bterm%5D=\(term)&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&access_token=\(accesstoken)"
        guard url.isValidURLString else {
            print(ColorgyErrorType.invalidURLString)
            failure(failInfo: nil)
            return
        }
        
        // queue job
        ColorgyAPITrafficControlCenter.queueNewBackgroundJob()
        // indicate user while downloading
        //        processing(processState: "正在下載資料...")
        processing(processTitle: "資料要吐出來囉！", processState: "正在下載資料...")
        // then start job
        afManager.GET(url, parameters: nil, progress: nil,success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            // check header
            //                            print(task.response)
            
            // job ended
            ColorgyAPITrafficControlCenter.unqueueBackgroundJob()
            // into background
            //                            let qos = Int(QOS_CLASS_USER_INTERACTIVE.value)
            let qos = Int(QOS_CLASS_USER_INTERACTIVE.rawValue)
            
            dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in
                
                if let response = response {
                    // then handle response
                    let json = JSON(response)
                    let courseRawDataArray = CourseRawDataArray(json: json, process: { (state) -> Void in
                        processing(processTitle: "吐了！", processState: state)
                    })
                    processing(processTitle: "再一下下就好了！", processState: "正在儲存資料到手機上...")
                    var dicts = [[String : AnyObject]]()
                    // this dic can use to generate [course]
                    if courseRawDataArray.objects != nil {
                        // processing all the data....
                        for (_, object) : (Int, CourseRawDataObject) in courseRawDataArray.objects!.enumerate() {
                            dicts.append(object.dictionary)
                        }
                        // successfully get a dicts
                        // generate [cours]
                        let courses = Course.generateCourseArrayWithDictionaries(dicts)
                        // return to main queue
                        if let courses = courses {
                            
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                success(courses: courses, json: json)
                            })
                        } else {
                            // fail to generate objects
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                failure(failInfo: nil)
                            })
                        }
                    } else {
                        // fail to generate objects
                        // no course data
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            let semester = Semester.currentSemesterAndYear() as (year: Int, term: Int)
                            failure(failInfo: "你的學校還沒有這個學期(\(semester.year)-\(semester.term))的課程資料喔！我們已經將您的學校記錄下來了，請等待資料更新！")
                            let params: [String : AnyObject] = ["user_id": "\(UserSetting.UserId())", "organization": "\(UserSetting.UserPossibleOrganization())", "department": "\(UserSetting.UserPossibleDepartment())", "year": semester.year, "term": semester.term]
                            Flurry.logEvent("v3.0: Organization Course Data Missing", withParameters: params as [NSObject : AnyObject])
                            Answers.logCustomEventWithName(AnswersLogEvents.organizationCourseDataMissing, customAttributes: params)
                        })
                    }
                } else {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        failure(failInfo: "轉換response失敗")
                    })
                }
            })
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                // job ended
                ColorgyAPITrafficControlCenter.unqueueBackgroundJob()
                // then handle response
                print(ColorgyErrorType.APIFailure.failDownloadCourses)
                print(error.localizedDescription)
                print((task?.response as? NSHTTPURLResponse)?.statusCode)
                if let statusCode = (task?.response as? NSHTTPURLResponse)?.statusCode {
                    if statusCode == 404 {
                        failure(failInfo: "我們沒有 \(organization) 課程內容！，錯誤代碼: \(error.localizedDescription)")
                    }
                    let params: [String : AnyObject] = ["user_id": "\(UserSetting.UserId())", "error_class": "ColorgyAPI.swift", "error_function": "getSchoolCourseData:", "error_description": error.localizedDescription]
                    Flurry.logEvent("v3.0: App Encounter Error Logging", withParameters: params)
                    Flurry.logError("ColorgyAPI.swift -> getSchoolCourseData:", message: "fail to get \(organization) course data", error: error)
                    Answers.logCustomEventWithName(AnswersLogEvents.noOraganizationCourseData, customAttributes: params)
                } else {
                    failure(failInfo: "你的網路不穩定，請確定在網路良好的環境下載哦！")
                }
        })
    }
    
    // course API
    // get course info
    /// Get a specific course raw data object using course code.
    /// Will just return a single data object.
    /// Not an array
    ///
    /// :param: code: A specific course code.
    /// :returns: courseRawDataObject: A single CourseRawDataObject?, might be nil.
    class func getCourseRawDataObjectWithCourseCode(code: String, success: (courseRawDataObject: CourseRawDataObject) -> Void, failure: () -> Void) {
        
        let afManager = AFHTTPSessionManager(baseURL: nil)
        afManager.requestSerializer = AFJSONRequestSerializer()
        afManager.responseSerializer = AFJSONResponseSerializer()
        
        guard !ColorgyAPITrafficControlCenter.isTokenRefreshing() else {
            // must not being refreshing token
            print(ColorgyErrorType.TrafficError.stillRefreshing)
            failure()
            return
        }
        guard let accesstoken = UserSetting.UserAccessToken() else {
            print(ColorgyErrorType.noAccessToken)
            failure()
            return
        }
        guard let school = UserSetting.UserPossibleOrganization() else {
            print(ColorgyErrorType.noOrganization)
            failure()
            return
        }
        let url = "https://colorgy.io:443/api/v1/\(school.lowercaseString)/courses/\(code).json?access_token=\(accesstoken)"
        guard url.isValidURLString else {
            print("invalud url")
            failure()
            return
        }
        
        // queue job
        ColorgyAPITrafficControlCenter.queueNewBackgroundJob()
        // then start job
        afManager.GET(url, parameters: nil, progress: nil,success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            // job ended
            ColorgyAPITrafficControlCenter.unqueueBackgroundJob()
            // into background
            //                        let qos = Int(QOS_CLASS_USER_INTERACTIVE.value)
            let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
            dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in
                // then handle response
                if let response = response {
                    let json = JSON(response)
                    let object = CourseRawDataObject(json: json)
                    // return to main queue
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        if let object = object {
                            success(courseRawDataObject: object)
                        } else {
                            failure()
                        }
                    })
                } else {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        failure()
                    })
                }
            })
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                // job ended
                ColorgyAPITrafficControlCenter.unqueueBackgroundJob()
                // then handle response
                print("Err \(error)")
                failure()
        })
    }
    
    // get students enrolled in specific course
    /// Get users who enroll in specific course.
    /// Server will return a UserCourseObject.
    ///
    /// :param: code: A course code.
    /// :returns: userCourseObjects: A [UserCourseObject]? array, might be nil.
    class func getStudentsInSpecificCourse(code: String, success: (userCourseObjects: [UserCourseObject]) -> Void, failure: () -> Void) {
        // server will return an array of user course objects json.
        let afManager = AFHTTPSessionManager(baseURL: nil)
        afManager.requestSerializer = AFJSONRequestSerializer()
        afManager.responseSerializer = AFJSONResponseSerializer()
        
        guard !ColorgyAPITrafficControlCenter.isTokenRefreshing() else {
            // must not being refreshing token
            print(ColorgyErrorType.TrafficError.stillRefreshing)
            failure()
            return
        }
        guard let accesstoken = UserSetting.UserAccessToken() else {
            print(ColorgyErrorType.noAccessToken)
            failure()
            return
        }
        let url = "https://colorgy.io:443/api/v1/user_courses.json?filter%5Bcourse_code%5D=\(code)&&&&&&&&&access_token=\(accesstoken)"
        guard url.isValidURLString else {
            print("invalud url")
            failure()
            return
        }
        
        // queue job
        ColorgyAPITrafficControlCenter.queueNewBackgroundJob()
        // then start job
        afManager.GET(url, parameters: nil, progress: nil,success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            // job ended
            ColorgyAPITrafficControlCenter.unqueueBackgroundJob()
            // into background
            //                        let qos = Int(QOS_CLASS_USER_INTERACTIVE.value)
            let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
            dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in
                // then handle response
                if let response = response {
                    let json = JSON(response)
                    print(json)
                    if let objects = UserCourseObjectArray(json: json).objects {
                        print(objects)
                        // return to main queue
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            success(userCourseObjects: objects)
                        })
                    } else {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            failure()
                        })
                    }
                } else {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        failure()
                    })
                }
            })
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                // job ended
                ColorgyAPITrafficControlCenter.unqueueBackgroundJob()
                // then handle response
                print(ColorgyErrorType.APIFailure.failGetUserCourses)
                failure()
        })
    }
    
    /// Get school/orgazination period data
    ///
    /// You can get school period data
    ///
    ///
    class func getSchoolPeriodData(completionHandler: (periodDataObjects: [PeriodDataObject]?) -> Void) {
        
        let afManager = AFHTTPSessionManager(baseURL: nil)
        afManager.requestSerializer = AFJSONRequestSerializer()
        afManager.responseSerializer = AFJSONResponseSerializer()
        
        guard !ColorgyAPITrafficControlCenter.isTokenRefreshing() else {
            // must not being refreshing token
            print(ColorgyErrorType.TrafficError.stillRefreshing)
            completionHandler(periodDataObjects: nil)
            return
        }
        guard let accesstoken = UserSetting.UserAccessToken() else {
            print(ColorgyErrorType.noAccessToken)
            completionHandler(periodDataObjects: nil)
            return
        }
        guard let school = UserSetting.UserPossibleOrganization() else {
            print(ColorgyErrorType.noOrganization)
            completionHandler(periodDataObjects: nil)
            return
        }
        let url = "https://colorgy.io:443/api/v1/\(school.lowercaseString)/period_data.json?access_token=\(accesstoken)"
        guard url.isValidURLString else {
            print("invalud url")
            completionHandler(periodDataObjects: nil)
            return
        }
        
        // queue job
        ColorgyAPITrafficControlCenter.queueNewBackgroundJob()
        // then start job
        afManager.GET(url, parameters: nil, progress: nil,success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            // job ended
            ColorgyAPITrafficControlCenter.unqueueBackgroundJob()
            // into background
            //                    let qos = Int(QOS_CLASS_USER_INTERACTIVE.value)
            let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
            dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in
                // then handle response
                if let response = response {
                    let json = JSON(response)
                    let resultObjects = PeriodDataObject.generatePeriodDataObjects(json)
                    UserSetting.storePeriodsData(resultObjects)
                    // return to main queue
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completionHandler(periodDataObjects: resultObjects)
                    })
                } else {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completionHandler(periodDataObjects: nil)
                    })
                }
            })
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                // job ended
                ColorgyAPITrafficControlCenter.unqueueBackgroundJob()
                // then handle response
                completionHandler(periodDataObjects: nil)
        })
    }
    
    /// Get school/orgazination period data
    ///
    /// You can get school period data
    ///
    ///
    class func getSchoolPeriodDataWithSchool(school: String?, completionHandler: (periodDataObjects: [PeriodDataObject]?) -> Void) {
        
        let afManager = AFHTTPSessionManager(baseURL: nil)
        afManager.requestSerializer = AFJSONRequestSerializer()
        afManager.responseSerializer = AFJSONResponseSerializer()
        
        guard !ColorgyAPITrafficControlCenter.isTokenRefreshing() else {
            // must not being refreshing token
            print(ColorgyErrorType.TrafficError.stillRefreshing)
            completionHandler(periodDataObjects: nil)
            return
        }
        guard let accesstoken = UserSetting.UserAccessToken() else {
            print(ColorgyErrorType.noAccessToken)
            completionHandler(periodDataObjects: nil)
            return
        }
        guard let school = school else {
            print(ColorgyErrorType.noOrganization)
            completionHandler(periodDataObjects: nil)
            return
        }
        let url = "https://colorgy.io:443/api/v1/\(school.lowercaseString)/period_data.json?access_token=\(accesstoken)"
        guard url.isValidURLString else {
            print("invalud url")
            completionHandler(periodDataObjects: nil)
            return
        }
        
        // queue job
        ColorgyAPITrafficControlCenter.queueNewBackgroundJob()
        // then start job
        afManager.GET(url, parameters: nil, progress: nil,success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            // job ended
            ColorgyAPITrafficControlCenter.unqueueBackgroundJob()
            // into background
            //                    let qos = Int(QOS_CLASS_USER_INTERACTIVE.value)
            let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
            dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in
                // then handle response
                if let response = response {
                    let json = JSON(response)
                    let resultObjects = PeriodDataObject.generatePeriodDataObjects(json)
                    //                                UserSetting.storePeriodsData(resultObjects)
                    // return to main queue
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completionHandler(periodDataObjects: resultObjects)
                    })
                } else {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completionHandler(periodDataObjects: nil)
                    })
                }
            })
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                // job ended
                ColorgyAPITrafficControlCenter.unqueueBackgroundJob()
                // then handle response
                completionHandler(periodDataObjects: nil)
        })
    }
    
    /// You can simply get a user info API using this.
    ///
    /// :returns: result: ColorgyAPIMeResult?, you can store it.
    /// :returns: error: An error if you got one, then handle it.
    class func getUserInfo(user_id user_id: Int, success: (result: ColorgyAPIUserResult) -> Void, failure: () -> Void) {
        
        let afManager = AFHTTPSessionManager(baseURL: nil)
        afManager.requestSerializer = AFJSONRequestSerializer()
        afManager.responseSerializer = AFJSONResponseSerializer()
        
        print("getting user \(user_id) API")
        
        guard !ColorgyAPITrafficControlCenter.isTokenRefreshing() else {
            print(ColorgyErrorType.TrafficError.stillRefreshing)
            failure()
            return
        }
        guard let accesstoken = UserSetting.UserAccessToken() else {
            failure()
            return
        }
        let url = "https://colorgy.io:443/api/v1/users/\(user_id).json?access_token=\(accesstoken)"
        guard url.isValidURLString else {
            print(ColorgyErrorType.invalidURLString)
            failure()
            return
        }
        
        // queue job
        ColorgyAPITrafficControlCenter.queueNewBackgroundJob()
        // then start job
        afManager.GET(url, parameters: nil, progress: nil,success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            // job ended
            ColorgyAPITrafficControlCenter.unqueueBackgroundJob()
            // into background
            //                        let qos = Int(QOS_CLASS_USER_INTERACTIVE.value)
            let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
            dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in
                // then handle response
                print("me API successfully get")
                // will pass in a json, then generate a result
                if let response = response {
                    let json = JSON(response)
                    print("user \(user_id) get!")
                    if let result = ColorgyAPIUserResult(json: json) {
                        // return to main queue
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            // ok
                            success(result: result)
                        })
                    } else {
                        // return to main queue
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            failure()
                        })
                    }
                } else {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        failure()
                    })
                }
            })
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                // job ended
                ColorgyAPITrafficControlCenter.unqueueBackgroundJob()
                // then handle response
                print("fail to get user \(user_id) API")
                failure()
        })
    }
    
    // MARK: - User API
    // get me
    /// You can simply get Me API using this.
    ///
    /// :returns: result: ColorgyAPIMeResult?, you can store it.
    /// :returns: error: An error if you got one, then handle it.
    class func me(completionHandler: (result: ColorgyAPIMeResult) -> Void, failure: () -> Void) {
        
        let afManager = AFHTTPSessionManager(baseURL: nil)
        afManager.requestSerializer = AFJSONRequestSerializer()
        afManager.responseSerializer = AFJSONResponseSerializer()
        
        print("getting me API")
        
        guard !ColorgyAPITrafficControlCenter.isTokenRefreshing() else {
            print(ColorgyErrorType.TrafficError.stillRefreshing)
            failure()
            return
        }
        guard let accesstoken = UserSetting.UserAccessToken() else {
            failure()
            return
        }
        let url = "https://colorgy.io:443/api/v1/me.json?access_token=\(accesstoken)"
        guard url.isValidURLString else {
            print(ColorgyErrorType.invalidURLString)
            failure()
            return
        }
        
        // queue job
        ColorgyAPITrafficControlCenter.queueNewBackgroundJob()
        // then start job
        afManager.GET(url, parameters: nil, progress: nil,success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            // job ended
            ColorgyAPITrafficControlCenter.unqueueBackgroundJob()
            // into background
            //                        let qos = Int(QOS_CLASS_USER_INTERACTIVE.value)
            let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
            dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in
                // then handle response
                print("me API successfully get")
                // will pass in a json, then generate a result
                if let response = response {
                    let json = JSON(response)
                    print("ME get!")
                    if let result = ColorgyAPIMeResult(json: json) {
                        print(result)
                        // store
                        UserSetting.storeAPIMeResult(result: result)
                        // return to main queue
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            completionHandler(result: result)
                        })
                    } else {
                        // return to main queue
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            failure()
                        })
                    }
                } else {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        failure()
                    })
                }
            })
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                // job ended
                ColorgyAPITrafficControlCenter.unqueueBackgroundJob()
                // then handle response
                print("fail to get me API")
                failure()
        })
    }
    
    // get me courses
    /// Get self courses from server.
    ///
    /// :returns: userCourseObjects: A [UserCourseObject]? array, might be nil or 0 element.
    class func getMeCourses(completionHandler: (userCourseObjects: [UserCourseObject]?) -> Void, failure: () -> Void) {
        
        let afManager = AFHTTPSessionManager(baseURL: nil)
        afManager.requestSerializer = AFJSONRequestSerializer()
        afManager.responseSerializer = AFJSONResponseSerializer()
        
        guard let userId = UserSetting.UserId() else {
            print(ColorgyErrorType.noSuchUser)
            failure()
            return
        }
        guard !ColorgyAPITrafficControlCenter.isTokenRefreshing() else {
            print(ColorgyErrorType.TrafficError.stillRefreshing)
            failure()
            return
        }
        guard let user = ColorgyUser() else {
            print(ColorgyErrorType.noSuchUser)
            failure()
            return
        }
        guard let possibleOrganization = user.possibleOrganization else {
            print("user get no possible org")
            failure()
            return
        }
        guard let accesstoken = user.accessToken else {
            failure()
            return
        }
        let semester: (year: Int, term: Int) = Semester.currentSemesterAndYear()
        let url = "https://colorgy.io:443/api/v1/user_courses.json?filter%5Buser_id%5D=\(userId)&filter%5Bcourse_organization_code%5D=\(possibleOrganization)&filter%5Byear%5D=\(semester.year)&filter%5Bterm%5D=\(semester.term)&&&&&&&access_token=\(accesstoken)"
        guard url.isValidURLString else {
            print(ColorgyErrorType.invalidURLString)
            failure()
            return
        }
        
        // queue job
        ColorgyAPITrafficControlCenter.queueNewBackgroundJob()
        // then start job
        afManager.GET(url, parameters: nil, progress: nil,success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            // job ended
            ColorgyAPITrafficControlCenter.unqueueBackgroundJob()
            // into background
            //                            let qos = Int(QOS_CLASS_USER_INTERACTIVE.value)
            let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
            dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in
                // then handle response
                // will return a array of courses
                if let response = response {
                    let json = JSON(response)
                    let userCourseObjects = UserCourseObjectArray(json: json).objects
                    // return to main queue
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completionHandler(userCourseObjects: userCourseObjects)
                    })
                } else {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completionHandler(userCourseObjects: nil)
                    })
                }
            })
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                // job ended
                ColorgyAPITrafficControlCenter.unqueueBackgroundJob()
                // then handle response
                print(ColorgyErrorType.APIFailure.failGetUserCourses)
                failure()
        })
    }
    
    // get **ALL** me courses
    /// Get **ALL** self courses from server.
    ///
    /// :returns: userCourseObjects: A [UserCourseObject]? array, might be nil or 0 element.
    class func getALLMeCourses(completionHandler: (userCourseObjects: [UserCourseObject]?) -> Void, failure: () -> Void) {
        
        let afManager = AFHTTPSessionManager(baseURL: nil)
        afManager.requestSerializer = AFJSONRequestSerializer()
        afManager.responseSerializer = AFJSONResponseSerializer()
        
        guard let userId = UserSetting.UserId() else {
            print(ColorgyErrorType.noSuchUser)
            failure()
            return
        }
        guard !ColorgyAPITrafficControlCenter.isTokenRefreshing() else {
            print(ColorgyErrorType.TrafficError.stillRefreshing)
            failure()
            return
        }
        guard let user = ColorgyUser() else {
            print(ColorgyErrorType.noSuchUser)
            failure()
            return
        }
        guard let possibleOrganization = user.possibleOrganization else {
            print("user get no possible org")
            failure()
            return
        }
        guard let accesstoken = user.accessToken else {
            failure()
            return
        }
        //    let semester: (year: Int, term: Int) = Semester.currentSemesterAndYear()
        let url = "https://colorgy.io:443/api/v1/user_courses.json?filter%5Buser_id%5D=\(userId)&filter%5Bcourse_organization_code%5D=\(possibleOrganization)&&&&&&&access_token=\(accesstoken)"
        guard url.isValidURLString else {
            print(ColorgyErrorType.invalidURLString)
            failure()
            return
        }
        
        // queue job
        ColorgyAPITrafficControlCenter.queueNewBackgroundJob()
        // then start job
        afManager.GET(url, parameters: nil, progress: nil,success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            // job ended
            ColorgyAPITrafficControlCenter.unqueueBackgroundJob()
            // into background
            //                            let qos = Int(QOS_CLASS_USER_INTERACTIVE.value)
            let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
            dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in
                // then handle response
                // will return a array of courses
                if let response = response {
                    let json = JSON(response)
                    let userCourseObjects = UserCourseObjectArray(json: json).objects
                    // return to main queue
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completionHandler(userCourseObjects: userCourseObjects)
                    })
                } else {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completionHandler(userCourseObjects: nil)
                    })
                }
            })
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                // job ended
                ColorgyAPITrafficControlCenter.unqueueBackgroundJob()
                // then handle response
                print(ColorgyErrorType.APIFailure.failGetUserCourses)
                failure()
        })
    }
    // get other's courses
    /// Get a specific courses from server.
    ///
    /// If userid is not a Int string, then server will just return [ ] empty array.
    ///
    /// :param: userid: A specific user id
    /// :returns: userCourseObjects: A [UserCourseObject]? array, might be nil or 0 element.
    class func getUserCoursesWithUserId(userid: String, completionHandler: (userCourseObjects: [UserCourseObject]?) -> Void, failure: () -> Void) {
        
        let afManager = AFHTTPSessionManager(baseURL: nil)
        afManager.requestSerializer = AFJSONRequestSerializer()
        afManager.responseSerializer = AFJSONResponseSerializer()
        
        guard !ColorgyAPITrafficControlCenter.isTokenRefreshing() else {
            print(ColorgyErrorType.TrafficError.stillRefreshing)
            failure()
            return
        }
        guard let user = ColorgyUser() else {
            print(ColorgyErrorType.noSuchUser)
            failure()
            return
        }
        print("getting user \(userid)'s course")
        guard let accesstoken = user.accessToken else {
            failure()
            return
        }
        let semester: (year: Int, term: Int) = Semester.currentSemesterAndYear()
        let url = "https://colorgy.io:443/api/v1/user_courses.json?filter%5Buser_id%5D=\(userid)&&filter%5Byear%5D=\(semester.year)&filter%5Bterm%5D=\(semester.term)&&&&&&&access_token=\(accesstoken)"
        print(url)
        guard url.isValidURLString else {
            print(ColorgyErrorType.invalidURLString)
            failure()
            return
        }
        
        // queue job
        ColorgyAPITrafficControlCenter.queueNewBackgroundJob()
        // then start job
        afManager.GET(url, parameters: nil, progress: nil,success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            // job ended
            ColorgyAPITrafficControlCenter.unqueueBackgroundJob()
            // into background
            //                            let qos = Int(QOS_CLASS_USER_INTERACTIVE.value)
            let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
            dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in
                // then handle response
                // will return a array of courses
                if let response = response {
                    let json = JSON(response)
                    let userCourseObjects = UserCourseObjectArray(json: json).objects
                    // return to main queue
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completionHandler(userCourseObjects: userCourseObjects)
                    })
                } else {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completionHandler(userCourseObjects: nil)
                    })
                }
            })
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                // job ended
                ColorgyAPITrafficControlCenter.unqueueBackgroundJob()
                // then handle response
                print(ColorgyErrorType.APIFailure.failGetUserCourses)
                failure()
        })
    }
    
    // PUT class
    class func PUTCourseToServer(courseCode: String, year: Int, term: Int, success: () -> Void, failure: () -> Void) {
        
        let afManager = AFHTTPSessionManager(baseURL: nil)
        afManager.requestSerializer = AFJSONRequestSerializer()
        afManager.responseSerializer = AFJSONResponseSerializer()
        
        guard !ColorgyAPITrafficControlCenter.isTokenRefreshing() else {
            print(ColorgyErrorType.TrafficError.stillRefreshing)
            failure()
            return
        }
        guard let accesstoken = UserSetting.UserAccessToken() else {
            print(ColorgyErrorType.noAccessToken)
            failure()
            return
        }
        guard let user_id = UserSetting.UserId() else {
            print("no user id")
            failure()
            return
        }
        guard let school = UserSetting.UserPossibleOrganization() else {
            print("no school")
            failure()
            return
        }
        let uuid = "\(user_id)-\(year)-\(term)-\(school.uppercaseString)-\(courseCode)"
        let url = "https://colorgy.io:443/api/v1/me/user_courses/\(uuid).json?access_token=\(accesstoken)"
        let params = ["user_courses":
            [
                "course_code": courseCode,
                "course_organization_code": school.uppercaseString,
                "year": year,
                "term": term
            ]
        ]
        print(url)
        print(params)
        guard url.isValidURLString else {
            print("url invalid")
            failure()
            return
        }
        
        // queue job
        ColorgyAPITrafficControlCenter.queueNewBackgroundJob()
        afManager.PUT(url, parameters: params, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            // job ended
            ColorgyAPITrafficControlCenter.unqueueBackgroundJob()
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                success()
            })
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                // job ended
                ColorgyAPITrafficControlCenter.unqueueBackgroundJob()
                print(task)
                failure()
        })
    }
    
    // DELETE class
    class func DELETECourseToServer(courseCode: String, success: (courseCode: String) -> Void, failure: () -> Void) {
        
        let afManager = AFHTTPSessionManager(baseURL: nil)
        afManager.requestSerializer = AFJSONRequestSerializer()
        afManager.responseSerializer = AFJSONResponseSerializer()
        
        guard !ColorgyAPITrafficControlCenter.isTokenRefreshing() else {
            print(ColorgyErrorType.TrafficError.stillRefreshing)
            failure()
            return
        }
        guard let accesstoken = UserSetting.UserAccessToken() else {
            print(ColorgyErrorType.noAccessToken)
            failure()
            return
        }
        
        // get self course data from server
        ColorgyAPI.getALLMeCourses({ (userCourseObjects) -> Void in
            print(userCourseObjects?.count)
            guard let userCourseObjects = userCourseObjects else {
                print("fail to get me course")
                failure()
                return
            }
            //            print(userCourseObjects)
            var isMatch = false
            for userCourseObject in userCourseObjects {
                if courseCode == userCourseObject.course_code  {
                    isMatch = true
                    let uuid = userCourseObject.uuid
                    let url = "https://colorgy.io:443/api/v1/me/user_courses/\(uuid).json?access_token=\(accesstoken)"
                    
                    guard url.isValidURLString else {
                        print(ColorgyErrorType.invalidURLString)
                        failure()
                        return
                    }
                    print(courseCode)
                    // queue job
                    ColorgyAPITrafficControlCenter.queueNewBackgroundJob()
                    afManager.DELETE(url, parameters: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                        // job ended
                        ColorgyAPITrafficControlCenter.unqueueBackgroundJob()
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            success(courseCode: courseCode)
                        })
                        }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                            // job ended
                            print(error.localizedDescription)
                            ColorgyAPITrafficControlCenter.unqueueBackgroundJob()
                            failure()
                    })
                }
            }
            // if no uuid match, shows that server doesnt store this course
            if !isMatch {
                // TODO: something wierd
                
                failure()
            }
            }, failure: { () -> Void in
                print("cant get me courses")
                failure()
        })
    }
    
    class func getSchools(success: (schools: [School]) -> Void, failure: () -> Void) {
        
        let afManager = AFHTTPSessionManager(baseURL: nil)
        afManager.requestSerializer = AFJSONRequestSerializer()
        afManager.responseSerializer = AFJSONResponseSerializer()
        
        guard !ColorgyAPITrafficControlCenter.isTokenRefreshing() else {
            print(ColorgyErrorType.TrafficError.stillRefreshing)
            failure()
            return
        }
        guard let accesstoken = UserSetting.UserAccessToken() else {
            print(ColorgyErrorType.noAccessToken)
            failure()
            return
        }
        let url = "https://colorgy.io:443/api/v1/organizations.json?access_token=\(accesstoken)"
        guard url.isValidURLString else {
            print(ColorgyErrorType.invalidURLString)
            failure()
            return
        }
        
        ColorgyAPITrafficControlCenter.queueNewBackgroundJob()
        afManager.GET(url, parameters: nil, progress: nil,success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            ColorgyAPITrafficControlCenter.unqueueBackgroundJob()
            if let response = response {
                let json = JSON(response)
                success(schools: School.generateSchoolsWithJSON(json))
            } else {
                failure()
            }
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                ColorgyAPITrafficControlCenter.unqueueBackgroundJob()
                failure()
        })
    }
    
    class func getDepartments(school: String, success: (departments: [Department]) -> Void, failure: () -> Void) {
        
        let afManager = AFHTTPSessionManager(baseURL: nil)
        afManager.requestSerializer = AFJSONRequestSerializer()
        afManager.responseSerializer = AFJSONResponseSerializer()
        
        guard !ColorgyAPITrafficControlCenter.isTokenRefreshing() else {
            print(ColorgyErrorType.TrafficError.stillRefreshing)
            failure()
            return
        }
        guard let accesstoken = UserSetting.UserAccessToken() else {
            print(ColorgyErrorType.noAccessToken)
            failure()
            return
        }
        let url = "https://colorgy.io:443/api/v1/organizations/\(school.uppercaseString).json?access_token=\(accesstoken)"
        guard url.isValidURLString else {
            print(ColorgyErrorType.invalidURLString)
            failure()
            return
        }
        
        ColorgyAPITrafficControlCenter.queueNewBackgroundJob()
        afManager.GET(url, parameters: nil, progress: nil,success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            if let response = response {
                let json = JSON(response)
                let departments = Department.generateDepartments(json)
                print(departments)
                success(departments: departments)
            } else {
                failure()
            }
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure()
        })
    }
    
    class func PATCHUserInfo(organization: String, department: String, year: String, success: () -> Void, failure: () -> Void) {
        
        let afManager = AFHTTPSessionManager(baseURL: nil)
        afManager.requestSerializer = AFJSONRequestSerializer()
        afManager.responseSerializer = AFJSONResponseSerializer()
        
        guard !ColorgyAPITrafficControlCenter.isTokenRefreshing() else {
            print(ColorgyErrorType.TrafficError.stillRefreshing)
            failure()
            return
        }
        guard let accesstoken = UserSetting.UserAccessToken() else {
            print(ColorgyErrorType.noAccessToken)
            failure()
            return
        }
        let url = "https://colorgy.io:443/api/v1/me.json?access_token=\(accesstoken)"
        guard url.isValidURLString else {
            print(ColorgyErrorType.invalidURLString)
            failure()
            return
        }
        
        let params = ["user":
            [
                "unconfirmed_organization_code": organization,
                "unconfirmed_department_code": department,
                "unconfirmed_started_year": year
            ]
        ]
        print(url)
		print(params)
        afManager.PATCH(url, parameters: params, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            print("PATCH OK")
            print(response)
            success()
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
				print(error.localizedDescription)
                print("fail to patch")
                failure()
        })
    }
    
    class func GETMEPrivacySetting(success success: (isTimeTablePublic: Bool) -> Void, failure: () -> Void) {
        
        let afManager = AFHTTPSessionManager(baseURL: nil)
        afManager.requestSerializer = AFJSONRequestSerializer()
        afManager.responseSerializer = AFJSONResponseSerializer()
        
        guard !ColorgyAPITrafficControlCenter.isTokenRefreshing() else {
            print(ColorgyErrorType.TrafficError.stillRefreshing)
            failure()
            return
        }
        guard let accesstoken = UserSetting.UserAccessToken() else {
            print(ColorgyErrorType.noAccessToken)
            failure()
            return
        }
        let url = "https://colorgy.io:443/api/v1/me/user_table_settings.json?access_token=\(accesstoken)"
        guard url.isValidURLString else {
            print(ColorgyErrorType.invalidURLString)
            failure()
            return
        }
        
        afManager.GET(url, parameters: nil, progress: nil,success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            if let response = response {
                let json = JSON(response)
                var isTimeTablePublic = false
                if json.isArray {
                    if let visibility = json[0]["courses_table_visibility"].bool {
                        isTimeTablePublic = visibility
                    }
                } else {
                    if let visibility = json["courses_table_visibility"].bool {
                        isTimeTablePublic = visibility
                    }
                }
                success(isTimeTablePublic: isTimeTablePublic)
            } else {
                failure()
            }
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure()
        })
    }
    
    class func GetUserPrivacySetting(userId userId: Int,  success: (isTimeTablePublic: Bool) -> Void, failure: () -> Void) {
        
        let afManager = AFHTTPSessionManager(baseURL: nil)
        afManager.requestSerializer = AFJSONRequestSerializer()
        afManager.responseSerializer = AFJSONResponseSerializer()
        
        guard !ColorgyAPITrafficControlCenter.isTokenRefreshing() else {
            print(ColorgyErrorType.TrafficError.stillRefreshing)
            failure()
            return
        }
        guard let accesstoken = UserSetting.UserAccessToken() else {
            print(ColorgyErrorType.noAccessToken)
            failure()
            return
        }
        guard userId > 0 else {
            print("user id must larger then 0")
            failure()
            return
        }
        let url = "https://colorgy.io/api/v1/user_table_settings/\(userId).json?access_token=\(accesstoken)"
        guard url.isValidURLString else {
            print(ColorgyErrorType.invalidURLString)
            failure()
            return
        }
        
        afManager.GET(url, parameters: nil, progress: nil,success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            if let response = response {
                let json = JSON(response)
                var isTimeTablePublic = false
                if json.isArray {
                    if let visibility = json[0]["courses_table_visibility"].bool {
                        isTimeTablePublic = visibility
                    }
                } else {
                    if let visibility = json["courses_table_visibility"].bool {
                        isTimeTablePublic = visibility
                    }
                }
                success(isTimeTablePublic: isTimeTablePublic)
            } else {
                failure()
            }
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
				print(error.localizedDescription)
                failure()
        })
    }
    
    class func PATCHMEPrivacySetting(trunIt on: Bool, success: () -> Void, failure: () -> Void) {
        
        let afManager = AFHTTPSessionManager(baseURL: nil)
        afManager.requestSerializer = AFJSONRequestSerializer()
        afManager.responseSerializer = AFJSONResponseSerializer()
        
        guard !ColorgyAPITrafficControlCenter.isTokenRefreshing() else {
            print(ColorgyErrorType.TrafficError.stillRefreshing)
            failure()
            return
        }
        guard let accesstoken = UserSetting.UserAccessToken() else {
            print(ColorgyErrorType.noAccessToken)
            failure()
            return
        }
        guard let userId = UserSetting.UserId() else {
            print(ColorgyErrorType.noSuchUser)
            failure()
            return
        }
        let url = "https://colorgy.io:443/api/v1/me/user_table_settings/\(userId).json?access_token=\(accesstoken)"
        guard url.isValidURLString else {
            print(ColorgyErrorType.invalidURLString)
            failure()
            return
        }
        
        let params = [
            "user_table_settings": [
                "courses_table_visibility": on
            ]
        ]
        afManager.PATCH(url, parameters: params, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            success()
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure()
        })
    }
    
    class func POSTUserFeedBack(userEmail: String, feedbackType: String, feedbackDescription: String, success: () -> Void, failure: () -> Void) {
        
        let afManager = AFHTTPSessionManager(baseURL: nil)
        afManager.requestSerializer = AFJSONRequestSerializer()
        afManager.responseSerializer = AFJSONResponseSerializer()
        
        guard !ColorgyAPITrafficControlCenter.isTokenRefreshing() else {
            print(ColorgyErrorType.TrafficError.stillRefreshing)
            failure()
            return
        }
        guard let accesstoken = UserSetting.UserAccessToken() else {
            print(ColorgyErrorType.noAccessToken)
            failure()
            return
        }
        let url = "https://colorgy.io:443/api/v1/me/user_app_feedbacks.json?access_token=\(accesstoken)"
        guard url.isValidURLString else {
            print(ColorgyErrorType.invalidURLString)
            failure()
            return
        }
        
        let osVersion = NSProcessInfo.processInfo().operatingSystemVersion
        let appVersion = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String
        let params = ["user_app_feedbacks":
            [
                "user_email": userEmail,
                "type": feedbackType,
                "description": feedbackDescription,
                "device_type": "ios",
                "device_manufacturer": "Apple",
                "device_os_verison": "\(osVersion.majorVersion).\(osVersion.minorVersion).\(osVersion.patchVersion)",
                "app_verison": appVersion ?? "unknown version"
            ]
        ]
        
        afManager.POST(url, parameters: params, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            print(response)
            success()
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print(error.localizedDescription)
                failure()
        })
    }
    
    class func POSTUserEmail(userEmail: String, success: (AnyObject) -> Void, failure: () -> Void) {
        
        let afManager = AFHTTPSessionManager(baseURL: nil)
        afManager.requestSerializer = AFJSONRequestSerializer()
        afManager.responseSerializer = AFJSONResponseSerializer()
        
        guard !ColorgyAPITrafficControlCenter.isTokenRefreshing() else {
            print(ColorgyErrorType.TrafficError.stillRefreshing)
            failure()
            return
        }
        guard let accesstoken = UserSetting.UserAccessToken() else {
            print(ColorgyErrorType.noAccessToken)
            failure()
            return
        }
        let url = "https://colorgy.io:443/api/v1/me/emails.json?access_token=\(accesstoken)"
        guard url.isValidURLString else {
            print(ColorgyErrorType.invalidURLString)
            failure()
            return
        }
        
        let params = ["user_email":
            [
                "email": userEmail
            ]
        ]
        
        afManager.POST(url, parameters: params, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            print(response)
            if let response = response {
                success(response)
            } else {
                failure()
            }
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print(error.localizedDescription)
                failure()
        })
    }
    
    
    class func PATCHUserImage(avatar: String, avatar_crop_x: Float, avatar_crop_y: Float, avatar_crop_w: Float, avatar_crop_h: Float, success: (response: AnyObject) -> Void, failure: () -> Void) {
        
        let afManager = AFHTTPSessionManager(baseURL: nil)
        afManager.requestSerializer = AFJSONRequestSerializer()
        afManager.responseSerializer = AFJSONResponseSerializer()
        
        guard !ColorgyAPITrafficControlCenter.isTokenRefreshing() else {
            print(ColorgyErrorType.TrafficError.stillRefreshing)
            failure()
            return
        }
        guard let accesstoken = UserSetting.UserAccessToken() else {
            print(ColorgyErrorType.noAccessToken)
            failure()
            return
        }
        let url = "https://colorgy.io:443/api/v1/me.json?access_token=\(accesstoken)"
        guard url.isValidURLString else {
            print(ColorgyErrorType.invalidURLString)
            failure()
            return
        }
        
        let params = ["user":
            [
                "avatar": avatar,
                "avatar_crop_x": avatar_crop_x,
                "avatar_crop_y": avatar_crop_y,
                "avatar_crop_w": avatar_crop_w,
                "avatar_crop_h": avatar_crop_h
            ]
        ]
        
        afManager.PATCH(url, parameters: params, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            if let response = response {
                print("PATCH OK")
                print(response)
                success(response: response)
            } else {
                failure()
            }
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print("fail to patch")
                failure()
        })
        
        return
    }
	
	class func registerUserWithName(name: String, email: String, password: String, passwordConfirm: String, success: () -> Void, failure: () -> Void) {
		
		let afManager = AFHTTPSessionManager(baseURL: nil)
//		afManager.requestSerializer = AFJSONRequestSerializer()
//		afManager.responseSerializer = AFJSONResponseSerializer()
		
		guard !ColorgyAPITrafficControlCenter.isTokenRefreshing() else {
			print(ColorgyErrorType.TrafficError.stillRefreshing)
			failure()
			return
		}
		let url = "https://colorgy.io/api/v1/sign_up"
		guard url.isValidURLString else {
			print(ColorgyErrorType.invalidURLString)
			failure()
			return
		}
		
		let params = [
			"user": [
				"name": name,
				"email": email,
				"password": password,
				"password_confirmation": passwordConfirm
			]
		]
		
		afManager.POST(url, parameters: params, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
			success()
			}, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
				print(error.localizedDescription)
				print((operation?.response as? NSHTTPURLResponse)?.statusCode)
				failure()
				guard let data = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] as? NSData else {
					// fail to get data
					return
				}
				
				// temp message
				var message = String()
				
				do {
					message = try "\(NSJSONSerialization.JSONObjectWithData(data, options: []))"
				} catch {
					return
				}
				
				print(message)
		})
	}
	
	class func availableOrganization(org: String, success: (isAvailable: Bool) -> Void, failure: () -> Void) {
		
		let afManager = AFHTTPSessionManager(baseURL: nil)
		//		afManager.requestSerializer = AFJSONRequestSerializer()
		//		afManager.responseSerializer = AFJSONResponseSerializer()
		
		guard !ColorgyAPITrafficControlCenter.isTokenRefreshing() else {
			print(ColorgyErrorType.TrafficError.stillRefreshing)
			failure()
			return
		}
		guard let accesstoken = UserSetting.UserAccessToken() else {
			print(ColorgyErrorType.noAccessToken)
			failure()
			return
		}
		let url = "https://colorgy.io:443/api/v1/available_org/\(org.uppercaseString).json?access_token=\(accesstoken)"
		guard url.isValidURLString else {
			print(ColorgyErrorType.invalidURLString)
			failure()
			return
		}
		
		afManager.GET(url, parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
			if let response = response {
				let json = JSON(response)
				print(json["available"].boolValue)
				success(isAvailable: json["available"].boolValue)
			} else {
				failure()
			}
			
			}, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
				print(error.localizedDescription)
				print((operation?.response as? NSHTTPURLResponse)?.statusCode)
				failure()
				guard let data = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] as? NSData else {
					// fail to get data
					return
				}
				
				// temp message
				var message = String()
				
				do {
					message = try "\(NSJSONSerialization.JSONObjectWithData(data, options: []))"
				} catch {
					return
				}
				
				print(message)
		})
	}
}