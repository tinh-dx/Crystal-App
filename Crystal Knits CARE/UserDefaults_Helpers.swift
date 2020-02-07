//
//  UserDefaults_Helpers.swift
//  Crystal Knits CARE
//
//  Created by REGISDMAC01 on 9/30/19.
//  Copyright © 2019 TinhDX. All rights reserved.
//

import Foundation
extension UserDefaults {
    func Set_KepV(key:String,value: String) {
        set(value, forKey: key)
        synchronize()
    }
    func Get_KepV(key:String) -> String {
        return string(forKey: key) ?? ""
    }
    func Remove_KepV(key:String){
        removeObject(forKey: key)
    }
}
