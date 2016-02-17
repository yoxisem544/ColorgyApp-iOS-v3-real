//
//  ColorgyChatAPI.swift
//  ColorgyCourse
//
//  Created by David on 2016/1/28.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

enum Gender: String {
	case Male = "male"
	case Female = "female"
	case Unspecified = "unspecified"
}

enum UserStatus: String {
	case NotRegistered = "not_registered"
	case Registered = "registered"
	case Banned = "banned"
}

enum HiStatus: String {
	case Pending = "pending"
	case Accepted = "accepted"
	case Rejected = "rejected"
}

enum NameStatus: String {
	case Ok = "ok"
	case AlreadyExists = "exists"
}

enum AnsweredLatestQuestionStatus:String {
    case Answered = "answered"
    case notAnswered = "not answered"
}

class ColorgyChatAPI : NSObject {
	
	static let serverURL = "http://chat.colorgy.io"
	
	// A Cross of Colorgy me
	class func ColorgyAPIMe(success: () -> Void, failure: () -> Void ) {
		ColorgyAPI.me({ (result) -> Void in
			success()
			}, failure: { () -> Void in
				failure()
		})
	}
	
	///上傳聊天室照片：
	///
	///用途：單純一個end-point以供照片上傳
	///使用方式：
	///
	///1. 傳一個http post給/upload/upload_chat_image，將圖片檔案放在file這個參數內
	///2. 伺服器會回傳圖片位置到result這個參數內
	class func uploadImage(image: UIImage, success: (result: String) -> Void, failure: () -> Void) {
		
		let afManager = AFHTTPSessionManager()
		afManager.requestSerializer = AFJSONRequestSerializer()
		afManager.responseSerializer = AFJSONResponseSerializer()
		
		guard let compressedImageData = UIImageJPEGRepresentation(image, 0.1) else {
			print("error loading iamge")
			return
		}
		
