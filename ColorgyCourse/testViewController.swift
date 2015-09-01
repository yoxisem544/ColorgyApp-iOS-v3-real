//
//  testViewController.swift
//  ColorgyCourse
//
//  Created by David on 2015/9/1.
//  Copyright (c) 2015年 David. All rights reserved.
//

import UIKit

class testViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var y = NSBundle.mainBundle().loadNibNamed("CourseDetailHeaderView", owner: self, options: nil)
        println(y)
        let yo = y[0] as! CourseDetailHeaderView
        yo.frame = self.view.frame
        yo.frame = CGRectMake(0, 0, self.view.frame.width, 279)
        yo.autoresizingMask = self.view.autoresizingMask
        yo.translatesAutoresizingMaskIntoConstraints()
        
        // scroll view 
        var scrollView = UIScrollView(frame: self.view.frame)
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height*2)
        scrollView.backgroundColor = UIColor.lightGrayColor()
        scrollView.addSubview(yo)
        
        self.view.addSubview(scrollView)
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
