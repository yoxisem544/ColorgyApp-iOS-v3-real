//
//  AvailableTarget.swift
//  ColorgyCourse
//
//  Created by David on 2016/2/8.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

class AvailableTarget : NSObject {
	// required
	var avatarBlur2XURL: String?
	var gender: Gender
	var id: String
	var name: String
	var lastAnswer: String?
	// optional
	var aboutSchool: String?
	var aboutConversation: String?
	var aboutPassion: String?
	var aboutHoroscope: String?
	var aboutHabitancy: String?
	var aboutExpertise: String?
	
	override var description: String {
		return "AvailableTarget: {\n\tavatarBlur2XURL -> \(avatarBlur2XURL)\n\tgender -> \(gender)\n\tid -> \(id)\n\tname -> \(name)\n\tlastAnswer -> \(lastAnswer)\n\taboutSchool -> \(aboutSchool)\n\taboutConversation -> \(aboutConversation)\n\taboutPassion -> \(aboutPassion)\n\taboutHoroscope -> \(aboutHoroscope)\n\taboutHabitancy -> \(aboutHabitancy)\n\taboutExpertise -> \(aboutExpertise)\n}"
	}
	
	convenience init?(json: JSON) {
		
		var _avatarBlur2XURL: String?
		var _gender: String?
		var _id: String?
		var _name: String?
		var _lastAnswer: String?
		var _aboutSchool: String?
		var _aboutConversation: String?
		var _aboutPassion: String?
		var _aboutHoroscope: String?
		var _aboutHabitancy: String?
		var _aboutExpertise: String?
		
		_avatarBlur2XURL = json["avatar_blur_2x_url"].string
		_gender = json["gender"].string
		_id = json["id"].string
		_name = json["name"].string
		_lastAnswer = json["lastAnswer"].string
		_aboutSchool = json["about"]["school"].string
		_aboutConversation = json["about"]["conversation"].string
		_aboutPassion = json["about"]["passion"].string
		_aboutHoroscope = json["about"]["horoscope"].string
		_aboutHabitancy = json["about"]["habitancy"].string
		_aboutExpertise = json["about"]["expertise"].string
		
		self.init(avatarBlur2XURL: _avatarBlur2XURL, gender: _gender, id: _id, name: _name, lastAnswer: _lastAnswer, aboutSchool: _aboutSchool, aboutConversation: _aboutConversation, aboutPassion: _aboutPassion, aboutHoroscope: _aboutHoroscope, aboutHabitancy: _aboutHabitancy, aboutExpertise: _aboutExpertise)
	}
	
	init?(avatarBlur2XURL: String?, gender: String?, id: String?, name: String?, lastAnswer: String?, aboutSchool: String?, aboutConversation: String?, aboutPassion: String?, aboutHoroscope: String?, aboutHabitancy: String?, aboutExpertise: String?) {
		
		self.gender = Gender.Unspecified
		self.id = String()
		self.name = String()
		
		super.init()
		
		// required
		guard id != nil else { return nil }
		guard gender != nil else { return nil }
		guard name != nil else { return nil }
		
		self.id = id!
		
		if gender == Gender.Unspecified.rawValue {
			self.gender = Gender.Unspecified
		} else if gender == Gender.Female.rawValue {
			self.gender = Gender.Female
		} else if gender == Gender.Male.rawValue {
			self.gender = Gender.Male
		} else {
			print("error generating AvailableTarget, unknown Gender")
			return nil
		}
		
		self.name = name!
		self.lastAnswer = lastAnswer
		self.avatarBlur2XURL = avatarBlur2XURL
		
		// optional
		self.aboutSchool = aboutSchool
		self.aboutConversation = aboutConversation
		self.aboutPassion = aboutPassion
		self.aboutHoroscope = aboutHoroscope
		self.aboutHabitancy = aboutHabitancy
		self.aboutExpertise = aboutExpertise
	}
	
	class func generateAvailableTarget(json: JSON) -> [AvailableTarget] {
		let json = json["result"]
		var targets = [AvailableTarget]()
		
		if json.isArray {
			for (_, json) : (String, JSON) in json {
				if let t = AvailableTarget(json: json) {
					targets.append(t)
				}
			}
		}
		
		return targets
	}
}