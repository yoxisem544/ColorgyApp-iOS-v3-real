//
//  ColorgyLoginResult.swift
//  ColorgyAPIHandler
//
//  Created by David on 2015/8/22.
//  Copyright (c) 2015年 David. All rights reserved.
//

import Foundation

// this is use to get key of the object/dictionary properly
struct OAuthKey {
    static let created_at = "created_at"
    static let scope = "scope"
    static let token_type = "token_type"
    static let access_token = "access_token"
    static let expires_in = "expires_in"
    static let refresh_token = "refresh_token"
}

/// A result from Colorgy OAuth server.
class ColorgyLoginResult : CustomStringConvertible {
    var created_at: Int?
    var scope: String?
    var token_type: String?
    var access_token: String?
    var expires_in: Int?
    var refresh_token: String?
    
    var description: String { return "{\n\tcreated_at => \(created_at)\n\tscope => \(scope)\n\ttoken_type => \(token_type)\n\taccess_token => \(access_token)\n\texpires_in => \(expires_in)\n\trefresh_token => \(refresh_token)\n}" }
    
    /// Initialization: Pass in json, then will generate a ColorgyLoginResult
    ///
    /// You can simply store this to **UserSetting.storeLoginResult**
    init?(response: JSON?) {
        if let response = response {
            created_at = response[OAuthKey.created_at].int
            scope = response[OAuthKey.scope].string
            token_type = response[OAuthKey.token_type].string
            access_token = response[OAuthKey.access_token].string
            refresh_token = response[OAuthKey.refresh_token].string
            expires_in = response[OAuthKey.expires_in].int
            
            if access_token == nil {
                return nil
            }
            if refresh_token == nil {
                 return nil
            }
        }
    }
}