//
//  LogoutHelper.swift
//  ColorgyCourse
//
//  Created by David on 2015/9/2.
//  Copyright (c) 2015年 David. All rights reserved.
//

import Foundation

class LogoutHelper {
    
    class func logoutPrepare(success success: () -> Void, failure: () -> Void) {
        // check network
        NetwrokQualityDetector.isNetworkStableToUse(stable: { () -> Void in
            // check token if is expired
            ColorgyAPI.checkIfTokenHasExpired(unexpired: { () -> Void in
                // check if device token is stored in server
                ColorgyAPI.GETdeviceToken(success: { (devices) -> Void in
                    // must return a [] if success
                    if UserSetting.getPushNotificationDeviceToken() != nil {
                        
                        if devices.count == 0 {
                            // no token stored in server, no need delete
                            success()
                        }
                        var isMatched = false
                        for device in devices {
                            // loop through all devices, check if this token matches server token
//                            if device["name"] == "\(deviceToken)" {
                            if device["name"] == UIDevice.currentDevice().name {
                                // if match
                                isMatched = true
                                // delete uuid token pare
                                ColorgyAPI.DELETEdeviceTokenAndPushNotificationPare(success: { () -> Void in
                                    // delete success
                                    success()
                                    }, failure: { () -> Void in
                                        // TODO: -  deelte using matched uuid
                                        if let uuid = device["uuid"] {
                                            ColorgyAPI.DELETEdeviceTokenAndPushNotificationPareUsingUUID(uuid, success: { () -> Void in
                                                success()
                                            }, failure: { () -> Void in
                                                failure()
                                            })
                                        } else {
                                            // fail to delete device, matbe try again?
                                            failure()
                                        }
                                })
                            }
                        }
                        // none of token matched, maybe just logout?
                        if !isMatched {
                            success()
                        }
                    } else {
                        // no device token, maybe logout?
                        success()
                    }
                }, failure: { () -> Void in
                    // check if this device does have a push notification token
                    // if not, no need to delete
                    if UserSetting.getPushNotificationDeviceToken() == nil {
                        success()
                    }
                    // fail to get device token, need to do it again
                    // something wrong with server? fail to get devices on server
                    failure()
                })
            }, expired: { () -> Void in
                // token expried need refresh
                ColorgyAPITrafficControlCenter.refreshAccessToken({ (loginResult) -> Void in
                    if let loginResult = loginResult {
                        UserSetting.storeLoginResult(result: loginResult)
                        // again
                        LogoutHelper.logoutPrepare(success: success, failure: failure)
                    }
                    // nil?
                }, failure: { () -> Void in
                    // fail to refresh token, refresh token expired, force logout
                    // TODO: force logout
                })
            })
            }, unstable: { () -> Void in
            // network is unstable, maybe try again later.
                failure()
        })
        
    }
    
    class func forceLogoutDueToRefreshTokenExpired(completionHandler: () -> Void) {
        UserSetting.refreshTokenExpiredUserSettingDeletion()
        completionHandler()
    }
    
    class func logout(completionHandler: () -> Void) {
        UserSetting.deleteAllUserSettings()
        completionHandler()
    }
    
}
