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
	// new key for emails
	static let userEmail = "user email"
	static let userFBEmail = "user fbemail"
	// test account
	static let isUserTestAccount = "user is test account"
    // guide keu
    static let isGuideShownToUser = "isGuideShownToUser"
    // local course caching data 
    static let localCourseCachingData = "courseDataFromServer"
    static let localCourseCachingDataDictionaries = "localCourseCachingDataDictionaries"
    // periods data
    static let periodsData = "SchoolPeriodsData"
    // push notification
    static let pushNotificationDeviceToken = "pushNotificationDeviceToken"
    static let deviceUUID = "pushNotificationDeviceUUID"
    // other settings: user's notification time setting
    static let courseNotificationTime = "courseNotificationTime for local notitfication"
    static let isCourseNotificationOn = "isCourseNotificationOn for local notitfication"
	// for chat
    static let nickyName = "nickyName"
	static let chatFirstTimeUpdateInformation = "chatFirstTimeUpdateInformation"
}

@objc class UserSetting : NSObject {
    
    // change login state
    class func changeLoginStateSuccessfully() {
        let ud = NSUserDefaults.standardUserDefaults()
        ud.setBool(true, forKey: UserSettingKey.isLogin)
        ud.synchronize()
    }

    // MARK: - getters
    class func isLogin() -> Bool {
        let ud = NSUserDefaults.standardUserDefaults()
        return ud.boolForKey(UserSettingKey.isLogin)
    }
    
    class func UserId() -> Int? {
        let ud = NSUserDefaults.standardUserDefaults()
        if let userid = ud.objectForKey(UserSettingKey.userId) as? Int {
            return userid
        }
        return nil
    }
	
	class func UserUUID() -> String? {
		let ud = NSUserDefaults.standardUserDefaults()
		if let uuid = ud.objectForKey(UserSettingKey.userUUID) as? String {
			return uuid
		}
		return nil
	}
	
    class func UserName() -> String? {
        let ud = NSUserDefaults.standardUserDefaults()
        if let userName = ud.objectForKey(UserSettingKey.userName) as? String {
            return userName
        }
        return nil
    }
    
    class func UserNickyName() -> String? {
        let ud = NSUserDefaults.standardUserDefaults()
        if let userNickyName = ud.objectForKey(UserSettingKey.nickyName) as? String {
            return userNickyName
        }
        return nil;
    }
	
	class func UserAvatarUrl() -> String? {
		let ud = NSUserDefaults.standardUserDefaults()
		if let url = ud.objectForKey(UserSettingKey.userAvatarUrl) as? String {
			return url
		}
		return nil
	}
	
	class func UserCoverPhotoUrl() -> String? {
		let ud = NSUserDefaults.standardUserDefaults()
		if let url = ud.objectForKey(UserSettingKey.userCoverPhotoUrl) as? String {
			return url
		}
		return nil
	}
	
	class func UserOrganization() -> String? {
		let ud = NSUserDefaults.standardUserDefaults()
		if let userOrganization = ud.objectForKey(UserSettingKey.userOrganization) as? String {
			return userOrganization
		}
		return nil
	}
	
