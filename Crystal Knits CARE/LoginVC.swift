//
//  ViewController.swift
//  Crystal-App
//
//  Created by REGISDMAC01 on 7/24/19.
//  Copyright © 2019 TinhDX. All rights reserved.
//

import UIKit
import UserNotifications
class RepeatingTimer {

    let timeInterval: TimeInterval
    
    init(timeInterval: TimeInterval) {
        self.timeInterval = timeInterval
    }
    
    private lazy var timer: DispatchSourceTimer = {
        let t = DispatchSource.makeTimerSource()
        t.schedule(deadline: .now() + self.timeInterval, repeating: self.timeInterval)
        t.setEventHandler(handler: { [weak self] in
            self?.eventHandler?()
            
        })
        return t
    }()

    var eventHandler: (() -> Void)?

    private enum State {
        case suspended
        case resumed
    }

    private var state: State = .suspended

    deinit {
        timer.setEventHandler {}
        timer.cancel()
        /*
         If the timer is suspended, calling cancel without resuming
         triggers a crash. This is documented here https://forums.developer.apple.com/thread/15902
         */
        resume()
        eventHandler = nil
    }

    func resume() {
        if state == .resumed {
            return
        }
        state = .resumed
        timer.resume()
    }

    func suspend() {
        if state == .suspended {
            return
        }
        state = .suspended
        timer.suspend()
    }
}
class LoginVC: UIViewController,UNUserNotificationCenterDelegate {
    //private let notificationPublisher = NotificationPublisher()
    @IBOutlet weak var company_logo: UIImageView!
    @IBOutlet weak var bt_login: UIButton!
    @IBOutlet weak var tf_LoginID: UITextField!
    @IBOutlet weak var bt_register: UIButton!
    @IBOutlet weak var btn_GuestLogin: UIButton!
    @IBOutlet weak var txt_Ver_No: UILabel!
    @IBOutlet weak var tf_Password: UITextField!
    @IBAction func btn_GuestLoginClick(_ sender: Any) {
        tf_LoginID.text = "Guest"
        tf_Password.text = "demo@123"
        UserDefaults.standard.Set_KepV(key: "FactoryID_K", value: "REG")
        Login_Action()
    }
    @IBAction func EnterKeyboad_To_LoginID(_ sender: Any) {
        
        //self.tf_Password.becomeFirstResponder()
        self.tf_LoginID.resignFirstResponder()
        self.tf_LoginID.selectedTextRange = self.tf_Password.textRange(from: self.tf_Password.beginningOfDocument, to: self.tf_Password.endOfDocument)
    }
    @IBAction func EnterKeyboad_To_Password(_ sender: Any) {
        showToast(message: "Hide Keyboard")
        Login_Action()
        self.tf_Password.resignFirstResponder()
        self.tf_LoginID.resignFirstResponder()

    }
    @IBAction func btn_Back(_ sender: Any) {
        UserDefaults.standard.Set_KepV(key: "LoginID_K", value: "")
        UserDefaults.standard.Set_KepV(key: "FullName_K", value: "")
        UserDefaults.standard.Set_KepV(key: "FactoryID_K", value: "")
        UserDefaults.standard.Set_KepV(key: "Password_K", value: "")
        let scr = storyboard?.instantiateViewController(withIdentifier: "scr_Wellcome") as! ShowSplashScreen
        present(scr, animated: true, completion: nil)
    }
    @IBAction func bt_Login(_ sender: Any) {
        
        Login_Action()
        self.tf_Password.resignFirstResponder()
        self.tf_LoginID.resignFirstResponder()
    }
    func Login_Action() {
        if Reachability.isConnectedToNetwork(){
        // print("Internet Connection Available!")
        //let MAC_add = UIDevice().identifierForVendor?.uuidString ?? ""
        if (C_Str_all(str: self.tf_LoginID.text ?? "") == ""){
            showToast(message: self.tf_LoginID.placeholder! + NSLocalizedString("sms_empty", comment: " Invalid input data !"))
            //self.tf_LoginID.becomeFirstResponder()
            self.tf_LoginID.setBottomBorder_red()
        }else{
            var string_Pass:String = ""
            if (self.tf_Password.text!.count > 30 ){
                string_Pass = self.tf_Password.text!
            }else{
                string_Pass =  md5(self.tf_Password.text!)
            }
            let DeviceID = UIDevice.current.identifierForVendor!.uuidString
            Get_User_Info(v_url: "Get_User_Info.php?Code_G=" + md5(NSLocalizedString("f1_FactoryID", comment: "REG")) +  self.tf_LoginID.text! +  md5(self.tf_LoginID.text!) + md5(String(randomInt())) + "_" + string_Pass + "_" + DeviceName  + "_" + FactoryID + "_" + MAC_add + "_" + DeviceID ){(res) in
                switch res{
                case .success(let courses):
                    if (courses.count > 0 ){
                    courses.forEach({ (courses) in
                        DispatchQueue.main.async {
                            if(courses.Status == "Login_OK"){
                                UserDefaults.standard.Set_KepV(key: "LoginID_K", value: courses.LoginID)
                                UserDefaults.standard.Set_KepV(key: "FullName_K", value: courses.FullName)
                                UserDefaults.standard.Set_KepV(key: "FactoryID_K", value: courses.FactoryID)
                                UserDefaults.standard.Set_KepV(key: "Password_K", value: courses.Password)
                                FullName = courses.FullName
                                LoginID = courses.LoginID
                                FactoryID = courses.FactoryID
                                Public_User = courses.Public_User
                                PhoneNumber = courses.Phone_Num
                                //self.Load_UnRead()
                                if #available(iOS 10.0, *) {
                                   //self.InterSchedule()
                                    //self.NotifJob();
                                } else {
                                    // Fallback on earlier versions
                                }
                                let scr = self.storyboard?.instantiateViewController(withIdentifier: "scr_SWRevealViewController") as! SWRevealViewController
                                self.present(scr, animated: true, completion: nil)
                            }else{
                                UserDefaults.standard.Set_KepV(key: "LoginID_K", value: "")
                                UserDefaults.standard.Set_KepV(key: "FullName_K", value: "")
                                UserDefaults.standard.Set_KepV(key: "Password_K", value: "")
                                self.showToast(message: NSLocalizedString("Worng_Password", comment: "Worng Password"))
                                //self.tf_Password.becomeFirstResponder()
                                //self.tf_Password.selectedTextRange = self.tf_Password.textRange(from: self.tf_Password.beginningOfDocument, to: self.tf_Password.endOfDocument)
                            }
                        }
                    })
                    }else if (courses.count == 0 ){
                        UserDefaults.standard.Set_KepV(key: "LoginID_K", value: "")
                        UserDefaults.standard.Set_KepV(key: "FullName_K", value: "")
                        UserDefaults.standard.Set_KepV(key: "FactoryID_K", value: "")
                        UserDefaults.standard.Set_KepV(key: "Password_K", value: "")
                        DispatchQueue.main.async {
                            self.showToast(message: NSLocalizedString("ID_not_Exits", comment: "ID_not_Exits"))
                            //self.tf_LoginID.becomeFirstResponder()
                            self.tf_LoginID.setBottomBorder_red()
                            //self.tf_LoginID.selectedTextRange = self.tf_LoginID.textRange(from: self.tf_LoginID.beginningOfDocument, to: self.tf_LoginID.endOfDocument)
                        }
                    }else{
                        print(courses.count)
                    }
                case .failure(let err):
                    //self.alertWindow(title: "Alert !",message: "Failed to get Json" + err)
                    print("Failed to get Json",err)
                }
            }
        }
        }else{
            self.alertWindow(title: "CARE Alert !",message: NSLocalizedString("Network_Error", comment: "Network_Error"))
        }
        
    }
    @IBAction func bt_Register(_ sender: Any) {
        //var Login_Satatu = ""
        //Login_Satatu = "NG"
        
        if Reachability.isConnectedToNetwork(){
            // print("Internet Connection Available!")
            
            //let MAC_add = UIDevice().identifierForVendor?.uuidString ?? ""
            if (C_Str_all(str: self.tf_LoginID.text ?? "") == ""){
                showToast(message: self.tf_LoginID.placeholder! + NSLocalizedString("sms_empty", comment: " Invalid input data !"))
                //self.tf_LoginID.becomeFirstResponder()
                self.tf_LoginID.setBottomBorder_red()
                
            }else{
                Get_User_Info(v_url: "Get_User_Info.php?Code_G=" + md5(NSLocalizedString("f1_FactoryID", comment: "REG")) +  self.tf_LoginID.text! +  md5(self.tf_LoginID.text!) + md5(String(randomInt())) + "_" + md5(self.tf_Password.text!) + "_" + DeviceName  + "_" + FactoryID + "_" + MAC_add ){(res) in
                    switch res{
                    case .success(let courses):
                        if (courses.count > 0 ){
                            //Login_Satatu = "OK"
                            courses.forEach({ (courses) in
                                LoginID = courses.LoginID
                                FullName = courses.FullName
                                PhoneNumber = courses.Phone_Num
                                Public_User = courses.Public_User
                                LoginStatu = courses.Status
                                DispatchQueue.main.async {
                                    if(courses.LoginID == self.tf_LoginID.text!){
                                        let scr = self.storyboard?.instantiateViewController(withIdentifier: "scr_Active_User") as! ActiveUser
                                        self.present(scr, animated: true, completion: nil)
                                    }else{
                                        self.showToast(message: NSLocalizedString("ID_not_Exits", comment: "ID_not_Exits"))
                                        //self.tf_LoginID.becomeFirstResponder()
                                        self.tf_LoginID.setBottomBorder_red()
                                        //self.tf_LoginID.selectedTextRange = self.tf_LoginID.textRange(from: self.tf_LoginID.beginningOfDocument, to: self.tf_LoginID.endOfDocument)
                                    }
                                }
                            })
                        }else if (courses.count == 0 ){
                            DispatchQueue.main.async {
                                self.showToast(message: NSLocalizedString("ID_not_Exits", comment: "ID_not_Exits"))
                                //self.tf_LoginID.becomeFirstResponder()
                                self.tf_LoginID.setBottomBorder_red()
                                //self.tf_LoginID.selectedTextRange = self.tf_LoginID.textRange(from: self.tf_LoginID.beginningOfDocument, to: self.tf_LoginID.endOfDocument)
                            }
                        }else{
                            print(courses.count)
                        }
                    case .failure(let err):
                        print("Failed to get Json",err)
                        //self.alertWindow(title: "Alert !",message: "Failed to get Json" + err)
                        self.alertWindow(title: "CARE Alert !",message: "Failed to get Json !")
                    }
                }
            }
        }else{
            self.alertWindow(title: "CARE Alert !",message: NSLocalizedString("Network_Error", comment: "Network_Error"))
        }
        self.tf_Password.resignFirstResponder()
        self.tf_LoginID.resignFirstResponder()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        if (UserDefaults.standard.Get_KepV(key: "LoginID_K") != "" && UserDefaults.standard.Get_KepV(key: "FactoryID_K") != "" && UserDefaults.standard.Get_KepV(key: "Password_K") != "") {
                self.tf_LoginID.text = UserDefaults.standard.Get_KepV(key: "LoginID_K")
                self.tf_Password.text = UserDefaults.standard.Get_KepV(key: "Password_K")
                Login_Action()
        }else {
            
            DispatchQueue.global(qos: .userInteractive).async {

                DispatchQueue.main.async {
                    self.txt_Ver_No.text = Ver_Name
                    self.company_logo.image = UIImage(named: Logo)
                    self.tf_LoginID.set_BG_left_img(str_img: "Login_icon.png")
                    self.tf_Password.set_BG_left_img(str_img: "Key_icon.png")
                    self.bt_login.set_Buttom_border()
                    self.bt_register.set_Buttom_border()
                    self.btn_GuestLogin.set_Buttom_border()
                    if (UserDefaults.standard.Get_KepV(key: "LoginID_K") != "")
                    {
                        
                        //self.tf_Password.becomeFirstResponder()
                        self.tf_LoginID.text = UserDefaults.standard.Get_KepV(key: "LoginID_K")
                    }else{
                         //self.tf_LoginID.becomeFirstResponder()
                    }
                }
            }

            

        }

    }

    fileprivate func Get_User_Info(v_url:String,completion: @escaping (Result<[Course],Error>)->()){
        let jsonurlstring =  NSLocalizedString("Sys_Domain", comment: "") + v_url
        let url = URL(string: jsonurlstring)
        //print(url as Any)
        if( url != nil){
        URLSession.shared.dataTask(with: url!) {(data,resp,err) in
            if let err = err{
                completion(.failure(err))
                return
            }
            do {
                let courses = try JSONDecoder().decode([Course].self, from: data!)
                completion(.success(courses))
            }catch let jsonError {
                completion(.failure(jsonError))
            }
        }.resume()
        }
    }
    struct  Course: Decodable{
        let LoginID:String
        let FactoryID:String
        let FullName:String
        let Phone_Num:String
        let Email:String
        let Status:String
        let Password:String
        let Text_Size:Int
        let Ver_No:Int
        let Public_User:String
    }
    @available(iOS 10.0, *)
    func InterSchedule() {
        let taskManager = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.getData), userInfo: nil, repeats: true)
        RunLoop.main.add(taskManager, forMode: RunLoop.Mode.common)
       // _ = Timer.scheduledTimer(timeInterval: 8.0, target: self, selector: #selector(self.getData), userInfo: ["score": 10], repeats: true)
    }
    @available(iOS 10.0, *)
    @objc func NotifJob(){
        DispatchQueue.background(delay: 1.0, background: {
             // do something in background
             print("Load data of notif")
            self.getData()
            
        }, completion: {
            if(Notif_Title != ""){
                print("send notif")
                self.sendNotification(title: "CARE", subtitle: Notif_Title, body: Notif_Zone, badge: 1)
            }
             // when background job finishes, wait 3 seconds and do something in main thread
        })
    }
    @available(iOS 10.0, *)
    @objc func getData(){
        Get_Notif{(res) in
            switch res{
            case .success(let courses):
                courses.forEach({ (courses) in
                    //self.InterSchedule()
                    DispatchQueue.main.async {
                        
                       print("ID=" + String(courses.ID) + "Title=" + courses.Title + "feature=" + String(courses.feature))
                        if(String(courses.ID) != ""){
                            Notif_Data = "Y"
                            Notif_ID = String(courses.ID)
                            Notif_Title = courses.Title
                            Notif_Zone = String(courses.feature)
                            self.sendNotification(title: "CARE", subtitle: Notif_Title, body: Notif_Zone, badge: 1)
                        }else{
                            Notif_Data = "N"
                            Notif_ID = ""
                            Notif_Title = ""
                            Notif_Zone = ""
                        }
                        
                        
                        
                    }
                })
            case .failure(let err):
                //case .failure(let err):
                print("Failed to get Json: Error :",err)
            }
        }
    }
    struct  Course_Noti: Decodable{
        let ID:Int
        let Title:String
        let feature:Int

    }
     func Get_Notif(completion: @escaping (Result<[Course_Noti],Error>)->()){
        if Reachability.isConnectedToNetwork(){
           // if let FUn_All = window?.rootViewController as? ShowSplashScreen {
        let jsonurlstring =  NSLocalizedString("Sys_Domain", comment: "") + "feature_Get_Notification.php?Code_G=" + md5(NSLocalizedString("f1_FactoryID", comment: "REG")) +  UserDefaults.standard.Get_KepV(key: "LoginID_K") +  md5(UserDefaults.standard.Get_KepV(key: "LoginID_K")) + md5(String(randomInt())) + "_" + UserDefaults.standard.Get_KepV(key: "LoginID_K") + "_" + UserDefaults.standard.Get_KepV(key: "FactoryID_K")
               // print(jsonurlstring)
        guard let url = URL(string: jsonurlstring) else {return}
        URLSession.shared.dataTask(with: url) {(data,resp,err) in
            if let err = err{
                completion(.failure(err))
                return
            }
            do {
                let courses = try JSONDecoder().decode([Course_Noti].self, from: data!)
                completion(.success(courses))
            }catch let jsonError {
                completion(.failure(jsonError))
            }
            
            }.resume()
            }
    }
    @available(iOS 10.0, *)
    func sendNotification(title: String,
                              subtitle: String,
                              body:String,
                              badge: Int?){

                let notificationContent = UNMutableNotificationContent()
                notificationContent.title = title
                notificationContent.subtitle  = subtitle
                notificationContent.body = body
        notificationContent.userInfo = ["ID": "5","Zone":"2" ]
                

                notificationContent.sound = UNNotificationSound.default
               UNUserNotificationCenter.current().delegate = self
        var dateComponents = DateComponents()
        // dateComponents.hour = 20
         //dateComponents.minute = 36
         dateComponents.second = 30
        //print("Schedule Noti \(Date())")
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60.0, repeats: false)
                let request = UNNotificationRequest(identifier: "TestLocalNotification", content: notificationContent, trigger: trigger)
                
                UNUserNotificationCenter.current().add(request) {
                    error in
                    if let error = error {
                        print(error.localizedDescription)
                    }else{
                        
                        print("send notifi 1111 OK")
                        usleep(3000000)
                        self.sendNotification_2(title: "CARE", subtitle: "1111", body: "111", badge: 1)
                    }
                }

        }
     @available(iOS 10.0, *)
    func sendNotification_2(title: String,
                          subtitle: String,
                          body:String,
                          badge: Int?){

            let notificationContent = UNMutableNotificationContent()
            notificationContent.title = title
            notificationContent.subtitle  = subtitle
            notificationContent.body = body
    notificationContent.userInfo = ["ID": "5","Zone":"2" ]
            
           
            notificationContent.sound = UNNotificationSound.default
           UNUserNotificationCenter.current().delegate = self
    var dateComponents = DateComponents()
    // dateComponents.hour = 20
     //dateComponents.minute = 36
     dateComponents.second = 30
    //print("Schedule Noti \(Date())")
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
   // let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60.0, repeats: false)
            let request = UNNotificationRequest(identifier: "TestLocalNotification", content: notificationContent, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) {
                error in
                if let error = error {
                    print(error.localizedDescription)
                }else{
                    print("send notifi 2222 OK")
                    usleep(3000000)
                    self.sendNotification(title: "CARE", subtitle: "222", body: "222", badge: 1)
                }
            }

    }
        @available(iOS 10.0, *)
            func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void){
                print("The Notification is about to be presented  " + UserDefaults.standard.Get_KepV(key: "LoginID_K"))
                DispatchQueue.background(delay: 0, background: {
                    //self.getData()
                    
                }, completion: {
                    if(Notif_Title != ""){
                        completionHandler([.badge,.sound,.alert])
                        Notif_Title = ""
                        Notif_ID = ""
                        Notif_Zone = ""
                    }else{
                        print("NONE")
                        //completionHandler
                    }
                     
                })
                
            }


        func pushToDetailVC(Zone:String,ID : String) {
            //print("DFDFDF" + Notif_Title)
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "scr_NewsDetailVC") as! NewDetailVC
                  // vc.Zone_String = Zone
                   // vc.ID_String = ID
            self.present(vc, animated: false, completion: nil)
            
                 // self.navigationController?.pushViewController(vc, animated: true)
            
           // let vc = NewDetailVC(nibName: "scr_NewsDetailVC", bundle: nil)
            //navigationController?.pushViewController(vc, animated: true )
            
            //let vc = self.storyboard?.instantiateViewController(withIdentifier: "scr_NewsDetailVC") as! NewDetailVC
            //vc.Zone_String = ZoneArray[indexPath.row]
             //vc.ID_String = IDArray[indexPath.row]
           //self.present(vc, animated: true, completion: nil)
            //self.presentingViewController(vc, animated: true, completion: nil)
            
            //let scr = self.storyboard?.instantiateViewController(withIdentifier: "scr_NewsDetailVC") as! NewDetailVC
            //self.present(scr, animated: true, completion: nil)
            
            
           //let scr = self.storyboard?.instantiateViewController(withIdentifier: "scr_NewsDetailVC") as! NewDetailVC
           
            // self.present(scr, animated: false, completion: nil)
            //self.navigationController?.pushViewController(scr, animated: true)

           // let scr = self.storyboard?.instantiateViewController(withIdentifier: "scr_NewsDetailVC") as! NewDetailVC
           // self.present(scr, animated: true, completion: nil)
            //self.navigationController?.pushViewController(scr, animated: true)
                
        }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
