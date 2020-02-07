//
//  ChangePhoneVC.swift
//  Crystal Knits CARE
//
//  Created by REGISDMAC01 on 10/9/19.
//  Copyright © 2019 TinhDX. All rights reserved.
//

import UIKit

class ChangePhoneVC: UIViewController {
    @IBOutlet weak var tf_NewPhone: UITextField!
    @IBOutlet weak var tf_OldPhone: UITextField!
    @IBOutlet weak var tf_Password: UITextField!
    @IBOutlet weak var btn_Cancel_Outket: UIButton!
    @IBOutlet weak var btn_OK_Outlet: UIButton!
    @IBOutlet weak var btn_menu: UIBarButtonItem!
    @IBAction func OldPhone_EnterPress(_ sender: Any) {
         self.tf_OldPhone.resignFirstResponder()
    }
    @IBAction func NewPhone_EnterPress(_ sender: Any) {
        self.tf_NewPhone.resignFirstResponder()
    }
    @IBAction func Pass_EnterPress(_ sender: Any) {
        self.tf_Password.resignFirstResponder()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        btn_menu.target = self.revealViewController()
        btn_menu.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
       btn_Cancel_Outket.set_Buttom_border()
       btn_OK_Outlet.set_Buttom_border()
        //self.navigationController?.isNavigationBarHidden = true
       // Do any additional setup after loading the view.
   }
    @IBAction func btn_Cancel_Click(_ sender: Any) {
        let scr = self.storyboard?.instantiateViewController(withIdentifier: "scr_SettingVC") as! SettingVC
        self.navigationController?.pushViewController(scr, animated: true)
    }
    @IBAction func btn_OK_Click(_ sender: Any) {
        let old_Phone:String = self.tf_OldPhone.text!
        let new_Phone = C_Str_all(str: self.tf_NewPhone.text ?? "")
        let Password:String = self.tf_Password.text!
        if (old_Phone != PhoneNumber){
            UI_tf_Forcus_Alert(UI_tf: tf_OldPhone, ms: NSLocalizedString("Phone_Error", comment: "Phone_Error"))
            return
        }
        if (new_Phone.count < 10 || new_Phone.count > 10){
            UI_tf_Forcus_Alert(UI_tf: tf_NewPhone, ms: NSLocalizedString("Phone_Error_New", comment: "Phone_Error_New"))
            return
        }
        if (md5(Password) != UserDefaults.standard.Get_KepV(key: "Password_K")){
            UI_tf_Forcus_Alert(UI_tf: tf_Password, ms: NSLocalizedString("Worng_Password", comment: "Worng_Password"))
            return
        }
        if Reachability.isConnectedToNetwork(){
            Change_Phone(url: "ChangePhone.php?Code_G=" + md5(String(randomInt())) + md5(NSLocalizedString("f1_FactoryID", comment: "REG")) +  new_Phone +  md5(new_Phone) +  md5(new_Phone) + "_" + LoginID + md5(String(randomInt())) + "_" + DeviceName + "_" + FactoryID + "_" + LG  + "_" + MAC_add  + "_" + old_Phone) {(res) in
            switch res{
                case .success(let courses):
                    if (courses.count > 0 ){
                                          //Login_Satatu = "OK"
                        courses.forEach({ (courses) in
                            DispatchQueue.main.async {
                                if(LoginID == courses.LoginID && courses.Phone_Num != "NG"){
                                    PhoneNumber = courses.Phone_Num
                                    let scr = self.storyboard?.instantiateViewController(withIdentifier: "scr_SettingVC") as! SettingVC
                                           let alert = UIAlertController(title: "CARE Alert !", message: NSLocalizedString("Phone_Change_OK", comment: "Phone_Change_OK") , preferredStyle: .alert)
                                           alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                                               switch action.style{
                                               case .default:
                                               self.present(scr, animated: true, completion: nil)
                                               self.navigationController?.pushViewController(scr, animated: true)
                                               case .cancel:
                                                   return
                                               case .destructive:
                                                    return
                                               @unknown default:
                                                self.present(scr, animated: true, completion: nil)
                                                  self.navigationController?.pushViewController(scr, animated: true)
                                                
                                               }
                                           }))
                                           self.present(alert, animated: true, completion: nil)
                                }else{
                                    self.alertWindow(title: "CARE !",message: NSLocalizedString("Error_", comment: "Error_"))
                                }
                            }
                        })
                    }else if (courses.count == 0 ){
                            self.alertWindow(title: "CARE !",message: NSLocalizedString("ID_not_Exits", comment: "ID_not_Exits"))
                    }else{
                            print(courses.count)
                    }
                case .failure(let err):
                    self.alertWindow(title: "Alert !",message: "Failed to get Json" + err.localizedDescription)
                }
            }
        }else{
            self.alertWindow(title: "Alert !",message: NSLocalizedString("Network_Error", comment: "Network Error") )
        }
 
    }

    fileprivate func Change_Phone(url:String,completion: @escaping (Result<[Course_ChangePhone],Error>)->()){
        let jsonurlstring =  NSLocalizedString("Sys_Domain", comment: "") + url
        //print(jsonurlstring)
        guard let v_url = URL(string: jsonurlstring) else {return}
        URLSession.shared.dataTask(with: v_url) {(data,resp,err) in
            if let err = err{
                completion(.failure(err))
                return
            }
            do {
                let courses = try JSONDecoder().decode([Course_ChangePhone].self, from: data!)
                completion(.success(courses))
            }catch let jsonError {
                completion(.failure(jsonError))
            }
            
        }.resume()
    }
    struct  Course_ChangePhone: Decodable{
        let LoginID:String
        let Phone_Num:String
    }
}
