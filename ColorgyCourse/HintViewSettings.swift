//
//  HintViewSettings.swift
//  ColorgyCourse
//
//  Created by David on 2016/2/1.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

struct HintViewSettingKey {
	static let AppFirstLaunchNavigationView = "AppFirstLaunchNavigationView"
	static let TimetableHintView = "TimetableHintView"
}

class HintViewSettings : NSObject {
	
	class func isAppFirstLaunchNavigationViewShown() -> Bool {
		let ud = NSUserDefaults.standardUserDefaults()
		return ud.boolForKey(HintViewSettingKey.AppFirstLaunchNavigationView)
	}
	
	class func isTimetableHintViewShown() -> Bool {
		let ud = NSUserDefaults.standardUserDefaults()
		return ud.boolForKey(HintViewSettingKey.TimetableHintView)
	}
}