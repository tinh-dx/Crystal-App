//
//  AppDelegate.swift
//  Crystal-App
//
//  Created by REGISDMAC01 on 7/24/19.
//  Copyright © 2019 TinhDX. All rights reserved.
//

import UIKit
import UserNotifications
import BackgroundTasks
import CommonCrypto
import Foundation
import Network
//import SwiftyJSON
//import Firebase
//import FirebaseMessaging
@available(iOS 10.0, *)
@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {
    //private let notificationPublisher = NotificationPublisher()
    var backgroundUpdateTask: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier(rawValue: 0)
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //FirebaseApp.configure()
        //UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplication.backgroundFetchIntervalMinimum)
        registerNotification()
        registerForPushNotifications()
        //getNotificationSettings()
        return true
    }
    func getNotificationSettings() {
      UNUserNotificationCenter.current().getNotificationSettings { settings in
        print("Notification settings: \(settings)")
      }
    }
    func registerForPushNotifications() {
      UNUserNotificationCenter.current() // 1
        .requestAuthorization(options: [.alert, .sound, .badge]) { // 2
          granted, error in
          print("Permission granted: \(granted)") // 3
      }
        
        //UN
    }
    func registerNotification() {
       // let notifSettings = UIUserNotificationSettings.init(
          //  types: [.sound,.alert, .badge],categories: nil
        //)
       // UIApplication.shared.registerUserNotificationSettings(notifSettings)
        UIApplication.shared.registerForRemoteNotifications()
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
      let token = tokenParts.joined()
      print("Device Token: \(token)")
    }
    func application(
      _ application: UIApplication,
      didFailToRegisterForRemoteNotificationsWithError error: Error) {
      print("Failed to register: \(error)")
    }
    private func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler competionHandler:  @escaping (UIBackgroundFetchResult) -> Void) {
        print(userInfo)
    }
    @objc @available(iOS 10.0, *)
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    func applicationWillResignActive(_ application: UIApplication) {
        self.endBackgroundUpdateTask()
        print("App is background")
    }
    func endBackgroundUpdateTask() {
        UIApplication.shared.endBackgroundTask(self.backgroundUpdateTask)
        self.backgroundUpdateTask = UIBackgroundTaskIdentifier.invalid
    }
    func applicationWillEnterForeground(_ application: UIApplication) {
        self.endBackgroundUpdateTask()
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    }
    @available(iOS 10.0, *)
       func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void){
           let idenfifer = response.actionIdentifier
           switch idenfifer {
           case UNNotificationDismissActionIdentifier:
               print("The notification was dismissed")
               completionHandler()
           case UNNotificationDefaultActionIdentifier:
            
               //if( Notif_Title != ""){
               
                    print("DFDFDF----")

                   
               completionHandler()
           default:
               print("the default case was called")
               completionHandler()
           }
           
       }
}

