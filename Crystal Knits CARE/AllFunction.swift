//
//  AllFunction.swift
//  Crystal Knits CARE
//
//  Created by REGISDMAC01 on 9/17/19.
//  Copyright © 2019 TinhDX. All rights reserved.
//

import CommonCrypto
import UIKit
import Foundation
import Network
extension UITextField {
    func setBottomBorder() {
        self.borderStyle = .none
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
    func setBottomBorder2() {
        self.layer.borderWidth=0.3
        self.layer.cornerRadius=10
        self.layer.borderColor=UIColor.brown.cgColor;
    }
    func setBottomBorder_red() {
        self.borderStyle = .none
        //self.layer.backgroundColor = UIColor.groupTableViewBackground.cgColor
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.red.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
    func set_BG_left_img(str_img: String) {
        let indentView = UIImageView(frame: CGRect(x:0,y:0,width: 25,height: 25))
        let image = UIImage(named: str_img)
        indentView.image=image
        self.leftView=indentView
        self.leftViewMode = .always
    }
}

extension UIButton{
    func set_Buttom_border() {
        self.layer.borderWidth=0.3
        self.layer.cornerRadius=10
        self.layer.borderColor=UIColor.brown.cgColor;
        //self.layer.backgroundColor=UIColor.blue.cgColor;
    }
    
}

extension DispatchQueue {
    static func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background ).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }

}
extension CharacterSet {

    /// Characters valid in at least one part of a URL.
    ///
    /// These characters are not allowed in ALL parts of a URL; each part has different requirements. This set is useful for checking for Unicode characters that need to be percent encoded before performing a validity check on individual URL components.
    static var urlAllowedCharacters: CharacterSet {
        // Start by including hash, which isn't in any set
        var characters = CharacterSet(charactersIn: "#")
        // All URL-legal characters
        characters.formUnion(.urlUserAllowed)
        characters.formUnion(.urlPasswordAllowed)
        characters.formUnion(.urlHostAllowed)
        characters.formUnion(.urlPathAllowed)
        characters.formUnion(.urlQueryAllowed)
        characters.formUnion(.urlFragmentAllowed)

        return characters
    }
}

extension String {

