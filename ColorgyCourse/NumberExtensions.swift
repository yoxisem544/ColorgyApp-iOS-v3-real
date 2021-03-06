//
//  NumberExtensions.swift
//  ColorgyCourse
//
//  Created by David on 2016/2/1.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

extension CGFloat {
	var DoubleValue: Double {
		return Double(self)
	}
}

extension Double {
	var CGFloatValue: CGFloat {
		return CGFloat(self)
	}
	
	var RadianValue: Double {
		return (M_PI * self / 180.0)
	}
}

extension Int {
	var DoubleValue: Double {
		return Double(self)
	}
	
	var stringValue: String {
		return String(self)
	}
}