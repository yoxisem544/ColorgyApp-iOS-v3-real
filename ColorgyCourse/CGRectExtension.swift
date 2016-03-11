//
//  CGRectExtension.swift
//  ColorgyCourse
//
//  Created by David on 2016/3/11.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

extension CGRect {
	var centerPoint: CGPoint {
		return CGPoint(x: self.midX, y: self.midY)
	}
}