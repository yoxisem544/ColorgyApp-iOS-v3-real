//
//  ViewController.swift
//  ColorgyAPIHandler
//
//  Created by David on 2015/8/22.
//  Copyright (c) 2015年 David. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var stateString: UILabel!

    @IBOutlet weak var deviceUUID: UITextField!
    
    
    @IBOutlet weak var fbAccessTokenTextField: UITextField!
    @IBAction func LoginToFacebook(sender: UIButton) {
        var login = ColorgyLogin()
        ColorgyLogin.loginToFacebook { (token) -> Void in
            if let token = token {
                self.fbAccessTokenTextField.text = token
                ColorgyLogin.loginToColorgyWithToken(token, handler: { (response, error) -> Void in
                    if error != nil {
                        println("something wrong")
                    } else {
                        println("login ok, this is response body: \(response)")
                        if let res = response {
                            self.accesstoken = res.access_token
                            UserSetting.storeLoginResult(result: res)
                        }
                    }
                })
            }
        }
    }
    
    @IBOutlet weak var colorgyAccessTokenTextField: UITextField!
    var accesstoken: String? {
        didSet {
            println("at did set")
            println(accesstoken)
            self.colorgyAccessTokenTextField.text = accesstoken
        }
    }
    
    
    @IBAction func checkCanlogout(sender: AnyObject) {
        LogoutHelper.logoutPrepare(success: { () -> Void in
            println("ready to logout")
            LogoutHelper.logout({ () -> Void in
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewControllerWithIdentifier("Main Login View") as! FBLoginViewController
                self.presentViewController(vc, animated: true, completion: nil)
            })
        }) { () -> Void in
            println("fail, not ready to logout")
        }
    }
    
    @IBAction func GetMeAPI(sender: AnyObject) {
        ColorgyAPI.me({ (result) -> Void in
            UserSetting.storeAPIMeResult(result: result)
            println("user now is \(ColorgyUser())")
        }, failure: { () -> Void in
            println("error getting me api")
        })
    }
    
    @IBOutlet weak var getuseridtextfield: UITextField!
    @IBAction func getusercourses(sender: AnyObject) {
        if let id = self.getuseridtextfield.text {
            ColorgyAPI.getUserCoursesWithUserId(id, completionHandler: { (userCourseObjects) -> Void in
                if let a = userCourseObjects {
                    for aa in a {
                        println(aa)
                    }
                }
            }, failure: { () -> Void in
                println("fail to get user courses")
            })
        }
    }
    @IBAction func getselfcourses(sender: AnyObject) {
        ColorgyAPI.getMeCourses({ (userCourseObjects) -> Void in
            println(userCourseObjects)
        }, failure: { () -> Void in
            println("幹幹幹")
        })
    }
    @IBAction func downloadcoursescli(sender: AnyObject) {
        if let counts = self.coursecounttextfield.text.toInt() {
            ColorgyAPI.getSchoolCourseData(counts, year: 2015, term: 1, success: { (courseRawDataObjects, json) -> Void in
                    println("ok fetch school course")
                }, failure: {
                   println("fuck of the fail download course")
            })
        }
        
    }
    @IBOutlet weak var coursecounttextfield: UITextField!
    let user = ColorgyUser()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        println(self.user)
//        CourseDB.storeFakeData()
//        CourseDB.storeFakeData()
//        CourseDB.getAllStoredCoursesObject()
//        CourseDB.deleteCourseWithCourseCode("1041-AC5007701")
//        ColorgyAPI.getStudentsInSpecificCourse("1041-AC5007701", completionHandler: { (userCourseObjects) -> Void in
//            if let objs = userCourseObjects {
//                println("\(objs.count) people enrolled in this course")
//            }
//        })
//        ColorgyAPI.getSchoolCourseData(1, completionHandler: { (courseRawDataObjects, json) -> Void in
//            if let json = json {
//                UserSetting.storeRawCourseJSON(json)
//            }
//        })
//        println(LocalCachingData.jsonFormat)
//        ColorgyAPI.getStudentsInSpecificCourse("a", completionHandler: { (userCourseObjects) -> Void in
//            println("OK")
//            println(userCourseObjects)
//        })
//        var tm = TimeTableView(frame: self.view.frame)
//        self.view.addSubview(tm)
        
        var tap = UITapGestureRecognizer(target: self, action: "tap")
        self.view.addGestureRecognizer(tap)
        
        var tm = TimeTableView(frame: self.view.frame)
        tm.delegate = self
