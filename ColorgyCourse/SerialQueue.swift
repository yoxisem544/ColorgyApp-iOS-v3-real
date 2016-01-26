//
//  HelloQueue.swift
//  ColorgyCourse
//
//  Created by David on 2016/1/22.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

let SERIAL_QUEUE = dispatch_queue_create("this.is.a.serial.queue", DISPATCH_QUEUE_SERIAL)
let isSerialMode = true