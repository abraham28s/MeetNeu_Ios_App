//
//  Globals.swift
//  MeetNeu
//
//  Created by Abraham Soto on 04/06/17.
//  Copyright © 2017 Abraham. All rights reserved.
//

import Foundation
import UIKit

struct UserAppInfo {
    static var isUserLoggedIn:Bool = false
    static var email = ""
    static var social_media = ""
    static var avatar = ""
    static var social_id_no = ""
    static var gender = ""
    static var complete_name = ""
    static var first_name = ""
    static var platform = 2
    static var is_debug = 0
}

struct UserLoggedWithMeetNeu {
    static var email = ""
    static var first_name = ""
    static var gender = ""
    static var id = ""
    static var last_name = ""
    static var profile_img = ""
    static var short_name = ""
    static var social_id_no = ""
}

struct GlobalVariables {
    
    static let diccionarioIconeus = ["1":"p_price.png",
                              "2":"p_valet.png",
                              "3":"price_cash.png",
                              "4":"price_cash_credit.png",
                              "5":"price_1.png",
                              "6":"price_2.png",
                              "7":"price_3.png",
                              "8":"date.png",
                              "9":"new_people.png",
                              "10":"friends.png",
                              "11":"get_love.png",
                              "12":"tourist.png",
                              "13":"morning.png",
                              "14":"afternoon.png",
                              "15":"night.png",
                              "16":"1_hour.png",
                              "17":"2_hour.png",
                              "18":"3_hour.png",
                              "19":"4_hour.png",
                              "20":"wifi.png",
                              "21":"20km.png",
                              "22":"5km.png"]

}

func llamaWebServiceNotif(idUsuario:String, tabBarItem:UITabBarItem){
    let secondQueue = DispatchQueue.global()
    secondQueue.async {
        
        let urlStr = "https://www.meetneu.com/api/users/myNotifications/unread/\(idUsuario)"
        let urlObject = URL(string: urlStr)
        var req = URLRequest(url: urlObject!)
        req.addValue("meet_user_for_api", forHTTPHeaderField: "php-auth-user")
        req.addValue("soy_el_password123@", forHTTPHeaderField: "php-auth-pw")
        req.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: req, completionHandler: {
            (data, response, error) in
            if(error != nil){
                print("error")
            }else{
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    DispatchQueue.main.async {
                        
                        let res:String = "\(String(describing: json!.value(forKey: "count")!))"
                        if(res != "0"){
                            tabBarItem.badgeValue = res
                        }
                        
                    }
                    
                }catch let error as NSError{
                    print(error)
                }
            }
        }).resume()
    }
}



    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

func alertaDefault(titulo: String, texto:String) -> UIAlertController{
    let alert = UIAlertController(title: titulo, message: texto, preferredStyle: .alert)
    let alertAccion = UIAlertAction(title: "Ok", style: .default, handler: nil)
    alert.addAction(alertAccion)
    return alert
    
}
