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
			self.userId = "56a470cfb94e4a5a7f5394b4"
			self.accesstoken = result.access_token
			self.uuid = "68efe6c7-66b8-43bd-8046-ca228a65767e"
			self.friendId = "56aef7f0e50c113d8cd702d9"
			self.performSegueWithIdentifier("to chat room", sender: nil)
			}) { () -> Void in
			
		}
	}
	
	@IBAction func test_yzu_student_f478() {
		ColorgyLogin.loginToColorgyWithUsername(username: "test-yuntech-student-ca62@test.colorgy.io", password: "test-yuntech-student-ca62", success: { (result) -> Void in
			self.userId = "56aef7f0e50c113d8cd702d9"
			self.accesstoken = result.access_token
			self.uuid = "7d936b9c-b670-487a-a6d6-23aac674124a"
			self.friendId = "56af0fb34bd9c5f12d613d7d"
			self.performSegueWithIdentifier("to chat room", sender: nil)
			}) { () -> Void in
				
		}
	}
	
	override func viewDidDisappear(animated: Bool) {
		super.viewDidDisappear(animated)
		hidesBottomBarWhenPushed = false
	}
	
	var userId: String!
	var accesstoken: String!
	var friendId: String!
	var uuid: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//		ColorgyChatAPI.checkNameExists("早安少女組", success: { (AnyObject) -> Void in
//			
//			}) { () -> Void in
//				
//		}
//		
//
//		ColorgyChatAPI.checkUserAvailability({ (user) -> Void in
//			print(user)
//			ColorgyChatAPI.updateName("早安少女組", userId: user.userId, success: { () -> Void in
//				
//				}, failure: { () -> Void in
//					
//			})
//			}) { () -> Void in
//		}
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
		
//		ColorgyChatAPI.checkUserAvailability({ (user) -> Void in
//			print(user)
//			ColorgyChatAPI.getHiList(user.userId, success: { () -> Void in
//				
//				}, failure: { () -> Void in
//					
//			})
//			}) { () -> Void in
//				
//		}
    }
	
	@IBAction func testAPI() {
		ColorgyChatAPI.checkUserAvailability({ (user) -> Void in
			ColorgyChatAPI.getHistoryTarget(user.userId, gender: Gender.Female.rawValue, page: "0", success: { () -> Void in
				print("ok")
				}, failure: { () -> Void in
					
			})
			}) { () -> Void in
				
		}
	}


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
		if segue.identifier == "to chat room" {
			hidesBottomBarWhenPushed = true
			let vc = segue.destinationViewController as! TestChatRoomViewController
			vc.userId = self.userId
			vc.uuid = self.uuid
			vc.friendId = self.friendId
			vc.accessToken = self.accesstoken
		}
    }


}
