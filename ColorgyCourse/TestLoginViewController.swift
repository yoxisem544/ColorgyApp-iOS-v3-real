//
//  TestLoginViewController.swift
//  ColorgyCourse
//
//  Created by David on 2015/9/2.
//  Copyright (c) 2015年 David. All rights reserved.
//

import UIKit

class TestLoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    @IBOutlet weak var statusLabel: UILabel!
    @IBAction func fblogin(sender: AnyObject) {
        ColorgyLogin.loginToFacebook { (token) -> Void in
            if let token = token {
                ColorgyLogin.loginToColorgyWithToken(token, handler: { (response, error) -> Void in
                    if let response = response {
                        // login ok
                        self.statusLabel.text = "login colorgy ok"
                        UserSetting.storeLoginResult(result: response)
                        // fetcg me api
                        ColorgyAPI.me({ (result) -> Void in
                            // store usr settings
                            self.statusLabel.text = "setting me api result"
                            UserSetting.storeAPIMeResult(result: result)
                            self.statusLabel.text = "generateAndStoreDeviceUUID"
                            UserSetting.generateAndStoreDeviceUUID()
                            
                            // ready to change view
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let vc = storyboard.instantiateViewControllerWithIdentifier("TabBarViewController") as! UITabBarController
                            self.presentViewController(vc, animated: true, completion: nil)
                            UserSetting.changeLoginStateSuccessfully()
                        }, failure: { () -> Void in
                             self.statusLabel.text = "fail get me api"
                        })
                    } else {
                        self.statusLabel.text = "login colorgy fail, \(error)"
                    }
                })
            } else {
                self.statusLabel.text = "login fb fail"
            }
        }
    }

}
