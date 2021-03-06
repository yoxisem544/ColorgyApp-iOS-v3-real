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
    
    private var islogin: Bool = false {
        didSet {
            if islogin {
                let pageURL = NSURL(string: "https://mall.colorgy.io")!
                let request = NSURLRequest(URL: pageURL)
                webView.loadRequest(request)
            } else {
                login()
            }
        }
    }
    
    private var hasFinishLoading = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        title = publisher.title
        webView.delegate = self
        webView.stopLoading()
        webView.sizeToFit()
        webView.scalesPageToFit = true
        
        // 
//        navigationBar.tintColor = UIColor(red:0.973,  green:0.584,  blue:0.502, alpha:1)
        navigationBar.tintColor = ColorgyColor.MainOrange
        // buttons
        let nextPage = UIBarButtonItem(image: UIImage(named: "forward"), style: UIBarButtonItemStyle.Done, target: self, action: #selector(goForward))
        let previousPage = UIBarButtonItem(image: UIImage(named: "backward"), style: UIBarButtonItemStyle.Done, target: self, action: #selector(goBack))
        self.navItem.setLeftBarButtonItems([previousPage, nextPage], animated: false)
        
        let reload = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: #selector(reloadPage))
        self.navItem.setRightBarButtonItems([reload], animated: false)
        
        login()
        
//        let pageURL = NSURL(string: "https://colorgy.io/mobile-index")!
//        let request = NSURLRequest(URL: pageURL)
//        webView.loadRequest(request)
//        navigationController?.hidesBarsOnSwipe = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        Analytics.trackActivityBoard()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        Analytics.stopTrackingActivityBoard()
    }
    
    func reloadPage() {
        // login again
        islogin = false
        if let accessToken = UserSetting.UserAccessToken() {
            print(accessToken)
            let reqObj = NSURLRequest(URL: NSURL(string: "https://colorgy.io/sso_new_session?access_token=" + accessToken)!)
            print(reqObj.URL)
            self.webView.loadRequest(reqObj)
        }
    }
    
    func goForward() {
        if self.webView.canGoForward {
            self.webView.goForward()
        }
    }
    
    func goBack() {
        if self.webView.canGoBack {
            self.webView.goBack()
        }
    }
    
    func login() {
//		let pageURL = NSURL(string: "https://mall.colorgy.io")!
//		let request = NSURLRequest(URL: pageURL)
//		let connection = NSURLConnection(request: request, delegate: self)
//		webView.loadRequest(request)
        if let accessToken = UserSetting.UserAccessToken() {
            let reqObj = NSURLRequest(URL: NSURL(string: "https://colorgy.io/sso_new_session?access_token=" + accessToken)!)
            print(reqObj.URL)
            self.webView.loadRequest(reqObj)
        }
    }
	

    
    
    func webViewDidStartLoad(webView: UIWebView) {
        hasFinishLoading = false
        progressView.progress = 0.05
        progressView.hidden = false
        updateProgress()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        // if not login
        if !islogin {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
                self.islogin = true
            }
        }
        
        
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

//	func connection(connection: NSURLConnection, canAuthenticateAgainstProtectionSpace protectionSpace: NSURLProtectionSpace) -> Bool {
//		return protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust
//	}
//	
//	func connection(connection: NSURLConnection, didReceiveAuthenticationChallenge challenge: NSURLAuthenticationChallenge) {
//		if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
//			if challenge.protectionSpace.host == "192.168.1.2" {
//				print("Allowing bypass...")
//				if let trust = challenge.protectionSpace.serverTrust {
//					let credential = NSURLCredential(trust: trust)
//					challenge.sender?.useCredential(credential, forAuthenticationChallenge: challenge)
//				}
//			} else {
//				print("Not trusting connection to host %@", challenge.protectionSpace.host)
//			}
//		}
//		challenge.sender?.continueWithoutCredentialForAuthenticationChallenge(challenge)
//	}
}

extension ActivityWebViewController : NSURLConnectionDelegate {
	
}
