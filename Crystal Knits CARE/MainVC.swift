//
//  HomePage_VC.swift
//  Crystal Knits CARE
//
//  Created by REGISDMAC01 on 9/23/19.
//  Copyright © 2019 TinhDX. All rights reserved.
//

import UIKit

class MainVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var btn_Menu: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    var nameArray = [String]()
    var dobArray = [String]()
    var imgURLArray = [String]()
    var ZoneArray = [String]()
    var IDArray = [String]()
    var Read_N = [String]()
    var Page_No:Int = 1
    var Total_R:Int = 0
     var indicator: UIActivityIndicatorView = UIActivityIndicatorView()
    func pushToDetailVC(Zone:String,ID : String) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "scr_NewsDetailVC") as! NewDetailVC
            vc.Zone_String = Zone
            vc.ID_String = ID
        self.navigationController?.pushViewController(vc, animated: true)
    }
    var refresher = UIRefreshControl()
     var url_v:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        Page_No = 1
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to Refresh")
        refresher.addTarget(self, action: #selector(Reload_table), for: UIControl.Event.valueChanged)
        
        tableView.addSubview(refresher)
        btn_Menu.target = self.revealViewController()
        btn_Menu.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
       
        switch Menu_Selected {
        case "News":
            self.navigationItem.title = NSLocalizedString("Menu_News", comment: "Menu_News")
            url_v =  NSLocalizedString("Sys_Domain", comment: "") + "feature_homepage.php?Code_G=" + md5(NSLocalizedString("f1_FactoryID", comment: "REG")) +  "1" +  md5("0") + md5(String(randomInt()))  + "_" + LoginID + "_" + FactoryID + "_" + Public_User
        case "Training":
            self.navigationItem.title = NSLocalizedString("Menu_Training", comment: "Menu_Training")
            url_v = NSLocalizedString("Sys_Domain", comment: "") + "feature_homepage.php?Code_G=" + md5(NSLocalizedString("f1_FactoryID", comment: "REG")) +  "2" +  md5("0") + md5(String(randomInt()))  + "_" + LoginID + "_" + FactoryID + "_" + Public_User
        case "Announcement":
            self.navigationItem.title = NSLocalizedString("Menu_Announcement", comment: "Menu_Announcement")
            url_v =  NSLocalizedString("Sys_Domain", comment: "") + "feature_homepage.php?Code_G=" + md5(NSLocalizedString("f1_FactoryID", comment: "REG")) +  "3" +  md5("0") + md5(String(randomInt()))  + "_" + LoginID + "_" + FactoryID + "_" + Public_User
        case "Survey":
            self.navigationItem.title = NSLocalizedString("Menu_Survey", comment: "Menu_Survey")
            url_v =  NSLocalizedString("Sys_Domain", comment: "") + "feature_homepage.php?Code_G=" + md5(NSLocalizedString("f1_FactoryID", comment: "REG")) +  "4" +  md5("0") + md5(String(randomInt()))  + "_" + LoginID + "_" + FactoryID + "_" + Public_User
        case "Recruitment":
        self.navigationItem.title = NSLocalizedString("Menu_Recruitment", comment: "Menu_Recruitment")
        url_v =  NSLocalizedString("Sys_Domain", comment: "") + "feature_homepage.php?Code_G=" + md5(NSLocalizedString("f1_FactoryID", comment: "REG")) +  "5" +  md5("0") + md5(String(randomInt()))  + "_" + LoginID + "_" + FactoryID + "_" + Public_User
        default:
            self.navigationItem.title = NSLocalizedString("f1_welcome", comment: "f1_welcome")
            url_v =  NSLocalizedString("Sys_Domain", comment: "") + "feature_homepage.php?Code_G=" + md5(NSLocalizedString("f1_FactoryID", comment: "REG")) +  "0" +  md5("0") + md5(String(randomInt()))  + "_" + LoginID + "_" + FactoryID + "_" + Public_User
        }
        self.tableView.delegate = self;
        self.tableView.sectionHeaderHeight = 0;
        self.tableView.sectionFooterHeight = 0;
        self.automaticallyAdjustsScrollViewInsets = false;
        DispatchQueue.global(qos: .userInteractive).async {
            self.downloadJsonWithURL()
        }
        //F_schedule()

        
    }

    override func didReceiveMemoryWarning() {
        
            super.didReceiveMemoryWarning()
    }
    public func delay(bySeconds seconds: Double, dispatchLevel: DispatchLevel = .main, closure: @escaping () -> Void) {
        let dispatchTime = DispatchTime.now() + seconds
        dispatchLevel.dispatchQueue.asyncAfter(deadline: dispatchTime, execute: closure)
    }

    public enum DispatchLevel {
        case main, userInteractive, userInitiated, utility, background
        var dispatchQueue: DispatchQueue {
            switch self {
            case .main:                 return DispatchQueue.main
            case .userInteractive:      return DispatchQueue.global(qos: .userInteractive)
            case .userInitiated:        return DispatchQueue.global(qos: .userInitiated)
            case .utility:              return DispatchQueue.global(qos: .utility)
            case .background:           return DispatchQueue.global(qos: .background)
            }
        }
    }
    func F_schedule(){
        
        //delay(bySeconds: 3) {
            // delayed code that will run on background thread
            
           // print("Active after 0.002 sec, and doesn't block main")
                       //self.F_schedule()
        //}
        //DispatchQueue.background(delay: 3.0, completion:{
            // do something in main thread after 3 seconds
           
        //})
         //DispatchQueue.global(qos: .background).async {
                /*Do something after 0.002 seconds have passed*/
                //sleep(5)
                
                
         //}
    }
    var Loading:String="N"
    @objc func Reload_table(){
        nameArray.removeAll()
        dobArray.removeAll()
        imgURLArray.removeAll()
        ZoneArray.removeAll()
        IDArray.removeAll()
        Read_N.removeAll()
        
        self.downloadJsonWithURL()
        self.refresh()
    }
    func refresh() {
        self.tableView.reloadData()
        self.refresher.endRefreshing()
    }
    @objc func downloadJsonWithURL() {
        self.Loading = "Y"
        let url = NSURL(string: url_v + "_" + String(Page_No))
        URLSession.shared.dataTask(with: (url as URL?)!, completionHandler: {(data, response, error) -> Void in
               if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                //print(jsonObj.value(forKey: "feature") as Any)
                if let actorArray = jsonObj.value(forKey: "feature") as? NSArray {
                       for actor in actorArray{
                           if let actorDict = actor as? NSDictionary {
                               if let name = actorDict.value(forKey: "News_Title") {
                                   self.nameArray.append(name as! String)
                               }
                               if let name = actorDict.value(forKey: "News_Author") {
                                   self.dobArray.append(name as! String)
                               }
                               if let name = actorDict.value(forKey: "News_img") {
                                   self.imgURLArray.append(name as! String)
                               }
                                if let name = actorDict.value(forKey: "feature") {
                                self.ZoneArray.append(name as! String)
                                }
                                if let name = actorDict.value(forKey: "ID") {
                                self.IDArray.append(name as! String)
                                }
                                if let name = actorDict.value(forKey: "Read_N") {
                                self.Read_N.append(name as! String)
                                }
                                if let name = actorDict.value(forKey: "Total_R") {
                                self.Total_R = (name as! Int)
                                }
                            
                           }
                       }
                   }
                OperationQueue.main.addOperation({
                    self.refresh()
                    self.Loading = "N"
                })
               }
           }).resume()
       }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return nameArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MainVC_TableviewCellTableViewCell
        
        let attrs1 = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18), NSAttributedString.Key.foregroundColor : UIColor.darkGray]
       // let attrs3 = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: <#T##CGFloat#>), NSAttributedString.Key.foregroundColor : UIColor.gray]

        let attrs2 = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor : UIColor.black]


        
        var attributedString2 = NSMutableAttributedString(string:"", attributes:attrs2)
        //print (String(indexPath.row))
        if(Read_N[indexPath.row] != "0" ){
            attributedString2 = NSMutableAttributedString(string:nameArray[indexPath.row], attributes:attrs1)
        }else{
            attributedString2 = NSMutableAttributedString(string:nameArray[indexPath.row], attributes:attrs2)
        }
        cell.lbContents.attributedText = attributedString2
        cell.lbRemark.text = dobArray[indexPath.row]
        let imgURL = NSURL(string: imgURLArray[indexPath.row])
        if imgURL != nil {
            DispatchQueue.global(qos: .userInteractive).async {
                let data = NSData(contentsOf: (imgURL as URL?)!)
                
                DispatchQueue.main.async {
                    if data != nil {
                    cell.imgView.image = UIImage(data: data! as Data)
                    }else{
                        cell.imgView.image = nil
                    }
                }
            }
        }
        return cell
    }
    ///for showing next detailed screen with the downloaded info
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "scr_NewsDetailVC") as! NewDetailVC
        vc.Zone_String = ZoneArray[indexPath.row]
         vc.ID_String = IDArray[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if ( indexPath.row == (IDArray.count - 1)  && Total_R > IDArray.count){
            if (Loading == "N"){
                self.Loading = "Y"
                Page_No = Page_No + 1
                indicator.frame = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0)
                    indicator.center = view.center
                    indicator.hidesWhenStopped=true
                indicator.color = UIColor.blue
                    view.addSubview(indicator)
                if #available(iOS 13.0, *) {
                    indicator.style = UIActivityIndicatorView.Style.large
                } else {
                    // Fallback on earlier versions
                }
                indicator.bringSubviewToFront(view)
                UIApplication.shared.endIgnoringInteractionEvents()
                indicator.startAnimating()
                self.perform(#selector(GetMore_), with: nil, afterDelay: 1.0)
            }
        }
    }
    @objc func GetMore_() {
       
 
         self.Loading = "Y"
        let url = NSURL(string: url_v + "_" + String(Page_No))
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // Change `2.0` to the desired number of seconds.
                URLSession.shared.dataTask(with: (url as URL?)!, completionHandler: {(data, response, error) -> Void in
                  if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                   //print(jsonObj.value(forKey: "feature") as Any)
                   if let actorArray = jsonObj.value(forKey: "feature") as? NSArray {
                          for actor in actorArray{
                              if let actorDict = actor as? NSDictionary {
                                  if let name = actorDict.value(forKey: "News_Title") {
                                      self.nameArray.append(name as! String)
                                  }
                                  if let name = actorDict.value(forKey: "News_Author") {
                                      self.dobArray.append(name as! String)
                                  }
                                  if let name = actorDict.value(forKey: "News_img") {
                                      self.imgURLArray.append(name as! String)
                                  }
                                   if let name = actorDict.value(forKey: "feature") {
                                   self.ZoneArray.append(name as! String)
                                   }
                                   if let name = actorDict.value(forKey: "ID") {
                                   self.IDArray.append(name as! String)
                                   }
                                   if let name = actorDict.value(forKey: "Read_N") {
                                   self.Read_N.append(name as! String)
                                   }
                                   if let name = actorDict.value(forKey: "Total_R") {
                                   self.Total_R = (name as! Int)
                                   }
                               
                              }
                          }
                      }
                   OperationQueue.main.addOperation({
                       self.tableView.reloadData()
                       self.refresher.endRefreshing()
                       self.Loading = "N"
                    self.indicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                   })
                  }
              }).resume()
        }
        refresh()
    }


    
}