    var RFC3986UnreservedEncoded:String {
        let unreservedChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~"
        let unreservedCharsSet: CharacterSet = CharacterSet(charactersIn: unreservedChars)
        let encodedString: String = self.addingPercentEncoding(withAllowedCharacters: unreservedCharsSet)!
        return encodedString
    }
}
extension UIViewController {

    
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/16, y: self.view.frame.size.height-150, width: self.view.frame.size.width * 7/8 , height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        //toastLabel.font = font
        toastLabel.font = UIFont(name: "Arial", size: 14.0)
        toastLabel.textAlignment = .center;
        toastLabel.numberOfLines = 0
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 2.0, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    func md5(_ string: String) -> String {
        let context = UnsafeMutablePointer<CC_MD5_CTX>.allocate(capacity: 1)
        var digest = Array<UInt8>(repeating:0, count:Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5_Init(context)
        CC_MD5_Update(context, string, CC_LONG(string.lengthOfBytes(using: String.Encoding.utf8)))
        CC_MD5_Final(&digest, context)
        //context.deallocate(capacity: 1)
        var hexString = ""
        for byte in digest {
            hexString += String(format:"%02x", byte)
        }
        return hexString
    }
   func randomInt() -> Int {
        return 1 + Int(arc4random_uniform(UInt32(100 - 1 + 1)))
    }
    func getIFAddresses() -> [String] {
        var addresses = [String]()
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return [] }
        guard let firstAddr = ifaddr else { return [] }
        
        // For each interface ...
        for ptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let flags = Int32(ptr.pointee.ifa_flags)
            let addr = ptr.pointee.ifa_addr.pointee
            
            // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
            if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    if (getnameinfo(ptr.pointee.ifa_addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),
                                    nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                        let address = String(cString: hostname)
                        addresses.append(address)
                    }
                }
            }
        }
        freeifaddrs(ifaddr)
        return addresses
    }
    func getWiFiAddress() -> String? {
        var address : String
        address = ""
        var tmp_s : String
        tmp_s = ""
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }
        
        // For each interface ...
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
             let flags = Int32(ifptr.pointee.ifa_flags)
            // Check for IPv4 or IPv6 interface:
            let addrFamily = interface.ifa_addr.pointee.sa_family.self
            if (addrFamily == 2 || addrFamily == 18 ) && (flags & (IFF_UP|IFF_RUNNING)) == (IFF_UP|IFF_RUNNING) /*&& (String( interface.ifa_dstaddr.debugDescription) != "nil")*/ {
               
                // Check interface name:
                
                let name = String(cString: interface.ifa_name)
            //let name_d = String( interface.ifa_dstaddr.debugDescription)
                if  (name.prefix(2) == "en" && String(ifptr.move().ifa_flags) == "34915") {
                    //print(String(ifptr.move().ifa_flags))
                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    
                    //print(name + "_" + String(cString: hostname) + "_" + String(addrFamily)  )
                    if address == ""{
                        tmp_s =  String(cString: hostname)
                    }else{
                        tmp_s =  address + "-" +  String(cString: hostname)
                    }
                    
                    address = tmp_s
                }
            }
        }
        freeifaddrs(ifaddr)
        
        return address
    }
    func UI_tf_Forcus_Alert(UI_tf:UITextField, ms:String) {
        DispatchQueue.main.async {
        let alert = UIAlertController(title: "CARE Alert !", message: ms, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
              UI_tf.becomeFirstResponder()
              UI_tf.textColor = UIColor.red
              UI_tf.selectedTextRange = UI_tf.textRange(from: UI_tf.beginningOfDocument, to: UI_tf.endOfDocument)
            case .cancel:
                return
            case .destructive:
                 return
            @unknown default:
               UI_tf.becomeFirstResponder()
               UI_tf.textColor = UIColor.red
               UI_tf.selectedTextRange = UI_tf.textRange(from: UI_tf.beginningOfDocument, to: UI_tf.endOfDocument)
            }
            
        }))
        self.present(alert, animated: true, completion: nil)
        }
    }
    func alertWindow(title: String, message: String) {
        DispatchQueue.main.async(execute: {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
            })
            alert.addAction(ok)
            DispatchQueue.main.async(execute: {
                self.present(alert, animated: true)
            })
        })
    }
    func alertWindow_2(title: String, message: String) {
        DispatchQueue.main.async(execute: {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
            })
            let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { action in
            })
            alert.addAction(ok)
            alert.addAction(cancel)
            DispatchQueue.main.async(execute: {
                self.present(alert, animated: true)
            })
        })
    }
    func C_Str(str: String) -> String {
        var kq_v = str.trimmingCharacters(in: .whitespacesAndNewlines)
        //kq_v = kq_v.replacingOccurrences(of: " ", with: "")
        //kq_v = kq_v.replacingOccurrences(of: "_", with: "")
        kq_v = kq_v.replacingOccurrences(of: "'", with: "")
        kq_v = kq_v.replacingOccurrences(of: "&", with: "")
        kq_v = kq_v.replacingOccurrences(of: "ʀ", with: "R")
        kq_v = kq_v.replacingOccurrences(of: "’", with: "R")
        return kq_v
    }
    func C_Str_all(str: String) -> String {
        var kq_v = str.trimmingCharacters(in: .whitespacesAndNewlines)
        kq_v = kq_v.replacingOccurrences(of: " ", with: "")
        kq_v = kq_v.replacingOccurrences(of: "_", with: "")
        kq_v = kq_v.replacingOccurrences(of: "'", with: "")
        kq_v = kq_v.replacingOccurrences(of: "&", with: "")
        kq_v = kq_v.replacingOccurrences(of: "ʀ", with: "R")
        kq_v = kq_v.replacingOccurrences(of: "’", with: "R")
        
        return kq_v
    }
}
