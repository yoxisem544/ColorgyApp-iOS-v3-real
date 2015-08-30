//
//  ColorgyLogin.swift
//  ColorgyAPIHandler
//
//  Created by David on 2015/8/22.
//  Copyright (c) 2015年 David. All rights reserved.
//

import Foundation

/// Contain all things colorgy login stuff.
class ColorgyLogin {
    
    struct Type {
        static let fb = "FB"
        static let email = "email"
    }
    
    /// Login to Facebook, with a completion handler will return a **access token** from Facebook.
    ///
    /// :returns: token: A access token from Facebook.
    class func loginToFacebook(handler: (token: String?) -> Void) {
        let login = FBSDKLoginManager()
        let permissions = ["email"]
        login.logInWithReadPermissions(permissions, handler: { (result, error) -> Void in
            if error != nil {
                println(ColorgyErrorType.failToLoginFB)
            } else if result.isCancelled {
                println(ColorgyErrorType.canceledFBLogin)
            } else {
                println("logged in")
                if let token = result.token.tokenString {
                    println(token)
                    handler(token: token)
                }
            }
            handler(token: nil)
        })
    }
    
    // connect to colorgy with fb token
    /// Login to Colorgy using Facebook's access token.
    ///
    /// **If successfully login, then will auto save login information**
    ///
    /// :param: token: A Facebook access token.
    /// :returns: response: A ColorgyLoginResult, simply store it using **UserSetting.storeLoginResult**
    class func loginToColorgyWithToken(token: String, handler: (response: ColorgyLoginResult?, error: AnyObject?) -> Void) {
        // configure AFNetworking
        let afManager = AFHTTPSessionManager(baseURL: nil)
        afManager.requestSerializer = AFJSONRequestSerializer()
        afManager.responseSerializer = AFJSONResponseSerializer()
        
        println("prepare to login to colorgy")
        
        let params = [
            "grant_type": "password",
            // 應用程式ID application id, in colorgy server
            "client_id": "ad2d3492de7f83f0708b5b1db0ac7041f9179f78a168171013a4458959085ba4",
            "client_secret": "d9de77450d6365ca8bd6717bbf8502dfb4a088e50962258d5d94e7f7211596a3",
            "username": "facebook:access_token",
            "password": token,
            "scope": "public account offline_access"
        ]
        
        afManager.POST("https://colorgy.io/oauth/token", parameters: params, success: { (task: NSURLSessionDataTask, response: AnyObject) -> Void in
            println("ok 200 from colorgy")
            let json = JSON(response)
            let result = ColorgyLoginResult(response: json)
            UserSetting.storeLoginResult(result: result)
            handler(response: result, error: nil)
            }, failure: { (task: NSURLSessionDataTask, error: NSError) -> Void in
                println(ColorgyErrorType.failToLoginColorgy)
                handler(response: nil, error: ColorgyErrorType.failToLoginColorgy)
        })
    }
    
    // TODO: need a login using email
    // do something
    
}

