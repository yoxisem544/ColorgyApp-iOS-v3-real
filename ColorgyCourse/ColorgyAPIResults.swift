//
//  ColorgyAPIResult.swift
//  ColorgyAPIHandler
//
//  Created by David on 2015/8/22.
//  Copyright (c) 2015年 David. All rights reserved.
//

import Foundation

private struct APIResult {
     struct Me {
        // all result key of me api is here
        static let id = "id"
        static let uuid = "uuid"
        static let username = "username"
        static let name = "name"
        static let avatar_url = "avatar_url"
        static let cover_photo_url = "cover_photo_url"
        static let _type = "_type"
        static let organization = "organization"
        static let department = "department"
        static let possible_organization_code = "possible_organization_code"
        static let possible_department_code = "possible_department_code"
    }
}

/// You can easily use this to handle with result from Me API.
class ColorgyAPIMeResult {
    var id: Int
    var uuid: String
    var username: String?
    var name: String?
    var avatar_url: String?
    var cover_photo_url: String?
    var _type: String?
    var organization: String?
    var department: String?
    var possible_organization_code: String?
    var possible_department_code: String?
    
    init?(json: JSON?) {
        // failable initializer must have all properties initialized before returning nil
        self.id = -1
        self.uuid = ""

        if let json = json {
            // necessary part
            if let id = json[APIResult.Me.id].int {
                self.id = id
            } else {
                return nil
            }
            if let uuid = json[APIResult.Me.uuid].string {
                self.uuid = uuid
            } else {
                return nil
            }
            // optional part
            if let username = json[APIResult.Me.username].string {
                self.username = username
            }
            if let name = json[APIResult.Me.name].string {
                self.name = name
            }
            if let avatar_url = json[APIResult.Me.avatar_url].string {
                self.avatar_url = avatar_url
            }
            if let cover_photo_url = json[APIResult.Me.cover_photo_url].string {
                self.cover_photo_url = cover_photo_url
            }
            if let _type = json[APIResult.Me._type].string {
                self._type = _type
            }
            if let organization = json[APIResult.Me.organization].string {
                self.organization = organization
            }
            if let department = json[APIResult.Me.department].string {
                self.department = department
            }
            if let possible_organization_code = json[APIResult.Me.possible_organization_code].string {
                self.possible_organization_code = possible_organization_code
            }
            if let possible_department_code = json[APIResult.Me.possible_department_code].string {
                self.possible_department_code = possible_department_code
            }
            if self.possible_organization_code == nil {
                // user must have a possible org code to use this
                return nil
            } else {
                if self.organization == nil {
                    // if user is not authorized, use the possible one.
                    self.organization = self.possible_organization_code
                }
            }
        } else {
            return nil
        }
    }
}