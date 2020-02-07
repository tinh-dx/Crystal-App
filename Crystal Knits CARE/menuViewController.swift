//
//  menu_ViewController.swift
//  Crystal Knits CARE
//
//  Created by REGISDMAC01 on 10/1/19.
//  Copyright © 2019 TinhDX. All rights reserved.
//

import UIKit
var Menu_Selected:String = ""
var Recruitment_N = ""
var Announcement_N = ""
var Training_N = ""
var Survey_N = ""
var News_N = ""
class menuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    var MenuCellID:[String] = ["News","Recruitment" ,"Announcement","Payslip","OtherPayments","Training","Survey","Feedback","Setting","Logout","Login"]
     var Menu_txt:[String] = [NSLocalizedString("mn_News", comment: "News")
        ,NSLocalizedString("mn_Recruitment", comment: "Recruitment")
        ,NSLocalizedString("mn_Announcement", comment: "Announcement"),NSLocalizedString("mn_Payslip", comment: "Payslip"),NSLocalizedString("mn_OtherPayments", comment: "OtherPayments"),NSLocalizedString("mn_Training", comment: "Training"),NSLocalizedString("mn_Survey", comment: "Survey"),NSLocalizedString("mn_FeedBack", comment: "Feedback"),NSLocalizedString("mn_Setting", comment: "Setting"),NSLocalizedString("mn_LogOut", comment: "Logout"),NSLocalizedString("mn_LogIn", comment: "Login")]
    @IBOutlet weak var img_Logo: UIImageView!
    @IBOutlet weak var lb_FullName: UILabel!
    @IBOutlet weak var myTable: UITableView!
    @IBOutlet weak var table_menu: UITableView!
  var refresher = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to Refresh")
        refresher.addTarget(self, action: #selector(Thread_Load_UnRead), for: UIControl.Event.valueChanged)
        myTable.addSubview(refresher)
        lb_FullName.text = FullName
       //let image = UIImage(named: "img__Logo")
        img_Logo.layer.borderWidth = 1.0
        img_Logo.layer.masksToBounds = false
        img_Logo.layer.borderColor = UIColor.white.cgColor
        img_Logo.layer.cornerRadius = img_Logo.frame.size.width / 2
        img_Logo.clipsToBounds = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(menuViewController.imageTapped(gesture:)))
        // add it to the image view;
        img_Logo.addGestureRecognizer(tapGesture)
        
        // make sure imageView can be interacted with by user
        img_Logo.isUserInteractionEnabled = true
        self.myTable.dataSource = self
        self.myTable.delegate = self
        //myTable.dataSource = self
        //self.myTable.contentInset = UIEdgeInsets(top: -35, left: 0, bottom: 0, right: 0);
        self.myTable.sectionHeaderHeight = 0;
        self.myTable.sectionFooterHeight = 0;
        self.automaticallyAdjustsScrollViewInsets = false;
        //self.automaticallyAdjustsScrollViewInsets = false;
    }
    override func viewWillAppear(_ animated: Bool) {
        Thread_Load_UnRead()
    }
    @objc func imageTapped(gesture: UIGestureRecognizer) {
        if (gesture.view as? UIImageView) != nil {
            Menu_Selected = "HomePage"
            let scr = self.storyboard?.instantiateViewController(withIdentifier: "scr_SWRevealViewController") as! SWRevealViewController
            self.present(scr, animated: true, completion: nil)
        }
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func didMove(toParent parent: UIViewController?) {
        
        super.didMove(toParent: parent)

        if parent == nil {
            debugPrint("Back Button pressed.")
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Menu_Selected = MenuCellID[indexPath.row]
        switch Menu_Selected {
        case "Logout":
            Change_Internal = "Y"
            if (UserDefaults.standard.Get_KepV(key: "Password_K") != ""){
                UserDefaults.standard.Set_KepV(key: "FullName_K", value: "")
                UserDefaults.standard.Set_KepV(key: "Password_K", value: "")
                let scr = self.storyboard?.instantiateViewController(withIdentifier: "scr_Login") as! LoginVC
                self.present(scr, animated: true, completion: nil)
            }else{
                UserDefaults.standard.Set_KepV(key: "FullName_K", value: "")
                UserDefaults.standard.Set_KepV(key: "Password_K", value: "")
                let scr = self.storyboard?.instantiateViewController(withIdentifier: "scr_Wellcome") as! ShowSplashScreen
                self.present(scr, animated: true, completion: nil)
            }
        case "Login":
            Change_Internal = "Y"
            UserDefaults.standard.Set_KepV(key: "FactoryID_K", value: "")
            UserDefaults.standard.Set_KepV(key: "LoginID_K", value: "")
            UserDefaults.standard.Set_KepV(key: "FullName_K", value: "")
            UserDefaults.standard.Set_KepV(key: "Password_K", value: "")
            let scr = self.storyboard?.instantiateViewController(withIdentifier: "scr_Wellcome") as! ShowSplashScreen
            self.present(scr, animated: true, completion: nil)
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print(String(arrCellID.count) + "_" + String(arrCellID.endIndex))
       
        return MenuCellID.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var rowHeight:CGFloat = 0.0
        if (Public_User == "G"){
            switch MenuCellID[indexPath.row] {
            case "Payslip":
                rowHeight = 0.0
            case "OtherPayments":
                rowHeight = 0.0
            case "Training":
                rowHeight = 0.0
            case "Announcement":
                rowHeight = 0.0
            case "Survey":
                    rowHeight = 0.0
            case "Feedback":
                    rowHeight = 0.0
            case "Logout":
                rowHeight = 0.0
            default:
                rowHeight = 65
            }
        }else{
            switch MenuCellID[indexPath.row] {
            case "Login":
                rowHeight = 0.0
            default:
                rowHeight = 65
            }
        }
    return rowHeight
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: MenuCellID[indexPath.row], for: indexPath as IndexPath)
        let label = cell.viewWithTag(123) as! UILabel
       //let attrs1 = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20), NSAttributedString.Key.foregroundColor : UIColor.black]
        let attrs1 = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18), NSAttributedString.Key.foregroundColor : UIColor.black]
      let attrs2 = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 22), NSAttributedString.Key.foregroundColor : UIColor.red]

       //let attributedString1 = NSMutableAttributedString(string: MenuCellID[indexPath.row], attributes:attrs1)
       let attributedString1 = NSMutableAttributedString(string: Menu_txt[indexPath.row], attributes:attrs1)
       
       var attributedString2 = NSMutableAttributedString(string:"", attributes:attrs2)
       
       switch MenuCellID[indexPath.row] {
       case "News":
            
           attributedString2 = NSMutableAttributedString(string:"  " + News_N, attributes:attrs2)
       case "Recruitment":
           attributedString2 = NSMutableAttributedString(string:"  " + Recruitment_N, attributes:attrs2)
       case "Training":
           attributedString2 = NSMutableAttributedString(string:"  " + Training_N, attributes:attrs2)
       case "Announcement":
           attributedString2 = NSMutableAttributedString(string:"  " + Announcement_N, attributes:attrs2)
       case "Survey":
           attributedString2 = NSMutableAttributedString(string:"  " + Survey_N, attributes:attrs2)
        case "Payslip":
        attributedString2 = NSMutableAttributedString(string:"", attributes:attrs2)
        case "OtherPayments":
        attributedString2 = NSMutableAttributedString(string:"", attributes:attrs2)
        case "Feedback":
        attributedString2 = NSMutableAttributedString(string:"", attributes:attrs2)
        case "Logout":
        attributedString2 = NSMutableAttributedString(string:"", attributes:attrs2)
        case "Login":
        attributedString2 = NSMutableAttributedString(string:"", attributes:attrs2)
       default:
           attributedString2 = NSMutableAttributedString(string:"", attributes:attrs1)
       }
       attributedString1.append(attributedString2)
        label.attributedText = attributedString1
        return cell
    }
   
    
    func change_UnRead(_ string: String) -> String {
        var KQString = ""
        switch string{
            case "0":
            KQString=""
            case "1":
            KQString="➀"
            case "2":
            KQString="➁"
            case "3":
            KQString="➂"
            case "4":
            KQString="➃"
            case "5":
            KQString="➄"
        default:
            KQString="➄+"
        }
        return KQString
    }
    @objc func Thread_Load_UnRead(){
        if(Public_User != "G"){
        DispatchQueue.background(delay: 1.0, background: {
             // do something in background
            self.Load_UnRead()
        }, completion: {
             // when background job finishes, wait 3 seconds and do something in main thread
            //self.table_menu.reloadData()
            //self.refresher.endRefreshing()
        })
        }else{
        self.refresher.endRefreshing()
        }
    }
    @objc func Load_UnRead(){
        UnRead_Sum(v_url: "UnRead_Summary.php?Code_G=" + md5(NSLocalizedString("f1_FactoryID", comment: "REG")) +  LoginID +  md5(LoginID) + md5(String(randomInt())) + "_" + FactoryID ){(res) in
                switch res{
                case .success(let courses):
                    if (courses.count > 0 ){
                    courses.forEach({ (courses) in
                        DispatchQueue.main.async {
                            News_N = self.change_UnRead(courses.News_N)
                            Recruitment_N = self.change_UnRead(courses.Recruitment_N)
                            Training_N = self.change_UnRead(courses.Training_N)
                            Announcement_N = self.change_UnRead(courses.Announcement_N)
                            Survey_N = self.change_UnRead(courses.Survey_N)
                            self.table_menu.reloadData()
                            self.refresher.endRefreshing()
                        }
                    })
                }
                case .failure(let err):
                    //self.alertWindow(title: "Alert !",message: "Failed to get Json" + err)
                    print("Failed to get Json",err)
                }
            }
    }
    fileprivate func UnRead_Sum(v_url:String,completion: @escaping (Result<[Course_Unread],Error>)->()){
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
                    let courses = try JSONDecoder().decode([Course_Unread].self, from: data!)
                    completion(.success(courses))
                }catch let jsonError {
                    completion(.failure(jsonError))
                }
            }.resume()
            }
        }
        struct  Course_Unread: Decodable{
            let News_N:String
            let Announcement_N:String
            let Recruitment_N:String
            let Survey_N:String
            let Training_N:String
        }


}
