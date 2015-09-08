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
    class func PUTdeviceToken(#success: () -> Void, failure: () -> Void) {
        if ColorgyAPITrafficControlCenter.isTokenRefreshing() {
            println(ColorgyErrorType.TrafficError.stillRefreshing)
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
                    
                    if let uuid = uuid {
                    let url = "https://colorgy.io:443/api/v1/me/devices/\(uuid).json?access_token=\(accesstoken)"
                        println(uuid)
                        println(params)
                        println(accesstoken)
                        afManager.PUT(url, parameters: params, success: { (task: NSURLSessionDataTask, response: AnyObject) -> Void in
                            println("Success")
                            success()
                            }, failure: { (task: NSURLSessionDataTask, error: NSError) -> Void in
                                println("fail \(error)")
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
    class func GETdeviceToken(#success: (devices: [[String : String]]) -> Void, failure: () -> Void) {
        if ColorgyAPITrafficControlCenter.isTokenRefreshing() {
            println(ColorgyErrorType.TrafficError.stillRefreshing)
            failure()
        } else {
            if let token = UserSetting.getPushNotificationDeviceToken() {
                if let accesstoken = UserSetting.UserAccessToken() {
                    let afManager = AFHTTPSessionManager(baseURL: nil)
                    afManager.requestSerializer = AFJSONRequestSerializer()
                    afManager.responseSerializer = AFJSONResponseSerializer()
                    
                    let url = "https://colorgy.io:443/api/v1/me/devices.json?access_token=\(accesstoken)"
                    afManager.GET(url, parameters: nil, success: { (task: NSURLSessionDataTask, response: AnyObject) -> Void in
                        let json = JSON(response)
                        var devices = [[String : String]]()
                        
                        for (index: String, json: JSON) in json {
                            if let name = json["name"].string {
                                if let uuid = json["uuid"].string {
                                    devices.append(["name": name, "uuid": uuid])
                                }
                            }
                        }
                        
                        success(devices: devices)
                        }, failure: { (task: NSURLSessionDataTask, error: NSError) -> Void in
                        println(error)
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
    class func DELETEdeviceTokenAndPushNotificationPare(#success: () -> Void, failure: () -> Void) {
        if ColorgyAPITrafficControlCenter.isTokenRefreshing() {
            println(ColorgyErrorType.TrafficError.stillRefreshing)
            failure()
        } else {
            if let accesstoken = UserSetting.UserAccessToken() {
                if let uuid = UserSetting.getDeviceUUID() {
                    let afManager = AFHTTPSessionManager(baseURL: nil)
                    afManager.requestSerializer = AFJSONRequestSerializer()
                    afManager.responseSerializer = AFJSONResponseSerializer()
                    
                    println(uuid)
                    let url = "https://colorgy.io:443/api/v1/me/devices/\(uuid).json?access_token=\(accesstoken)"
                    afManager.DELETE(url, parameters: nil, success: { (task: NSURLSessionDataTask, response: AnyObject) -> Void in
                        success()
                        }, failure: { (task: NSURLSessionDataTask, error: NSError) -> Void in
                        failure()
                    })
                } else {
                    println("no need delete uuid token pare")
                    success()
                }
            } else {
                println("no access token")
                failure()
            }
        }
    }
    
    /// Delete a uuid and push notification token set.
    /// Always call this in background worker.
    class func DELETEdeviceTokenAndPushNotificationPareUsingUUID(uuid: String?, success: () -> Void, failure: () -> Void) {
        if ColorgyAPITrafficControlCenter.isTokenRefreshing() {
            println(ColorgyErrorType.TrafficError.stillRefreshing)
            failure()
        } else {
            if let accesstoken = UserSetting.UserAccessToken() {
                if let uuid = uuid {
                    let afManager = AFHTTPSessionManager(baseURL: nil)
                    afManager.requestSerializer = AFJSONRequestSerializer()
                    afManager.responseSerializer = AFJSONResponseSerializer()
                    
                    println(uuid)
                    let url = "https://colorgy.io:443/api/v1/me/devices/\(uuid).json?access_token=\(accesstoken)"
                    afManager.DELETE(url, parameters: nil, success: { (task: NSURLSessionDataTask, response: AnyObject) -> Void in
                        success()
                        }, failure: { (task: NSURLSessionDataTask, error: NSError) -> Void in
                            failure()
                    })
                } else {
                    println("no need delete uuid token pare")
                    success()
                }
            } else {
                println("no access token")
                failure()
            }
        }
    }
    
    // MARK: - check if token expired
    /// Check if token has expired
    class func checkIfTokenHasExpired(#unexpired: () -> Void, expired: () -> Void) {
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
    class func getSchoolCourseData(count: Int?, year: Int, term: Int, success: (courseRawDataDictionary: [[String : AnyObject]], json: JSON) -> Void, failure: () -> Void) {
        
        let afManager = AFHTTPSessionManager(baseURL: nil)
        afManager.requestSerializer = AFJSONRequestSerializer()
        afManager.responseSerializer = AFJSONResponseSerializer()
        
        if ColorgyAPITrafficControlCenter.isTokenRefreshing() {
            println(ColorgyErrorType.TrafficError.stillRefreshing)
            failure()
        } else {
            if let organization = UserSetting.UserPossibleOrganization() {
                if let accesstoken = UserSetting.UserAccessToken() {
                    let coursesCount = count ?? 20000
                    let url = "https://colorgy.io:443/api/v1/\(organization.lowercaseString)/courses.json?per_page=\(String(coursesCount))&&&filter%5Byear%5D=\(year)&filter%5Bterm%5D=\(term)&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&access_token=\(accesstoken)"
                    if url.isValidURLString {
                        // queue job
                        ColorgyAPITrafficControlCenter.queueNewBackgroundJob()
                        // then start job
                        afManager.GET(url, parameters: nil, success: { (task: NSURLSessionDataTask, response: AnyObject) -> Void in
                            // job ended
                            ColorgyAPITrafficControlCenter.unqueueBackgroundJob()
                            // into background
//                            let qos = Int(QOS_CLASS_USER_INTERACTIVE.value)
                            let qos = Int(QOS_CLASS_USER_INITIATED.value)
                            dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in
                                // then handle response
                                let json = JSON(response)
                                let courseRawDataArray = CourseRawDataArray(json: json)
                                var dicts = [[String : AnyObject]]()
                                if courseRawDataArray.objects != nil {
                                    for object in courseRawDataArray.objects! {
                                        dicts.append(object.dictionary)
                                    }
                                    // return to main queue
                                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                        success(courseRawDataDictionary: dicts, json: json)
                                    })
                                } else {
                                    // fail to generate objects
                                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                        failure()
                                    })
                                }
                                
                            })
                            }, failure: { (task: NSURLSessionDataTask, error: NSError) -> Void in
                                // job ended
                                ColorgyAPITrafficControlCenter.unqueueBackgroundJob()
                                // then handle response
                                println(ColorgyErrorType.APIFailure.failDownloadCourses)
                                failure()
                        })
                    } else {
                        println(ColorgyErrorType.invalidURLString)
                        failure()
                    }
                }
            } else {
                failure()
                println(ColorgyErrorType.noOrganization)
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
    class func getCourseRawDataObjectWithCourseCode(code: String, completionHandler: (courseRawDataObject: CourseRawDataObject?) -> Void) {
        
        let afManager = AFHTTPSessionManager(baseURL: nil)
        afManager.requestSerializer = AFJSONRequestSerializer()
        afManager.responseSerializer = AFJSONResponseSerializer()
        
        if ColorgyAPITrafficControlCenter.isTokenRefreshing() {
            println(ColorgyErrorType.TrafficError.stillRefreshing)
            completionHandler(courseRawDataObject: nil)
        } else {
            if let accesstoken = UserSetting.UserAccessToken() {
                let url = "https://colorgy.io:443/api/v1/ntust/courses/\(code).json?access_token=\(accesstoken)"
                
                if url.isValidURLString {
                    // queue job
                    ColorgyAPITrafficControlCenter.queueNewBackgroundJob()
                    // then start job
                    afManager.GET(url, parameters: nil, success: { (task: NSURLSessionDataTask, response: AnyObject) -> Void in
                        // job ended
                        ColorgyAPITrafficControlCenter.unqueueBackgroundJob()
                        // into background
//                        let qos = Int(QOS_CLASS_USER_INTERACTIVE.value)
                        let qos = Int(QOS_CLASS_USER_INITIATED.value)
                        dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in
                            // then handle response
                            println(response)
                            let json = JSON(response)
                            let object = CourseRawDataObject(json: json)
                                // return to main queue
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                completionHandler(courseRawDataObject: object)
                            })
                        })
                        }, failure: { (task: NSURLSessionDataTask, error: NSError) -> Void in
                            // job ended
                            ColorgyAPITrafficControlCenter.unqueueBackgroundJob()
                            // then handle response
                            println("Err \(error)")
                            completionHandler(courseRawDataObject: nil)
                    })
                } else {
                    println(ColorgyErrorType.invalidURLString)
                    completionHandler(courseRawDataObject: nil)
                }
            } else {
                println(ColorgyErrorType.APIFailure.failGetUserCourses)
                completionHandler(courseRawDataObject: nil)
            }
        }
    }
    
    // get students enrolled in specific course
    /// Get users who enroll in specific course.
    /// Server will return a UserCourseObject.
    ///
    /// :param: code: A course code.
    /// :returns: userCourseObjects: A [UserCourseObject]? array, might be nil.
    class func getStudentsInSpecificCourse(code: String, completionHandler: (userCourseObjects: [UserCourseObject]?) -> Void) {
        // server will return an array of user course objects json.
        let afManager = AFHTTPSessionManager(baseURL: nil)
        afManager.requestSerializer = AFJSONRequestSerializer()
        afManager.responseSerializer = AFJSONResponseSerializer()
        
        if ColorgyAPITrafficControlCenter.isTokenRefreshing() {
            println(ColorgyErrorType.TrafficError.stillRefreshing)
            completionHandler(userCourseObjects: nil)
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
                        let qos = Int(QOS_CLASS_USER_INITIATED.value)
                        dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in
                            // then handle response
                            let json = JSON(response)
                            let objects = UserCourseObjectArray(json: json).objects
                            // return to main queue
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                completionHandler(userCourseObjects: objects)
                            })
                        })
                        }, failure: { (task: NSURLSessionDataTask, error: NSError) -> Void in
                            // job ended
                            ColorgyAPITrafficControlCenter.unqueueBackgroundJob()
                            // then handle response
                            println(ColorgyErrorType.APIFailure.failGetUserCourses)
                            completionHandler(userCourseObjects: nil)
                    })
                } else {
                    println(ColorgyErrorType.invalidURLString)
                    println(url)
                    completionHandler(userCourseObjects: nil)
                }
            } else {
                println(ColorgyErrorType.APIFailure.failGetUserCourses)
                completionHandler(userCourseObjects: nil)
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
        
        if ColorgyAPITrafficControlCenter.isTokenRefreshing() {
            println(ColorgyErrorType.TrafficError.stillRefreshing)
            completionHandler(periodDataObjects: nil)
        } else {
            if let accesstoken = UserSetting.UserAccessToken() {
                let url = "https://colorgy.io:443/api/v1/ntust_period_data.json?access_token=\(accesstoken)"
                // queue job
                ColorgyAPITrafficControlCenter.queueNewBackgroundJob()
                // then start job
                afManager.GET(url, parameters: nil, success: { (task: NSURLSessionDataTask, response: AnyObject) -> Void in
                    // job ended
                    ColorgyAPITrafficControlCenter.unqueueBackgroundJob()
                    // into background
//                    let qos = Int(QOS_CLASS_USER_INTERACTIVE.value)
                    let qos = Int(QOS_CLASS_USER_INITIATED.value)
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
                    }, failure: { (task: NSURLSessionDataTask, error: NSError) -> Void in
                        // job ended
                        ColorgyAPITrafficControlCenter.unqueueBackgroundJob()
                        // then handle response
                        completionHandler(periodDataObjects: nil)
                })
            } else {
                println(ColorgyErrorType.noAccessToken)
                completionHandler(periodDataObjects: nil)
            }
        }
    }
    
    /// You can simply get a user info API using this.
    ///
    /// :returns: result: ColorgyAPIMeResult?, you can store it.
    /// :returns: error: An error if you got one, then handle it.
    class func getUserInfo(#user_id: Int, success: (result: ColorgyAPIUserResult) -> Void, failure: () -> Void) {
        let afManager = AFHTTPSessionManager(baseURL: nil)
        afManager.requestSerializer = AFJSONRequestSerializer()
        afManager.responseSerializer = AFJSONResponseSerializer()
        
        println("getting user \(user_id) API")
        
        if ColorgyAPITrafficControlCenter.isTokenRefreshing() {
            println(ColorgyErrorType.TrafficError.stillRefreshing)
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
                        let qos = Int(QOS_CLASS_USER_INITIATED.value)
                        dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in
                            // then handle response
                            println("me API successfully get")
                            // will pass in a json, then generate a result
                            let json = JSON(response)
                            println("user \(user_id) get!")
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
                        }, failure: { (task: NSURLSessionDataTask, error: NSError) -> Void in
                            // job ended
                            ColorgyAPITrafficControlCenter.unqueueBackgroundJob()
                            // then handle response
                            println("fail to get user \(user_id) API")
                            failure()
                    })
                } else {
                    println(ColorgyErrorType.invalidURLString)
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
        
        println("getting me API")
        
        if ColorgyAPITrafficControlCenter.isTokenRefreshing() {
            println(ColorgyErrorType.TrafficError.stillRefreshing)
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
                        let qos = Int(QOS_CLASS_USER_INITIATED.value)
                        dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in
                            // then handle response
                            println("me API successfully get")
                            // will pass in a json, then generate a result
                            let json = JSON(response)
                            println("ME get!")
                            if let result = ColorgyAPIMeResult(json: json) {
                                // return to main queue
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    completionHandler(result: result)
                                })
                            } else {
                                // return to main queue
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    failure
                                })
                            }
                        })
                        }, failure: { (task: NSURLSessionDataTask, error: NSError) -> Void in
                            // job ended
                            ColorgyAPITrafficControlCenter.unqueueBackgroundJob()
                            // then handle response
                            println("fail to get me API")
                            failure()
                    })
                } else {
                    println(ColorgyErrorType.invalidURLString)
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
    class func getMeCourses(completionHanlder: (userCourseObjects: [UserCourseObject]?) -> Void, failure: () -> Void) {
        let ud = NSUserDefaults.standardUserDefaults()
        if let userId = UserSetting.UserId() {
            let userIdString = String(userId)
            ColorgyAPI.getUserCoursesWithUserId(userIdString, completionHandler: completionHanlder, failure: failure)
        } else {
            println(ColorgyErrorType.noSuchUser)
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
            println(ColorgyErrorType.TrafficError.stillRefreshing)
            failure()
        } else {
            let user = ColorgyUser()
            if let user = user {
                println("getting user \(userid)'s course")
                if let accesstoken = user.accessToken {
                    let url = "https://colorgy.io:443/api/v1/user_courses.json?filter%5Buser_id%5D=\(userid)&&&&&&&&&&access_token=\(accesstoken)"

                    if url.isValidURLString {
                        // queue job
                        ColorgyAPITrafficControlCenter.queueNewBackgroundJob()
                        // then start job
                        afManager.GET(url, parameters: nil, success: { (task: NSURLSessionDataTask, response: AnyObject) -> Void in
                            // job ended
                            ColorgyAPITrafficControlCenter.unqueueBackgroundJob()
                            // into background
//                            let qos = Int(QOS_CLASS_USER_INTERACTIVE.value)
                            let qos = Int(QOS_CLASS_USER_INITIATED.value)
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
                            }, failure: { (task: NSURLSessionDataTask, error: NSError) -> Void in
                                // job ended
                                ColorgyAPITrafficControlCenter.unqueueBackgroundJob()
                                // then handle response
                                println(ColorgyErrorType.APIFailure.failGetUserCourses)
                                failure()
                        })
                    } else {
                        println(ColorgyErrorType.invalidURLString)
                        failure()
                    }
                } else {
                    println(ColorgyErrorType.noAccessToken)
                    failure()
                }
            } else {
                println(ColorgyErrorType.noSuchUser)
                failure()
            }
        }
        
    }
    
    // PUT class
    class func PUTCourseToServer(courseCode: String, success: () -> Void, failure: () -> Void) {
        
        let afManager = AFHTTPSessionManager(baseURL: nil)
        afManager.requestSerializer = AFJSONRequestSerializer()
        afManager.responseSerializer = AFJSONResponseSerializer()
        
        if ColorgyAPITrafficControlCenter.isTokenRefreshing() {
            println(ColorgyErrorType.TrafficError.stillRefreshing)
            failure()
        } else {
            if let accesstoken = UserSetting.UserAccessToken() {
                if let deviceUUID = UserSetting.getDeviceUUID() {
                    if let school = UserSetting.UserPossibleOrganization() {
                        let uuid = "\(courseCode)-\(deviceUUID)"
                        let url = "https://colorgy.io:443/api/v1/me/user_courses/\(uuid).json?access_token=\(accesstoken)"
                        
                        let params = ["user_courses":
                            [
                                "course_code": courseCode,
                                "course_organization_code": school.lowercaseString,
                                "year": 2015,
                                "term": 1
                            ]
                        ]
                        
                        println(url)
                        println(params)
                        
                        if url.isValidURLString {
                            // queue job
                            ColorgyAPITrafficControlCenter.queueNewBackgroundJob()
                            afManager.PUT(url, parameters: params, success: { (task: NSURLSessionDataTask, response: AnyObject) -> Void in
                                // job ended
                                ColorgyAPITrafficControlCenter.unqueueBackgroundJob()
                                success()
                                }, failure: { (task: NSURLSessionDataTask, error: NSError) -> Void in
                                    // job ended
                                    ColorgyAPITrafficControlCenter.unqueueBackgroundJob()
                                    println(task)
                                    failure()
                            })
                        } else {
                            println("url invalid")
                            failure()
                        }
                    } else {
                        println("no school")
                        failure()
                    }
                } else {
                    println("no device uuid")
                    failure()
                }
            } else {
                println(ColorgyErrorType.noAccessToken)
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
            println(ColorgyErrorType.TrafficError.stillRefreshing)
            failure()
        } else {
            if let accesstoken = UserSetting.UserAccessToken() {
                if let deviceUUID = UserSetting.getDeviceUUID() {
                    if let school = UserSetting.UserPossibleOrganization() {
                        // get self course data from server
                        ColorgyAPI.getMeCourses({ (userCourseObjects) -> Void in
                            if let userCourseObjects = userCourseObjects {
                                println(userCourseObjects)
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
                                                }, failure: { (task: NSURLSessionDataTask, error: NSError) -> Void in
                                                    // job ended
                                                    ColorgyAPITrafficControlCenter.unqueueBackgroundJob()
                                                    failure()
                                            })
                                        } else {
                                            println("url invalid")
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
                                println("fail to get me course")
                                failure()
                            }
                        }, failure: { () -> Void in
                            println("cant get me courses")
                            failure()
                        })
                    } else {
                        println("no school")
                        failure()
                    }
                } else {
                    println("no device uuid")
                    failure()
                }
            } else {
                println(ColorgyErrorType.noAccessToken)
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
    
}