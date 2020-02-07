//
//  ActiveUser.swift
//  Crystal Knits CARE
//
//  Created by REGISDMAC01 on 9/23/19.
//  Copyright © 2019 TinhDX. All rights reserved.
//

import UIKit

class ActiveUser: UIViewController {

    @IBOutlet weak var tb_phonenumber: UITextField!
    @IBOutlet weak var tb_activecode: UITextField!
    @IBOutlet weak var bt_GetCode: UIButton!
    @IBOutlet weak var bt_Active: UIButton!
    @IBOutlet weak var V_FullName: UILabel!
    @IBOutlet weak var V_PhoneNumber: UILabel!
    @IBOutlet weak var V_Status: UILabel!
    @IBAction func PhoneNumber_EnterPress(_ sender: Any) {
        self.tb_phonenumber.resignFirstResponder()
    }
    @IBAction func Active_Code_EnterPress(_ sender: Any) {
        self.tb_activecode.resignFirstResponder()
    }
    @IBAction func bt_get_code(_ sender: Any) {
        if Reachability.isConnectedToNetwork(){
            if (C_Str_all(str: self.tb_phonenumber.text ?? "") == PhoneNumber){
               Get_Active_Code(url: "Get_Active_Code.php?Code_G=" + md5(NSLocalizedString("f1_FactoryID", comment: "REG")) +  PhoneNumber +  md5(PhoneNumber) + md5(String(randomInt())) + "_" + LoginID + "_" + LG  + "_" + DeviceName + "_" + MAC_add + "_" + FactoryID ){(res) in
                    switch res{
                    case .success(let courses):
                        if (courses.count > 0 ){
                            //Login_Satatu = "OK"
                            courses.forEach({ (courses) in
                                DispatchQueue.main.async {
                                    if(LoginID == courses.LoginID){
                                        DispatchQueue.main.async {
                                            self.alertWindow(title: "CARE !",message: NSLocalizedString("Active_Code_Sent", comment: "Active_Code_Sent") + "-->" + courses.Phone_Num )
                                            self.tb_phonenumber.resignFirstResponder()
                                            //self.tb_activecode.becomeFirstResponder()
                                            //self.tb_activecode.selectedTextRange = self.tb_activecode.textRange(from: self.tb_activecode.beginningOfDocument, to: self.tb_activecode.endOfDocument)
                                        }
                                    }else{
                                        self.showToast(message: NSLocalizedString("ID_not_Exits", comment: "ID_not_Exits"))
                                    }
                                }
                            })
                        }else if (courses.count == 0 ){
                            DispatchQueue.main.async {
                                self.showToast(message: NSLocalizedString("ID_not_Exits", comment: "ID_not_Exits"))
                            }
                        }else{
                            print(courses.count)
                        }
                    case .failure(let err):
                        print("Failed to get Json",err)
                        self.alertWindow(title: "Alert !",message: "Failed to get Json")
                    }
                }
            }else{
                showToast(message: NSLocalizedString("Phone_Error", comment: "Phone_Error !"))
                self.tb_phonenumber.resignFirstResponder()
                //self.tb_phonenumber.becomeFirstResponder()
                self.tb_phonenumber.textColor = UIColor.red
                //self.tb_phonenumber.selectedTextRange = self.tb_phonenumber.textRange(from: self.tb_phonenumber.beginningOfDocument, to: self.tb_phonenumber.endOfDocument)
            }
        }else{
            self.alertWindow(title: "Alert !",message: NSLocalizedString("Network_Error", comment: "Network Error") )
        }
    }
    @IBAction func bt_active(_ sender: Any) {
        if Reachability.isConnectedToNetwork(){
            let the_Code = C_Str_all(str: self.tb_activecode.text ?? "")
            if (the_Code.count == 6){
               Active_User(url: "Active_User.php?Code_G=" + md5(NSLocalizedString("f1_FactoryID", comment: "REG")) +  the_Code +  md5(the_Code) + md5(String(randomInt())) + "_" + LoginID + "_" + LG  + "_" + DeviceName + "_" + MAC_add + "_" + FactoryID ){(res) in
                    switch res{
                    case .success(let courses):
                        if (courses.count > 0 ){
                            //Login_Satatu = "OK"
                            courses.forEach({ (courses) in
                                DispatchQueue.main.async {
                                    if(LoginID == courses.LoginID){
                                        //scr_ChangePassword
                                        DispatchQueue.main.async {
                                            Act_Code = courses.Active_Code
                                            UserDefaults.standard.Set_KepV(key: "LoginID_K", value: courses.LoginID)
                                            UserDefaults.standard.Set_KepV(key: "FactoryID_K", value: courses.FactoryID)
                                            self.alertWindow(title: "CARE !",message: NSLocalizedString("Active_OK", comment: "Active_OK"))
                                            let scr = self.storyboard?.instantiateViewController(withIdentifier: "scr_ChangePassword") as! ChangePassword
                                            self.present(scr, animated: true, completion: nil)
                                        }
                                    }else{
                                        self.alertWindow(title: "CARE !",message: NSLocalizedString("ID_not_Exits", comment: "ID_not_Exits"))
                                    }
                                }
                            })
                        }else if (courses.count == 0 ){
                            DispatchQueue.main.async {
                                 self.alertWindow(title: "CARE !",message: NSLocalizedString("ID_not_Exits", comment: "ID_not_Exits"))
                            }
                        }else{
                            print(courses.count)
                        }
                    case .failure(let err):
                        print("Failed to get Json",err)
                        self.alertWindow(title: "Alert !",message: "Failed to get Json")
                    }
                }
            }else{
                 self.alertWindow(title: "CARE !",message: NSLocalizedString("Active_Code_Error", comment: "Active_Code_Error"))
                self.tb_phonenumber.resignFirstResponder()
                //self.tb_activecode.becomeFirstResponder()
                self.tb_activecode.textColor = UIColor.red
                //self.tb_activecode.selectedTextRange = self.tb_activecode.textRange(from: self.tb_activecode.beginningOfDocument, to: self.tb_activecode.endOfDocument)
            }
        }else{
            self.alertWindow(title: "Alert !",message: NSLocalizedString("Network_Error", comment: "Network Error") )
        }
    }
    @IBAction func bt_back(_ sender: Any) {
        let scr = storyboard?.instantiateViewController(withIdentifier: "scr_Login") as! LoginVC
        present(scr, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        bt_Active.set_Buttom_border()
        bt_GetCode.set_Buttom_border()
        tb_phonenumber.set_BG_left_img(str_img: "phoneicon.png")
        tb_activecode.set_BG_left_img(str_img: "keyicon.png")
        V_FullName.text = FullName
        if(PhoneNumber != ""){
            V_PhoneNumber.text = PhoneNumber.prefix(3) + " * * * " + PhoneNumber.suffix(3)
        }else{
            V_PhoneNumber.text = NSLocalizedString("Phone_nil", comment: "No Phone")
            
        }
        
        V_Status.text = LoginStatu
        // Do any additional setup after loading the view.
    }
    fileprivate func Get_Active_Code(url:String,completion: @escaping (Result<[Course],Error>)->()){
        let jsonurlstring =  NSLocalizedString("Sys_Domain", comment: "") + url
        //print(jsonurlstring)
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
    }
    struct  Course: Decodable{
        let Phone_Num:String
        let LoginID:String
        let Act_Code:String
        let Sent_Time:String
    }
    fileprivate func Active_User(url:String,completion: @escaping (Result<[Course_ActiveUser],Error>)->()){
        let jsonurlstring =  NSLocalizedString("Sys_Domain", comment: "") + url
        //print(jsonurlstring)
        guard let url = URL(string: jsonurlstring) else {return}
        URLSession.shared.dataTask(with: url) {(data,resp,err) in
            if let err = err{
                completion(.failure(err))
                return
            }
            do {
                let courses = try JSONDecoder().decode([Course_ActiveUser].self, from: data!)
                completion(.success(courses))
            }catch let jsonError {
                completion(.failure(jsonError))
            }
            
        }.resume()
    }
    struct  Course_ActiveUser: Decodable{
        let LoginID:String
        let FactoryID:String
        let FullName:String
        let Phone_Num:String
        let Email:String
        let Password:String
        let Active_Code:String
        let Status:String
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
