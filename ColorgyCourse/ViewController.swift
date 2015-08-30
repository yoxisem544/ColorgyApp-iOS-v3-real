//
//  ViewController.swift
//  ColorgyAPIHandler
//
//  Created by David on 2015/8/22.
//  Copyright (c) 2015年 David. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var accesstokenTextField: UITextField!
    @IBAction func updateAccesstokenClicked(sender: AnyObject) {
        println(self.user?.accessToken)
    }
    
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
    
    
    @IBAction func GetMeAPI(sender: AnyObject) {
        ColorgyAPI.me { (result, error) -> Void in
            if error != nil {
                println("error \(error)")
            } else {
                if let result = result {
                    UserSetting.storeAPIMeResult(result: result)
                    println("user now is \(ColorgyUser())")
                }
            }
        }
    }
    
    @IBOutlet weak var getuseridtextfield: UITextField!
    @IBAction func getusercourses(sender: AnyObject) {
        if let id = self.getuseridtextfield.text {
            ColorgyAPI.getUserCoursesWithUserId(id, completionHandler: { (userCourseObjects) -> Void in
                println("okgetcourse")

                if let a = userCourseObjects {
                    for aa in a {
                        println(aa)
                    }
                }
            })
        }
    }
    @IBAction func getselfcourses(sender: AnyObject) {
        ColorgyAPI.getMeCourses { (userCourseObjects) -> Void in
            println("幹幹幹")
            println(userCourseObjects)
        }
    }
    @IBAction func downloadcoursescli(sender: AnyObject) {
        if let counts = self.coursecounttextfield.text.toInt() {
            ColorgyAPI.getSchoolCourseData(counts, completionHandler: { (courseRawDataObjects, json) -> Void in
                if let rawdataobjects = courseRawDataObjects {
                    println("ok fetch school course")
                }
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
        self.view.addSubview(tm)
        
        
//        ColorgyAPI.getCourseRawDataObjectWithCourseCode("1041-AC5007701", completionHandler: { (courseRawDataObject) -> Void in
//            if let courseRawDataObject = courseRawDataObject {
//                if let c = Course(rawData: courseRawDataObject) {
//                    println(c)
//                    tm.courses = [c]
//                }
//            }
//        })
        
        ColorgyAPI.getSchoolCourseData(5, completionHandler: { (courseRawDataObjects, json) -> Void in
            if let courseRawDataObjects = courseRawDataObjects {
                println("Get!")
                if let cs = Course.generateCourseArrayWithRawDataObjects(courseRawDataObjects) {
                    tm.courses = cs
                }
            }
        })
        
        println(UIDevice.currentDevice().name)
        
    }
    
    func tap() {
        self.view.endEditing(true)
    }

    @IBAction func refreshtokenclicked(sender: AnyObject) {
        println("refresh clicked")
        NetwrokQualityDetector.isNetworkStableToUse(stable: { () -> Void in
            ColorgyAPITrafficControlCenter.refreshAccessToken { (loginResult) -> Void in
                if loginResult != nil {
                    println("refresh ended")
                }
            }
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
            } else if quality == NetworkQuality.NormalSpeedNetwork {
                println("NormalSpeedNetwork!")
            } else if quality == NetworkQuality.LowSpeedNetwork {
                println("LowSpeedNetwork!")
            } else if quality == NetworkQuality.VeryBadNetwork {
                println("VeryBadNetwork!")
            } else if quality == NetworkQuality.NoNetwork {
                println("NoNetwork!")
            }
        }
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
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
