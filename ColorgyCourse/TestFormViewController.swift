//
//  TestFormViewController.swift
//  ColorgyCourse
//
//  Created by David on 2016/1/22.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

class TestFormViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let reportProblem: [String?] = ["沒有我的學校", "沒有我的系所", "找不到我的課", "課程資訊錯誤", "其他"]
        let fuckContent: [String?] = ["鞭打工程師", "幫工程師加油"]
        let sss = ReportFormView(headerTitleText: "dkskjds", checkListTitleLabelText: "dsjkdkjsdkj", checkListContents: reportProblem, problemDescriptionLabelText: "sdkjiu298", emailTitleLabelText: "ds89sd89", fuckContents: fuckContent, footerTitleLabelText: "98ds98d")
        self.view.addSubview(sss)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
