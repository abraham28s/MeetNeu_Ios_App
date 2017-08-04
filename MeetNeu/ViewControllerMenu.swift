//
//  ViewControllerMenu.swift
//  MeetNeu
//
//  Created by Abraham Soto on 26/06/17.
//  Copyright © 2017 Abraham. All rights reserved.
//

import UIKit
import Magnetic
import CoreLocation
import SpriteKit


class ViewControllerMenu: UIViewController,MagneticDelegate,CLLocationManagerDelegate {
    var ArregloImg = [#imageLiteral(resourceName: "Icon_Beber_fondo"),#imageLiteral(resourceName: "Icon_Jugar_fondo"),#imageLiteral(resourceName: "Icon_Comer_fondo"),#imageLiteral(resourceName: "Icon_Bailar_fondo"),#imageLiteral(resourceName: "Icon_Entrenar_fondo"),#imageLiteral(resourceName: "Icon_Concierto_fondo"),#imageLiteral(resourceName: "Icon_Cultivarnos_fondo")]
    var ArregloNames = ["Beber","Jugar","Comer","Bailar","Entrenar","Concierto","Cultivarnos"]
    var codigo = 0
    let locationManager = CLLocationManager()
    var latitude = ""
    var longitug = ""
    var bandera = true
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if(bandera){
            bandera = false
            let locValue:CLLocationCoordinate2D = manager.location!.coordinate
            latitude = "\(locValue.latitude)"
            longitug = "\(locValue.longitude)"
            manager.stopUpdatingLocation()
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization
        status: CLAuthorizationStatus) {
        print("status: \(status)")
        if status == .authorizedWhenInUse {
            // Hay permiso, iniciar las actualizaciones
            locationManager.startUpdatingLocation()
        } else if status == .denied {
            locationManager.stopUpdatingLocation()
            print("Puedes habilitar el gps en Ajustes")
        }
    }
    
    @IBOutlet weak var magneticView: MagneticView!  {
        didSet {
            magnetic.magneticDelegate = self
            //magnetic.allowsMultipleSelection = false
            magnetic.physicsWorld.speed = 2.5
            print(magnetic.speed)
            magnetic.backgroundColor = hexStringToUIColor(hex: "49556B")
        }
    }
    
    var magnetic: Magnetic {
        return magneticView.magnetic
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        var coun = 0;
        for ico in ArregloImg{
            let node = ImageNode(text: "", image: ico, color: UIColor.white, radius: 40.0)
            node.name = ArregloNames[coun]
            magnetic.addChild(node)
            coun = coun + 1
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    func magnetic(_ magnetic: Magnetic, didSelect node: Node) {
        switch node.name! {
        case "Beber":
            pressBeber()
        case "Jugar":
            pressJugar()
        case "Comer":
            pressComer()
        case "Bailar":
            pressBailar()
        case "Entrenar":
            pressGym()
        case "Concierto":
            pressConcierto()
        case "Cultivarnos":
            pressCultivarnos()
        default:
            print("not")
        }
    }
    
    func magnetic(_ magnetic: Magnetic, didDeselect node: Node) {
        switch node.name! {
        case "Beber":
            pressBeber()
        case "Jugar":
            pressJugar()
        case "Comer":
            pressComer()
        case "Bailar":
            pressBailar()
        case "Entrenar":
            pressGym()
        case "Concierto":
            pressConcierto()
        case "Cultivarnos":
            pressCultivarnos()
        default:
            print("not")
        }
    }
    
    class ImageNode: Node {
        override var image: UIImage? {
            didSet {
                sprite.texture = image.map { SKTexture(image: $0) }
            }
        }
        override func selectedAnimation() {}
        override func deselectedAnimation() {}
    }
    
    func llamaWebServiceOTG(cat: String,catNumber: Int){
        
        let secondQueue = DispatchQueue.global()
        secondQueue.async {
            var request = URLRequest(url: URL(string: "https://www.meetneu.com/api/users/createEvent")!)
            request.httpMethod = "POST"
            request.addValue("meet_user_for_api", forHTTPHeaderField: "php-auth-user")
            request.addValue("soy_el_password123@", forHTTPHeaderField: "php-auth-pw")
            
            let postString = "userId=\(UserLoggedWithMeetNeu.id)&eventName=OTG\(cat)&eventType=100&eventSubtype=\(catNumber)&latitude=\(self.latitude)&longitude=\(self.longitug)"
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
                            print("\nEste es el json de Menu OTG\n\(json!)\n____________")
                            self.parseAJson(json: json!,catName: cat)
                            
                        }
                        
                    }catch let error as NSError{
                        print(error)
                    }
                }
            }).resume()
        }
    }
    
    func parseAJson(json: NSDictionary,catName:String){
        let code = json.value(forKey: "code") as! Int
        //Enrolled
        if code == 20{
            print("Se le muestra un evento")
        }else if code == 21 { // created
            print("Se crea el evento")
        }else if code == 23{
            print("El evento con esa categoria ya estaba creado y se debe poner un timeout")
        }else{
            print("El codigo es:\(code) y aun no esta implementado")
        }
        
        let create = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "createOnTheGoSB") as! ViewControllerCreateOnTheGo
        let timeout = json.value(forKey: "kickTime")
        if(timeout != nil){
            create.time = timeout as! String
        }
        create.cat = catName
        create.code = code
        
        self.navigationController?.pushViewController(create, animated: true)
    }
    
    @IBAction func pressBeber() {
        llamaWebServiceOTG(cat: "beber", catNumber: 100)
    }

    @IBAction func pressConcierto() {
        llamaWebServiceOTG(cat: "concierto", catNumber: 700)
    }
    
    @IBAction func pressBailar() {
        llamaWebServiceOTG(cat: "bailar", catNumber: 200)
    }

    @IBAction func pressComer() {
         llamaWebServiceOTG(cat: "comer", catNumber: 500)
    }
    
    @IBAction func pressCultivarnos() {
        llamaWebServiceOTG(cat: "arte", catNumber: 400)
    }

    @IBAction func pressGym() {
        llamaWebServiceOTG(cat: "entrenar", catNumber: 300)
    }
    
    @IBAction func pressJugar() {
        llamaWebServiceOTG(cat: "jugar", catNumber: 600)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
