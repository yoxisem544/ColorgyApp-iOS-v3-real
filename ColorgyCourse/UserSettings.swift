//
//  UserSettingKeys.swift
//  ColorgyAPIHandler
//
//  Created by David on 2015/8/22.
//  Copyright (c) 2015年 David. All rights reserved.
//

import Foundation

struct UserSettingKey {
    static let userAccessToken = "ColorgyAccessToken"
    static let userRefreshToken = "ColorgyRefreshToken"
    static let accessTokenCreatedTime = "ColorgyCreatedTime"
    static let accessTokenExpiredTime = "ColorgyExpireTime"
    static let accessTokenscope = "ColorgyScope"
    static let isLogin = "isLogin"
    static let accessTokenTokenType = "ColorgyTokenType"
    // user info
    // something to do with me API result
    static let userName = "userName"
    static let userAccountName = "userAccountName"
    static let userOrganization = "userOrganization"
    static let userDepartment = "userDepartment"
    static let userId = "userId"
    static let userUUID = "userUUID"
    static let userAvatarUrl = "userAvatarUrl"
    static let userCoverPhotoUrl = "userCoverPhotoUrl"
    static let userType = "userType"
    // new key for unauthorized users
    static let userPossibleOrganization = "userPossibleOrganization"
    static let userPossibleDepartment = "userPossibleDepartment"
    // guide keu
    static let isGuideShownToUser = "isGuideShownToUser"
    // local course caching data 
    static let localCourseCachingData = "courseDataFromServer"
    // periods data
    static let periodsData = "SchoolPeriodsData"
}

class UserSetting {

    // MARK: - getters
    class func UserId() -> Int? {
        let ud = NSUserDefaults.standardUserDefaults()
        if let userid = ud.objectForKey(UserSettingKey.userId) as? Int {
            return userid
        }
        return nil
    }
    
    class func UserPossibleOrganization() -> String? {
        let ud = NSUserDefaults.standardUserDefaults()
        if let userPossibleOrganization = ud.objectForKey(UserSettingKey.userPossibleOrganization) as? String {
            return userPossibleOrganization
        }
        return nil
    }
    
    class func UserAccessToken() -> String? {
        let ud = NSUserDefaults.standardUserDefaults()
        if let userAccessToken = ud.objectForKey(UserSettingKey.userAccessToken) as? String {
            return userAccessToken
        }
        return nil
    }
    
    class func UserRefreshToken() -> String? {
        let ud = NSUserDefaults.standardUserDefaults()
        if let userRefreshToken = ud.objectForKey(UserSettingKey.userRefreshToken) as? String {
            return userRefreshToken
        }
        return nil
    }
    // MARK: - get / store periods data
    class func storePeriodsData(periodDataObjects: [PeriodDataObject]?) {
        if let periodDataObjects = periodDataObjects {
            var dicts = [[String : String]]()
            for object in periodDataObjects {
                dicts.append(object.dictionary)
            }
            // sort the order
            var count = 0
            dicts.sort({ (v1, v2) -> Bool in
                // TODO: unwrap dictionary string danger
                let n1 = v1["order"]?.toInt()
                let n2 = v2["order"]?.toInt()
                println("\(n1), \(n2)")
                if ((n1 != nil) && (n2 != nil)) {
                    return (n1! < n2!)
                } else {
                    return false
                }
            })
            let ud = NSUserDefaults.standardUserDefaults()
            ud.setObject(dicts, forKey: UserSettingKey.periodsData)
            ud.synchronize()
        }
    }
    
    class func getPeriodData() -> [[String : String]] {
        let ud = NSUserDefaults.standardUserDefaults()
        let dicts: AnyObject? = ud.objectForKey(UserSettingKey.periodsData)
        if let dicts = dicts as? [[String : String]] {
            if dicts.count == 0 {
                // prevent return a zero array
                return [[:]]
            }
            return dicts
        }
        return [[:]]
    }
    
    // MARK: - store local course caching data
    class func storeRawCourseJSON(rawJSON: JSON?) {
        if let json = rawJSON {
            if let data = json.rawData(){
                NSUserDefaults.standardUserDefaults().setObject(data, forKey: UserSettingKey.localCourseCachingData)
                NSUserDefaults.standardUserDefaults().synchronize()
            }
        }
    }
    
    class func deleteLocalCourseDataCaching() {
        NSUserDefaults.standardUserDefaults().removeObjectForKey(UserSettingKey.localCourseCachingData)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    // MARK: - save user settings
    // store at first time login
    class func storeLoginResult(#result: ColorgyLoginResult) {
        let ud = NSUserDefaults.standardUserDefaults()
        ud.setObject(result.access_token, forKey: UserSettingKey.userAccessToken)
        ud.setObject(result.created_at, forKey: UserSettingKey.accessTokenCreatedTime)
        ud.setObject(result.expires_in, forKey: UserSettingKey.accessTokenExpiredTime)
        ud.setObject(result.refresh_token, forKey: UserSettingKey.userRefreshToken)
        ud.setObject(result.scope, forKey: UserSettingKey.accessTokenscope)
        ud.setObject(result.token_type, forKey: UserSettingKey.accessTokenTokenType)
        ud.synchronize()
    }
    
