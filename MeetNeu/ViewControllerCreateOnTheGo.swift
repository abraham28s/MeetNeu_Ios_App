//
//  ViewControllerCreateOnTheGo.swift
//  MeetNeu
//
//  Created by Abraham Soto on 03/07/17.
//  Copyright © 2017 Abraham. All rights reserved.
//

import UIKit

class ViewControllerCreateOnTheGo: UIViewController {
    
    var cat = ""
    var code = 0
    var time = ""
    var internaltime = 0
    var tiempo = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switch cat {
        case "beber":
            headerImgVw.image = #imageLiteral(resourceName: "Head_beber")
            titleLb.text = "Quitate lo aburrido y tomate unos tragos coquetos"
            titleLb.textColor = hexStringToUIColor(hex: "bc2bc9")
            goButton.setImage(#imageLiteral(resourceName: "Go_Beber"), for: .normal)
        case "arte":
            headerImgVw.image = #imageLiteral(resourceName: "Head_arte")
            titleLb.text = "Descubre, aprende y diviertete viviendo esta experiencia"
            titleLb.textColor = hexStringToUIColor(hex: "1daa4c")
            goButton.setImage(#imageLiteral(resourceName: "Go_Arte"), for: .normal)
        case "entrenar":
            headerImgVw.image = #imageLiteral(resourceName: "Head_Entrenar")
            titleLb.text = "Mejora tu rendimiento fisico entrenando"
            titleLb.textColor = hexStringToUIColor(hex: "2ab5ca")
            goButton.setImage(#imageLiteral(resourceName: "Go_Entrenar"), for: .normal)
        case "jugar":
            headerImgVw.image = #imageLiteral(resourceName: "Head_Jugar")
            titleLb.text = "¿Aburrido? Diviertete con este partido de"
            titleLb.textColor = hexStringToUIColor(hex: "296dd2")
            goButton.setImage(#imageLiteral(resourceName: "Go_Jugar"), for: .normal)
        case "concierto":
            headerImgVw.image = #imageLiteral(resourceName: "Head_Concierto")
            titleLb.text = "Grita y canta con todas tus fuerzas a lado de"
            titleLb.textColor = hexStringToUIColor(hex: "28e6b6")
            goButton.setImage(#imageLiteral(resourceName: "Go_Concierto"), for: .normal)
        case "comer":
            headerImgVw.image = #imageLiteral(resourceName: "Head_Comer")
            titleLb.text = "¿Hambre? Llena el estomago y alegra el corazón"
            titleLb.textColor = hexStringToUIColor(hex: "f38c15")
            goButton.setImage(#imageLiteral(resourceName: "Go_Comer"), for: .normal)
        case "bailar":
            headerImgVw.image = #imageLiteral(resourceName: "Head_Bailar")
            titleLb.text = "Usa tus mejores pass y deslumbra a todos en la pista"
            titleLb.textColor = hexStringToUIColor(hex: "e8359b")
            goButton.setImage(#imageLiteral(resourceName: "Go_Bailar"), for: .normal)
            
        default:
            print("nothing")
        }
        
        switch code {
        case 23:
            labelIntegrantes.isHidden = false
        default:
            print("Hellow")
        }
        if time != ""{
            internaltime = Int(self.time)!
            tiempo = Timer.scheduledTimer(timeInterval: 1,
                             target: self,
                             selector: #selector(self.updateTime),
                             userInfo: nil,
                             repeats: true)
        }else{
            timerlbl.isHidden = true
        }
        // Do any additional setup after loading the view.
    }
    
    func updateTime(){
        timerlbl.text = "Faltan \(internaltime) para el kick"
        internaltime -= 1
        if(internaltime == -1){
            tiempo.invalidate()
            llamaServicioParaEliminarApartado()
        }
    }
    
    func llamaServicioParaEliminarApartado(){
        let secondQueue = DispatchQueue.global()
        secondQueue.async {
            var request = URLRequest(url: URL(string: "https://www.meetneu.com/api/users/deleteStoredPlace")!)
            request.httpMethod = "POST"
            request.addValue("meet_user_for_api", forHTTPHeaderField: "php-auth-user")
            request.addValue("soy_el_password123@", forHTTPHeaderField: "php-auth-pw")
            
            let postString = "participantId=\(UserLoggedWithMeetNeu.id)"
            print(postString)
            request.httpBody = postString.data(using: .utf8)
            
            URLSession.shared.dataTask(with: request, completionHandler: {
                (data, response, error) in
                if(error != nil){
                    print(error)
                }else{
                    do{
                        let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                        
                        DispatchQueue.main.async {
                            print("Se elemina apartado")
                            self.navigationController?.popViewController(animated: true)
                        }
                        
                    }catch let error as NSError{
                        print(error)
                    }
                }
            }).resume()
        }

    }
    
    @IBOutlet weak var timerlbl: UILabel!
    
    @IBAction func pressGoButton(_ sender: Any) {
        if(UserAppInfo.isUserLoggedIn){
            tiempo.invalidate()
            llamarAServicioDeFullEnroll()
        }else{
            self.present(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginSB") as UIViewController, animated: true, completion: nil)
        }
        
    }
    
    func llamarAServicioDeFullEnroll(){
        let secondQueue = DispatchQueue.global()
        secondQueue.async {
            var request = URLRequest(url: URL(string: "https://www.meetneu.com/api/users/fullEnroll")!)
            request.httpMethod = "POST"
            request.addValue("meet_user_for_api", forHTTPHeaderField: "php-auth-user")
            request.addValue("soy_el_password123@", forHTTPHeaderField: "php-auth-pw")
            
            let postString = "participantId=\(UserLoggedWithMeetNeu.id)"
            print(postString)
            request.httpBody = postString.data(using: .utf8)
            
            URLSession.shared.dataTask(with: request, completionHandler: {
                (data, response, error) in
                if(error != nil){
                    print(error)
                }else{
                    do{
                        let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                        
                        DispatchQueue.main.async {
                            print("Se hace un fullenroll al user")
                            
                            //SE debe llamar a la otra pantalla
                            let create = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "eventOTGSB") as! ViewControllerEventOTG
                            create.cat = self.cat
                            self.navigationController?.pushViewController(create, animated: true)
                        }
                        
                    }catch let error as NSError{
                        print(error)
                    }
                }
            }).resume()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var headerImgVw: UIImageView!
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var labelIntegrantes: UILabel!
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