		print(compressedImageData.length)
		afManager.POST(serverURL + "/upload/upload_chat_image", parameters: nil, constructingBodyWithBlock: { (formData: AFMultipartFormData) -> Void in
			
			}, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
				
			}, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
				
		})
		afManager.POST(serverURL + "/upload/upload_chat_image", parameters: nil, constructingBodyWithBlock: { (formdata: AFMultipartFormData) -> Void in
			formdata.appendPartWithFileData(compressedImageData, name: "file", fileName: "file", mimeType: "image/jpeg")
			}, progress: nil, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
				if let response = response {
					let json = JSON(response)
					print(json)
					if let result = json["result"].string {
						success(result: result)
					} else {
						failure()
					}
				} else {
					failure()
				}
			}, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
				print(error.localizedDescription)
				print(operation)
				failure()
		})?.resume()
	}
	
	///檢查使用者狀態：(simple test passed)
	///
	///用途：在一打開聊天功能時，第一件事就是檢查他是不是已經登入過並且認證完成，如果成功的話會回傳在聊天系統裡面的userId。若是第一次登入，也會創建一個user並且回傳id。
	///使用方式：
	///
	///1. 傳一個http post給/users/check_user_available，參數包含使用者的uuid、accessToken
	///2. 如果成功，回傳使用者的id以及status
	class func checkUserAvailability(success: (user: ChatUser) -> Void, failure: () -> Void) {
		
		let afManager = AFHTTPSessionManager(baseURL: nil)
		afManager.requestSerializer = AFJSONRequestSerializer()
		afManager.responseSerializer = AFJSONResponseSerializer()
		
		guard let uuid = UserSetting.UserUUID() else {
			failure()
			return
		}
		guard let accessToken = UserSetting.UserAccessToken() else {
			failure()
			return
		}
		
		let params = ["uuid": uuid, "accessToken": accessToken]

		afManager.POST(serverURL + "/users/check_user_available", parameters: params, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
			//            print(response)
			if let response = response {
				if let user = ChatUser(json: JSON(response)) {
					success(user: user)
				} else {
					failure()
				}
			} else {
				failure()
			}
			}, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
				print(error.localizedDescription)
				failure()
		})
	}
	
	///檢查使用者暱稱：(simple test passed)
	///
	///用途：給 app 一個 web API endpoint 來更檢查使用者暱稱
	///使用方式：
	///
	///1. 傳一個http post給/users/check_name_exists，參數包含使用者的name
	///2. 回傳json：{ result: 'ok' }或者json：{ result: 'exists' }、狀態皆為200
	class func checkNameExists(name: String, success: (status: NameStatus) -> Void, failure: () -> Void) {
		
		let afManager = AFHTTPSessionManager(baseURL: nil)
		afManager.requestSerializer = AFJSONRequestSerializer()
		afManager.responseSerializer = AFJSONResponseSerializer()
		
		let params = ["name": name]
		print(params)
		afManager.POST(serverURL + "/users/check_name_exists", parameters: params, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
			if let response = response {
				let json = JSON(response)
				print(json["result"].string)
				if json["result"].string == NameStatus.Ok.rawValue {
					success(status: NameStatus.Ok)
				} else if json["result"].string == NameStatus.AlreadyExists.rawValue {
					success(status: NameStatus.AlreadyExists)
				} else {
					failure()
					print("fail to generate NameStatus, unknown status")
				}
			} else {
				failure()
			}
			}, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
				print(error.localizedDescription)
				failure()
		})
	}
	
	class func checkNameExists(name: String, success: (status: String) -> Void, failure: () -> Void) {
		
		let afManager = AFHTTPSessionManager(baseURL: nil)
		afManager.requestSerializer = AFJSONRequestSerializer()
		afManager.responseSerializer = AFJSONResponseSerializer()
		
		let params = ["name": name]
		print(params)
		afManager.POST(serverURL + "/users/check_name_exists", parameters: params, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
			if let response = response {
				let json = JSON(response)
				print(json["result"].string)
				if json["result"].string == NameStatus.Ok.rawValue {
					success(status: NameStatus.Ok.rawValue)
				} else if json["result"].string == NameStatus.AlreadyExists.rawValue {
					success(status: NameStatus.AlreadyExists.rawValue)
				} else {
					failure()
					print("fail to generate NameStatus, unknown status")
				}
			} else {
				failure()
			}
			}, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
				print(error.localizedDescription)
				failure()
		})
	}
	
	///更新使用者名稱：(simple test passed)
	///
	///用途：給 app 一個 web API endpoint 來更新使用者名稱
	///使用方式：
	///
	///1. 傳一個http post給/users/update_name，參數包含使用者的name、userId、 uuid、accessToken
	class func updateName(name: String, userId: String, success: () -> Void, failure: () -> Void) {
		
		let ud = NSUserDefaults.standardUserDefaults()
		ud.setObject(name, forKey: UserSettingKey.nickyName)
		ud.synchronize()
		
		let afManager = AFHTTPSessionManager(baseURL: nil)
		afManager.requestSerializer = AFJSONRequestSerializer()
		afManager.responseSerializer = AFJSONResponseSerializer()
		
		guard let uuid = UserSetting.UserUUID() else {
			failure()
			return
		}
		guard let accessToken = UserSetting.UserAccessToken() else {
			failure()
			return
		}
		
		let params = [
			"name": name,
			"userId": userId,
			"uuid": uuid,
			"accessToken": accessToken
		]
		print(params)
		afManager.POST(serverURL + "/users/update_name", parameters: params, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
			print(response)
			// TODO: maybe handle returned response
			success()
			}, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
				failure()
				print(error.localizedDescription)
		})
	}
	
	///更新使用者資料：(simple test passed)
	///
	///用途：給 app 一個 web API endpoint 來更新使用者的相關訊息（星座，興趣等等）
	///使用方式：
	///
	///1. 傳一個http post給/users/update_about，參數包含使用者的about、userId、 uuid、accessToken
	class func updateAbout(userId: String, horoscope: String?, school: String?, habitancy: String?, conversation: String?, passion: String?, expertise: String?, success: () -> Void, failure: () -> Void) {
		
		let afManager = AFHTTPSessionManager(baseURL: nil)
		afManager.requestSerializer = AFJSONRequestSerializer()
		afManager.responseSerializer = AFJSONResponseSerializer()
		
		guard let uuid = UserSetting.UserUUID() else {
			failure()
			return
		}
		guard let accessToken = UserSetting.UserAccessToken() else {
			failure()
			return
		}
		
		let params = [
			"about": [
				"horoscope": (horoscope ?? ""), //星座
				"school": (school ?? ""), //學校
				"habitancy": (habitancy ?? ""), //居住地
				"conversation": (conversation ?? ""), //想聊的話題
				"passion": (passion ?? ""), //現在熱衷的事情
				"expertise": (expertise ?? "") //專精的事情
			],
			"userId": userId,
			"uuid": uuid,
			"accessToken": accessToken
		]
		print(params)
		afManager.POST(serverURL + "/users/update_about", parameters: params, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
			//            print(response)
			success()
			}, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
				failure()
				print(error.localizedDescription)
		})
	}
	
	///更新使用者大頭貼，更新使用者的驗證狀態：
	///
	///用途：因為資料庫不同，需要在上傳大頭貼後，或者使用者收到信件驗證後跟chat server確認更新的資料
	///使用方式：
	///
	///1. 傳一個http post給/users/update_from_core，參數包含使用者的 uuid、accessToken
	class func updateFromCore(success: () -> Void, failure: () -> Void) {
		
		let afManager = AFHTTPSessionManager(baseURL: nil)
		afManager.requestSerializer = AFJSONRequestSerializer()
		afManager.responseSerializer = AFJSONResponseSerializer()
		
		guard let uuid = UserSetting.UserUUID() else {
			failure()
			return
		}
		guard let accessToken = UserSetting.UserAccessToken() else {
			failure()
			return
		}
		
		let params = [
			"uuid": uuid,
			"accessToken": accessToken
		]
		print(params)
		afManager.POST(serverURL + "/users/update_from_core", parameters: params, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
			print(response)
			success()
			}, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
				failure()
				print(error.localizedDescription)
		})
	}
	
	///取得使用者資料（是自己）：
	///
	///用途：給 app 一個 web API endpoint 來取得使用者的相關訊息（星座，興趣等等）
	///使用方式：
	///
	///1. 傳一個http post給/users/me，參數包括使用者的 uuid, accessToken
	///2. 回傳使用者的基本資料，包括status, name, about, lastAnswer, avatar_url
	class func me(success: (user: ChatMeUserInformation) -> Void, failure: () -> Void) {
		
		let afManager = AFHTTPSessionManager(baseURL: nil)
		afManager.requestSerializer = AFJSONRequestSerializer()
		afManager.responseSerializer = AFJSONResponseSerializer()
		
		guard let uuid = UserSetting.UserUUID() else {
			failure()
			return
		}
		guard let accessToken = UserSetting.UserAccessToken() else {
			failure()
			return
		}
		
		let params = [
			"uuid": uuid,
			"accessToken": accessToken
		]
		print(params)
		afManager.POST(serverURL + "/users/me", parameters: params, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
			if let response = response {
				let json = JSON(response)["result"]
				if let user = ChatMeUserInformation(json: json) {
					success(user: user)
				} else {
					print("fail to generate UnmatchedUser at me api.")
					failure()
				}
			} else {
				failure()
			}
			}, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
				failure()
				print(error.localizedDescription)
		})
	}
	
	///取得使用者資料（不是自己的使用者）：
	///
	///用途：給 app 一個 web API endpoint 來取得使用者的相關訊息（星座，興趣等等）
	///使用方式：
	///
	///1. 傳一個http post給/users/get_user，參數包含使用者的userId
	///2. 回傳使用者的公開詳細資料，包含使用者的status,name,about,lastAnsweredDate,lastAnswer,avatar_blur_2x_url(預設就是都是最模糊的),organization_code
	class func getUser(userId: String, success: (user: ChatUserInformation) -> Void, failure: () -> Void) {
		
		let afManager = AFHTTPSessionManager(baseURL: nil)
		afManager.requestSerializer = AFJSONRequestSerializer()
		afManager.responseSerializer = AFJSONResponseSerializer()
		
		let params = [
			"userId": userId
		]
		
		afManager.POST(serverURL + "/users/get_user", parameters: params, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
			if let response = response {
				let json = JSON(response)["result"]
				if let u = ChatUserInformation(json: json) {
					success(user: u)
				} else {
					failure()
				}
			} else {
				failure()
			}
			}, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
				failure()
				print(error.localizedDescription)
		})
	}
	
	///舉報使用者：
	///
	///用途：給 app 一個 web API endpoint 來舉報使用者
	///使用方式：
	///
	///1. 傳一個http post給/report/report_user，參數包含uuid, accessToken,  userId, targetId, type,reason
	class func reportUser(userId: String, targetId: String, type: String, reason: String, success: () -> Void, failure: () -> Void) {
		
		let afManager = AFHTTPSessionManager(baseURL: nil)
		afManager.requestSerializer = AFJSONRequestSerializer()
		afManager.responseSerializer = AFJSONResponseSerializer()
		
		guard let uuid = UserSetting.UserUUID() else {
			failure()
			return
		}
		guard let accessToken = UserSetting.UserAccessToken() else {
			failure()
			return
		}
		
		let params = [
			"uuid": uuid,
			"accessToken": accessToken,
			"userId": userId,
			"targetId": targetId,
			"type": type,
			"reason": reason
		]
		print(params)
		afManager.POST(serverURL + "/report/report_user", parameters: params, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
			success()
			}, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
				failure()
				print(error.localizedDescription)
		})
	}
	
	///封鎖使用者：
	///
	///用途：給 app 一個 web API endpoint 來封鎖使用者，之後在得到聊天室列表將會得不到被封鎖的人。進不去過去的聊天室，也收不到任何聊天室的訊息（單方面）。
	///使用方式：
	///
	///1. 傳一個http post給/users/block_user，參數包含uuid,accessToken, userId,targetId
	///2. 回傳200即代表已經封鎖
	class func blockUser(userId: String, targetId: String, success: () -> Void, failure: () -> Void) {
		
		let afManager = AFHTTPSessionManager(baseURL: nil)
		afManager.requestSerializer = AFJSONRequestSerializer()
		afManager.responseSerializer = AFJSONResponseSerializer()
		
		guard let uuid = UserSetting.UserUUID() else {
			failure()
			return
		}
		guard let accessToken = UserSetting.UserAccessToken() else {
			failure()
			return
		}
		
		let params = [
			"uuid": uuid,
			"accessToken": accessToken,
			"userId": userId,
			"targetId": targetId
		]
		print(params)
		afManager.POST(serverURL + "/users/block_user", parameters: params, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
			success()
			}, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
				failure()
				print(error.localizedDescription)
		})
	}
	
	///取得聊天室列表：(simple test passed)
	///
	///用途：給 app 一個 web API endpoint 來封鎖使用者，之後在得到聊天室列表將會得不到被封鎖的人。進不去過去的聊天室，也收不到任何聊天室的訊息（單方面）。
	///使用方式：
	///
	///1. 傳一個http post給/users/get_available_target，參數包含gender,uuid,accessToken,userId,page，page從零開始，0,1,2,3,4,5...一直到回傳為空陣列為止
	///2. 如果成功，回傳的資料包括id,name, about,lastAnswer,avatar_blur_2x_url,一次會回傳20個
	class func getAvailableTarget(userId: String, gender: Gender, page: Int, success: (targets: [AvailableTarget]) -> Void, failure: () -> Void) {
		
		let afManager = AFHTTPSessionManager(baseURL: nil)
		afManager.requestSerializer = AFJSONRequestSerializer()
		afManager.responseSerializer = AFJSONResponseSerializer()
		
		guard let uuid = UserSetting.UserUUID() else {
			failure()
			return
		}
		guard let accessToken = UserSetting.UserAccessToken() else {
			failure()
			return
		}
		
		let params = [
			"uuid": uuid,
			"accessToken": accessToken,
			"userId": userId,
			"gender": gender.rawValue,
			"page": page.stringValue
		]
		
		afManager.POST(serverURL + "/users/get_available_target", parameters: params, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
			if let response = response {
				let targets = AvailableTarget.generateAvailableTarget(JSON(response))
				success(targets: targets)
			} else {
				failure()
			}
			}, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
				print(error.localizedDescription)
				failure()
		})
	}
	
	class func getAvailableTarget(userId: String, gender: String, page: Int, success: (targets: [AvailableTarget]) -> Void, failure: () -> Void) {
		
		let afManager = AFHTTPSessionManager(baseURL: nil)
		afManager.requestSerializer = AFJSONRequestSerializer()
		afManager.responseSerializer = AFJSONResponseSerializer()
		
		guard let uuid = UserSetting.UserUUID() else {
			failure()
			return
		}
		guard let accessToken = UserSetting.UserAccessToken() else {
			failure()
			return
		}
		
		let params = [
			"uuid": uuid,
			"accessToken": accessToken,
			"userId": userId,
			"gender": gender,
			"page": page.stringValue
		]
		
		afManager.POST(serverURL + "/users/get_available_target", parameters: params, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
			if let response = response {
				let targets = AvailableTarget.generateAvailableTarget(JSON(response))
				success(targets: targets)
			} else {
				failure()
			}
			}, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
				print(error.localizedDescription)
				failure()
		})
	}
	
	///取得最新問題：
	///
	///用途：取得最新問題以及最新問題的date，此處的date會用在回答問題的api call中。
	///使用方式：
	///
	///1. 傳一個http get給/questions/get_question
	///2. 成功的會會回傳最新的問題以及date參數
	class func getQuestion(success: (date: String?, question: String?) -> Void, failure: () -> Void) {
		
		let afManager = AFHTTPSessionManager(baseURL: nil)
		afManager.requestSerializer = AFJSONRequestSerializer()
		afManager.responseSerializer = AFJSONResponseSerializer()
		
		afManager.GET(serverURL + "/questions/get_question", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
			if let response = response {
				let json = JSON(response)
				success(date: json["date"].string, question: json["question"].string)
			} else {
				failure()
			}
			}, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
				print(error.localizedDescription)
				failure()
		})
	}
	
	///回答問題：
	///
	///用途：回傳當日（或者最新）問題的答案給伺服器，如果不是最新會回傳錯誤。
	///使用方式：
	///
	///1. 傳一個http post給/users/answer_question，參數包含uuid,accessToken, userId,date(format:yyyymmdd),answer
	class func answerQuestion(userId: String, answer: String, date: String, success: () -> Void, failure: () -> Void) {
		
		let afManager = AFHTTPSessionManager(baseURL: nil)
		afManager.requestSerializer = AFJSONRequestSerializer()
		afManager.responseSerializer = AFJSONResponseSerializer()
		
		guard let uuid = UserSetting.UserUUID() else {
			failure()
			return
		}
		guard let accessToken = UserSetting.UserAccessToken() else {
			failure()
			return
		}
		
		let params = [
			"uuid": uuid,
			"accessToken": accessToken,
			"userId": userId,
			"date": date,
			"answer": answer
		]
		print(params)
		afManager.POST(serverURL + "/users/answer_question", parameters: params, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
			// print(JSON(response))
			success()
			}, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
				print(error.localizedDescription)
				failure()
		})
	}
	
	///檢查打招呼：(simple test passed)
	///
	///用途：檢查是否已經打過招呼。如果有打過回傳打招呼的結果。
	///使用方式：
	///
	///1. 傳一個http post給/hi/check_hi，參數包含的userId,targetId,uuid,accessToken
	///2. 回傳打招呼的結果，有兩種狀況可以繼續打招呼：(1) 從沒打過招呼 (2) 被拒絕可以再打一次，兩者的結果都是一樣的status 200：{ result: 'ok, you can say hi' }，若是已經(1)打過招呼然後成功過 (2)打過招呼還在等候回應，回傳status 200：{ result: 'already said hi' }
	class func checkHi(userId: String, targetId: String, success: (canSayHi: Bool) -> Void, failure: () -> Void) {
		let afManager = AFHTTPSessionManager(baseURL: nil)
		afManager.requestSerializer = AFJSONRequestSerializer()
		afManager.responseSerializer = AFJSONResponseSerializer()
		
		guard let uuid = UserSetting.UserUUID() else {
			failure()
			return
		}
		guard let accessToken = UserSetting.UserAccessToken() else {
			failure()
			return
		}
		
		let params = [
			"uuid": uuid,
			"accessToken": accessToken,
			"userId": userId,
			"targetId": targetId
		]
		
		afManager.POST(serverURL + "/hi/check_hi", parameters: params, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
			if let response = response {
				let json = JSON(response)
				print(json)
				if json["result"].string == "already said hi" {
					// can't say hi, return false
					success(canSayHi: false)
				} else if json["result"].string == "ok, you can say hi" {
					// can say hi, return true
					success(canSayHi: true)
				} else if json["result"].string == "target already said hi" {
					success(canSayHi: false)
				} else {
					print("fail to check say hi, unknown result")
					failure()
				}
			} else {
				failure()
			}
			}, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
				print(error.localizedDescription)
				failure()
		})
	}
	
	///打招呼：(simple test passed)
	///
	///用途：與特定的使用者打招呼，如果以打過招呼就直接進入聊天室即可。
	///使用方式：
	///
	///1. 傳一個http post給/hi/say_hi，參數包含使用者的userId,uuid, accessToken,targetId,message
	///2. 與一個陌生人打招呼
	class func sayHi(userId: String, targetId: String, message: String, success: () -> Void, failure: () -> Void) {
		
		let afManager = AFHTTPSessionManager(baseURL: nil)
		afManager.requestSerializer = AFJSONRequestSerializer()
		afManager.responseSerializer = AFJSONResponseSerializer()
		
		guard let uuid = UserSetting.UserUUID() else {
			failure()
			return
		}
		guard let accessToken = UserSetting.UserAccessToken() else {
			failure()
			return
		}
		guard userId != targetId else {
			failure()
			print("sayHi API error, userId and targetId cannot be same")
			return
		}
		
		let params = [
			"uuid": uuid,
			"accessToken": accessToken,
			"userId": userId,
			"targetId": targetId,
			"message": message
		]
		
		afManager.POST(serverURL + "/hi/say_hi", parameters: params, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
			success()
			}, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
				print(error.localizedDescription)
				print(error.localizedDescription)
				print(task?.response)
				print(error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey])
				let data = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] as? NSData
				do {
					try print(NSJSONSerialization.JSONObjectWithData(data!, options: []))
				} catch {
					
				}
				failure()
		})
	}
	
	///取得打招呼列表：(simple test passed)
	///
	///用途：取得被打招呼列表
	///使用方式：
	///
	///1. 傳一個http post給/hi/get_list，參數包含使用者的userId,uuid,accessToken
	///2. 回傳被打過招呼的列表
	class func getHiList(userId: String, success: (hiList: [Hello]) -> Void, failure: () -> Void) {
		
		let afManager = AFHTTPSessionManager(baseURL: nil)
		afManager.requestSerializer = AFJSONRequestSerializer()
		afManager.responseSerializer = AFJSONResponseSerializer()
		
		guard let uuid = UserSetting.UserUUID() else {
			failure()
			return
		}
		guard let accessToken = UserSetting.UserAccessToken() else {
			failure()
			return
		}
		
		let params = [
			"uuid": uuid,
			"accessToken": accessToken,
			"userId": userId
		]
		print(params)
		afManager.POST(serverURL + "/hi/get_list", parameters: params, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
			if let response = response {
				let json = JSON(response)
				print(json)
				let hiList = Hello.generateHiList(json)
				success(hiList: hiList)
			} else {
				failure()
			}
			}, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
				print(error.localizedDescription)
				failure()
		})
	}
	
	///接受打招呼：(simple test passed)
	///
	///用途：接受一個打招呼
	///使用方式：
	///
	///1. 傳一個http post給/hi/accept_hi，參數包含使用者的userId,uuid, accessToken,hiId
	///2. 必須要是target才能傳送這個request，會產生一個空的聊天室，回傳status 200
	class func acceptHi(userId: String, hiId: String, success: () -> Void, failure: () -> Void) {
		
		let afManager = AFHTTPSessionManager(baseURL: nil)
		afManager.requestSerializer = AFJSONRequestSerializer()
		afManager.responseSerializer = AFJSONResponseSerializer()
		
		guard let uuid = UserSetting.UserUUID() else {
			failure()
			return
		}
		guard let accessToken = UserSetting.UserAccessToken() else {
			failure()
			return
		}
		
		let params = [
			"uuid": uuid,
			"accessToken": accessToken,
			"userId": userId,
			"hiId": hiId
		]
		
		afManager.POST(serverURL + "/hi/accept_hi", parameters: params, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
			success()
			}, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
				print(error.localizedDescription)
				print(error.localizedDescription)
				print(task?.response)
				print(error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey])
				let data = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] as? NSData
				do {
					try print(NSJSONSerialization.JSONObjectWithData(data!, options: []))
				} catch {
					
				}
				if let a = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] {
					print(JSON(a))
				} else {
					print("false")
				}
				failure()
		})
	}
	
	
	///拒絕打招呼：(simple test passed)
	///
	///用途：拒絕一個打招呼
	///使用方式：
	///
	///1. 傳一個http post給/hi/reject_hi，參數包含使用者的userId,uuid, accessToken,hiId
	///2. 必須要是target才能傳送這個request，會將一個打招呼的status更改為rejected
	class func rejectHi(userId: String, hiId: String, success: () -> Void, failure: () -> Void) {
		
		let afManager = AFHTTPSessionManager(baseURL: nil)
		afManager.requestSerializer = AFJSONRequestSerializer()
		afManager.responseSerializer = AFJSONResponseSerializer()
		
		guard let uuid = UserSetting.UserUUID() else {
			failure()
			return
		}
		guard let accessToken = UserSetting.UserAccessToken() else {
			failure()
			return
		}
		
		let params = [
			"uuid": uuid,
			"accessToken": accessToken,
			"userId": userId,
			"hiId": hiId
		]
		
		afManager.POST(serverURL + "/hi/reject_hi", parameters: params, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
			success()
			}, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
				print(error.localizedDescription)
				failure()
		})
	}
	
	///檢查是否回答過最新問題：
	///
	///用途：在顯示問題之前需要先檢查是否回答過最新問題
	///使用方式：
	///
	///1. 傳一個http post給/users/check_answered_latest，參數包含uuid,accessToken,userId
	///2. 成功的會會回傳{ result: 'answered' }以及{ result: 'not answered'  }
    class func checkAnsweredLatestQuestion(userId: String, success: (answered :Bool) -> Void, failure: () -> Void) {
		
		let afManager = AFHTTPSessionManager(baseURL: nil)
		afManager.requestSerializer = AFJSONRequestSerializer()
		afManager.responseSerializer = AFJSONResponseSerializer()
		
		guard let uuid = UserSetting.UserUUID() else {
			failure()
			return
		}
		guard let accessToken = UserSetting.UserAccessToken() else {
			failure()
			return
		}
		
		let params = [
			"uuid": uuid,
			"accessToken": accessToken,
			"userId": userId
		]
        
        print(params)
        
		afManager.POST(serverURL + "/users/check_answered_latest", parameters: params, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
			if let response = response {
				let json = JSON(response)
				if json["result"].string == "answered" {
					success(answered: true)
				} else if json["result"].string == "not answered" {
					success(answered: false)
				} else {
					print("check answer lastest fail, unknown type")
					failure()
				}
			} else {
				failure()
			}
			}, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
				print(error.localizedDescription)
				failure()
		})
	}
	
	///取得好友列表：
	///
	///用途：給 app 一個 web API endpoint 來得到過去聊天過的使用者
	///使用方式：
	///
	///1. 傳一個http post給/users/get_history_target，參數包含gender,uuid,accessToken,userId,page，page從零開始，0,1,2,3,4,5...一直到回傳為空陣列為止
	///2. 如果成功，回傳的資料包括id,name, about,lastAnswer,avatar_blur_2x_url,一次會回傳20個
	class func getHistoryTarget(userId: String, gender: Gender, page: Int, success: (targets: [HistoryChatroom]) -> Void, failure: () -> Void) {
		
		let afManager = AFHTTPSessionManager(baseURL: nil)
		afManager.requestSerializer = AFJSONRequestSerializer()
		afManager.responseSerializer = AFJSONResponseSerializer()
		
		guard let uuid = UserSetting.UserUUID() else {
			failure()
			return
		}
		guard let accessToken = UserSetting.UserAccessToken() else {
			failure()
			return
		}
		
		let params = [
			"uuid": uuid,
			"accessToken": accessToken,
			"userId": userId,
			"gender": gender.rawValue,
			"page": page.stringValue
		]
		
		afManager.POST(serverURL + "/users/get_history_target", parameters: params, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
			if let response = response {
				let json = JSON(response)
				let rooms = HistoryChatroom.generateHistoryChatrooms(json)
				success(targets: rooms)
			} else {
				failure()
			}
			}, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
				print(error.localizedDescription)
				failure()
		})
	}
	
	class func getHistoryTarget(userId: String, gender: Gender, fromPage: Int, toPage: Int, complete: (targets: [HistoryChatroom]) -> Void) {
		var pagesToGet = toPage - fromPage + 1
		var targets = [HistoryChatroom]()
		for page in fromPage...toPage {
			print("getting page \(page)")
			getHistoryTarget(userId, gender: gender, page: page, success: { (_targets) -> Void in
				print(_targets)
				for t in _targets {
					targets.append(t)
				}
				pagesToGet -= 1
				if pagesToGet == 0 {
					complete(targets: targets)
				}
				}, failure: { () -> Void in
					pagesToGet -= 1
					if pagesToGet == 0 {
						complete(targets: targets)
					}
			})
		}
	}
	
	///刪除聊天室：
	///
	///用途：提供一個刪除聊天室的api，而聊天室將會從此從自己的聊天列表消失
	///使用方式：
	///
	///1. 傳一個http post給/users/remove_chatroom，參數包括：uuid,accessToken,userId,chatroomId
	///2. 若成功的話，會回傳一個{ result: success }
	class func removeChatroom(userId: String, chatroomId: String, success:() -> Void, failure: () -> Void) {
		
		let afManager = AFHTTPSessionManager(baseURL: nil)
		afManager.requestSerializer = AFJSONRequestSerializer()
		afManager.responseSerializer = AFJSONResponseSerializer()
		
		guard let uuid = UserSetting.UserUUID() else {
			failure()
			return
		}
		guard let accessToken = UserSetting.UserAccessToken() else {
			failure()
			return
		}
		
		let params = [
			"uuid": uuid,
			"accessToken": accessToken,
			"userId": userId,
			"chatroomId": chatroomId
		]
		print(params)
		afManager.POST(serverURL + "/users/remove_chatroom", parameters: params, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
			if let response = response {
				let json = JSON(response)
				if json["result"].string == "success" {
					success()
				} else {
					failure()
				}
			} else {
				failure()
			}
			}, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
				print(error.localizedDescription)
				print(operation?.response)
				print(error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey])
				let data = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] as? NSData
				do {
					try print(NSJSONSerialization.JSONObjectWithData(data!, options: []))
				} catch {
					
				}
				failure()
		})
	}
	
	///離開聊天室：
	///
	///用途：提供一個離開聊天室的api，對方將會收到一個來自系統的訊息，而聊天室將會從此從自己的聊天列表消失
	///使用方式：
	///
	///1. 傳一個http post給/chatroom/leave_chatroom，參數包括：uuid,accessToken,userId,chatroomId
	///2. 若成功的話，會回傳一個{ result: success }
	class func leaveChatroom(userId: String, chatroomId: String, success:() -> Void, failure: () -> Void) {
		
		let afManager = AFHTTPSessionManager(baseURL: nil)
		afManager.requestSerializer = AFJSONRequestSerializer()
		afManager.responseSerializer = AFJSONResponseSerializer()
		
		guard let uuid = UserSetting.UserUUID() else {
			failure()
			return
		}
		guard let accessToken = UserSetting.UserAccessToken() else {
			failure()
			return
		}
		
		let params = [
			"uuid": uuid,
			"accessToken": accessToken,
			"userId": userId,
			"chatroomId": chatroomId
		]
		
		afManager.POST(serverURL + "/chatroom/leave_chatroom", parameters: params, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
			if let response = response {
				let json = JSON(response)
				if json["result"].string == "success" {
					success()
				} else {
					failure()
				}
			} else {
				failure()
			}
			}, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
				failure()
		})
	}
	
	///更新對方稱呼：
	///
	///用途：更新對方的暱稱，並不會讓對方知道
	///使用方式：
	///
	///1. 傳一個http post給/chatroom/update_target_alias，參數包括uuid,accessToken,userId,chatroomId,alias
	///2. 若成功之後的establish connection後就會回傳對方的alias
	class func updateOthersNickName(userId: String, chatroomId: String, nickname: String, success:() -> Void, failure: () -> Void) {
		
		let afManager = AFHTTPSessionManager(baseURL: nil)
		afManager.requestSerializer = AFJSONRequestSerializer()
		afManager.responseSerializer = AFJSONResponseSerializer()
		
		guard let uuid = UserSetting.UserUUID() else {
			failure()
			return
		}
		guard let accessToken = UserSetting.UserAccessToken() else {
			failure()
			return
		}
		
		let params = [
			"uuid": uuid,
			"accessToken": accessToken,
			"userId": userId,
			"chatroomId": chatroomId,
			"alias": nickname
		]
		
		afManager.POST(serverURL + "/chatroom/update_target_alias", parameters: params, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
			success()
			}, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
				failure()
		})
	}

	
	class func checkImageType(data: NSData) {
		var c = UInt8()
		data.getBytes(&c, length: 1)
		
		switch c {
		case 0xFF:
			print("jpg")
		case 0x89:
			print("png")
		case 0x47:
			print("gif")
		case 0x49:
			print("tiff")
		case 0x4D:
			print("tiff")
		default:
			break
		}
	}
}