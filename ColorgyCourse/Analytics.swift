//
//  Analytics.swift
//  ColorgyCourse
//
//  Created by David on 2016/5/3.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation
import Crashlytics

class Analytics: NSObject {
	
	class func trackAppLaunch() {
		Mixpanel.sharedInstance().track(MixpanelEvents.OpenApp)
		let id = UserSetting.UserId() ?? -1
		let school = UserSetting.UserPossibleOrganization() ?? "no school"
		let name = UserSetting.UserName() ?? "no name"
		let params = ["user_id": id, "user_name": name, "school": school]
		Flurry.logEvent("v3.0 User didFinishLaunchingWithOptions", withParameters: params as! [NSObject : AnyObject])
	}
	
	class func trackEnterBackground() {
		Flurry.logEvent("v3.0: User Close Application, application enter background")
	}
	
	class func trackBecomeActive() {
		Flurry.logEvent("v3.0: User Start Application, applicationDidBecomeActive")
	}
	
	class func trackActivityBoard() {
		 Flurry.logEvent("v3.0: User Using Activity Board", timed: true)
	}
	
	class func stopTrackingActivityBoard() {
		Flurry.endTimedEvent("v3.0: User Using Activity Board", withParameters: nil)
	}
	
	// MARK: - Chat
	class func trackSendImage() {
		Flurry.logEvent("v3.0 Chat: User Sent A Photo/Image")
	}
	
	class func trackSendMessage() {
		Flurry.logEvent("v3.0 Chat: User Sent A Message")
	}
	
	// MARK: - Login
	class func trackLoginWithFB() {
		Flurry.logEvent("v3.0: User login using FB")
		Answers.logCustomEventWithName(AnswersLogEvents.userLoginWithFacebook, customAttributes: nil)
	}
	
	class func trackCancelLoginFBByUser() {
		Mixpanel.sharedInstance().track(MixpanelEvents.FacebookLoginFailByUserCancel)
		Flurry.logEvent("FacebookLoginFailByUserCancel")
	}
	
	class func trackLoginWithEmail() {
		
	}
	
	class func trackOnEmailLoginView() {
		Flurry.logEvent("v3.0: User On Email Login View", timed: true)
	}
	
	class func stopTrackingOnEmailLoginView() {
		Flurry.endTimedEvent("User On Email Login View", withParameters: nil)
	}
	
	// MARK: - Table View
	class func trackUsingTimeTable(params: [String : AnyObject]) {
		Flurry.logEvent("v3.0: User Watching Other's Timetable View", withParameters: params, timed: true)
		Answers.logCustomEventWithName(AnswersLogEvents.userWatchingOthersTimetable, customAttributes: params)
	}
	
	class func stopTrackingUsingTimeTable() {
		Flurry.endTimedEvent("v3.0: User Watching Other's Timetable View", withParameters: nil)
	}
	
	class func trackUsingDetailCourseView() {
		Flurry.logEvent("v3.0: User Using Detail Course View", timed: true)
		Answers.logCustomEventWithName(AnswersLogEvents.userWatchingDetailCourseView, customAttributes: nil)
	}
	
	class func stopTrackingUsingDetailCourseView() {
		Flurry.endTimedEvent("v3.0: User Using Detail Course View", withParameters: nil)
	}
	
	class func trackUserTapOnOthersProfilePhoto(user: Int) {
		Flurry.logEvent("v3.0: User Tap on Classmate's Profile Photo", withParameters: ["user_id": user])
		Mixpanel.sharedInstance().track(MixpanelEvents.clickOthersProfileImage)
	}
	
	// MARK: - Create Course
	class func trackCreateLocalCourse(params: [String : AnyObject]) {
		Flurry.logEvent("v3.0: User Created A Local Course", withParameters: params as [NSObject : AnyObject])
		Answers.logCustomEventWithName(AnswersLogEvents.userCreateALocalCourse, customAttributes: params)
	}
}