    class func storeAPIMeResult(#result: ColorgyAPIMeResult) {
        let ud = NSUserDefaults.standardUserDefaults()
        ud.setObject(result._type, forKey: UserSettingKey.userType)
        ud.setObject(result.avatar_url, forKey: UserSettingKey.userAvatarUrl)
        ud.setObject(result.cover_photo_url, forKey: UserSettingKey.userCoverPhotoUrl)
        ud.setObject(result.id, forKey: UserSettingKey.userId)
        ud.setObject(result.name, forKey: UserSettingKey.userName)
        ud.setObject(result.username, forKey: UserSettingKey.userAccountName)
        ud.setObject(result.uuid, forKey: UserSettingKey.userUUID)
        ud.setObject(result.department, forKey: UserSettingKey.userDepartment)
        ud.setObject(result.organization, forKey: UserSettingKey.userOrganization)
        ud.setObject(result.possible_department_code, forKey: UserSettingKey.userPossibleDepartment)
        ud.setObject(result.possible_organization_code, forKey: UserSettingKey.userPossibleOrganization)
        ud.synchronize()
    }
    
    // MARK: - delete user settings
    // TODO: logout delete settings
    // while logging out, delete setting
    // 1. logout deleting setting
    class func deleteAllUserSettings() {
        let ud = NSUserDefaults.standardUserDefaults()
        ud.removeObjectForKey(UserSettingKey.userAccessToken)
        ud.removeObjectForKey(UserSettingKey.userRefreshToken)
        ud.removeObjectForKey(UserSettingKey.accessTokenCreatedTime)
        ud.removeObjectForKey(UserSettingKey.accessTokenExpiredTime)
        ud.removeObjectForKey(UserSettingKey.accessTokenscope)
        ud.removeObjectForKey(UserSettingKey.isLogin)
        ud.removeObjectForKey(UserSettingKey.accessTokenTokenType)
        // user info
        // something to do with me API result
        ud.removeObjectForKey(UserSettingKey.userName)
        ud.removeObjectForKey(UserSettingKey.userAccountName)
        ud.removeObjectForKey(UserSettingKey.userOrganization)
        ud.removeObjectForKey(UserSettingKey.userDepartment)
        ud.removeObjectForKey(UserSettingKey.userId)
        ud.removeObjectForKey(UserSettingKey.userUUID)
        ud.removeObjectForKey(UserSettingKey.userAvatarUrl)
        ud.removeObjectForKey(UserSettingKey.userCoverPhotoUrl)
        ud.removeObjectForKey(UserSettingKey.userType)
        // new key for unauthorized users
        ud.removeObjectForKey(UserSettingKey.userPossibleOrganization)
        ud.removeObjectForKey(UserSettingKey.userPossibleDepartment)
        // guide keu
        ud.removeObjectForKey(UserSettingKey.isGuideShownToUser)
        // local caching data
        ud.removeObjectForKey(UserSettingKey.localCourseCachingData)
        // period data
        ud.removeObjectForKey(UserSettingKey.periodsData)
        ud.synchronize()
    }
    // 2. refresh token expired logout
    class func refreshTokenExpiredUserSettingDeletion() {
        let ud = NSUserDefaults.standardUserDefaults()
        ud.removeObjectForKey(UserSettingKey.userAccessToken)
        ud.removeObjectForKey(UserSettingKey.userRefreshToken)
        ud.removeObjectForKey(UserSettingKey.accessTokenCreatedTime)
        ud.removeObjectForKey(UserSettingKey.accessTokenExpiredTime)
        ud.removeObjectForKey(UserSettingKey.accessTokenscope)
        ud.removeObjectForKey(UserSettingKey.isLogin)
        ud.removeObjectForKey(UserSettingKey.accessTokenTokenType)
        // user info
        // something to do with me API result
        ud.removeObjectForKey(UserSettingKey.userName)
        ud.removeObjectForKey(UserSettingKey.userAccountName)
        ud.removeObjectForKey(UserSettingKey.userOrganization)
        ud.removeObjectForKey(UserSettingKey.userDepartment)
        ud.removeObjectForKey(UserSettingKey.userId)
        ud.removeObjectForKey(UserSettingKey.userUUID)
        ud.removeObjectForKey(UserSettingKey.userAvatarUrl)
        ud.removeObjectForKey(UserSettingKey.userCoverPhotoUrl)
        ud.removeObjectForKey(UserSettingKey.userType)
        // new key for unauthorized users
        ud.removeObjectForKey(UserSettingKey.userPossibleOrganization)
        ud.removeObjectForKey(UserSettingKey.userPossibleDepartment)
        // guide keu
//        ud.removeObjectForKey(UserSettingKey.isGuideShownToUser)
        // period data
        ud.removeObjectForKey(UserSettingKey.periodsData)
        ud.synchronize()
    }
}