//        self.view.addSubview(tm)
        
        
//        ColorgyAPI.getCourseRawDataObjectWithCourseCode("1041-AC5007701", completionHandler: { (courseRawDataObject) -> Void in
//            if let courseRawDataObject = courseRawDataObject {
//                if let c = Course(rawData: courseRawDataObject) {
//                    println(c)
//                    tm.courses = [c]
//                }
//            }
//        })
        
//        ColorgyAPI.getSchoolCourseData(5, year: 2015, term: 1, success: { (courseRawDataObjects, json) -> Void in
//            println("Get!")
//            }, failure: {
//              println("fuck fail Get!")
//        })
        
        println(UIDevice.currentDevice().name)
        self.view.addSubview(acsView)
        
//        UserSetting.generateAndStoreDeviceUUID()
//        UserSetting.setNeedDeletePushNotitficationDeviceToken()
//        UserSetting.successfullyDeleteToken()
//        BackgroundWorker().startJobs()
        

//        LogoutHelper.logoutPrepare(success: { () -> Void in
//            println("ready to logout")
//            }, failure: { () -> Void in
//            println("not ready to logout")
//        })
        
        self.deviceUUID.text = UserSetting.getDeviceUUID()
    }
    
    var acsView = AddCourseSuccessfulView()
    
    func tap() {
        self.view.endEditing(true)
    }

    @IBAction func refreshtokenclicked(sender: AnyObject) {
        println("refresh clicked")
        self.stateString.text = "refresh clicked"
        NetwrokQualityDetector.isNetworkStableToUse(stable: { () -> Void in
            ColorgyAPITrafficControlCenter.refreshAccessToken({ (loginResult) -> Void in
                if loginResult != nil {
                    println("refresh ended")
                    self.stateString.text = "refresh ended"
                }
            }, failure: { () -> Void in
                
            })
        }, unstable: { () -> Void in
            println("low speed")
        })
    }
    @IBAction func getschoolperioddata(sender: AnyObject) {
        ColorgyAPI.getSchoolPeriodData { (periodDataObjects) -> Void in
            if let objects = periodDataObjects {
                println(objects)
                var tm = TimeTableView(frame: self.view.frame)
                self.view.addSubview(tm)
            }
        }
    }

    @IBAction func networktest(sender: AnyObject) {
        println("Click get quality")
        NetwrokQualityDetector.getNetworkQuality { (quality) -> Void in
            if quality == NetworkQuality.HighSpeedNetwork {
                println("Hi!")
                self.stateString.text = "HighSpeedNetwork"
            } else if quality == NetworkQuality.NormalSpeedNetwork {
                println("NormalSpeedNetwork!")
                self.stateString.text = "NormalSpeedNetwork"
            } else if quality == NetworkQuality.LowSpeedNetwork {
                println("LowSpeedNetwork!")
                self.stateString.text = "LowSpeedNetwork"
            } else if quality == NetworkQuality.VeryBadNetwork {
                println("VeryBadNetwork!")
                self.stateString.text = "VeryBadNetwork"
            } else if quality == NetworkQuality.NoNetwork {
                println("NoNetwork!")
                self.stateString.text = "NoNetwork"
            }
        }
    }
    @IBAction func putnotitficationtoken(sender: AnyObject) {
        ColorgyAPI.PUTdeviceToken(success: { () -> Void in
            println("put device token ok")
        }) { () -> Void in
            println("put device token fail")
        }
    }
    @IBAction func checkanimation(sender: AnyObject) {
        acsView.animate()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: TimeTableViewDelegate {
    func timeTableView(userDidTapOnCell cell: CourseCellView) {
        println(cell.courseInfo.name)
    }
    
    func timeTableViewDidScroll(scrollView: UIScrollView) {
        
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
