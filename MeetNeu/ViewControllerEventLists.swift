//
//  ViewControllerEventLists.swift
//  MeetNeu
//
//  Created by Abraham Soto on 29/05/17.
//  Copyright © 2017 Abraham. All rights reserved.
//

import UIKit
import CoreLocation
import EasyTipView

class ViewControllerEventLists: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    @IBOutlet weak var TablaEventos: UITableView!
    
    var arreglotitles:[String] = []
    var dictColores:[String:String] = [:]
    var eventos:[String:Any] = [:]
    var iconeus:[String:[String:[String]]] = [:]
    let locationManager = CLLocationManager()
    var latitude = ""
    var longitug = ""
    var bandera = true
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ToolTips
        var preferences = EasyTipView.Preferences()
        preferences.drawing.font = UIFont(name: "Futura-Medium", size: 13)!
        preferences.drawing.foregroundColor = hexStringToUIColor(hex: "454545")
        preferences.drawing.backgroundColor = UIColor.white
        preferences.drawing.arrowPosition = EasyTipView.ArrowPosition.bottom
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        /*
         * Optionally you can make these preferences global for all future EasyTipViews
         */
        EasyTipView.globalPreferences = preferences
        
        ///
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.handleRefresh(refreshControl:)), for: UIControlEvents.valueChanged)
        TablaEventos.addSubview(refreshControl)
        TablaEventos.tableFooterView = UIView()
        TablaEventos.allowsSelection = false
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
                // Do any additional setup after loading the view.
    }
    
    @IBAction func didPressSearchButton(_ sender: Any) {
        self.present(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "searchSB") as UIViewController, animated: true, completion: nil)
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        // Do some reloading of data and update the table view's data source
        // Fetch more objects from a web service, for example...
        
        // Simply adding an object to the data source for this example
        
        //locationManager.startUpdatingLocation()
        consumeWebServices()
        //self.TablaEventos.reloadData()
        refreshControl.endRefreshing()
    }
    
    @IBAction func pressProfileButton(_ sender: Any) {
        //If user is logged in it should send to profile, if not, to log in
        self.definesPresentationContext = true
        self.modalPresentationStyle = .overCurrentContext
        if(UserAppInfo.isUserLoggedIn){
            self.present(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "profileSB") as UIViewController, animated: true, completion: nil)
        }else{
            self.present(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginSB") as UIViewController, animated: true, completion: nil)
            //self.navigationController?.pushViewController(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginSB") as UIViewController, animated: true)
        }
    }
    
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if(bandera){
        bandera = false
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        latitude = "\(locValue.latitude)"
        longitug = "\(locValue.longitude)"
        manager.stopUpdatingLocation()
        consumeWebServices()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        //self.consumeWebServices()
        if(UserAppInfo.isUserLoggedIn){
            do{
            let datos = try Data(contentsOf: URL(string:UserAppInfo.avatar)!)
            let imagen = UIImage(data: datos)
                profileBtn.setImage(imagen?.circleMasked, for: .normal)
                
            }catch let error {
                print(error.localizedDescription)
            }
        }else{
            profileBtn.setImage(#imageLiteral(resourceName: "Perfil"), for: .normal)
        }
    }
    @IBOutlet weak var profileBtn: UIButton!

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

    
    func consumeWebServices(){
        print("\(latitude),\(longitug)")
        let secondQueue = DispatchQueue.global()
        secondQueue.async {
            
            let urlStr = "https://meetneu.com/api/events"
            let urlObject = URL(string: urlStr)
            var req = URLRequest(url: urlObject!)
            req.addValue("meet_user_for_api", forHTTPHeaderField: "php-auth-user")
            req.addValue("soy_el_password123@", forHTTPHeaderField: "php-auth-pw")
            req.addValue(self.latitude, forHTTPHeaderField: "php-loc-lat")
            req.addValue(self.longitug, forHTTPHeaderField: "php-loc-lon")
            req.httpMethod = "GET"
            
            URLSession.shared.dataTask(with: req, completionHandler: {
                (data, response, error) in
                if(error != nil){
                    print("error")
                }else{
                    do{
                        let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
    
                        DispatchQueue.main.async {
                            //print(json!)
                            self.jsonAcomodo(json: json!)
                            self.TablaEventos.reloadData()
                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        }
                        
                    }catch let error as NSError{
                        print(error)
                    }
                }
            }).resume()
        }
    }
    
    func jsonAcomodo(json:NSDictionary){
        //let categorias = json.value(forKey: "category") as! NSArray
        
        let near = json.value(forKey: "near") as! NSDictionary
        
        let even_list_near_me = near.value(forKey: "event_list") as! NSArray
        if(even_list_near_me.count>0){
            var arrTemp:[[String:String]] = []
            for even in even_list_near_me {
                var dic:[String:String] = [:]
                for val in even as! NSDictionary{
                    dic[val.key as! String] = "\(val.value)"
                }
                arrTemp.append(dic)
            }
            eventos[near.value(forKey: "categoryName") as! String] = arrTemp
        }
        let eventList = json.value(forKey: "event_list") as! NSDictionary
        for ca in eventList {
            var arrTemp:[[String:String]] = []
            for even in ca.value as! NSArray {
                var dic:[String:String] = [:]
                for val in even as! NSDictionary{
                    dic[val.key as! String] = "\(val.value)"
                }
                arrTemp.append(dic)
            }
            eventos[ca.key as! String] = arrTemp
        }
        arreglotitles = (eventos as NSDictionary).allKeys as! [String]
        //if(UserAppInfo.isUserLoggedIn){
        arreglotitles.insert("On The Go", at: 0)
        //}
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return arreglotitles.count
    }

    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return arreglotitles[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            print("OTG")
            return TableViewCellForEventCarrousel(vista:self,seccion:indexPath.section,latitud:latitude,longitud:longitug)
        }
        let eventosPerCategori = (eventos as NSDictionary).value(forKey: arreglotitles[indexPath.section]) as! [[String : String]]?
        if eventosPerCategori == nil{
            return UITableViewCell()
        }else{
            print("Normie")
            return TableViewCellForEventCarrousel(eventos:eventosPerCategori!,categoria:arreglotitles[indexPath.section],vista:self,seccion:indexPath.section)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section == 0 ){
            return 400-61
        }
        return 400
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UIImage {
    var isPortrait:  Bool    { return size.height > size.width }
    var isLandscape: Bool    { return size.width > size.height }
    var breadth:     CGFloat { return min(size.width, size.height) }
    var breadthSize: CGSize  { return CGSize(width: breadth, height: breadth) }
    var breadthRect: CGRect  { return CGRect(origin: .zero, size: breadthSize) }
    var circleMasked: UIImage? {
        UIGraphicsBeginImageContextWithOptions(breadthSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        guard let cgImage = cgImage?.cropping(to: CGRect(origin: CGPoint(x: isLandscape ? floor((size.width - size.height) / 2) : 0, y: isPortrait  ? floor((size.height - size.width) / 2) : 0), size: breadthSize)) else { return nil }
        UIBezierPath(ovalIn: breadthRect).addClip()
        UIImage(cgImage: cgImage, scale: 1, orientation: imageOrientation).draw(in: breadthRect)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

