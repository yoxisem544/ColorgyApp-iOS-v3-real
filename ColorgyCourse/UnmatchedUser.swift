//
//  UnmatchedUser.swift
//  ColorgyCourse
//
//  Created by David on 2016/2/8.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

class UnmatchedUser : NSObject {
	// required
	var gender: Gender
	var lastAnswer: String?
	var id: String
	var avatarBlur2XURL: String
	var name: String
	// optional
	var aboutSchool: String?
	var aboutConversation: String?
	var aboutPassion: String?
	var aboutHoroscope: String?
	var aboutHabitancy: String?
	var aboutExpertise: String?
	
	override var description: String {
		return "UnmatchedUser: {\n\tgender -> \(gender)\n\tlastAnswer -> \(lastAnswer)\n\tid -> \(id)\n\tavatarBlur2XURL -> \(avatarBlur2XURL)\n\tname -> \(name)\n\taboutSchool -> \(aboutSchool)\n\taboutConversation -> \(aboutConversation)\n\taboutPassion -> \(aboutPassion)\n\taboutHoroscope -> \(aboutHoroscope)\n\taboutHabitancy -> \(aboutHabitancy)\n\taboutExpertise -> \(aboutExpertise)\n}"
	}
	
	convenience init?(json: JSON) {
		
		var _gender: String?
		var _lastAnswer: String?
		var _id: String?
		var _avatarBlur2XURL: String?
		var _name: String?
		var _aboutSchool: String?
		var _aboutConversation: String?
		var _aboutPassion: String?
		var _aboutHoroscope: String?
		var _aboutHabitancy: String?
		var _aboutExpertise: String?
		
		_gender = json["gender"].string
		_lastAnswer = json["lastAnswer"].string
		_id = json["id"].string
		_avatarBlur2XURL = json["avatar_blur_2x_url"].string
		_name = json["name"].string
		_aboutSchool = json["about"]["school"].string
		_aboutConversation = json["about"]["conversation"].string
		_aboutPassion = json["about"]["passion"].string
		_aboutHoroscope = json["about"]["horoscope"].string
		_aboutHabitancy = json["about"]["habitancy"].string
		_aboutExpertise = json["about"]["expertise"].string
		
		self.init(gender: _gender, lastAnswer: _lastAnswer, id: _id, avatarBlur2XURL: _avatarBlur2XURL, name: _name, aboutSchool: _aboutSchool, aboutConversation: _aboutConversation, aboutPassion: _aboutPassion, aboutHoroscope: _aboutHoroscope, aboutHabitancy: _aboutHabitancy, aboutExpertise: _aboutExpertise)
	}
	
	init?(gender: String?, lastAnswer: String?, id: String?, avatarBlur2XURL: String?, name: String?, aboutSchool: String?, aboutConversation: String?, aboutPassion: String?, aboutHoroscope: String?, aboutHabitancy: String?, aboutExpertise: String?) {
		
		self.gender = Gender.Unspecified
		self.id = String()
		self.avatarBlur2XURL = String()
		self.name = String()
		
		super.init()
		
		// required
		guard gender != nil else { return nil }
		guard id != nil else { return nil }
		guard avatarBlur2XURL != nil else { return nil }
		guard name != nil else { return nil }
		
		if gender == Gender.Unspecified.rawValue {
			self.gender = Gender.Unspecified
		} else if gender == Gender.Male.rawValue {
			self.gender = .Male
		} else if gender == Gender.Female.rawValue {
			self.gender = .Female
		} else {
			print("Fail to generate UnmatchedUser, because of Gender error")
			return nil
		}
		self.id = id!
		self.avatarBlur2XURL = avatarBlur2XURL!
		self.name = name!
		
		// optional
		self.lastAnswer = lastAnswer
		self.aboutSchool = aboutSchool
		self.aboutConversation = aboutConversation
		self.aboutPassion = aboutPassion
		self.aboutHoroscope = aboutHoroscope
		self.aboutHabitancy = aboutHabitancy
		self.aboutExpertise = aboutExpertise
	}
	
	class func generateUnmatchedUsers(json: JSON) -> [UnmatchedUser] {
		let result = json["result"]
//		print(result)
		var unmatchedUsers = [UnmatchedUser]()
		if result.isArray {
			for (_, json) : (String, JSON) in result {
				if let u = UnmatchedUser(json: json) {
					unmatchedUsers.append(u)
				}
			}
		}
		
		return unmatchedUsers
	}
}