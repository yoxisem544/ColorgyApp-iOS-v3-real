//
//  WebViewController.swift
//  News
//
//  Created by Duc Tran on 7/21/15.
//  Copyright © 2015 Developer Inspirus. All rights reserved.
//

import UIKit

class ActivityWebViewController: UIViewController, UIWebViewDelegate
{
//    var publisher: Publisher!
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet private weak var webView: UIWebView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var navItem: UINavigationItem!
    
    private var hasFinishLoading = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        title = publisher.title
        webView.delegate = self
        webView.stopLoading()
        
        // 
        navigationBar.tintColor = UIColor(red:0.973,  green:0.584,  blue:0.502, alpha:1)
        // buttons
        var nextPage = UIBarButtonItem(image: UIImage(named: "forward"), style: UIBarButtonItemStyle.Done, target: self, action: "goForward")
        var previousPage = UIBarButtonItem(image: UIImage(named: "backward"), style: UIBarButtonItemStyle.Done, target: self, action: "goBack")
        self.navItem.setLeftBarButtonItems([previousPage, nextPage], animated: false)
        
        var reload = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "reloadPage")
        self.navItem.setRightBarButtonItems([reload], animated: false)
        
        let pageURL = NSURL(string: "https://google.com")!
        let request = NSURLRequest(URL: pageURL)
        webView.loadRequest(request)
//        navigationController?.hidesBarsOnSwipe = true
    }
    
    func reloadPage() {
        // login again
        if let accessToken = UserSetting.UserAccessToken() {
            var reqObj = NSURLRequest(URL: NSURL(string: "https://colorgy.io/sso_new_session?access_token=" + accessToken)!)
            println(reqObj.URL)
            self.webView.loadRequest(reqObj)
            self.webView.reload()
        }
    }
    
    func loginThreeTimes() {
        
    }
    
    
    func webViewDidStartLoad(webView: UIWebView) {
        hasFinishLoading = false
        progressView.progress = 0.05
        updateProgress()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            [weak self] in
            if let _self = self {
                _self.hasFinishLoading = true
            }
        }
    }
    
    deinit {
        webView.stopLoading()
        webView.delegate = nil
    }
    
    func updateProgress() {
        if progressView.progress >= 1 {
            progressView.hidden = true
        } else {
            
            if hasFinishLoading {
                progressView.progress += 0.002
            } else {
                if progressView.progress <= 0.3 {
                    progressView.progress += 0.004
                } else if progressView.progress <= 0.6 {
                    progressView.progress += 0.002
                } else if progressView.progress <= 0.9 {
                    progressView.progress += 0.001
                } else if progressView.progress <= 0.94 {
                    progressView.progress += 0.0001
                } else {
                    progressView.progress = 0.9401
                }
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.008 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
                [weak self] in
                if let _self = self {
                    _self.updateProgress()
                }
            }
        }
    }


}
