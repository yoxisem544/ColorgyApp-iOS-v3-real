////
////  BackgroundWorker.swift
////  ColorgyCourse
////
////  Created by David on 2015/9/2.
////  Copyright (c) 2015年 David. All rights reserved.
////
//
//import Foundation
//
//class BackgroundWorker {
//    func startJobs() {
//        
//        // check if accesstoken is expired, if yes get a new one
//        // everything started if token if ok
//        ColorgyAPI.checkIfTokenHasExpired(unexpired: { () -> Void in
//            println("token still unexpired")
//            // start jobs
//            
//            // start job to delete uuid token pare
//            self.deleteDeviceUUIDAndPushNotificationToken()
//            
//            // job to refresh token according to time
//            
//            // job to update course if changed or need update
//        }, expired: { () -> Void in
//            println("token expired")
//            // check if can refresh, if not, wait
//            if ColorgyAPITrafficControlCenter.canRefresh() {
//                // refresh and start it over again
//                ColorgyAPITrafficControlCenter.refreshAccessToken({ (loginResult) -> Void in
//                    if let loginResult = loginResult {
//                        // if successfully refresh, do job again
//                        UserSetting.storeLoginResult(result: loginResult)
//                        self.startJobs()
//                    } else {
//                        println("fail refresh...... something wrong")
//                    }
//                }, failure: { () -> Void in
//                    // might be no network
//                    let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * 1))
//                    dispatch_after(delay, dispatch_get_main_queue(), { () -> Void in
//    //                    self.startJobs()
//                    })
//                })
//            } else {
//                // if not, wait and try again
//                println(" wait and try refershing again")
//                let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * 1))
//                dispatch_after(delay, dispatch_get_main_queue(), { () -> Void in
//                    self.startJobs()
//                })
//            }
//        })
//        
//    }
//    
//    // signal center, job queue center
//    
//    /// This method will get called while user logout, and need to fully delete uuid token pare.
//    /// keep doing this job if uuid and token hasn't been deleted
//    func deleteDeviceUUIDAndPushNotificationToken() {
//        if let needDeleteToken = UserSetting.getNeedDeleteDeviceToken() {
//            ColorgyAPI.DELETEdeviceTokenAndPushNotificationPare({ () -> Void in
//                UserSetting.successfullyDeleteToken()
//                }, failure: { () -> Void in
//                    println("fail delete, retrying")
//                    let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * 1))
//                    dispatch_after(delay, dispatch_get_main_queue(), { () -> Void in
//                        self.deleteDeviceUUIDAndPushNotificationToken()
//                    })
//            })
//        }
//    }
//}