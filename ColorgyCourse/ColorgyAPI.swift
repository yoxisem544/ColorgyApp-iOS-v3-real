//
//  ColorgyAPIHandler.swift
//  ColorgyAPIHandler
//
//  Created by David on 2015/8/22.
//  Copyright (c) 2015年 David. All rights reserved.
//

import Foundation

class ColorgyAPI {
    
    // what do i need here?
    // need to
    
    // MARK: - push notification device token
    // push notification device token
    class func PUTdeviceToken(success success: () -> Void, failure: () -> Void) {
        if ColorgyAPITrafficControlCenter.isTokenRefreshing() {
            print(ColorgyErrorType.TrafficError.stillRefreshing)
            failure()
        } else {
            if let token = UserSetting.getPushNotificationDeviceToken() {
                if let accesstoken = UserSetting.UserAccessToken() {
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
                        afManager.PUT(url, parameters: params, success: { (task: NSURLSessionDataTask, response: AnyObject) -> Void in
                        print("Success")
                        // job ended
                        ColorgyAPITrafficControlCenter.unqueueBackgroundJob()
                        success()
                        }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                        print("fail \(error)")
                        // job ended
                        ColorgyAPITrafficControlCenter.unqueueBackgroundJob()
                        failure()
                        })
                    } else {
                        failure()
                    }
                } else {
                    failure()
                }
            } else {
                failure()
            }
        }
    }
    
    /// Get all the token stored in server
    class func GETdeviceToken(success success: (devices: [[String : String]]) -> Void, failure: () -> Void) {
        if ColorgyAPITrafficControlCenter.isTokenRefreshing() {
            print(ColorgyErrorType.TrafficError.stillRefreshing)
            failure()
        } else {
            if UserSetting.getPushNotificationDeviceToken() != nil {
                if let accesstoken = UserSetting.UserAccessToken() {
                    let afManager = AFHTTPSessionManager(baseURL: nil)
                    afManager.requestSerializer = AFJSONRequestSerializer()
                    afManager.responseSerializer = AFJSONResponseSerializer()
                    
                    // queue job
                    ColorgyAPITrafficControlCenter.queueNewBackgroundJob()
                    let url = "https://colorgy.io:443/api/v1/me/devices.json?access_token=\(accesstoken)"
                    afManager.GET(url, parameters: nil, success: { (task: NSURLSessionDataTask, response: AnyObject) -> Void in
                        // job ended
                        ColorgyAPITrafficControlCenter.unqueueBackgroundJob()
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
                        }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                            // job ended
                            ColorgyAPITrafficControlCenter.unqueueBackgroundJob()
                            print(error)
                            failure()
                    })
                } else {
                    failure()
                }
            } else {
                // no device token
                failure()
            }
        }
    }
    
    /// Delete a uuid and push notification token set.
    /// Always call this in background worker.
    class func DELETEdeviceTokenAndPushNotificationPare(success success: () -> Void, failure: () -> Void) {
        if ColorgyAPITrafficControlCenter.isTokenRefreshing() {
            print(ColorgyErrorType.TrafficError.stillRefreshing)
            failure()
        } else {
            if let accesstoken = UserSetting.UserAccessToken() {
                if let uuid = UserSetting.getDeviceUUID() {
                    let afManager = AFHTTPSessionManager(baseURL: nil)
                    afManager.requestSerializer = AFJSONRequestSerializer()
                    afManager.responseSerializer = AFJSONResponseSerializer()
                    
                    print(uuid)
                    let url = "https://colorgy.io:443/api/v1/me/devices/\(uuid).json?access_token=\(accesstoken)"
                    // queue job
                    ColorgyAPITrafficControlCenter.queueNewBackgroundJob()
                    afManager.DELETE(url, parameters: nil, success: { (task: NSURLSessionDataTask, response: AnyObject) -> Void in
                        // job ended
                        ColorgyAPITrafficControlCenter.unqueueBackgroundJob()
                        success()
                        }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                            // job ended
                            ColorgyAPITrafficControlCenter.unqueueBackgroundJob()
                            failure()
                    })
                } else {
                    print("no need delete uuid token pare")
                    success()
                }
            } else {
                print("no access token")
                failure()
            }
        }
    }
    
    /// Delete a uuid and push notification token set.
    /// Always call this in background worker.
    class func DELETEdeviceTokenAndPushNotificationPareUsingUUID(uuid: String?, success: () -> Void, failure: () -> Void) {
        if ColorgyAPITrafficControlCenter.isTokenRefreshing() {
            print(ColorgyErrorType.TrafficError.stillRefreshing)
            failure()
        } else {
            if let accesstoken = UserSetting.UserAccessToken() {
                if let uuid = uuid {
                    let afManager = AFHTTPSessionManager(baseURL: nil)
                    afManager.requestSerializer = AFJSONRequestSerializer()
                    afManager.responseSerializer = AFJSONResponseSerializer()
                    
                    print(uuid)
                    let url = "https://colorgy.io:443/api/v1/me/devices/\(uuid).json?access_token=\(accesstoken)"
                    // queue job
                    ColorgyAPITrafficControlCenter.queueNewBackgroundJob()
                    afManager.DELETE(url, parameters: nil, success: { (task: NSURLSessionDataTask, response: AnyObject) -> Void in
                        // job ended
                        ColorgyAPITrafficControlCenter.unqueueBackgroundJob()
                        success()
                        }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                            // job ended
                            ColorgyAPITrafficControlCenter.unqueueBackgroundJob()
                            failure()
                    })
                } else {
                    print("no need delete uuid token pare")
                    success()
                }
            } else {
                print("no access token")
                failure()
            }
        }
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
    class func getSchoolCourseData(count: Int?, year: Int, term: Int, success: (courses: [Course], json: JSON) -> Void, failure: (failInfo: String?) -> Void, processing: (processState: String) -> Void) {
        
        let afManager = AFHTTPSessionManager(baseURL: nil)
        afManager.requestSerializer = AFJSONRequestSerializer()
        afManager.responseSerializer = AFJSONResponseSerializer()
        
        if ColorgyAPITrafficControlCenter.isTokenRefreshing() {
            print(ColorgyErrorType.TrafficError.stillRefreshing)
            failure(failInfo: nil)
        } else {
            if let organization = UserSetting.UserPossibleOrganization() {
                if let accesstoken = UserSetting.UserAccessToken() {
                    let coursesCount = count ?? 20000
                    let url = "https://colorgy.io:443/api/v1/\(organization.lowercaseString)/courses.json?per_page=\(String(coursesCount))&&&filter%5Byear%5D=\(year)&filter%5Bterm%5D=\(term)&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&access_token=\(accesstoken)"
                    if url.isValidURLString {
                        // queue job
                        ColorgyAPITrafficControlCenter.queueNewBackgroundJob()
                        // indicate user while downloading
                        processing(processState: "正在下載資料...")
                        // then start job
                        afManager.GET(url, parameters: nil, success: { (task: NSURLSessionDataTask, response: AnyObject) -> Void in
                            // check header
//                            print(task.response)  
                            
                            // job ended
                            ColorgyAPITrafficControlCenter.unqueueBackgroundJob()
                            // into background
                            //                            let qos = Int(QOS_CLASS_USER_INTERACTIVE.value)
                            let qos = Int(QOS_CLASS_USER_INTERACTIVE.rawValue)
                            
                            dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in
                                
                                processing(processState: "下載完成，準備處理資料...")
                                // then handle response
                                let json = JSON(response)
                                let courseRawDataArray = CourseRawDataArray(json: json, process: { (state) -> Void in
                                    processing(processState: state)
                                })
                                processing(processState: "正在儲存資料到手機上...")
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
                                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                        failure(failInfo: nil)
                                    })
                                }
                                
                            })
                            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                                // job ended
                                ColorgyAPITrafficControlCenter.unqueueBackgroundJob()
                                // then handle response
                                print(ColorgyErrorType.APIFailure.failDownloadCourses)
                                print(error.localizedDescription)
                                print(error)
                                failure(failInfo: "你的網路不穩定，請確定在網路良好的環境下載哦！")
                        })
                    } else {
                        print(ColorgyErrorType.invalidURLString)
                        failure(failInfo: nil)
                    }
                }
            } else {
                failure(failInfo: nil)
                print(ColorgyErrorType.noOrganization)
            }
        }
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
        
        if ColorgyAPITrafficControlCenter.isTokenRefreshing() {
            print(ColorgyErrorType.TrafficError.stillRefreshing)
            failure()
        } else {
            if let accesstoken = UserSetting.UserAccessToken() {
                if let school = UserSetting.UserPossibleOrganization() {
                    let url = "https://colorgy.io:443/api/v1/\(school.lowercaseString)/courses/\(code).json?access_token=\(accesstoken)"
                    
                    if url.isValidURLString {
                        // queue job
                        ColorgyAPITrafficControlCenter.queueNewBackgroundJob()
                        // then start job
                        afManager.GET(url, parameters: nil, success: { (task: NSURLSessionDataTask, response: AnyObject) -> Void in
                            // job ended
                            ColorgyAPITrafficControlCenter.unqueueBackgroundJob()
                            // into background
                            //                        let qos = Int(QOS_CLASS_USER_INTERACTIVE.value)
                            let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
                            dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in
                                // then handle response
//                                print(response)
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
                            })
                            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                                // job ended
                                ColorgyAPITrafficControlCenter.unqueueBackgroundJob()
                                // then handle response
                                print("Err \(error)")
                                failure()
                        })
                    } else {
                        print(ColorgyErrorType.invalidURLString)
                        failure()
                    }
                } else {
                    print(ColorgyErrorType.noOrganization)
                    failure()
                }
            } else {
                print(ColorgyErrorType.APIFailure.failGetUserCourses)
                failure()
            }
        }
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
        
        if ColorgyAPITrafficControlCenter.isTokenRefreshing() {
            print(ColorgyErrorType.TrafficError.stillRefreshing)
            failure()
        } else {
            if let accesstoken = UserSetting.UserAccessToken() {
                let url = "https://colorgy.io:443/api/v1/user_courses.json?filter%5Bcourse_code%5D=\(code)&&&&&&&&&access_token=\(accesstoken)"
                if url.isValidURLString {
                    // queue job
                    ColorgyAPITrafficControlCenter.queueNewBackgroundJob()
                    // then start job
                    afManager.GET(url, parameters: nil, success: { (task: NSURLSessionDataTask, response: AnyObject) -> Void in
                        // job ended
                        ColorgyAPITrafficControlCenter.unqueueBackgroundJob()
                        // into background
                        //                        let qos = Int(QOS_CLASS_USER_INTERACTIVE.value)
                        let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
                        dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in
                            // then handle response
                            let json = JSON(response)
                            print(json)
                            if let objects = UserCourseObjectArray(json: json).objects {
                                print(objects)
                                // return to main queue
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    success(userCourseObjects: objects)
                                })
                            } else {
                                failure()
                            }
                        })
                        }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                            // job ended
                            ColorgyAPITrafficControlCenter.unqueueBackgroundJob()
                            // then handle response
                            print(ColorgyErrorType.APIFailure.failGetUserCourses)
                            failure()
                    })
                } else {
                    print(ColorgyErrorType.invalidURLString)
                    print(url)
                    failure()
                }
            } else {
                print(ColorgyErrorType.APIFailure.failGetUserCourses)
                failure()
            }
        }
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
        afManager.GET(url, parameters: nil, success: { (task: NSURLSessionDataTask, response: AnyObject) -> Void in
            // job ended
            ColorgyAPITrafficControlCenter.unqueueBackgroundJob()
            // into background
            //                    let qos = Int(QOS_CLASS_USER_INTERACTIVE.value)
            let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
            dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in
                // then handle response
                let json = JSON(response)
                let resultObjects = PeriodDataObject.generatePeriodDataObjects(json)
                UserSetting.storePeriodsData(resultObjects)
                // return to main queue
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler(periodDataObjects: resultObjects)
                })
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
        afManager.GET(url, parameters: nil, success: { (task: NSURLSessionDataTask, response: AnyObject) -> Void in
            // job ended
            ColorgyAPITrafficControlCenter.unqueueBackgroundJob()
            // into background
            //                    let qos = Int(QOS_CLASS_USER_INTERACTIVE.value)
            let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
            dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in
                // then handle response
                let json = JSON(response)
                let resultObjects = PeriodDataObject.generatePeriodDataObjects(json)
                //                                UserSetting.storePeriodsData(resultObjects)
                // return to main queue
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler(periodDataObjects: resultObjects)
                })
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
        
        if ColorgyAPITrafficControlCenter.isTokenRefreshing() {
            print(ColorgyErrorType.TrafficError.stillRefreshing)
            failure()
        } else {
            if let accesstoken = UserSetting.UserAccessToken() {
                let url = "https://colorgy.io:443/api/v1/users/\(user_id).json?access_token=\(accesstoken)"
                
                if url.isValidURLString {
                    // queue job
                    ColorgyAPITrafficControlCenter.queueNewBackgroundJob()
                    // then start job
                    afManager.GET(url, parameters: nil, success: { (task: NSURLSessionDataTask, response: AnyObject) -> Void in
                        // job ended
                        ColorgyAPITrafficControlCenter.unqueueBackgroundJob()
                        // into background
                        //                        let qos = Int(QOS_CLASS_USER_INTERACTIVE.value)
                        let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
                        dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in
                            // then handle response
                            print("me API successfully get")
                            // will pass in a json, then generate a result
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
                        })
                        }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                            // job ended
                            ColorgyAPITrafficControlCenter.unqueueBackgroundJob()
                            // then handle response
                            print("fail to get user \(user_id) API")
                            failure()
                    })
                } else {
                    print(ColorgyErrorType.invalidURLString)
                    failure()
                }
            } else {
                failure()
            }
        }
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
        
        if ColorgyAPITrafficControlCenter.isTokenRefreshing() {
            print(ColorgyErrorType.TrafficError.stillRefreshing)
            failure()
        } else {
            if let accesstoken = UserSetting.UserAccessToken() {
                let url = "https://colorgy.io:443/api/v1/me.json?access_token=\(accesstoken)"
                
                if url.isValidURLString {
                    // queue job
                    ColorgyAPITrafficControlCenter.queueNewBackgroundJob()
                    // then start job
                    afManager.GET(url, parameters: nil, success: { (task: NSURLSessionDataTask, response: AnyObject) -> Void in
                        // job ended
                        ColorgyAPITrafficControlCenter.unqueueBackgroundJob()
                        // into background
                        //                        let qos = Int(QOS_CLASS_USER_INTERACTIVE.value)
                        let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
                        dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in
                            // then handle response
                            print("me API successfully get")
                            // will pass in a json, then generate a result
                            let json = JSON(response)
                            print("ME get!")
                            if let result = ColorgyAPIMeResult(json: json) {
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
                        })
                        }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                            // job ended
                            ColorgyAPITrafficControlCenter.unqueueBackgroundJob()
                            // then handle response
                            print("fail to get me API")
                            failure()
                    })
                } else {
                    print(ColorgyErrorType.invalidURLString)
                    failure()
                }
            } else {
                failure()
            }
        }
        
    }
    
    // get me courses
    /// Get self courses from server.
    ///
    /// :returns: userCourseObjects: A [UserCourseObject]? array, might be nil or 0 element.
    class func getMeCourses(completionHandler: (userCourseObjects: [UserCourseObject]?) -> Void, failure: () -> Void) {
        if let userId = UserSetting.UserId() {
            let userIdString = String(userId)
            let afManager = AFHTTPSessionManager(baseURL: nil)
            afManager.requestSerializer = AFJSONRequestSerializer()
            afManager.responseSerializer = AFJSONResponseSerializer()
            
            if ColorgyAPITrafficControlCenter.isTokenRefreshing() {
                print(ColorgyErrorType.TrafficError.stillRefreshing)
                failure()
            } else {
                let user = ColorgyUser()
                if let user = user {
                    print("getting user \(userId)'s course")
                    if let possibleOrganization = user.possibleOrganization {
                        if let accesstoken = user.accessToken {
                            let semester: (year: Int, term: Int) = Semester.currentSemesterAndYear()
                            let url = "https://colorgy.io:443/api/v1/user_courses.json?filter%5Buser_id%5D=\(userId)&filter%5Bcourse_organization_code%5D=\(possibleOrganization)&filter%5Byear%5D=\(semester.year)&filter%5Bterm%5D=\(semester.term)&&&&&&&access_token=\(accesstoken)"
                            
                            if url.isValidURLString {
                                // queue job
                                ColorgyAPITrafficControlCenter.queueNewBackgroundJob()
                                // then start job
                                afManager.GET(url, parameters: nil, success: { (task: NSURLSessionDataTask, response: AnyObject) -> Void in
                                    // job ended
                                    ColorgyAPITrafficControlCenter.unqueueBackgroundJob()
                                    // into background
                                    //                            let qos = Int(QOS_CLASS_USER_INTERACTIVE.value)
                                    let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
                                    dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in
                                        // then handle response
                                        // will return a array of courses
                                        let json = JSON(response)
                                        let userCourseObjects = UserCourseObjectArray(json: json).objects
                                        // return to main queue
                                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                            completionHandler(userCourseObjects: userCourseObjects)
                                        })
                                    })
                                    }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                                        // job ended
                                        ColorgyAPITrafficControlCenter.unqueueBackgroundJob()
                                        // then handle response
                                        print(ColorgyErrorType.APIFailure.failGetUserCourses)
                                        failure()
                                })
                            } else {
                                print(ColorgyErrorType.invalidURLString)
                                failure()
                            }
                        } else {
                            print(ColorgyErrorType.noAccessToken)
                            failure()
                        }
                    } else {
                        print("user get no possible org")
                        failure()
                    }
                } else {
                    print(ColorgyErrorType.noSuchUser)
                    failure()
                }
            }
        } else {
            print(ColorgyErrorType.noSuchUser)
            failure()
        }
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
        
        if ColorgyAPITrafficControlCenter.isTokenRefreshing() {
            print(ColorgyErrorType.TrafficError.stillRefreshing)
            failure()
        } else {
            let user = ColorgyUser()
            if let user = user {
                print("getting user \(userid)'s course")
                if let accesstoken = user.accessToken {
                    let semester: (year: Int, term: Int) = Semester.currentSemesterAndYear()
                    let url = "https://colorgy.io:443/api/v1/user_courses.json?filter%5Buser_id%5D=\(userid)&&filter%5Byear%5D=\(semester.year)&filter%5Bterm%5D=\(semester.term)&&&&&&&access_token=\(accesstoken)"
                    print(url)
//                    let url = "https://colorgy.io:443/api/v1/user_courses.json?filter%5Buser_id%5D=\(userid)&&&&&&&&&&access_token=\(accesstoken)"
                    
                    if url.isValidURLString {
                        // queue job
                        ColorgyAPITrafficControlCenter.queueNewBackgroundJob()
                        // then start job
                        afManager.GET(url, parameters: nil, success: { (task: NSURLSessionDataTask, response: AnyObject) -> Void in
                            // job ended
                            ColorgyAPITrafficControlCenter.unqueueBackgroundJob()
                            // into background
                            //                            let qos = Int(QOS_CLASS_USER_INTERACTIVE.value)
                            let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
                            dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in
                                // then handle response
                                // will return a array of courses
                                let json = JSON(response)
                                let userCourseObjects = UserCourseObjectArray(json: json).objects
                                // return to main queue
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    completionHandler(userCourseObjects: userCourseObjects)
                                })
                            })
                            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                                // job ended
                                ColorgyAPITrafficControlCenter.unqueueBackgroundJob()
                                // then handle response
                                print(ColorgyErrorType.APIFailure.failGetUserCourses)
                                failure()
                        })
                    } else {
                        print(ColorgyErrorType.invalidURLString)
                        failure()
                    }
                } else {
                    print(ColorgyErrorType.noAccessToken)
                    failure()
                }
            } else {
                print(ColorgyErrorType.noSuchUser)
                failure()
            }
        }
        
    }
    
    // PUT class
    class func PUTCourseToServer(courseCode: String, year: Int, term: Int, success: () -> Void, failure: () -> Void) {
        
        let afManager = AFHTTPSessionManager(baseURL: nil)
        afManager.requestSerializer = AFJSONRequestSerializer()
        afManager.responseSerializer = AFJSONResponseSerializer()
        
        if ColorgyAPITrafficControlCenter.isTokenRefreshing() {
            print(ColorgyErrorType.TrafficError.stillRefreshing)
            failure()
        } else {
            if let accesstoken = UserSetting.UserAccessToken() {
                if let user_id = UserSetting.UserId() {
                    if let school = UserSetting.UserPossibleOrganization() {
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
                        
                        if url.isValidURLString {
                            // queue job
                            ColorgyAPITrafficControlCenter.queueNewBackgroundJob()
                            afManager.PUT(url, parameters: params, success: { (task: NSURLSessionDataTask, response: AnyObject) -> Void in
                                // job ended
                                ColorgyAPITrafficControlCenter.unqueueBackgroundJob()
                                success()
                                }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                                    // job ended
                                    ColorgyAPITrafficControlCenter.unqueueBackgroundJob()
                                    print(task)
                                    failure()
                            })
                        } else {
                            print("url invalid")
                            failure()
                        }
                    } else {
                        print("no school")
                        failure()
                    }
                } else {
                    print("no user id")
                    failure()
                }
            } else {
                print(ColorgyErrorType.noAccessToken)
                failure()
            }
        }
    }
    // DELETE class
    class func DELETECourseToServer(courseCode: String, success: (courseCode: String) -> Void, failure: () -> Void) {
        
        let afManager = AFHTTPSessionManager(baseURL: nil)
        afManager.requestSerializer = AFJSONRequestSerializer()
        afManager.responseSerializer = AFJSONResponseSerializer()
        
        if ColorgyAPITrafficControlCenter.isTokenRefreshing() {
            print(ColorgyErrorType.TrafficError.stillRefreshing)
            failure()
        } else {
            if let accesstoken = UserSetting.UserAccessToken() {
                if UserSetting.getDeviceUUID() != nil {
                    if UserSetting.UserPossibleOrganization() != nil {
                        // get self course data from server
                        ColorgyAPI.getMeCourses({ (userCourseObjects) -> Void in
                            if let userCourseObjects = userCourseObjects {
                                print(userCourseObjects)
                                var isMatch = false
                                for userCourseObject in userCourseObjects {
                                    if courseCode == userCourseObject.course_code  {
                                        isMatch = true
                                        let uuid = userCourseObject.uuid
                                        let url = "https://colorgy.io:443/api/v1/me/user_courses/\(uuid).json?access_token=\(accesstoken)"
                                        
                                        if url.isValidURLString {
                                            // queue job
                                            ColorgyAPITrafficControlCenter.queueNewBackgroundJob()
                                            afManager.DELETE(url, parameters: nil, success: { (task: NSURLSessionDataTask, response: AnyObject) -> Void in
                                                // job ended
                                                ColorgyAPITrafficControlCenter.unqueueBackgroundJob()
                                                success(courseCode: courseCode)
                                                }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                                                    // job ended
                                                    ColorgyAPITrafficControlCenter.unqueueBackgroundJob()
                                                    failure()
                                            })
                                        } else {
                                            print("url invalid")
                                            failure()
                                        }
                                    }
                                }
                                // if no uuid match, shows that server doesnt store this course
                                if !isMatch {
                                    // TODO: something wierd
                                    failure()
                                }
                            } else {
                                print("fail to get me course")
                                failure()
                            }
                            }, failure: { () -> Void in
                                print("cant get me courses")
                                failure()
                        })
                    } else {
                        print("no school")
                        failure()
                    }
                } else {
                    print("no device uuid")
                    failure()
                }
            } else {
                print(ColorgyErrorType.noAccessToken)
                failure()
            }
        }
    }
    // get user basic info
    // after get user basic info, do i need to download their image?
    // no, i'll download it if i need it
    
    
    
    // properties
    
    // functions
    
    // keys
    //    struct Method {
    //        static let put = "PUT"
    //        static let delete = "DELETE"
    //    }
    
    
    class func getSchools(success: (schools: [School]) -> Void, failure: () -> Void) {
        let afManager = AFHTTPSessionManager(baseURL: nil)
        afManager.requestSerializer = AFJSONRequestSerializer()
        afManager.responseSerializer = AFJSONResponseSerializer()
        
        if ColorgyAPITrafficControlCenter.isTokenRefreshing() {
            print(ColorgyErrorType.TrafficError.stillRefreshing)
            failure()
        } else {
            if let accesstoken = UserSetting.UserAccessToken() {
                let url = "https://colorgy.io:443/api/v1/organizations.json?access_token=\(accesstoken)"
                if url.isValidURLString {
                    ColorgyAPITrafficControlCenter.queueNewBackgroundJob()
                    afManager.GET(url, parameters: nil, success: { (task: NSURLSessionDataTask, response: AnyObject) -> Void in
                        ColorgyAPITrafficControlCenter.unqueueBackgroundJob()
                        let json = JSON(response)
                        success(schools: School.generateSchoolsWithJSON(json))
                        }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                            ColorgyAPITrafficControlCenter.unqueueBackgroundJob()
                            failure()
                    })
                } else {
                    print("url not valid")
                }
            } else {
                print("no token")
            }
        }
    }
    
    class func getDepartments(school: String, success: (departments: [Department]) -> Void, failure: () -> Void) {
        let afManager = AFHTTPSessionManager(baseURL: nil)
        afManager.requestSerializer = AFJSONRequestSerializer()
        afManager.responseSerializer = AFJSONResponseSerializer()
        
        if ColorgyAPITrafficControlCenter.isTokenRefreshing() {
            print(ColorgyErrorType.TrafficError.stillRefreshing)
            failure()
        } else {
            if let accesstoken = UserSetting.UserAccessToken() {
                let url = "https://colorgy.io:443/api/v1/organizations/\(school.uppercaseString).json?access_token=\(accesstoken)"
                if url.isValidURLString {
                    ColorgyAPITrafficControlCenter.queueNewBackgroundJob()
                    afManager.GET(url, parameters: nil, success: { (task: NSURLSessionDataTask, response: AnyObject) -> Void in
                        let json = JSON(response)
                        let departments = Department.generateDepartments(json)
                        print(departments)
                        success(departments: departments)
                        }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                        failure()
                    })
                } else {
                    print("url is not valid")
                    print(url)
                }
            }
        }
    }
    class func PATCHUserInfo(organization: String, department: String, year: String, success: () -> Void, failure: () -> Void) {
        let afManager = AFHTTPSessionManager(baseURL: nil)
        afManager.requestSerializer = AFJSONRequestSerializer()
        afManager.responseSerializer = AFJSONResponseSerializer()
        
        if ColorgyAPITrafficControlCenter.isTokenRefreshing() {
            print(ColorgyErrorType.TrafficError.stillRefreshing)
            failure()
        } else {
            if let accesstoken = UserSetting.UserAccessToken() {
                let url = "https://colorgy.io:443/api/v1/me.json?access_token=\(accesstoken)"
                if url.isValidURLString {
                    let params = ["user":
                        [
                            "unconfirmed_organization_code": organization,
                            "unconfirmed_department_code": department,
                            "unconfirmed_started_year": year
                        ]
                    ]
                    
                    afManager.PATCH(url, parameters: params, success: { (task: NSURLSessionDataTask, response: AnyObject) -> Void in
                        print("PATCH OK")
                        print(response)
                        success()
                        }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                            print("fail to patch")
                            failure()
                    })
                    
                } else {
                    print("PATCH url not vaild")
                }
            } else {
                print("PATCH no accesstoken")
            }
        }
    }
}