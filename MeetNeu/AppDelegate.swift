//
//  AppDelegate.swift
//  MeetNeu
//
//  Created by Abraham Soto on 17/05/17.
//  Copyright © 2017 Abraham. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate  {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let tab:UITabBarController = self.window?.rootViewController as! UITabBarController
        tab.delegate = PrincipalViewController()
        
        if UserAppInfo.isUserLoggedIn{
            llamaWebServiceNotif(idUsuario: UserLoggedWithMeetNeu.id, tabBarItem: (tab.viewControllers?[3].tabBarItem)!)
        }
        
        // Override point for customization after application launch.
        // Override point for customization after application launch.
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(String(describing: configureError))")
        
        GIDSignIn.sharedInstance().delegate = self
        SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        return true
    }
    
    
    

    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            /*Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            // ...
            print("si se curo");
            */
            UserAppInfo.isUserLoggedIn = true
            UserAppInfo.email = user.profile.email!
            UserAppInfo.social_media = "3"
            UserAppInfo.avatar = "\(user.profile.imageURL(withDimension: 256))"
            UserAppInfo.social_id_no = user.userID!
            UserAppInfo.gender = "google"
            UserAppInfo.complete_name = user.profile.name!
            UserAppInfo.first_name = user.profile.givenName!
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notif"), object: nil)
        } else {
            print("\(error.localizedDescription)")
        }
    }
    
    
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url as URL!, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[.annotation]) || FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

