//
//  Mode.swift
//  ColorgyCourse
//
//  Created by David on 2015/7/28.
//  Copyright (c) 2015年 David. All rights reserved.
//

import Foundation

class Release: NSObject {
    #if DEBUG
        static let mode = false
    #else
        static let mode = true
    #endif
}