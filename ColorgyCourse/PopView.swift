//
//  PopView.swift
//  ColorgyAPIHandler
//
//  Created by David on 2015/8/28.
//  Copyright (c) 2015年 David. All rights reserved.
//

import UIKit

class PopView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    var okButton: UIButton!
    var popContentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(message: String?) {
        super.init(frame: CGRectZero)
        
        let mainScreenRect = UIScreen.mainScreen().bounds
        let backgroundDarkView = UIView(frame: mainScreenRect)
        backgroundDarkView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.addSubview(backgroundDarkView)
        
        let popContentViewWidth = mainScreenRect.width * 0.7
        
        // calculate lines
        // spacing is 16 to left and right
        let labelWidth = popContentViewWidth - (16 * 2)
        let messageLabel = UILabel(frame: CGRectMake(0, 0, labelWidth, CGFloat.max))
        messageLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        messageLabel.numberOfLines = 0
        messageLabel.text = message
        messageLabel.sizeToFit()
        messageLabel.layer.borderWidth = 2
        messageLabel.layer.borderColor = UIColor.redColor().CGColor
        
        // button
        var okButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        okButton.frame = CGRectMake(0, 0, popContentViewWidth/2, 30)
        okButton.setTitle("OK!", forState: UIControlState.Normal)
        okButton.addTarget(self, action: "okButtonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        
        // 70% of width of main screen 
        popContentView = UIView(frame: CGRectMake(0, 0, popContentViewWidth, okButton.bounds.height + 16 + messageLabel.bounds.height + 32))
        popContentView.backgroundColor = UIColor.whiteColor()
        popContentView.addSubview(messageLabel)
        messageLabel.center.x = popContentView.bounds.midX
        messageLabel.frame.origin.y = 16
        
        // add button to popview
        popContentView.addSubview(okButton)
        okButton.center.x = popContentView.bounds.midX
        okButton.frame.origin.y = messageLabel.frame.maxY + 16
        
        // center popview
        popContentView.center = backgroundDarkView.center
        
        self.addSubview(popContentView)
        
        // expand the frame
        self.frame = mainScreenRect
    }
    
    func okButtonClicked(sender: UIButton) {
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.popContentView.transform = CGAffineTransformMakeTranslation(0, 500)
        }) { (finished) -> Void in
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.alpha = 0
            }, completion: { (finished) -> Void in
                self.hidden = true
            })
        }
    }
    

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
