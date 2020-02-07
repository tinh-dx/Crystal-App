//
//  SettingVC.swift
//  Crystal Knits CARE
//
//  Created by REGISDMAC01 on 10/3/19.
//  Copyright © 2019 TinhDX. All rights reserved.
//

import UIKit

class SettingVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var arrCellID:[String] = ["ChangePassword","ChangePhone","LoginHistory"]
    @IBOutlet weak var myTable: UITableView!
    @IBOutlet weak var btn_menu: UIBarButtonItem!
     override func viewDidLoad() {
         super.viewDidLoad()
         btn_menu.target = self.revealViewController()
         btn_menu.action = #selector(SWRevealViewController.revealToggle(_:))
         self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        myTable.delegate = self
        myTable.dataSource = self
        self.myTable.delegate = self;
        self.myTable.sectionHeaderHeight = 0;
        self.myTable.sectionFooterHeight = 0;
        self.automaticallyAdjustsScrollViewInsets = false;
        self.navigationItem.title = NSLocalizedString("Menu_Setting", comment: "Setting")
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCellID.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (Public_User == "N"){
            switch arrCellID[indexPath.row] {
            case "ChangePassword":
                let scr = self.storyboard?.instantiateViewController(withIdentifier: "scr_ChangePassword") as! ChangePassword
                self.present(scr, animated: true, completion: nil)
            case "ChangePhone":
                Menu_Selected = arrCellID[indexPath.row]
                let scr = self.storyboard?.instantiateViewController(withIdentifier: "scr_ChangePhoneVC") as! ChangePhoneVC
                //self.present(scr, animated: true, completion: nil)
                self.navigationController?.pushViewController(scr, animated: true)
            case "LoginHistory":
                Menu_Selected = arrCellID[indexPath.row]
                let scr = self.storyboard?.instantiateViewController(withIdentifier: "scr_NewsDetailVC") as! NewDetailVC
                self.navigationController?.pushViewController(scr, animated: true)
            default:
                return
            }
        }else{
            self.alertWindow(title: "CARE Alert !",message: NSLocalizedString("Access_Denied", comment: "Access_Denied"))
            return
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: arrCellID[indexPath.row], for: indexPath as IndexPath)
         
          return cell
      }
}
