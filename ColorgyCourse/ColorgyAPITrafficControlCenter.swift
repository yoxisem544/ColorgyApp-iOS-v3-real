//
//  ColorgyAPITrafficControlCenter.swift
//  ColorgyAPIHandler
//
//  Created by David on 2015/8/26.
//  Copyright (c) 2015年 David. All rights reserved.
//

import Foundation

class ColorgyAPITrafficControlCenter {
    
    struct TrafficKey {
        static let IsRefreshingAccessToken = "IsRefreshingAccessToken"
        static let BackgroundJobQueue = "BackgroundJobQueue"
    }
    
    class func isTokenRefreshing() -> Bool {
        let ud = NSUserDefaults.standardUserDefaults()
        return ud.boolForKey(TrafficKey.IsRefreshingAccessToken)
    }
    
    // need to queue background jobs, if jobs still processing, no refresh
    // if need refresh no background job is queueing.
    // while refreshing no job accepted
    
    class func queueNewBackgroundJob() {
        let ud = NSUserDefaults.standardUserDefaults()
        var jobCount = ud.integerForKey(TrafficKey.BackgroundJobQueue)
        jobCount++
        println("jobs \(jobCount)")
        ud.setInteger(jobCount, forKey: TrafficKey.BackgroundJobQueue)
        ud.synchronize()
    }
    
    class func unqueueBackgroundJob() {
        let ud = NSUserDefaults.standardUserDefaults()
        var jobCount = ud.integerForKey(TrafficKey.BackgroundJobQueue)
        jobCount--
        println("jobs \(jobCount)")
        if jobCount < 0 {
            jobCount = 0
        }
        ud.setInteger(jobCount, forKey: TrafficKey.BackgroundJobQueue)
        ud.synchronize()
    }
    
    class func getBackgroundJobCount() -> Int {
        let ud = NSUserDefaults.standardUserDefaults()
        return ud.integerForKey(TrafficKey.BackgroundJobQueue)
    }
    
    class func isAnyBackgroundJobs() -> Bool {
        let ud = NSUserDefaults.standardUserDefaults()
        if ud.integerForKey(TrafficKey.BackgroundJobQueue) > 0 {
            return true
        }
        return false
    }
    
    class func canRefresh() -> Bool {
        // if no queueing jobs and not refreshing, then you can refresh token
        // if there is any job -> true
        // if refreshing -> true
        // so it is a or logic, any of this is true, then we can not do any refreshing job
        // while return, make it opposite
        return !(ColorgyAPITrafficControlCenter.isAnyBackgroundJobs() || ColorgyAPITrafficControlCenter.isTokenRefreshing())
    }
    
    class func changeRefreshingState() {
        let ud = NSUserDefaults.standardUserDefaults()
        let state = !ud.boolForKey(TrafficKey.IsRefreshingAccessToken)
        ud.setBool(state, forKey: TrafficKey.IsRefreshingAccessToken)
        ud.synchronize()
    }
    
    /// Refresh access token.
    ///
    /// **Will auto save result if successfully login**
    ///
    /// :returns: loginResult:  ColorgyLoginResult?
    class func refreshAccessToken(completionHandler: (loginResult: ColorgyLoginResult?) -> Void) {
        
        let afManager = AFHTTPSessionManager(baseURL: nil)
        afManager.requestSerializer = AFJSONRequestSerializer()
        afManager.responseSerializer = AFJSONResponseSerializer()
        
        if ColorgyAPITrafficControlCenter.canRefresh() {
            if let refreshtoken = UserSetting.UserRefreshToken() {
                let params = [
                    "grant_type": "refresh_token",
                    // 應用程式ID application id, in colorgy server
                    "client_id": "ad2d3492de7f83f0708b5b1db0ac7041f9179f78a168171013a4458959085ba4",
                    "client_secret": "d9de77450d6365ca8bd6717bbf8502dfb4a088e50962258d5d94e7f7211596a3",
                    "refresh_token": refreshtoken
                ]
                
                // change to refresing state
                ColorgyAPITrafficControlCenter.changeRefreshingState()
                
                afManager.POST("https://colorgy.io/oauth/token?", parameters: params, success: { (task: NSURLSessionDataTask, response: AnyObject) -> Void in
                    // change to refresing finish state
                    ColorgyAPITrafficControlCenter.changeRefreshingState()
                    let json = JSON(response)
                    let result = ColorgyLoginResult(response: json)
                    UserSetting.storeLoginResult(result: result)
                    completionHandler(loginResult: result)
                    println("refresk okok")
                        }, failure: { (task: NSURLSessionDataTask, error: NSError) -> Void in
                            // change to refresing finish state
                            ColorgyAPITrafficControlCenter.changeRefreshingState()
                            
                            // TODO: - very critical part, refresh fail, token expired -
                            // logout user here
                            UserSetting.refreshTokenExpiredUserSettingDeletion()
                            println(ColorgyErrorType.TrafficError.refreshTokenExpired)
                            
                            completionHandler(loginResult: nil)
                    })
            } else {
                println("no refresh token")
                completionHandler(loginResult: nil)
            }
        } else {
            println("cant refresh")
            completionHandler(loginResult: nil)
        }
    }
}