//
//  DLMessagesViewController.swift
//  CustomMessengerWorkout
//
//  Created by David on 2016/1/14.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

struct DLMessageControllerIdentifier {
    static let DLIncomingMessageBubbleIdentifier = "DLIncomingMessageBubble"
    static let DLOutgoingMessageBubbleIdentifier = "DLOutgoingMessageBubble"
}

protocol DLMessagesViewControllerDelegate {
    func DLMessagesViewControllerDidClickedMessageButton(withReturnMessage message: String?)
}

class DLMessagesViewController: UIViewController {
    
    var bubbleTableView: UITableView!
    var keyboardTextInputView: TextInputView!
    var kbHeight: CGFloat! = 0.0
    var keyboardAndMessageGap: CGFloat = 8.0
    
    var delegate: DLMessagesViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        bubbleTableView = UITableView(frame: UIScreen.mainScreen().bounds)
        self.view.addSubview(bubbleTableView)
        bubbleTableView.registerNib(UINib(nibName: DLMessageControllerIdentifier.DLIncomingMessageBubbleIdentifier, bundle: nil), forCellReuseIdentifier: DLMessageControllerIdentifier.DLIncomingMessageBubbleIdentifier)
        bubbleTableView.registerNib(UINib(nibName: DLMessageControllerIdentifier.DLOutgoingMessageBubbleIdentifier, bundle: nil), forCellReuseIdentifier: DLMessageControllerIdentifier.DLOutgoingMessageBubbleIdentifier)
        
        bubbleTableView.delegate = self
        bubbleTableView.dataSource = self
        
        bubbleTableView.estimatedRowHeight = 197
        bubbleTableView.rowHeight = UITableViewAutomaticDimension
        
        bubbleTableView.keyboardDismissMode = .Interactive
        
        bubbleTableView.separatorStyle = .None
        
        keyboardTextInputView = TextInputView()
        keyboardTextInputView.frame.origin.y = UIScreen.mainScreen().bounds.maxY - keyboardTextInputView.bounds.height
        keyboardTextInputView.delegate = self
        self.view.addSubview(keyboardTextInputView)
        
        // adjust inset
        bubbleTableView.contentInset.bottom = keyboardAndMessageGap + keyboardTextInputView.bounds.height
    }
    
    func scrollToButtom(animated animated: Bool) {
        let numbers = bubbleTableView.numberOfRowsInSection(0)
        let indexPath = NSIndexPath(forRow: numbers - 1, inSection: 0)
		if numbers >= 1 {
			bubbleTableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: animated)
			print(bubbleTableView.contentSize.height)
		}
    }
    
    func finishedSendingMessage() {
		let rows = bubbleTableView.numberOfRowsInSection(0)
		// rows is always actul count
		// pass in rows in inserting
        bubbleTableView.insertRowsAtIndexPaths([NSIndexPath(forRow: rows, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Bottom)
		// rows here no need to -1
		bubbleTableView.scrollToRowAtIndexPath(NSIndexPath(forRow: rows, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: false)
    }
	
	func messageRecieved() {
		finishedSendingMessage()
	}
}

extension DLMessagesViewController : TextInputViewDelegate {
    func textInputView(didUpdateKeyboardFrame kbRect: CGRect?, textInputView: TextInputView) {
        if let kbRect = kbRect {
            keyboardTextInputView.frame.origin.y = kbRect.origin.y - textInputView.frame.height
            kbHeight =  UIScreen.mainScreen().bounds.height - kbRect.origin.y
            // adjust inset
            let bottomInset = UIScreen.mainScreen().bounds.height - keyboardTextInputView.frame.origin.y + keyboardAndMessageGap
            bubbleTableView.contentInset.bottom = bottomInset
            scrollToButtom(animated: false)
        }
    }
    func textInputView(didUpdateFrame textInputView: TextInputView) {
        
    }
    func textInputView(didClickedSendMessageButton message: String?) {
        delegate?.DLMessagesViewControllerDidClickedMessageButton(withReturnMessage: message)
    }
}

extension DLMessagesViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(DLMessageControllerIdentifier.DLIncomingMessageBubbleIdentifier, forIndexPath: indexPath) as! DLIncomingMessageBubble
        //        let cell = tableView.dequeueReusableCellWithIdentifier(DLMessageControllerIdentifier.DLOutgoingMessageBubbleIdentifier, forIndexPath: indexPath) as! DLOutgoingMessageBubble
        
        //        let s = ["幹你媽的回去當心北市長啦", "不要擔心他1/16就回來當了","選後新民意既已讓民進黨全面執政，可提早進場一展執政抱負卻一再牽拖，民進黨真的做好執政準備了嗎？", "jaksjkas", "a"]
        //        cell.textlabel.text = s[random()%3]
        //        let img = ["11.jpg", "60.jpg", "1.jpg"]
        //        cell.userImageView.image = UIImage(named: img[random()%3])
        
        return cell
    }
    

}
