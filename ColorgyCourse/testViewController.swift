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
        yo.frame = CGRectMake(20, 20, self.view.frame.width, 300)
        yo.autoresizingMask = self.view.autoresizingMask
        yo.translatesAutoresizingMaskIntoConstraints()
        self.view.addSubview(yo)
        yo.layer.borderColor = UIColor.redColor().CGColor
        yo.layer.borderWidth = 10
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
