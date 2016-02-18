//
//  ChatReportViewController.swift
//  ColorgyCourse
//
//  Created by David on 2016/2/18.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

class ChatReportViewController: UIViewController {
	
	var reportView: ChatReportView!
	
	var encounteredProblems: [String?]!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		if encounteredProblems == nil {
			encounteredProblems = ["感覺被騷擾", "對方有不正當的言談", "對話涉及言語攻擊", "太色啦Q__Q", "其他原因"]
		}
		reportView = ChatReportView(headerTitleText: "有什麼問題儘管回報吧！", problemPickerTitleLabelText: "你遇到的問題", problemPickerContents: encounteredProblems, problemDescriptionLabelText: "請敘述當時遇到的情況")
	
		reportView.frame.origin.y = 64
		reportView.formDelegate = self
		view.addSubview(reportView)
    }
}

extension ChatReportViewController : ChatReportViewDelegate {
	func chatReportView(contentUpdated problem: String?, description: String?) {
		print(problem)
		print(description)
	}
}
