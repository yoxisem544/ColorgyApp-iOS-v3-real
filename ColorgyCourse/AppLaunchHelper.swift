//
//  AppLaunchHelper.swift
//  ColorgyCourse
//
//  Created by David on 2015/9/7.
//  Copyright (c) 2015年 David. All rights reserved.
//

import Foundation

class AppLaunchHelper {
    class func startJob() {
        
        // set refresh state to can refresh
        ColorgyAPITrafficControlCenter.setRefreshingStateToNotRefreshing()
        
        // check needed info
        // device uuid
        let deviceuuid = UserSetting.getDeviceUUID()
        // possible org
        let possibelorg = UserSetting.UserPossibleOrganization()
        // periods data
        let perioddata = UserSetting.getPeriodData()
        let isRefreshable = ColorgyAPITrafficControlCenter.isRefershTokenRefreshable()
        
        if ((perioddata == [[:]]) || (deviceuuid == nil) || (possibelorg == nil) || !isRefreshable) {
            UserSetting.deleteAllUserSettings()
        }
        
        // check token expired
        ColorgyAPI.checkIfTokenHasExpired(unexpired: { () -> Void in
            // no need to refresh
            }, expired: { () -> Void in
                // refresh
                NetwrokQualityDetector.isNetworkStableToUse(stable: { () -> Void in
                    // can refresh
                    ColorgyAPITrafficControlCenter.refreshAccessToken({ (loginResult) -> Void in
                        // ok refresh
                        }, failure: { () -> Void in
                            // fail to refresh
                            print("fail to refresh")
                    })
                    }, unstable: { () -> Void in
                        // network unstable
                })
        })
    }
}