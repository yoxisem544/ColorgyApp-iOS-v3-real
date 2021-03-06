//
//  ColorgyAPITrafficControlCenter.swift
//  ColorgyAPIHandler
//
//  Created by David on 2015/8/26.
//  Copyright (c) 2015年 David. All rights reserved.
//

import Foundation

class ColorgyAPITrafficControlCenter : NSObject {
    
    struct TrafficKey {
        static let IsRefreshingAccessToken = "IsRefreshingAccessToken"
        static let BackgroundJobQueue = "BackgroundJobQueue"
        static let isRefershTokenRefreshable = "isRefershTokenRefreshableKEY"
    }
    
    // get refresh token state
    class func isRefershTokenRefreshable() -> Bool {
        let ud = NSUserDefaults.standardUserDefaults()
        return ud.boolForKey(TrafficKey.isRefershTokenRefreshable)
    }
    
    class func setRefreshStateToCanRefresh() {
        let ud = NSUserDefaults.standardUserDefaults()
        ud.setBool(true, forKey: TrafficKey.isRefershTokenRefreshable)
        print("can refresh, not refreshing")
        ud.synchronize()
    }
    
    class func setRefreshStateToCanNOTRefresh() {
        let ud = NSUserDefaults.standardUserDefaults()
        ud.setBool(false, forKey: TrafficKey.isRefershTokenRefreshable)
        ud.synchronize()
    }
    
    class func isTokenRefreshing() -> Bool {
        let ud = NSUserDefaults.standardUserDefaults()
        return ud.boolForKey(TrafficKey.IsRefreshingAccessToken)
    }
    
    // need to queue background jobs, if jobs still processing, no refresh
    // if need refresh no background job is queueing.
    // while refreshing no job accepted
    
    class func unQueueAllJobs() {
        let ud = NSUserDefaults.standardUserDefaults()
        ud.setInteger(0, forKey: TrafficKey.BackgroundJobQueue)
        ud.synchronize()
    }
    
    class func queueNewBackgroundJob() {
        let ud = NSUserDefaults.standardUserDefaults()
        var jobCount = ud.integerForKey(TrafficKey.BackgroundJobQueue)
        jobCount += 1
        print("jobs \(jobCount)")
        ud.setInteger(jobCount, forKey: TrafficKey.BackgroundJobQueue)
        ud.synchronize()
    }
    
    class func unqueueBackgroundJob() {
        let ud = NSUserDefaults.standardUserDefaults()
        var jobCount = ud.integerForKey(TrafficKey.BackgroundJobQueue)
        jobCount -= 1
        print("jobs \(jobCount)")
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
	
	static var refreshRetryTimeAccumulator: Double = 1.0
	static let refreshRetryTimeAccumulatroFactor: Double = 1.4
    
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
    
    class func setRefreshingStateToNotRefreshing() {
        let ud = NSUserDefaults.standardUserDefaults()
        ud.setBool(false, forKey: TrafficKey.IsRefreshingAccessToken)
        ud.synchronize()
    }
    
    /// Refresh access token.
    ///
    /// **Will auto save result if successfully login**
    ///
    /// :returns: loginResult:  ColorgyLoginResult?
    class func refreshAccessToken(completionHandler: (loginResult: ColorgyLoginResult?) -> Void, failure: () -> Void) {
        
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
				
				print(params)
                // change to refresing state
                ColorgyAPITrafficControlCenter.changeRefreshingState()
                
                afManager.POST("https://colorgy.io/oauth/token?", parameters: params, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                    // change to refresing finish state
                    ColorgyAPITrafficControlCenter.changeRefreshingState()
					if let response = response {
						let json = JSON(response)
						if let result = ColorgyLoginResult(response: json) {
							UserSetting.storeLoginResult(result: result)
							completionHandler(loginResult: result)
						} else {
							failure()
						}
					} else {
						failure()
					}
                    print("refresk okok")
                    }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                        // change to refresing finish state
                        ColorgyAPITrafficControlCenter.changeRefreshingState()
                        ColorgyAPITrafficControlCenter.setRefreshStateToCanNOTRefresh()
                        // TODO: - very critical part, refresh fail, token expired -
                        // logout user here
                        UserSetting.refreshTokenExpiredUserSettingDeletion()
                        print(ColorgyErrorType.TrafficError.refreshTokenExpired)
                        
                        
                        
                        //                            completionHandler(loginResult: nil)
                        failure()
                })
            } else {
                print("no refresh token")
                //                completionHandler(loginResult: nil)
                failure()
            }
		} else if ColorgyAPITrafficControlCenter.isAnyBackgroundJobs() {
			print("can't refresh, because there is still jobs in the background")
			print("will retry in \(ColorgyAPITrafficControlCenter.refreshRetryTimeAccumulator) seconds")
			let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * ColorgyAPITrafficControlCenter.refreshRetryTimeAccumulator))
			dispatch_after(delay, dispatch_get_main_queue(), { () -> Void in
				// increase retry time
				ColorgyAPITrafficControlCenter.refreshRetryTimeAccumulator = ColorgyAPITrafficControlCenter.refreshRetryTimeAccumulator * ColorgyAPITrafficControlCenter.refreshRetryTimeAccumulatroFactor
				// retry again
				ColorgyAPITrafficControlCenter.refreshAccessToken({ (loginResult) -> Void in
					print("successfully refresh token, resetting time to 1.0")
					ColorgyAPITrafficControlCenter.refreshRetryTimeAccumulator = 1.0
					completionHandler(loginResult: loginResult)
					}, failure: { () -> Void in
						failure()
				})
			})
		} else {
            print("can't refresh, because token is refershing")
            //            completionHandler(loginResult: nil)
            failure()
        }
    }
}