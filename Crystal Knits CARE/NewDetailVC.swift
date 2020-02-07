//
//  NewDetailVC.swift
//  Crystal Knits CARE
//
//  Created by REGISDMAC01 on 10/5/19.
//  Copyright © 2019 TinhDX. All rights reserved.
//

import UIKit
import WebKit
class NewDetailVC: UIViewController,WKNavigationDelegate,WKUIDelegate {
    let webview: WKWebView = {
        let config = WKWebViewConfiguration()
        let view = WKWebView(frame: .zero, configuration: config);
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    @IBOutlet weak var btn_Menu: UIBarButtonItem!
    var Zone_String:String!
    var ID_String:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        btn_Menu.target = self.revealViewController()
        btn_Menu.action = #selector(SWRevealViewController.revealToggle(_:))
        //self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        var url_v:String = ""
        switch Menu_Selected {
        case "Feedback":
            self.navigationItem.title = NSLocalizedString("Menu_FeedBack", comment: "Feed Back")
            url_v =  NSLocalizedString("Sys_Domain", comment: "") + "webview_FeedBack_" + LG + ".php?Code_G=" + md5(NSLocalizedString("f1_FactoryID", comment: "REG")) +  LoginID +  md5(LoginID) + md5(String(randomInt()))  + "_" + FactoryID
        case "Payslip":
            self.navigationItem.title = NSLocalizedString("Menu_Payslip", comment: "Payslip")
            url_v =  NSLocalizedString("Sys_Domain", comment: "") + "webview_PaySlip_1step_" + LG + ".php?Code_G=" + md5(NSLocalizedString("f1_FactoryID", comment: "REG")) +  LoginID +  md5(LoginID) + md5(String(randomInt())) + "_" + PhoneNumber + "_" + DeviceName  + "_" + FactoryID + "_" + MAC_add
        case "OtherPayments":
                   self.navigationItem.title = NSLocalizedString("Menu_OtherPayments", comment: "OtherPayments")
                   url_v =  NSLocalizedString("Sys_Domain", comment: "") + "webview_OtherAllowance_1step_" + LG + ".php?Code_G=" + md5(NSLocalizedString("f1_FactoryID", comment: "REG")) +  LoginID +  md5(LoginID) + md5(String(randomInt())) + "_" + PhoneNumber + "_" + DeviceName  + "_" + FactoryID + "_" + MAC_add
        case "ChangePhone":
            self.navigationItem.title = NSLocalizedString("Menu_ChangePhone", comment: "Menu_ChangePhone")
            url_v =  NSLocalizedString("Sys_Domain", comment: "") + "webview_ChangePhone_" + LG + ".php?Code_G=" + md5(NSLocalizedString("f1_FactoryID", comment: "REG")) +  LoginID +  md5(LoginID) + md5(String(randomInt())) + "_" + PhoneNumber + "_" + DeviceName  + "_" + FactoryID + "_" + MAC_add
        case "LoginHistory":
        self.navigationItem.title = NSLocalizedString("Menu_LoginHistory", comment: "Menu_LoginHistory")
        url_v =  NSLocalizedString("Sys_Domain", comment: "") + "webview_LoginHistory_" + LG + ".php?Code_G=" + md5(NSLocalizedString("f1_FactoryID", comment: "REG")) +  LoginID +  md5(LoginID) + md5(String(randomInt())) + "_" + PhoneNumber + "_" + DeviceName  + "_" + FactoryID + "_" + MAC_add
            
        default:
            switch Zone_String {
            case "1":
                self.navigationItem.title = NSLocalizedString("Menu_News", comment: "Menu_News") + " / .."
                url_v =  NSLocalizedString("Sys_Domain", comment: "") + "webview_NewsDetail_" + LG + ".php?Code_G=" + md5(NSLocalizedString("f1_FactoryID", comment: "REG")) +  ID_String +  md5(ID_String) + md5(String(randomInt()))  + "_" + Zone_String + "_" + LoginID + "_" + FactoryID
            case "2":
                self.navigationItem.title = NSLocalizedString("Menu_Training", comment: "Menu_Training") + " / .."
                url_v =  NSLocalizedString("Sys_Domain", comment: "") + "webview_NewsDetail_" + LG + ".php?Code_G=" + md5(NSLocalizedString("f1_FactoryID", comment: "REG")) +  ID_String +  md5(ID_String) + md5(String(randomInt()))  + "_" + Zone_String + "_" + LoginID + "_" + FactoryID
            case "3":
                self.navigationItem.title = NSLocalizedString("Menu_Announcement", comment: "Menu_Announcement") + " / .."
                url_v =  NSLocalizedString("Sys_Domain", comment: "") + "webview_NewsDetail_" + LG + ".php?Code_G=" + md5(NSLocalizedString("f1_FactoryID", comment: "REG")) +  ID_String +  md5(ID_String) + md5(String(randomInt()))  + "_" + Zone_String + "_" + LoginID + "_" + FactoryID
            case "4":
                self.navigationItem.title = NSLocalizedString("Menu_Survey", comment: "Menu_Survey") + " / .."
                url_v =  NSLocalizedString("Sys_Domain", comment: "") + "webview_Survey_" + LG + ".php?Code_G=" + md5(NSLocalizedString("f1_FactoryID", comment: "REG")) +  ID_String +  md5(ID_String) + md5(String(randomInt()))  +  "_" + LoginID + "_" + FactoryID
            case "5":
                    self.navigationItem.title = NSLocalizedString("Menu_Recruitment", comment: "Menu_Recruitment") + " / .."
                    url_v =  NSLocalizedString("Sys_Domain", comment: "") + "webview_NewsDetail_" + LG + ".php?Code_G=" + md5(NSLocalizedString("f1_FactoryID", comment: "REG")) +  ID_String +  md5(ID_String) + md5(String(randomInt()))  + "_" + Zone_String + "_" + LoginID + "_" + FactoryID
            default:
                url_v =  NSLocalizedString("Sys_Domain", comment: "") + "webview_FeedBack_" + LG + ".php?Code_G=" + md5(NSLocalizedString("f1_FactoryID", comment: "REG")) +  LoginID +  md5(LoginID) + md5(String(randomInt()))  + "_" + FactoryID
                self.navigationItem.title = NSLocalizedString("Menu_FeedBack", comment: "Feed Back")
            }
            
        }
        DispatchQueue.global(qos: .userInteractive).async {
            let url = URL(string: url_v)
            //print(url_v)
            let myWebsite = URLRequest(url: url!)
            DispatchQueue.main.async {
                self.view.addSubview(self.webview)
                self.webview.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
                self.webview.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
                self.webview.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
                self.webview.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
                self.webview.configuration.preferences.javaScriptEnabled = true
                self.webview.load(myWebsite)
            }
        }
        
        
    }
}
