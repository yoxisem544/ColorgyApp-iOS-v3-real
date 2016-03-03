//
//  ChaeMeUser.swift
//  ColorgyCourse
//
//  Created by David on 2016/2/8.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

class ChatMeUserInformation : NSObject {
	// required
	var status: Int
	var avatarURL: String?
	var organizationCode: String
	var id: String
	var name: String
	// optional
	var aboutSchool: String?
	var aboutConversation: String?
	var aboutPassion: String?
	var aboutHoroscope: String?
	var aboutHabitancy: String?
	var aboutExpertise: String?
	
	override var description: String {
		return "ChatMeUserInformation: {\n\tstatus -> \(status)\n\tavatarURL -> \(avatarURL)\n\torganizationCode -> \(organizationCode)\n\tid -> \(id)\n\tname -> \(name)\n\taboutSchool -> \(aboutSchool)\n\taboutConversation -> \(aboutConversation)\n\taboutPassion -> \(aboutPassion)\n\taboutHoroscope -> \(aboutHoroscope)\n\taboutHabitancy -> \(aboutHabitancy)\n\taboutExpertise -> \(aboutExpertise)\n}"
	}
	
	convenience init?(json: JSON) {
		
		var _status: Int?
		var _avatarURL: String?
		var _organizationCode: String?
		var _id: String?
		var _name: String?
		var _aboutSchool: String?
		var _aboutConversation: String?
		var _aboutPassion: String?
		var _aboutHoroscope: String?
		var _aboutHabitancy: String?
		var _aboutExpertise: String?

		_status = json["status"].number?.integerValue
		_avatarURL = json["avatar_url"].string
		_organizationCode = json["organization_code"].string
		_id = json["id"].string
		_name = json["name"].string
		_aboutSchool = json["about"]["school"].string
		_aboutConversation = json["about"]["conversation"].string
		_aboutPassion = json["about"]["passion"].string
		_aboutHoroscope = json["about"]["horoscope"].string
		_aboutHabitancy = json["about"]["habitancy"].string
		_aboutExpertise = json["about"]["expertise"].string
		
		self.init(status: _status, avatarURL: _avatarURL, organizationCode: _organizationCode, id: _id, name: _name, aboutSchool: _aboutSchool, aboutConversation: _aboutConversation, aboutPassion: _aboutPassion, aboutHoroscope: _aboutHoroscope, aboutHabitancy: _aboutHabitancy, aboutExpertise: _aboutExpertise)
	}
	
	init?(status: Int?, avatarURL: String?, organizationCode: String?, id: String?, name: String?, aboutSchool: String?, aboutConversation: String?, aboutPassion: String?, aboutHoroscope: String?, aboutHabitancy: String?, aboutExpertise: String?) {
		
		self.status = Int()
		self.organizationCode = String()
		self.id = String()
		self.name = String()
		
		super.init()
		
		// required
		guard status != nil else { return nil }
		guard id != nil else { return nil }
		guard organizationCode != nil else { return nil }
		guard name != nil else { return nil }
		
		self.status = status!
		self.id = id!
		self.organizationCode = organizationCode!
		self.name = name!
		self.avatarURL = avatarURL
		
		// optional
		self.aboutSchool = aboutSchool
		self.aboutConversation = aboutConversation
		self.aboutPassion = aboutPassion
		self.aboutHoroscope = aboutHoroscope
		self.aboutHabitancy = aboutHabitancy
		self.aboutExpertise = aboutExpertise
	}
}