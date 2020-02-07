//
//  ChangePassword.swift
//  Crystal Knits CARE
//
//  Created by REGISDMAC01 on 9/27/19.
//  Copyright © 2019 TinhDX. All rights reserved.
//

import UIKit

class ChangePassword: UIViewController {

    @IBOutlet weak var old_Password: UITextField!
    @IBOutlet weak var new_Password1: UITextField!
    @IBOutlet weak var new_Password2: UITextField!
    @IBOutlet weak var outlet_bt_Cancel: UIButton!
    @IBOutlet weak var outlet_bt_OK: UIButton!
    @IBAction func CANCEL_Click(_ sender: Any) {
        UserDefaults.standard.Set_KepV(key: "Password_K", value: "")
        let scr = self.storyboard?.instantiateViewController(withIdentifier: "scr_Login") as! LoginVC
        self.present(scr, animated: true, completion: nil)
    }
    @IBAction func OK_Click(_ sender: Any) {
        UserDefaults.standard.Set_KepV(key: "Password_K", value: "")
        let the_Code = C_Str_all(str: self.old_Password.text ?? "")
        let the_Code1 = C_Str_all(str: self.new_Password1.text ?? "")
        let the_Code2 =  C_Str_all(str: self.new_Password2.text ?? "")
        if (the_Code.count < 6){
            showToast(message: NSLocalizedString("Active_Code_Error", comment: "Active_Code_Error !"))
            self.old_Password.becomeFirstResponder()
            self.old_Password.textColor = UIColor.red
            self.old_Password.selectedTextRange = self.old_Password.textRange(from: self.old_Password.beginningOfDocument, to: self.old_Password.endOfDocument)
            return
        }
        if(the_Code1 != the_Code2){
            showToast(message: NSLocalizedString("NewPass_Not_match", comment: "NewPass_Not_match !"))
            self.new_Password2.becomeFirstResponder()
            self.new_Password2.textColor = UIColor.red
            self.new_Password2.selectedTextRange = self.new_Password2.textRange(from: self.new_Password2.beginningOfDocument, to: self.new_Password2.endOfDocument)
            return
        }
        if (the_Code1.count < 6){
            showToast(message: NSLocalizedString("NewPass_Error", comment: "NewPass_Error !"))
            self.new_Password2.becomeFirstResponder()
            self.new_Password2.textColor = UIColor.red
            self.new_Password2.selectedTextRange = self.new_Password2.textRange(from: self.new_Password2.beginningOfDocument, to: self.new_Password2.endOfDocument)
            return
        }
        if Reachability.isConnectedToNetwork(){
            Change_Password(url: "ChangePassword.php?Code_G=" + md5(String(randomInt())) + md5(NSLocalizedString("f1_FactoryID", comment: "REG")) +  the_Code +  md5(the_Code) +  md5(the_Code1) + "_" + LoginID + md5(String(randomInt())) + "_" + DeviceName + "_" + FactoryID + "_" + LG  + "_" + MAC_add){(res) in
                           switch res{
                           case .success(let courses):
                               if (courses.count > 0 ){
                                   //Login_Satatu = "OK"
                                   courses.forEach({ (courses) in
                                       DispatchQueue.main.async {
                                        if(LoginID == courses.LoginID && courses.Phone_Num != "NG"){
                                                Act_Code = ""
                                                UserDefaults.standard.Set_KepV(key: "LoginID_K", value: courses.LoginID)
                                                   let scr = self.storyboard?.instantiateViewController(withIdentifier: "scr_Login") as! LoginVC
                                                   self.present(scr, animated: true, completion: nil)
                                           }else{
                                               self.alertWindow(title: "CARE !",message: NSLocalizedString("Active_Code_Error", comment: "Active_Code_Error"))
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
                   self.alertWindow(title: "Alert !",message: NSLocalizedString("Network_Error", comment: "Network Error") )
               }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if (Act_Code != "") {
            self.old_Password.text = Act_Code
            self.new_Password1.becomeFirstResponder()
        }else{
            self.old_Password.becomeFirstResponder()
        }
        self.old_Password.set_BG_left_img(str_img: "keyicon.png")
        self.new_Password1.set_BG_left_img(str_img: "newpassword.png")
        self.new_Password2.set_BG_left_img(str_img: "newpassword.png")
        self.outlet_bt_OK.set_Buttom_border()
        self.outlet_bt_Cancel.set_Buttom_border()
        
        
        
        // Do any additional setup after loading the view.
    }
    fileprivate func Change_Password(url:String,completion: @escaping (Result<[Course_ChangePass],Error>)->()){
        let jsonurlstring =  NSLocalizedString("Sys_Domain", comment: "") + url
        //print(jsonurlstring)
        guard let v_url = URL(string: jsonurlstring) else {return}
        URLSession.shared.dataTask(with: v_url) {(data,resp,err) in
            if let err = err{
                completion(.failure(err))
                return
            }
            do {
                let courses = try JSONDecoder().decode([Course_ChangePass].self, from: data!)
                completion(.success(courses))
            }catch let jsonError {
                completion(.failure(jsonError))
            }
            
        }.resume()
    }
    struct  Course_ChangePass: Decodable{
        let LoginID:String
        let Phone_Num:String
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
