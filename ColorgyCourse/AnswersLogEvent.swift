//
//  AnswersLogEvent.swift
//  ColorgyCourse
//
//  Created by David on 2016/2/1.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

struct AnswersLogEvents {
	// App Delegate
	static let userDidFinishedLaunchWithOption = "User Start App, Finish Launch."
	static let appEnterBackground = "User Close Application, Application Enter Background."
	static let appDidBecomeActive = "User Start Application, Application Did Become Active."
	// for login
	static let userLoginWithFacebook = "User Login With Facebook"
	static let userLoginWithEmail = "User Login With Email"
	static let userLogout = "User Logout"
	// for course 
	static let userWatchingOthersTimetable = "User Watching Other's Timetable"
	static let userCreateALocalCourse = "User Create A Local Course"
	static let userWatchingDetailCourseView = "User Watching Detail Course View"
	static let userTapOnClassmateProfilePhoto = "User Tap On Classmate's Profile Photo"
	// for api
	static let organizationCourseDataMissing = "Organization Course Data Missing"
	// settings
	static let userChangedCourseNotificationSetting = "User Changed Course Notification Setting"
	static let userUsingSettingsPage = "User Using Settings Page"
	static let userChangedPrivacySetting = "User Changed Privacy Setting"
	static let userGoToFanPage = "User Go To Fan Page"
	// report 
	static let userSendFeedback = "User Send Feedback"
	// search course
	static let userUsingSearchCourseView = "User Using Search Course View"
	static let userDeleteCourse = "User Delete Course"
	static let userAddCourse = "User Add Course"
	// timetable
	static let userUsingTimetable = "User Using Timetable"
	// error
	static let noOraganizationCourseData = "No Oraganization Course Data"
}