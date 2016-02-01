//
//  LaunchNavigationViewController.swift
//  ColorgyCourse
//
//  Created by David on 2016/2/1.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

class LaunchNavigationViewController: UIViewController {
	
	var topScrollView: UIScrollView?
	var spinGuideView: SpinView?
	var dismissGuideView: DismissGuideView?

	func setupTopScrollView() {
		topScrollView = UIScrollView(frame: CGRectMake(0, 0, view.frame.width, view.frame.height))
		topScrollView?.contentSize = CGSize(width: view.frame.width * 3, height: view.frame.height)
		topScrollView?.backgroundColor = UIColor.clearColor()
		view.addSubview(topScrollView!)
		topScrollView?.delegate = self
		topScrollView?.pagingEnabled = true
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		let imagePaths = ["Intro1","Intro2","Intro3"]
		let titles = ["隨身課表帶著走", "校園課程直接選", "課前通知"]
		let subtitles = ["不再忘記上課、跑錯教室！", "導入各校課程，輕鬆加進課程！", "自訂上課多久前通知提醒下堂課地點與時間"]
		spinGuideView = SpinView(radius: self.view.bounds.size.height, imagePaths: imagePaths, titles: titles, subtitles: subtitles)
		spinGuideView?.moveBelowBottom(view.bounds.size.height / 2)
		spinGuideView?.delegate = self
		view.addSubview(spinGuideView!)
		setupTopScrollView()
		view.backgroundColor = UIColor(red:0.973,  green:0.588,  blue:0.502, alpha:1)
		print(UIScreen.mainScreen().bounds)
		dismissGuideView = DismissGuideView(title: "馬上開始使用！")
		view.addSubview(dismissGuideView!)
		dismissGuideView?.delegate = self
    }

	func updateUI(offset: CGFloat) {
		let percent = offset / topScrollView!.contentSize.width
		spinGuideView?.rotatePercentage = percent.DoubleValue
	}

}

extension LaunchNavigationViewController : UIScrollViewDelegate {
	func scrollViewDidScroll(scrollView: UIScrollView) {
		updateUI(scrollView.contentOffset.x)
	}
}

extension LaunchNavigationViewController : SpinViewDelegate {
	func enterLastPage() {
		print("enterLastPage")
		dismissGuideView?.show()
	}
	
	func notInLastPage() {
		dismissGuideView?.hide()
	}
}

extension LaunchNavigationViewController : DismissGuideViewDelegate {
	func dismissGuideTouchUpInside() {
		print("tapped inside")
		
		HintViewSettings.setAppFirstLaunchNavigationViewShown()
		
		if !UserSetting.isLogin() {
			// dump data
			CourseDB.deleteAllCourses()
			// need login
			let storyboard = UIStoryboard(name: "Main", bundle: nil)
			let vc = storyboard.instantiateViewControllerWithIdentifier("Main Login View") as! FBLoginViewController
			self.presentViewController(vc, animated: true, completion: nil)
		} else {
			let storyboard = UIStoryboard(name: "Main", bundle: nil)
			let vc = storyboard.instantiateViewControllerWithIdentifier("TabBarViewController") as! UITabBarController
			self.presentViewController(vc, animated: true, completion: nil)
		}
	}
}
