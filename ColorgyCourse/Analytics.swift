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
	
	class func trackOnFriendListView() {
		let userInfo: [String : NSObject] = ["user name": UserSetting.UserName() ?? "no name"]
		Flurry.logEvent("v3.0 Chat: User On Friend List View", withParameters: userInfo, timed: true)
	}
	
	class func stopTrackingOnFriendListView() {
		Flurry.endTimedEvent("v3.0 Chat: User On Friend List View", withParameters: nil)
	}
	
	class func trackAcceptHi() {
		Flurry.logEvent("v3.0 Chat: User Accept Hi")
	}
	
	class func trackRejectHi() {
		Flurry.logEvent("v3.0 Chat: User Reject Hi")
	}
	
	// MARK: - Search Course
	class func trackOnSearchCourseView() {
		Flurry.logEvent("v3.0: User Using Search Course View", timed: true)
		Answers.logCustomEventWithName(AnswersLogEvents.userUsingSearchCourseView, customAttributes: nil)
	}
	
	class func stopTrackingOnSearchCourseView() {
		Flurry.endTimedEvent("v3.0: User Using Search Course View", withParameters: nil)
	}
	
	class func trackDeleteCourse() {
		Flurry.logEvent("v3.0: User Delete A Course")
		Answers.logCustomEventWithName(AnswersLogEvents.userDeleteCourse, customAttributes: nil)
	}
	
	class func trackAddCourse() {
		Flurry.logEvent("v3.0: User Add A Course")
		Answers.logCustomEventWithName(AnswersLogEvents.userAddCourse, customAttributes: nil)
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
	
	class func trackOnFBLoginView() {
		Flurry.logEvent("v3.0: User On FB Login View", timed: true)
		Answers.logCustomEventWithName(AnswersLogEvents.userLoginWithFacebook, customAttributes: nil)
	}
	
	class func stopTrackingOnFBLoginView() {
		Flurry.endTimedEvent("v3.0: User On FB Login View", withParameters: nil)
	}
	
	class func trackLoginWithEmail() {
		Flurry.logEvent("v3.0: User login using Email")
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
	
	class func trackTapAddCourseButton() {
		Flurry.logEvent("v3.0: User Tap Add Button To Search Course View")
	}
	
	class func trackOnTimeTableView() {
		Flurry.logEvent("v3.0: User Using User Timetable", timed: true)
		Answers.logCustomEventWithName(AnswersLogEvents.userUsingTimetable, customAttributes: nil)
	}
	
	class func stopTrackingOnTimeTableView() {
		Flurry.endTimedEvent("v3.0: User Using User Timetable", withParameters: nil)
	}
	
	class func trackTapOnCourse() {
		Flurry.logEvent("v3.0: User Tap on Course on Their Timetable")
	}
	
	// MARK: - Create Course
	class func trackCreateLocalCourse(params: [String : AnyObject]) {
		Flurry.logEvent("v3.0: User Created A Local Course", withParameters: params as [NSObject : AnyObject])
		Answers.logCustomEventWithName(AnswersLogEvents.userCreateALocalCourse, customAttributes: params)
	}
	
	// MARK: - Setting
	class func trackUserChangePrivacySetting(params: [String : AnyObject]) {
		Flurry.logEvent("v3.0: User Change Their Privacy Setting", withParameters: params as [NSObject : AnyObject])
		Answers.logCustomEventWithName(AnswersLogEvents.userChangedPrivacySetting, customAttributes: params)
	}
	
	class func trackOnSettingPage() {
		Flurry.logEvent("v3.0: User On Setting Page")
		Answers.logCustomEventWithName(AnswersLogEvents.userUsingSettingsPage, customAttributes: nil)
	}
	
	class func trackGotoFBFanPage() {
		Flurry.logEvent("v3.0: User goto FB fan page using app.")
		Answers.logCustomEventWithName(AnswersLogEvents.userGoToFanPage, customAttributes: nil)
	}
	
	class func trackLogout() {
		Flurry.logEvent("v3.0: User Logout App")
		Answers.logCustomEventWithName(AnswersLogEvents.userLogout, customAttributes: nil)
	}
	
	// MARK: - Report
	class func trackUserSendFeedback(params: [String : AnyObject]) {
		Flurry.logEvent("v3.0: User Send Feedback", withParameters: params as [NSObject : AnyObject])
		Answers.logCustomEventWithName(AnswersLogEvents.userSendFeedback, customAttributes: params)
		Mixpanel.sharedInstance().track(MixpanelEvents.SubmitFeedbackFormSuccess)
	}
}