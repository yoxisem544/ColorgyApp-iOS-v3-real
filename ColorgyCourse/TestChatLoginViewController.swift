//
//  TestChatLoginViewController.swift
//  ColorgyCourse
//
//  Created by David on 2016/1/25.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

class TestChatLoginViewController: UIViewController {
	
	@IBAction func  test_yuntech_student_ca62() {
		ColorgyLogin.loginToColorgyWithUsername(username: "test-yzu-student-f478@test.colorgy.io", password: "test-yzu-student-f478", success: { (result) -> Void in
			let params = [
				"method": "post",
				"headers": [],
				"data": [
					"accessToken": result.access_token!,
					"friendId": "56aef7f0e50c113d8cd702d9",
					"userId": "56af0fb34bd9c5f12d613d7d",
					"uuid": "68efe6c7-66b8-43bd-8046-ca228a65767e"
				],
				"url": "/chatroom/establish_connection"
			]
			self.userId = "56a470cfb94e4a5a7f5394b4"
			self.performSegueWithIdentifier("to chat room", sender: params)
			}) { () -> Void in
			
		}
	}
	
	@IBAction func test_yzu_student_f478() {
		ColorgyLogin.loginToColorgyWithUsername(username: "test-yuntech-student-ca62@test.colorgy.io", password: "test-yuntech-student-ca62", success: { (result) -> Void in
			let params = [
				"method": "post",
				"headers": [],
				"data": [
					"accessToken": result.access_token!,
					"friendId": "56af0fb34bd9c5f12d613d7d",
					"userId": "56aef7f0e50c113d8cd702d9",
					"uuid": "7d936b9c-b670-487a-a6d6-23aac674124a"
				],
				"url": "/chatroom/establish_connection"
			]
			self.userId = "56a470aab94e4a5a7f5394b3"
			self.performSegueWithIdentifier("to chat room", sender: params)
			}) { () -> Void in
				
		}
	}
	
	var userId: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		ColorgyChatAPI.checkNameExists("早安少女組", success: { () -> Void in
			
			}) { () -> Void in
				
		}
		

		ColorgyChatAPI.checkUserAvailability({ (user) -> Void in
			print(user)
			ColorgyChatAPI.updateName("早安少女組", userId: user.userId, success: { () -> Void in
				
				}, failure: { () -> Void in
					
			})
			}) { () -> Void in
		}
//
//		ColorgyChatAPI.updateFromCore({ () -> Void in
//			
//			}) { () -> Void in
//				
//		}
		
//		ColorgyChatAPI.me({ () -> Void in
//			
//			
//			}) { () -> Void in
//				
//		}
		
//		ColorgyChatAPI.checkUserAvailability({ (user) -> Void in
//			ColorgyChatAPI.getUser(user.userId, success: { () -> Void in
//
//				}, failure: { () -> Void in
//					
//			})
//			}) { () -> Void in
//				
//		}
		
//		ColorgyChatAPI.getAvailableTarget({ () -> Void in
//			
//			}) { () -> Void in
//				
//		}
//
//		ColorgyChatAPI.getQuestion({ () -> Void in
//			
//			
//			}) { () -> Void in
//				
//		}
		
//		ColorgyChatAPI.answerQuestion("yo", answer: "yo", success: { () -> Void in
//			
//			
//			}) { () -> Void in
//				
//		}
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
		if segue.identifier == "to chat room" {
			let vc = segue.destinationViewController as! TestChatRoomViewController
			vc.params = sender as? [String : NSObject]
			vc.userId = self.userId
		}
    }


}
