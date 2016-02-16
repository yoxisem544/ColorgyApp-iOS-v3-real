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
		self.statusLabel.text = "切換中..."
		ColorgyLogin.loginToColorgyWithUsername(username: "test-yzu-student-f478@test.colorgy.io", password: "test-yzu-student-f478", success: { (result) -> Void in
			ColorgyAPI.me({ (result) -> Void in
				UserSetting.storeAPIMeResult(result: result)
				self.statusLabel.text = "你現在是 \(UserSetting.UserPossibleOrganization())的學生"
				}, failure: { () -> Void in
					
			})
			}) { () -> Void in
			
		}
	}
	
	@IBAction func test_yzu_student_f478() {
		self.statusLabel.text = "切換中..."
		ColorgyLogin.loginToColorgyWithUsername(username: "test-yuntech-student-ca62@test.colorgy.io", password: "test-yuntech-student-ca62", success: { (result) -> Void in
			ColorgyAPI.me({ (result) -> Void in
				UserSetting.storeAPIMeResult(result: result)
				self.statusLabel.text = "你現在是 \(UserSetting.UserPossibleOrganization())的學生"
				}, failure: { () -> Void in
					
			})
			}) { () -> Void in
				
		}
	}
	
	func generalLogin(n: String, p: String) {
		self.statusLabel.text = "切換中..."
		ColorgyLogin.loginToColorgyWithUsername(username: n, password: p, success: { (result) -> Void in
			ColorgyAPI.me({ (result) -> Void in
				UserSetting.storeAPIMeResult(result: result)
				self.statusLabel.text = "你現在是 \(UserSetting.UserPossibleOrganization())的學生"
				}, failure: { () -> Void in
					
			})
			}) { () -> Void in
				
		}
	}
	
	@IBOutlet weak var statusLabel: UILabel!
	
	override func viewDidDisappear(animated: Bool) {
		super.viewDidDisappear(animated)
		hidesBottomBarWhenPushed = false
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		statusLabel.text = "你現在是 \(UserSetting.UserPossibleOrganization())的學生"
	}
	
	var userId: String!
	var accesstoken: String!
	var friendId: String!
	var uuid: String!

	var testAccounts: [[String]] = [["test-yzu-student-f478@test.colorgy.io", "test-yzu-student-f478", "元智 學生"],
		["test-yuntech-student-ca62@test.colorgy.io", "test-yuntech-student-ca62", "雲科 學生"],
		["test-yuhing-student-44b4@test.colorgy.io", "test-yuhing-student-44b4", " 育英 學生"],
		["test-ytit-student-cfa1@test.colorgy.io", "test-ytit-student-cfa1", " 永達 學生"],
		["test-ypu-student-5f3d@test.colorgy.io", "test-ypu-student-5f3d", "元培科大 學生"],
		["test-ym-student-bfe6@test.colorgy.io", "test-ym-student-bfe6", " 陽明 學生"],
		["test-ydu-student-7a4e@test.colorgy.io", "test-ydu-student-7a4e", "育達 學生"],
		["test-wzu-student-b565@test.colorgy.io", "test-wzu-student-b565", "文藻 學生"],
		["test-wfu-student-23d8@test.colorgy.io", "test-wfu-student-23d8", "吳鳳科大 學生"],
		["test-vnu-student-0f6f@test.colorgy.io", "test-vnu-student-0f6f", "萬能科大 學生"],
		["test-utaipei-student-b364@test.colorgy.io", "test-utaipei-student-b364", "市北大 學生"],
		["test-usckh-student-72fe@test.colorgy.io", "test-usckh-student-72fe", "實踐高雄 學生"],
		["test-usc-student-22be@test.colorgy.io", "test-usc-student-22be", "實踐 學生"],
		["test-ukn-student-8776@test.colorgy.io", "test-ukn-student-8776", "康寧 學生"],
		["test-twu-student-f165@test.colorgy.io", "test-twu-student-f165", "環球科大 學生"],
		["test-tut-student-c911@test.colorgy.io", "test-tut-student-c911", "南應 學生"],
		["test-tust-student-7dde@test.colorgy.io", "test-tust-student-7dde", " 大華 學生"],
		["test-ttu-student-0b07@test.colorgy.io", "test-ttu-student-0b07", "大同 學生"],
		["test-ttc-student-30f0@test.colorgy.io", "test-ttc-student-30f0", "大同學院 學生"],
		["test-tsu-student-3963@test.colorgy.io", "test-tsu-student-3963", "首府 學生"],
		["test-tsint-student-359b@test.colorgy.io", "test-tsint-student-359b", "城市科大 學生"],
		["test-tpcu-student-c2d4@test.colorgy.io", "test-tpcu-student-c2d4", " 城市科大 學生"],
		["test-toko-student-ba96@test.colorgy.io", "test-toko-student-ba96", " 稻江 學生"],
		["test-tnua-student-a406@test.colorgy.io", "test-tnua-student-a406", " 北藝 學生"],
		["test-tnu-student-2432@test.colorgy.io", "test-tnu-student-2432", "東南科大 學生"],
		["test-tnnua-student-3eb5@test.colorgy.io", "test-tnnua-student-3eb5", "南藝大 學生"],
		["test-tmu-student-7cf8@test.colorgy.io", "test-tmu-student-7cf8", "北醫 學生"],
		["test-tku-student-a43d@test.colorgy.io", "test-tku-student-a43d", "淡江 學生"],
		["test-thu-student-0029@test.colorgy.io", "test-thu-student-0029", "東海 學生"],
		["test-tht-student-1d62@test.colorgy.io", "test-tht-student-1d62", "臺觀 學生"],
		["test-tf-student-5b5d@test.colorgy.io", "test-tf-student-5b5d", " 東方 學生"],
		["test-tcu-student-9ea4@test.colorgy.io", "test-tcu-student-9ea4", "慈濟 學生"],
		["test-tcpa-student-1b40@test.colorgy.io", "test-tcpa-student-1b40", " 戲曲 學生"],
		["test-tcmt-student-928d@test.colorgy.io", "test-tcmt-student-928d", " 北海 學生"],
		["test-tccn-student-36f5@test.colorgy.io", "test-tccn-student-36f5", " 慈濟學院 學生"],
		["test-takming-student-b50d@test.colorgy.io", "test-takming-student-b50d", "德明科大 學生"],
		["test-tajen-student-11b1@test.colorgy.io", "test-tajen-student-11b1", "大仁科大 學生"],
		["test-stut-student-00dc@test.colorgy.io", "test-stut-student-00dc", " 南台科大 學生"],
		["test-stust-student-6937@test.colorgy.io", "test-stust-student-6937", "南臺科大 學生"],
		["test-stu-student-c6d5@test.colorgy.io", "test-stu-student-c6d5", "樹德科大 學生"],
		["test-sju-student-9580@test.colorgy.io", "test-sju-student-9580", "聖約翰科大 學生"],
		["test-shu-student-2a6d@test.colorgy.io", "test-shu-student-2a6d", "世新 學生"],
		["test-scu-student-c5b1@test.colorgy.io", "test-scu-student-c5b1", "東吳 學生"],
		["test-pu-student-3af7@test.colorgy.io", "test-pu-student-3af7", " 靜宜 學生"],
		["test-pccu-student-8fb5@test.colorgy.io", "test-pccu-student-8fb5", " 文化 學生"],
		["test-oit-student-7988@test.colorgy.io", "test-oit-student-7988", "亞東 學生"],
		["test-ocu-student-557d@test.colorgy.io", "test-ocu-student-557d", "僑光 學生"],
		["test-nuu-student-0f5d@test.colorgy.io", "test-nuu-student-0f5d", "聯合 學生"],
		["test-nutn-student-2824@test.colorgy.io", "test-nutn-student-2824", " 南大 學生"],
		["test-nuk-student-ae2f@test.colorgy.io", "test-nuk-student-ae2f", "高大 學生"],
		["test-ntut-student-0d0d@test.colorgy.io", "test-ntut-student-0d0d", " 北科大 學生"],
		["test-ntust-student-33a6@test.colorgy.io", "test-ntust-student-33a6", "台科大 學生"],
		["test-ntue-student-e002@test.colorgy.io", "test-ntue-student-e002", " 北教大 學生"],
		["test-ntua-student-30be@test.colorgy.io", "test-ntua-student-30be", " 台藝大 學生"],
		["test-ntu-student-2f1d@test.colorgy.io", "test-ntu-student-2f1d", "台大 學生"],
		["test-nttu-student-31d5@test.colorgy.io", "test-nttu-student-31d5", " 東大 學生"],
		["test-ntsu-student-d10c@test.colorgy.io", "test-ntsu-student-d10c", " 國體 學生"],
		["test-ntpu-student-1760@test.colorgy.io", "test-ntpu-student-1760", " 北大 學生"],
		["test-ntpc-student-38dd@test.colorgy.io", "test-ntpc-student-38dd", " 海工 學生"],
		["test-ntou-student-b229@test.colorgy.io", "test-ntou-student-b229", " 海洋 學生"],
		["test-ntnu-student-50d8@test.colorgy.io", "test-ntnu-student-50d8", " 台師大 學生"],
		["test-ntit-student-b340@test.colorgy.io", "test-ntit-student-b340", " 中科大 學生"],
		["test-ntin-student-382d@test.colorgy.io", "test-ntin-student-382d", " 台南護專 學生"],
		["test-nthu-student-7589@test.colorgy.io", "test-nthu-student-7589", " 清大 學生"],
		["test-ntcu-student-9b40@test.colorgy.io", "test-ntcu-student-9b40", " 中教大 學生"],
		["test-ntcpe-student-470b@test.colorgy.io", "test-ntcpe-student-470b", "台體 學生"],
		["test-ntcnc-student-1e31@test.colorgy.io", "test-ntcnc-student-1e31", "中護 學生"],
		["test-ntcb-student-9ccf@test.colorgy.io", "test-ntcb-student-9ccf", " 北商 學生"],
		["test-nsysu-student-9649@test.colorgy.io", "test-nsysu-student-9649", "中山 學生"],
		["test-nqu-student-2bc0@test.colorgy.io", "test-nqu-student-2bc0", "金大 學生"],
		["test-npust-student-4fb5@test.colorgy.io", "test-npust-student-4fb5", "屏東科大 學生"],
		["test-nptu-student-e4a0@test.colorgy.io", "test-nptu-student-e4a0", " 屏大 學生"],
		["test-nou-student-2cf4@test.colorgy.io", "test-nou-student-2cf4", "空大 學生"],
		["test-nkut-student-e3a5@test.colorgy.io", "test-nkut-student-e3a5", " 南開 學生"],
		["test-nkuht-student-7269@test.colorgy.io", "test-nkuht-student-7269", "高餐 學生"],
		["test-nknu-student-37aa@test.colorgy.io", "test-nknu-student-37aa", " 高師大 學生"],
		["test-nkfust-student-c4ee@test.colorgy.io", "test-nkfust-student-c4ee", " 高第一 學生"],
		["test-njtc-student-56a1@test.colorgy.io", "test-njtc-student-56a1", " 南榮 學生"],
		["test-niu-student-c2c2@test.colorgy.io", "test-niu-student-c2c2", "宜大 學生"],
		["test-nhu-student-f3c1@test.colorgy.io", "test-nhu-student-f3c1", "南華 學生"],
		["test-nhcue-student-80a5@test.colorgy.io", "test-nhcue-student-80a5", "竹教 學生"],
		["test-nfu-student-b51c@test.colorgy.io", "test-nfu-student-b51c", "虎尾科大 學生"],
		["test-ndmctsgh-student-eebc@test.colorgy.io", "test-ndmctsgh-student-eebc", " 國防醫 學生"],
		["test-ndhu-student-4911@test.colorgy.io", "test-ndhu-student-4911", " 東華 學生"],
		["test-ncyu-student-1078@test.colorgy.io", "test-ncyu-student-1078", " 嘉大 學生"],
		["test-ncut-student-ccd3@test.colorgy.io", "test-ncut-student-ccd3", " 勤益科大 學生"],
		["test-ncue-student-b67c@test.colorgy.io", "test-ncue-student-b67c", " 彰師大 學生"],
		["test-ncu-student-f377@test.colorgy.io", "test-ncu-student-f377", "中央 學生"],
		["test-nctu-student-e46c@test.colorgy.io", "test-nctu-student-e46c", " 交大 學生"],
		["test-ncnu-student-9b2b@test.colorgy.io", "test-ncnu-student-9b2b", " 暨南 學生"],
		["test-ncku-student-6ca5@test.colorgy.io", "test-ncku-student-6ca5", " 成大 學生"],
		["test-nchu-student-6174@test.colorgy.io", "test-nchu-student-6174", " 中興 學生"],
		["test-nccu-student-e5a3@test.colorgy.io", "test-nccu-student-e5a3", " 政大 學生"],
		["test-nanya-student-1c9a@test.colorgy.io", "test-nanya-student-1c9a", "南亞 學生"]]
	@IBOutlet weak var testAccountTableView: UITableView!
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		testAccountTableView.delegate = self
		testAccountTableView.dataSource = self
    }
	
	@IBAction func goBackToMainAccount() {
		self.statusLabel.text = "切換中..."
		ColorgyLogin.loginToFacebook { (token) -> Void in
			if let token = token {
				ColorgyLogin.loginToColorgyWithToken(token, handler: { (response, error) -> Void in
					ColorgyAPI.me({ (result) -> Void in
						UserSetting.storeAPIMeResult(result: result)
						self.statusLabel.text = "你現在是 \(UserSetting.UserPossibleOrganization())的學生"
						}, failure: { () -> Void in
							
					})
				})
			}
		}
	}


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
		if segue.identifier == "to chat room" {
			hidesBottomBarWhenPushed = true
			let vc = segue.destinationViewController as! ChatRoomViewController
			vc.userId = self.userId
			vc.uuid = self.uuid
			vc.friendId = self.friendId
			vc.accessToken = self.accesstoken
		}
    }


}

extension TestChatLoginViewController : UITableViewDelegate, UITableViewDataSource {
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return testAccounts.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("test account", forIndexPath: indexPath)
		cell.textLabel?.text = testAccounts[indexPath.row][2] + " " + testAccounts[indexPath.row][0]
		return cell
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
		generalLogin(testAccounts[indexPath.row][0], p: testAccounts[indexPath.row][1])
	}
}
