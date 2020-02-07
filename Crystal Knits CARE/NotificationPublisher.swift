//
//  NotificationPublisher.swift
//  Crystal Knits CARE
//
//  Created by REGISDMAC01 on 10/15/19.
//  Copyright © 2019 TinhDX. All rights reserved.
//

import UIKit
import UserNotifications
class NotificationPublisher: NSObject {
    //private let AppDe = AppDelegate()
    func sendNotification(title: String,
                          subtitle: String,
                          body:String,
                          badge: Int?,
                          delayInterval: Int?){
        if #available(iOS 10.0, *) {
            let notificationContent = UNMutableNotificationContent()
            notificationContent.title = title
            notificationContent.subtitle  = subtitle
            notificationContent.body = body
            var delayTimeTrigger: UNTimeIntervalNotificationTrigger?
            
            if let delayInterval = delayInterval {
                delayTimeTrigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(delayInterval), repeats:false)
            }
            
            if let badge = badge {
                var currentBadgeCount = UIApplication.shared.applicationIconBadgeNumber
                currentBadgeCount += badge
                notificationContent.badge = NSNumber(integerLiteral: currentBadgeCount)
            }
            notificationContent.sound = UNNotificationSound.default
            UNUserNotificationCenter.current().delegate = self
            let request = UNNotificationRequest(identifier: "TestLocalNotification", content: notificationContent, trigger: delayTimeTrigger)
            
            
            UNUserNotificationCenter.current().add(request) {
                error in
                if let error = error {
                    print(error.localizedDescription)
                }else{ 
                }
            }
        }
    }

}
@available(iOS 10.0, *)
extension NotificationPublisher : UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void){
        //print("The Notification is about to be presented" + UserDefaults.standard.Get_KepV(key: "LoginID_K"))
        completionHandler([.badge,.sound,.alert])
    }

    @available(iOS 10.0, *)
       func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void){
           //print("fdfdsfd")
           let idenfifer = response.actionIdentifier
           switch idenfifer {
           case UNNotificationDismissActionIdentifier:
               //print("The notification was dismissed")
               completionHandler()
           case UNNotificationDefaultActionIdentifier:
               if( Notif_Title != ""){
                print("user opened the app from the notification" + Notif_Title)
                   pushToDetailVC(Zone: Notif_Zone,ID : Notif_ID)
               }
               Notif_Title = ""
               Notif_ID = ""
               Notif_Zone = ""
                   
               completionHandler()
           default:
               //print("the default case was called")
               completionHandler()
           }
           
       }
   
    
    
    func pushToDetailVC(Zone:String,ID : String) {

    }

}
