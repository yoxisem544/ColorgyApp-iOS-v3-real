//
//  ColorgyChatAPI.swift
//  ColorgyCourse
//
//  Created by David on 2016/1/28.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

class ColorgyChatAPI : NSObject {
	
	static let serverURL = "http://52.68.177.186"
	
	class func uploadImage(image: UIImage, success: (result: String) -> Void, failure: () -> Void) {
		
		let afManager = AFHTTPRequestOperationManager()
		afManager.requestSerializer = AFJSONRequestSerializer()
		afManager.responseSerializer = AFJSONResponseSerializer()
		
		guard var compressedImageData = UIImageJPEGRepresentation(image, 0.1) else {
			print("error loading iamge")
			return
		}
		
		print(compressedImageData.length)
		
		let params = ["file": compressedImageData]
		
//		afManager.POST(serverURL + "/upload/upload_chat_image", parameters: nil, constructingBodyWithBlock: { (formData: AFMultipartFormData) -> Void in
//			formData.appendPartWithFormData(compressedImageData, name: "data/file")
//			}, success: { (operation: AFHTTPRequestOperation, response: AnyObject) -> Void in
//				print(response)
//			}) { (operation: AFHTTPRequestOperation?, error: NSError) -> Void in
//				print(error.localizedDescription)
//				print(operation?.response?.allHeaderFields)
//				print(operation)
//		}?.start()
		
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
	
	class func checkNameExists(name: String, success: () -> Void, failure: () -> Void) {
		
		let afManager = AFHTTPSessionManager(baseURL: nil)
		afManager.requestSerializer = AFJSONRequestSerializer()
		afManager.responseSerializer = AFJSONResponseSerializer()

		let params = ["name": name]
		print(params)
		afManager.POST(serverURL + "/users/check_name_exists", parameters: params, success: { (task: NSURLSessionDataTask, response: AnyObject) -> Void in
			print(response)
			}, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
				print(error.localizedDescription)
				failure()
		})
	}
	
	class func updateName(name: String, userId: String, success: () -> Void, failure: () -> Void) {
		
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
			}, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
				failure()
				print(error.localizedDescription)
		})
	}
	
	class func updateAbout(about: String, userId: String, success: () -> Void, failure: () -> Void) {
		
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
			"about": about,
			"userId": userId,
			"uuid": uuid,
			"accessToken": accessToken
		]
		print(params)
		afManager.POST(serverURL + "/users/update_about", parameters: params, success: { (task: NSURLSessionDataTask, response: AnyObject) -> Void in
			print(response)
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
			}, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
				failure()
				print(error.localizedDescription)
		})
	}
	
	class func me(success: () -> Void, failure: () -> Void) {
		
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
			}, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
				failure()
				print(error.localizedDescription)
		})
	}
	
	class func getUser(userId: String, success: () -> Void, failure: () -> Void) {
		
		let afManager = AFHTTPSessionManager(baseURL: nil)
		afManager.requestSerializer = AFJSONRequestSerializer()
		afManager.responseSerializer = AFJSONResponseSerializer()
		
		let params = [
			"userId": userId
		]
		print(params)
		afManager.POST(serverURL + "/users/get_user", parameters: params, success: { (task: NSURLSessionDataTask, response: AnyObject) -> Void in
			print(JSON(response))
			}, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
				failure()
				print(error.localizedDescription)
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