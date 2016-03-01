//
//  AppDelegate.swift
//  ColorgyCourse
//
//  Created by David on 2015/8/30.
//  Copyright (c) 2015年 David. All rights reserved.
//

import UIKit
import CoreData

import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
	
	let kStatusBarTappedNotification = "statusBarTappedNotification"

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.

        // reset all jobs
        ColorgyAPITrafficControlCenter.unQueueAllJobs()
        
        // get ready to launch
        AppLaunchHelper.startJob()
        
        // every time open the app, download new data
        CourseUpdateHelper.needUpdateCourse()

        // crashlytics, answers
        Fabric.with([Crashlytics.self(), Answers.self()])
		let id = UserSetting.UserId() ?? -1
		let school = UserSetting.UserPossibleOrganization() ?? "no school"
		let name = UserSetting.UserName() ?? "no name"
		let params: [String : AnyObject] = ["user_id": id, "user_name": name, "school": school]
		Answers.logCustomEventWithName(AnswersLogEvents.userDidFinishedLaunchWithOption, customAttributes: params)
		
        // Flurry setup
		setupFlurry()
		
		// Mixpanel
		setupMixpanel()
        
        // register for notification
        UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [UIUserNotificationType.Alert, UIUserNotificationType.Badge, UIUserNotificationType.Sound], categories: nil))
        UIApplication.sharedApplication().registerForRemoteNotifications()
        
        // segemented control font face
		setupAppearance()
        
        // show view
		setupView()
		
		// for dev
		developmentMethods()

		NSNotificationCenter.defaultCenter().addObserver(self, selector: "objectContextObjectsDidChange:", name: NSManagedObjectContextObjectsDidChangeNotification, object: nil)
		
        return true
    }
	
	func objectContextObjectsDidChange(notification: NSNotification) {
		let sender = notification.object as! NSManagedObjectContext

		if sender == self.managedObjectContext {
			// on main thread
			sender.performBlock { () -> Void in
				self.managedObjectContext.mergeChangesFromContextDidSaveNotification(notification)
			}
		} else if sender == self.backgroundContext {
			// on background thread
			sender.performBlock { () -> Void in
				self.backgroundContext.mergeChangesFromContextDidSaveNotification(notification)
			}
		} else {
			// other thread
			backgroundContext.performBlock { () -> Void in
				self.backgroundContext.mergeChangesFromContextDidSaveNotification(notification)
			}
			managedObjectContext.performBlock { () -> Void in
				self.managedObjectContext.mergeChangesFromContextDidSaveNotification(notification)
			}
		}
	}
	
	func setupMixpanel() {
		if Release().mode {
			let mixpanel = Mixpanel.sharedInstanceWithToken("988f2b266e2bfe423085a0959ca936f3")
			mixpanel.track(MixpanelEvents.OpenApp)
		}
	}
	
	func setupFlurry() {
		if Release().mode {
			// setup Flurry
			Flurry.startSession(SecretKey.FlurryProductionKey) // replace flurryKey with your own key
			let id = UserSetting.UserId() ?? -1
			let school = UserSetting.UserPossibleOrganization() ?? "no school"
			let name = UserSetting.UserName() ?? "no name"
			let params = ["user_id": id, "user_name": name, "school": school]
			Flurry.logEvent("v3.0 User didFinishLaunchingWithOptions", withParameters: params as! [NSObject : AnyObject])
		} else {
			Flurry.startSession(SecretKey.FlurryDevelopmentKey) // for dev
			let id = UserSetting.UserId() ?? -1
			let school = UserSetting.UserPossibleOrganization() ?? "no school"
			let name = UserSetting.UserName() ?? "no name"
			let params = ["user_id": id, "user_name": name, "school": school]
			Flurry.logEvent("v3.0 User didFinishLaunchingWithOptions", withParameters: params as! [NSObject : AnyObject])
		}
	}
	
	func setupAppearance() {
		let attr: [NSObject : AnyObject] = NSDictionary(object: UIFont(name: "STHeitiTC-Light", size: 15)!, forKey: NSFontAttributeName) as! [NSObject : AnyObject]
		UISegmentedControl.appearance().setTitleTextAttributes(attr, forState: UIControlState.Normal)
		UITabBar.appearance().tintColor = ColorgyColor.MainOrange
	}
	
	func setupView() {
		self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
		self.window?.backgroundColor = UIColor.whiteColor()
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
//		
//		        let vc = storyboard.instantiateViewControllerWithIdentifier("A1") as! UINavigationController
//		        self.window?.rootViewController = vc
//		        self.window?.makeKeyAndVisible()
		
		if HintViewSettings.isAppFirstLaunchNavigationViewShown() {
			// guide shown
			if !UserSetting.isLogin() {
				// dump data
				CourseDB.deleteAllCourses()
				// need login
				let vc = storyboard.instantiateViewControllerWithIdentifier("Main Login View") as! FBLoginViewController
				self.window?.rootViewController = vc
				self.window?.makeKeyAndVisible()
			} else {
				let vc = storyboard.instantiateViewControllerWithIdentifier("TabBarViewController") as! UITabBarController
				self.window?.rootViewController = vc
				self.window?.makeKeyAndVisible()
			}
		} else {
			let vc = storyboard.instantiateViewControllerWithIdentifier("launch navigation") as! LaunchNavigationViewController
			self.window?.rootViewController = vc
			self.window?.makeKeyAndVisible()
		}
	}
	
	func developmentMethods() {
		if !Release().mode {
			// for dev
//			DevelopmentTestingMethods.test(loginCounts: 99)
		}
	}
	
    @available(iOS 9.0, *)
    func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
        print("i am now inside performing")
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print(error)
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
		print(deviceToken)
        UserSetting.storePushNotificationDeviceToken(deviceToken)
        // update token
        ColorgyAPI.PUTdeviceToken(success: { () -> Void in
            print("niti OK")
        }) { () -> Void in
            print("noti fail")
        }
    }
	
	// MARK: - notification
	func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
		print("did recieve notification")
		print("user info")
		print(userInfo)
		if application.applicationState == UIApplicationState.Active {
			
		}
	}
	
	// MARK: - status bar touched
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		super.touchesBegan(touches, withEvent: event)
		if window != nil {
			if let location: CGPoint = event?.allTouches()?.first?.locationInView(window!) {
				let statusBarFrame = UIApplication.sharedApplication().statusBarFrame
				if CGRectContainsPoint(statusBarFrame, location) {
					statusBarTouchedAction()
				}
			}
		}
		
	}
	
	func statusBarTouchedAction() {
		NSNotificationCenter.defaultCenter().postNotificationName(kStatusBarTappedNotification, object: nil)
	}

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        // Flurry
        if Release().mode {
            Flurry.logEvent("v3.0: User Close Application, application enter background")
        }
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        // Flurry
        if Release().mode {
            Flurry.logEvent("v3.0: User Start Application, applicationDidBecomeActive")
        } else {
            Flurry.logEvent("User applicationWillEnterForeground, for testing")
        }
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "misk.ColorgyCourse" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("ColorgyCourse", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("ColorgyCourse.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        // migration options
        var options = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
        do {
            try coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: options)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
//            coordinator = nil
//            // Report any error we got.
//            var dict = [String: AnyObject]()
//            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
//            dict[NSLocalizedFailureReasonErrorKey] = failureReason
//            dict[NSUnderlyingErrorKey] = error
//            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
//            // Replace this with code to handle the error appropriately.
//            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            NSLog("Unresolved error \(error), \(error!.userInfo)")
//            abort()
        }
//        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: options) == nil {
//            coordinator = nil
//            // Report any error we got.
//            var dict = [String: AnyObject]()
//            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
//            dict[NSLocalizedFailureReasonErrorKey] = failureReason
//            dict[NSUnderlyingErrorKey] = error
//            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
//            // Replace this with code to handle the error appropriately.
//            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            NSLog("Unresolved error \(error), \(error!.userInfo)")
//            abort()
//        }
        
        return coordinator
    }()

	// original settings
//    lazy var managedObjectContext: NSManagedObjectContext = {
//        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
//        let coordinator = self.persistentStoreCoordinator
//        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
//        managedObjectContext.persistentStoreCoordinator = coordinator
//        return managedObjectContext
//        }()
	
	lazy var managedObjectContext: NSManagedObjectContext = {
		// Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
		let coordinator = self.persistentStoreCoordinator
//		if coordinator == nil {
//			return nil
//		}
//		NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.ConfinementConcurrencyType)
		var managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
		managedObjectContext.persistentStoreCoordinator = coordinator
		managedObjectContext.mergePolicy = NSRollbackMergePolicy
		return managedObjectContext
	}()
	
	
	
	lazy var backgroundContext: NSManagedObjectContext = {
		let coordinator = self.persistentStoreCoordinator
//		if coordinator == nil {
//			return nil
//		}
		var managedObjectContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
		managedObjectContext.persistentStoreCoordinator = coordinator
		managedObjectContext.mergePolicy = NSOverwriteMergePolicy
		managedObjectContext.undoManager = nil
		return managedObjectContext
	}()

    // MARK: - Core Data Saving support

    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }

}

