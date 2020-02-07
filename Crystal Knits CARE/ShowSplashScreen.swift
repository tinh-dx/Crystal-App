//
//  ShowSplashScreen.swift
//  Crystal-App
//
//  Created by REGISDMAC01 on 7/30/19.
//  Copyright © 2019 TinhDX. All rights reserved.
//
import UIKit
var FactoryID:String = ""
var Logo:String = ""
var LG:String = (Locale.current.languageCode ?? "EN").uppercased()
var DeviceName:String = ""
var LoginID:String = ""
var PhoneNumber:String = ""
var LoginStatu:String = ""
var FullName:String = ""
var MAC_add:String = ""
var Act_Code:String = ""
var Ver_Name:String = ""
var Public_User:String = ""
var Change_Internal:String = ""
var Notif_ID:String = ""
var Notif_Title:String = ""
var Notif_Zone:String = ""
var Notif_Data:String = "N"
class ShowSplashScreen: UIViewController {
    //private let notificationPublisher = NotificationPublisher()
    @IBOutlet weak var lb_welcome: UILabel!
    @IBOutlet weak var lb_version: UILabel!
    @IBOutlet weak var btf_CSVL: UIButton!
    @IBOutlet weak var btf_STF: UIButton!
    @IBOutlet weak var tf_REG: UIButton!
    @IBOutlet weak var lb_selectCompany: UILabel!
    var REG:String=""
    var CSVL:String=""
    var STF:String=""
    var IOS_Ver_NO:Int!
    var Bul_Ver_NO:Int = Int(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "0") ?? 0
    //var Bul_Ver_NO:Int = Int(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0") ?? 0
    //var Bul_Ver_NO:Int = 8
    var IOS_Link:String=""
    @IBAction func bt_REG(_ sender: Any) {
        Fac_Click(FacID: "REG")
    }
    @IBAction func bt_CSVL(_ sender: Any) {
        Fac_Click(FacID: "CSVL")
    }
    @IBAction func bt_STF(_ sender: Any) {
        Fac_Click(FacID: "STF")
    }
    func Fac_Click(FacID:String) {
        switch FacID {
        case "REG":
            if ( REG=="Y") {
                MoveSCR(scr_v: "scr_Login", Var_1: "REG", Var_2: NSLocalizedString("reg_logo", comment: "reg_en_logo.png"))
                
            }else{
                showToast(message: NSLocalizedString("ms_NotFinish", comment: "Not Finished"))
                Start_theApp()
            }
        case "CSVL":
            if (CSVL=="Y") {
                MoveSCR(scr_v: "scr_Login", Var_1: "CSVL", Var_2: NSLocalizedString("csvl_logo", comment: "csvl_en_logo.png"))
                
            }else{
                showToast(message: NSLocalizedString("ms_NotFinish", comment: "Not Finished"))
                Start_theApp()
            }
        case "STF":
            if (STF=="Y") {
                MoveSCR(scr_v: "scr_Login", Var_1: "STF", Var_2: NSLocalizedString("stf_logo", comment: "stf_en_logo.png"))
            }else{
                showToast(message: NSLocalizedString("ms_NotFinish", comment: "Not Finished"))
                Start_theApp()
            }
        default:
            if ( REG=="Y") {
                MoveSCR(scr_v: "scr_Login", Var_1: "REG", Var_2: NSLocalizedString("reg_logo", comment: "reg_en_logo.png"))
                
            }else{
                showToast(message: NSLocalizedString("ms_NotFinish", comment: "Not Finished"))
                Start_theApp()
            }
        }
    }
    fileprivate func MoveSCR(scr_v : String, Var_1 : String, Var_2: String) {
        if Reachability.isConnectedToNetwork(){
            if(Bul_Ver_NO < IOS_Ver_NO){
                let alert = UIAlertController(title: "CARE Alert !", message: NSLocalizedString("Sys_Update", comment: "Sys_Update") + "( Ver: " + String(IOS_Ver_NO) + " )", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    switch action.style{
                    case .default:
                      self.openAppStore()
                    case .cancel:
                        return
                    case .destructive:
                         return
                    @unknown default:
                       self.openAppStore()
                    }
                    
                }))
                self.present(alert, animated: true, completion: nil)
                
            }else{
                //print("You version is up to date !")
                FactoryID=Var_1;
                Logo=Var_2;
                let scr = storyboard?.instantiateViewController(withIdentifier: scr_v) as! LoginVC
                present(scr, animated: true, completion: nil)
            }
        }else{
            self.alertWindow(title: "Alert !",message: NSLocalizedString("Network_Error", comment: "Network_Error"))
        }

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        Start_theApp()
    }
    func Start_theApp(){
        DispatchQueue.global(qos: .userInteractive).async {
            if (LG != "EN"){
                LG = "LC"
            }else{
                LG = "EN"
            }
            DeviceName = self.C_Str_all(str: UIDevice.current.name).RFC3986UnreservedEncoded
            MAC_add = self.getWiFiAddress()!
            self.Do_GetINfor()
                DispatchQueue.main.async {
                    self.Load_Form()
                }
        }
    }
    func Load_Form()  {
        self.lb_welcome.text = NSLocalizedString("f1_welcome", comment: "welcome!")
        self.lb_selectCompany.text = NSLocalizedString("f1_SelectCompany", comment: "Select your company")
        self.tf_REG.setTitle(NSLocalizedString("f1_REG", comment: "REG"), for: .normal)
        self.btf_CSVL.setTitle(NSLocalizedString("f1_CSVL", comment: "CSVL"), for: .normal)
        self.btf_STF.setTitle(NSLocalizedString("f1_STF", comment: "STF"), for: .normal)
        self.tf_REG.set_Buttom_border()
        self.btf_CSVL.set_Buttom_border()
        self.btf_STF.set_Buttom_border()
    }
    func Do_GetINfor(){
        Get_Sys_Info{(res) in
            switch res{
            case .success(let courses):
                courses.forEach({ (courses) in
                    if (courses.SMS_F=="Y"){
                        let alert = UIAlertController(title: "Alert", message: courses.SMS, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }else{}
                    DispatchQueue.main.async {
                        self.REG=courses.REG
                        self.CSVL=courses.CSVL
                        self.STF=courses.STF
                        self.IOS_Ver_NO=courses.IOS_Ver_No
                        Ver_Name = courses.IOS_Ver_Name
                        self.IOS_Link=courses.IOS_Link
                         self.lb_version.text = courses.IOS_Ver_Name
                        if (UserDefaults.standard.Get_KepV(key: "LoginID_K") != "" && UserDefaults.standard.Get_KepV(key: "FactoryID_K") != ""  && UserDefaults.standard.Get_KepV(key: "Password_K") != "") {
                            self.Fac_Click(FacID: UserDefaults.standard.Get_KepV(key: "FactoryID_K"))
                        }else{
                            if(Change_Internal != "Y"){
                            UserDefaults.standard.Set_KepV(key: "FactoryID_K", value: "REG")
                            UserDefaults.standard.Set_KepV(key: "LoginID_K", value: "Guest")
                            UserDefaults.standard.Set_KepV(key: "Password_K", value: "f702c1502be8e55f4208d69419f50d0a")
                            self.Fac_Click(FacID: UserDefaults.standard.Get_KepV(key: "FactoryID_K"))
                            }
                        }
                    }
                })
            case .failure(let err):
                //case .failure(let err):
                //print("Failed to get Json",err)
                self.alertWindow(title: "CARE Alert !",message: "Failed to get Json ! (" + err.localizedDescription + ")" )
            }
        }
    }
    func openAppStore() {
        if let url = URL(string: IOS_Link),
            UIApplication.shared.canOpenURL(url)
        {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    struct  Course: Decodable{
        let IOS_Ver_No:Int
        let REG:String
        let CSVL:String
        let STF:String
        let SMS_F:String
        let SMS:String
        let IOS_Link:String
        let IOS_Ver_Name:String
    }
    fileprivate func Get_Sys_Info(completion: @escaping (Result<[Course],Error>)->()){
        if Reachability.isConnectedToNetwork(){
        let jsonurlstring =  NSLocalizedString("Sys_Domain", comment: "") + "Get_Sys_Info.php?LG="+LG
        guard let url = URL(string: jsonurlstring) else {return}
        URLSession.shared.dataTask(with: url) {(data,resp,err) in
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
        }else{
            self.alertWindow(title: "CARE Alert !",message: NSLocalizedString("Network_Error", comment: "Network_Error"))
        }
    }
    
}

