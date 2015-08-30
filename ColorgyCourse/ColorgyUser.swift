//
//  ColorgyUserInfo.swift
//  ColorgyAPIHandler
//
//  Created by David on 2015/8/22.
//  Copyright (c) 2015年 David. All rights reserved.
//

import Foundation

class ColorgyUser: Printable {
    // access token
    var accessToken: String?
    var refreshToken: String?
    // info part
    // required
    var id: Int
    // optional
    var uuid: String?
    var name: String?
    var account: String?
    var organization: String?
    var department: String?
    var possibleDepartment: String?
    var possibleOrganization: String?
    var avatarURL: String?
    var coverPhotoURL: String?
    
    private let ud = NSUserDefaults.standardUserDefaults()
    
    var description: String { return "User: {\n\tid: \(id)\n\tuuid: \(uuid)\n\tname: \(name)\n\taccount: \(account)\n\torganization: \(organization)\n\tdepartment: \(department)\n\tpossibleDepartment: \(possibleDepartment)\n\tpossibleOrganization: \(possibleOrganization)\n\tavatarURL: \(avatarURL)\n\tcoverPhotoURL: \(coverPhotoURL)\n\taccessToken: \(accessToken)\n\trefreshToken: \(refreshToken)}" }
    
    init?() {
        // failable initialzer, init required part first.
        self.id = Int()
        self.possibleOrganization = ""
        
        self.accessToken = ud.objectForKey(UserSettingKey.userAccessToken) as? String
        self.refreshToken = ud.objectForKey(UserSettingKey.userRefreshToken) as? String
        self.name = ud.objectForKey(UserSettingKey.userName) as? String
        self.account = ud.objectForKey(UserSettingKey.userAccountName) as? String
        self.organization = ud.objectForKey(UserSettingKey.userOrganization) as? String
        self.department = ud.objectForKey(UserSettingKey.userDepartment) as? String
        self.possibleOrganization = ud.objectForKey(UserSettingKey.userPossibleOrganization) as? String
        self.possibleDepartment = ud.objectForKey(UserSettingKey.userPossibleDepartment) as? String
        self.uuid = ud.objectForKey(UserSettingKey.userUUID) as? String
        self.avatarURL = ud.objectForKey(UserSettingKey.userAvatarUrl) as? String
        self.coverPhotoURL = ud.objectForKey(UserSettingKey.userCoverPhotoUrl) as? String
        
        if let id = ud.objectForKey(UserSettingKey.userId) as? Int {
            self.id = id
        } else {
            return nil
        }
    }
}