	class func UserDepartment() -> String? {
		let ud = NSUserDefaults.standardUserDefaults()
		if let userDepartment = ud.objectForKey(UserSettingKey.userDepartment) as? String {
			return userDepartment
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
    
    class func UserPossibleDepartment() -> String? {
        let ud = NSUserDefaults.standardUserDefaults()
        if let userPossibleDepartment = ud.objectForKey(UserSettingKey.userPossibleDepartment) as? String {
            return userPossibleDepartment
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
	
	// MARK: - email
	class func UserEmail() -> String? {
		let ud = NSUserDefaults.standardUserDefaults()
		if let email = ud.objectForKey(UserSettingKey.userEmail) as? String {
			return email
		}
		return nil
	}
	
	class func UserFBEmail() -> String? {
		let ud = NSUserDefaults.standardUserDefaults()
		if let fbemail = ud.objectForKey(UserSettingKey.userFBEmail) as? String {
			return fbemail
		}
		return nil
	}
	
	// MARK: - test account
	class func isUserTestAccount() -> Bool {
		let ud = NSUserDefaults.standardUserDefaults()
		return ud.boolForKey(UserSettingKey.isUserTestAccount)
	}
    
    // MARK: - push notification
    class func storePushNotificationDeviceToken(token: NSData) {
        let ud = NSUserDefaults.standardUserDefaults()
        ud.setObject(token, forKey: UserSettingKey.pushNotificationDeviceToken)
        ud.synchronize()
    }
    
    class func getPushNotificationDeviceToken() -> NSData? {
        let ud = NSUserDefaults.standardUserDefaults()
        if let token = ud.objectForKey(UserSettingKey.pushNotificationDeviceToken) as? NSData {
            return token
        }
        return nil
    }
    
    /// This method will generate a unique uuid of this device, according to username and device name.
    /// This will be unique, and get set only **once**.
    ///
    /// **Dont delete this while logout, any reset of this uuid must via BackgroundWorker.**
    class func generateAndStoreDeviceUUID() {
        let ud = NSUserDefaults.standardUserDefaults()
        // if user has a username
        if let username = UserSetting.UserName() {
            // and doesn't have a device uuid set
            if getDeviceUUID() == nil {
                // generate random uuid
                let randomUUID = NSUUID().UUIDString
                // generate and store one
                let deviceUUID = "\(username.uuidEncode)-\(UIDevice.currentDevice().name.uuidEncode)-\(randomUUID)"
                print(deviceUUID)
                ud.setObject(deviceUUID, forKey: UserSettingKey.deviceUUID)
                ud.synchronize()
            }
        }
    }
    
    /// A device alway have a uuid
    /// **generateAndStoreDeviceUUID** must get called when user login
    /// after logout, delete this uuid
    class func getDeviceUUID() -> String? {
        let ud = NSUserDefaults.standardUserDefaults()
        if let uuid = ud.objectForKey(UserSettingKey.deviceUUID) as? String {
            return uuid
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
            dicts.sortInPlace({ (v1, v2) -> Bool in
                // TODO: unwrap dictionary string danger
                let n1 = Int(v1["order"] ?? "")
                let n2 = Int(v2["order"] ?? "")
                print("\(n1), \(n2)")
                if ((n1 != nil) && (n2 != nil)) {
                    print((n1! < n2!))
                    return (n1! < n2!)
                } else {
                    return false
                }
            })

            let ud = NSUserDefaults.standardUserDefaults()
            ud.setObject(dicts, forKey: UserSettingKey.periodsData)
            print(dicts)
            ud.synchronize()
        }
    }
    
    class func storeFakePeriodsData() {
        var dicts = [[String : String]]()
        for i in 1...16 {
            dicts.append(["code": "\(i)", "_type": "fake_period_data", "id": "\(i)", "order": "\(i)", "time":""])
        }
        let ud = NSUserDefaults.standardUserDefaults()
        ud.setObject(dicts, forKey: UserSettingKey.periodsData)
        print(dicts)
        ud.synchronize()
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
//            if let data = json.rawData(){
//                NSUserDefaults.standardUserDefaults().setObject(data, forKey: UserSettingKey.localCourseCachingData)
//                NSUserDefaults.standardUserDefaults().synchronize()
//            }
            do {
                let data = try json.rawData()
                NSUserDefaults.standardUserDefaults().setObject(data, forKey: UserSettingKey.localCourseCachingData)
                NSUserDefaults.standardUserDefaults().synchronize()
            } catch {
                
            }
        }
    }
    
    class func deleteLocalCourseDataCaching() {
        NSUserDefaults.standardUserDefaults().removeObjectForKey(UserSettingKey.localCourseCachingData)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func storeLocalCourseDataDictionaries(dictionaries: [[String : AnyObject]]) {
        NSUserDefaults.standardUserDefaults().setObject(dictionaries, forKey: UserSettingKey.localCourseCachingDataDictionaries)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func deleteLocalCourseDataDictionaries() {
        NSUserDefaults.standardUserDefaults().removeObjectForKey(UserSettingKey.localCourseCachingDataDictionaries)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func getLocalCourseDataDictionary() -> [[String : AnyObject]]? {
        if let dicts = NSUserDefaults.standardUserDefaults().objectForKey(UserSettingKey.localCourseCachingDataDictionaries) as? [[String : AnyObject]] {
            return dicts
        }
        return nil
    }
    
    // MARK: user course notification time
    class func getCourseNotificationTime() -> Int {
        return NSUserDefaults.standardUserDefaults().integerForKey(UserSettingKey.courseNotificationTime)
    }
    
    class func setCourseNotificationTime(time time: Int) {
        NSUserDefaults.standardUserDefaults().setInteger(time, forKey: UserSettingKey.courseNotificationTime)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func isCourseNotificationOn() -> Bool {
        return NSUserDefaults.standardUserDefaults().boolForKey(UserSettingKey.isCourseNotificationOn)
    }
    
    class func setCourseNotification(turnIt on: Bool) {
        NSUserDefaults.standardUserDefaults().setBool(on, forKey: UserSettingKey.isCourseNotificationOn)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func registerCourseNotification() {
        UserSetting.setCourseNotificationTime(time: 10)
        UserSetting.setCourseNotification(turnIt: true)
    }
    
    
    // MARK: - save user settings
    // store at first time login
    class func storeLoginResult(result result: ColorgyLoginResult) {
        let ud = NSUserDefaults.standardUserDefaults()
        ud.setObject(result.access_token, forKey: UserSettingKey.userAccessToken)
        ud.setObject(result.created_at, forKey: UserSettingKey.accessTokenCreatedTime)
        ud.setObject(result.expires_in, forKey: UserSettingKey.accessTokenExpiredTime)
        ud.setObject(result.refresh_token, forKey: UserSettingKey.userRefreshToken)
        ud.setObject(result.scope, forKey: UserSettingKey.accessTokenscope)
        ud.setObject(result.token_type, forKey: UserSettingKey.accessTokenTokenType)
        ud.synchronize()
    }
    
    class func storeAPIMeResult(result result: ColorgyAPIMeResult) {
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
		// emails
		ud.setObject(result.email, forKey: UserSettingKey.userEmail)
		ud.setObject(result.fbemail, forKey: UserSettingKey.userFBEmail)
		// test account
		ud.setBool(result.isTestAccount, forKey: UserSettingKey.isUserTestAccount)
        ud.synchronize()
    }
	
	// MARK: - pop for the first time
	class func didPopUpdateInformation() {
		let ud = NSUserDefaults.standardUserDefaults()
		ud.setBool(true, forKey: UserSettingKey.chatFirstTimeUpdateInformation)
		ud.synchronize()
	}
	
	class func getDidPopUpdateInformation() -> Bool {
		let ud = NSUserDefaults.standardUserDefaults()
		return ud.boolForKey(UserSettingKey.chatFirstTimeUpdateInformation)
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
		// emails
		ud.removeObjectForKey(UserSettingKey.userEmail)
		ud.removeObjectForKey(UserSettingKey.userFBEmail)
		// test account
		ud.removeObjectForKey(UserSettingKey.isUserTestAccount)
        // new key for unauthorized users
        ud.removeObjectForKey(UserSettingKey.userPossibleOrganization)
        ud.removeObjectForKey(UserSettingKey.userPossibleDepartment)
        // guide keu
        ud.removeObjectForKey(UserSettingKey.isGuideShownToUser)
        // local caching data
        ud.removeObjectForKey(UserSettingKey.localCourseCachingData)
        ud.removeObjectForKey(UserSettingKey.localCourseCachingDataDictionaries)
        // period data
        ud.removeObjectForKey(UserSettingKey.periodsData)
        // push notification
        // put it to background worker
//        self.setNeedDeletePushNotitficationDeviceToken()
        ud.removeObjectForKey(UserSettingKey.deviceUUID)
        // course notification time
        ud.removeObjectForKey(UserSettingKey.courseNotificationTime)
        ud.removeObjectForKey(UserSettingKey.nickyName)
		ud.removeObjectForKey(UserSettingKey.chatFirstTimeUpdateInformation)
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
		// emails
		ud.removeObjectForKey(UserSettingKey.userEmail)
		ud.removeObjectForKey(UserSettingKey.userFBEmail)
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