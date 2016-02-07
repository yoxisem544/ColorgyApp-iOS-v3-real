//
//  ColorgyChatAPI.swift
//  ColorgyCourse
//
//  Created by David on 2016/1/28.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

class ColorgyChatAPI : NSObject {

    static let serverURL = "http://chat.colorgy.io"
    
    // A Cross of Colorgy me
    class func ColorgyAPIMe( success: () -> Void, failure: () -> Void ) {
        ColorgyAPI.me({ (result) -> Void in
            success()
            }, failure: { () -> Void in
                failure()
        })
    }
    
    class func uploadImage(image: UIImage, success: (result: String) -> Void, failure: () -> Void) {
        
        let afManager = AFHTTPRequestOperationManager()
        afManager.requestSerializer = AFJSONRequestSerializer()
        afManager.responseSerializer = AFJSONResponseSerializer()
        
        guard let compressedImageData = UIImageJPEGRepresentation(image, 0.1) else {
            print("error loading iamge")
            return
        }
        
        print(compressedImageData.length)
        
        afManager.POST(serverURL + "/upload/upload_chat_image", parameters: nil, constructingBodyWithBlock: { (formdata: AFMultipartFormData) -> Void in
            formdata.appendPartWithFileData(compressedImageData, name: "file", fileName: "file", mimeType: "image/jpeg")
            }, success: { (operation: AFHTTPRequestOperation, response: AnyObject) -> Void in
                let json = JSON(response)
                print(json)
                if let result = json["result"].string {
                    success(result: result)
                } else {
                    failure()
                }
            }) { (operation: AFHTTPRequestOperation?, error: NSError) -> Void in
                print(error.localizedDescription)
                print(operation?.response?.allHeaderFields)
                print(operation)
                failure()
            }?.start()
    }
    
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
        print(params)
        afManager.POST(serverURL + "/users/check_user_available", parameters: params, success: { (task: NSURLSessionDataTask, response: AnyObject) -> Void in
            print(response)
            if let user = ChatUser(json: JSON(response)) {
                success(user: user)
            } else {
                failure()
            }
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print(error.localizedDescription)
                failure()
        })
    }
    
    class func checkNameExists(name: String, success: (AnyObject) -> Void, failure: () -> Void) {
        
        let afManager = AFHTTPSessionManager(baseURL: nil)
        afManager.requestSerializer = AFJSONRequestSerializer()
        afManager.responseSerializer = AFJSONResponseSerializer()
        
        let params = ["name": name]
        print(params)
        afManager.POST(serverURL + "/users/check_name_exists", parameters: params, success: { (task: NSURLSessionDataTask, response: AnyObject) -> Void in
            print(response)
            success(response)
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print(error.localizedDescription)
                failure()
        })
    }
    
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
        afManager.POST(serverURL + "/users/update_name", parameters: params, success: { (task: NSURLSessionDataTask, response: AnyObject) -> Void in
            print(response)
            success()
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure()
                print(error.localizedDescription)
        })
    }
    
    class func updateAbout(about: NSDictionary, userId: String, success: () -> Void, failure: () -> Void) {
        
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
                "horoscope": "123", //星座
                "school": "123", //學校
                "habitancy": "123", //居住地
                "conversation": "123", //想聊的話題
                "passion": "123", //現在熱衷的事情
                "expertise": "123" //專精的事情
            ],
            "userId": userId,
            "uuid": uuid,
            "accessToken": accessToken
        ]
        print(params)
        afManager.POST(serverURL + "/users/update_about", parameters: params, success: { (task: NSURLSessionDataTask, response: AnyObject) -> Void in
//            print(response)
            success()
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure()
                print(error.localizedDescription)
        })
    }
    
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
        afManager.POST(serverURL + "/users/update_from_core", parameters: params, success: { (task: NSURLSessionDataTask, response: AnyObject) -> Void in
            print(response)
            success()
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure()
                print(error.localizedDescription)
        })
    }
    
    class func me(success: (AnyObject) -> Void, failure: () -> Void) {
        
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
        afManager.POST(serverURL + "/users/me", parameters: params, success: { (task: NSURLSessionDataTask, response: AnyObject) -> Void in
            print(JSON(response))
            success(response)
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure()
                print(error.localizedDescription)
        })
    }
    
    class func getUser(userId: String, success: (AnyObject) -> Void, failure: () -> Void) {
        
        let afManager = AFHTTPSessionManager(baseURL: nil)
        afManager.requestSerializer = AFJSONRequestSerializer()
        afManager.responseSerializer = AFJSONResponseSerializer()
        
        let params = [
            "userId": userId
        ]
        print(params)
        afManager.POST(serverURL + "/users/get_user", parameters: params, success: { (task: NSURLSessionDataTask, response: AnyObject) -> Void in
            print(JSON(response))
            success(response)
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure()
                print(error.localizedDescription)
        })
    }
    
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
        afManager.POST(serverURL + "/report/report_user", parameters: params, success: { (task: NSURLSessionDataTask, response: AnyObject) -> Void in
            print(JSON(response))
            success()
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure()
                print(error.localizedDescription)
        })
    }
    
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
        afManager.POST(serverURL + "/users/block_user", parameters: params, success: { (task: NSURLSessionDataTask, response: AnyObject) -> Void in
            print(JSON(response))
            success()
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure()
                print(error.localizedDescription)
        })
    }
    
    class func getAvailableTarget(userId: String, gender: String, page: String, success: (AnyObject) -> Void, failure: () -> Void) {
        
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
            "page": page
        ]
        
        afManager.POST(serverURL + "/users/get_available_target", parameters: params, success: { (task: NSURLSessionDataTask, response: AnyObject) -> Void in
            print(JSON(response))
            success(response)
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print(error.localizedDescription)
                failure()
        })
    }
    
    class func getQuestion(success: (AnyObject) -> Void, failure: () -> Void) {
        
        let afManager = AFHTTPSessionManager(baseURL: nil)
        afManager.requestSerializer = AFJSONRequestSerializer()
        afManager.responseSerializer = AFJSONResponseSerializer()
        
        afManager.GET(serverURL + "/questions/get_question", parameters: nil, success: { (task: NSURLSessionDataTask, response: AnyObject) -> Void in
            print(JSON(response))
            success(response)
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print(error.localizedDescription)
                failure()
        })
    }
    
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
        afManager.POST(serverURL + "/users/answer_question", parameters: params, success: { (task: NSURLSessionDataTask, response: AnyObject) -> Void in
            // print(JSON(response))
            success()
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print(error.localizedDescription)
                failure()
        })
    }
	///用途：檢查是否已經打過招呼。如果有打過回傳打招呼的結果。
	///使用方式：
	///
	/// 1. 傳一個http post給/hi/check_hi，參數包含的userId,targetId,uuid,accessToken
	/// 2. 回傳打招呼的結果，有兩種狀況可以繼續打招呼：(1) 從沒打過招呼 (2) 被拒絕可以再打一次
	class func checkHi(userId: String, targetId: String, success: () -> Void, failure: () -> Void) {
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
		
		afManager.POST(serverURL + "/hi/check_hi", parameters: params, success: { (task: NSURLSessionDataTask, response: AnyObject) -> Void in
			print(JSON(response))
			success()
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
		
		let params = [
			"uuid": uuid,
			"accessToken": accessToken,
			"userId": userId,
			"targetId": targetId,
			"message": message
		]
		
		afManager.POST(serverURL + "/hi/say_hi", parameters: params, success: { (task: NSURLSessionDataTask, response: AnyObject) -> Void in
			print(JSON(response))
			success()
			}, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
				print(error.localizedDescription)
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
	class func getHiList(userId: String, success: () -> Void, failure: () -> Void) {
		
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
		
		afManager.POST(serverURL + "/hi/get_list", parameters: params, success: { (task: NSURLSessionDataTask, response: AnyObject) -> Void in
			print(JSON(response))
			success()
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
		
		afManager.POST(serverURL + "/hi/accept_hi", parameters: params, success: { (task: NSURLSessionDataTask, response: AnyObject) -> Void in
			print(JSON(response))
			success()
			}, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
				print(error.localizedDescription)
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
		
		afManager.POST(serverURL + "/hi/reject_hi", parameters: params, success: { (task: NSURLSessionDataTask, response: AnyObject) -> Void in
			print(JSON(response))
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
	class func checkAnsweredLatestQuestion(userId: String, success: () -> Void, failure: () -> Void) {
		
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
		
		afManager.POST(serverURL + "/users/check_answered_latest", parameters: params, success: { (task: NSURLSessionDataTask, response: AnyObject) -> Void in
			print(JSON(response))
			success()
			}, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
				print(error.localizedDescription)
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