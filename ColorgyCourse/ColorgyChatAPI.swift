//
//  ColorgyChatAPI.swift
//  ColorgyCourse
//
//  Created by David on 2016/1/28.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

class ColorgyChatAPI {
	
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