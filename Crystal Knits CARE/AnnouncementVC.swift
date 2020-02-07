//
//  AnnouncementVC.swift
//  Crystal Knits CARE
//
//  Created by REGISDMAC01 on 10/1/19.
//  Copyright © 2019 TinhDX. All rights reserved.
//

import UIKit

class AnnouncementVC: UIViewController {

    
    @IBOutlet weak var btn_menu: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        btn_menu.target = self.revealViewController()
        btn_menu.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())

        var url_v:String = ""
        switch Menu_Selected {
        case "News":
            self.navigationItem.title = NSLocalizedString("Menu_News", comment: "")
            url_v = "webview_FeedBack_" + LG + ".php?Code_G=" + md5(NSLocalizedString("f1_FactoryID", comment: "REG")) +  LoginID +  md5(LoginID) + md5(String(randomInt()))  + "_" + FactoryID
        default:
            url_v = "webview_FeedBack_" + LG + ".php?Code_G=" + md5(NSLocalizedString("f1_FactoryID", comment: "REG")) +  LoginID +  md5(LoginID) + md5(String(randomInt()))  + "_" + FactoryID
            self.navigationItem.title = NSLocalizedString("Menu_Announcement", comment: "")
        }
        print(url_v)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    

    

}
