//
//  NetwrokQualityDetector.swift
//  ColorgyAPIHandler
//
//  Created by David on 2015/8/26.
//  Copyright (c) 2015年 David. All rights reserved.
//

import Foundation

class NetwrokQualityDetector {
    class func testSpeed() -> Double {
        let url = SampleURL.jQuery
        var request = NSURLRequest(URL: NSURL(string: url)!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 60)
        var response: AutoreleasingUnsafeMutablePointer<NSURLResponse?> = nil
        
        var before = NSDate()
        
        var responseData = NSURLConnection.sendSynchronousRequest(request, returningResponse: response, error: nil)
        if let responseData = responseData {
            // clear cache
            NSURLCache.sharedURLCache().removeAllCachedResponses()
            
            var now = NSDate().timeIntervalSinceDate(before)
            // nstimeinterval specific in second.
            var speed = Double(responseData.length) / now / 1024
            
            return speed
        } else {
            return 0
        }
    }
    
    class func getQualityWithSpeed(speed: Double) -> NetworkQuality {
        if speed > 300 {
            return NetworkQuality.HighSpeedNetwork
        } else if speed > 150 {
            return NetworkQuality.NormalSpeedNetwork
        } else if speed > 30 {
            return NetworkQuality.LowSpeedNetwork
        } else if speed > 0 {
            return NetworkQuality.VeryBadNetwork
        } else {
            return NetworkQuality.NoNetwork
        }
    }
    
    class func getNetworkQuality(completionHandler: (quality: NetworkQuality) -> Void) {
        let qos = Int(QOS_CLASS_USER_INTERACTIVE.value)
        dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in
            let speed = self.testSpeed()
            // return to main queue
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let quality = self.getQualityWithSpeed(speed)
                completionHandler(quality: quality)
            })
        })
    }
    
    /// Check if network is stable enough to use
    /// 
    /// If network speed pinging to google is lower than 30KB/s, its unstable
    ///
    /// :returns: stable(): If speed is greater than 30KB/s
    /// :returns: unstable(): If speed is less than 30KB/s
    class func isNetworkStableToUse(#stable: () -> Void, unstable: () -> Void) {
        self.getNetworkQuality { (quality) -> Void in
            if quality == NetworkQuality.HighSpeedNetwork || quality == NetworkQuality.NormalSpeedNetwork || quality == NetworkQuality.LowSpeedNetwork {
                // good
                stable()
            } else {
                // bad
                unstable()
            }
        }
    }
    
    struct SampleURL {
        static let jQuery = "http://code.jquery.com/jquery-1.11.3.min.js"
        static let jQueryOnGoogle = "http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.14/jquery-ui.js"
        
    }
}

enum NetworkQuality {
    case HighSpeedNetwork
    case NormalSpeedNetwork
    case LowSpeedNetwork
    case VeryBadNetwork
    case NoNetwork
}