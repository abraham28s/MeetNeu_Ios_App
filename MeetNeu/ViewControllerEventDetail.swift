//
//  ViewControllerEventDetail.swift
//  MeetNeu
//
//  Created by Abraham Soto on 05/06/17.
//  Copyright © 2017 Abraham. All rights reserved.
//

import UIKit
import EasyTipView

class ViewControllerEventDetail: UIViewController, ViewPagerDataSource, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var enterexitBtn: UIButton!
    @IBOutlet weak var tablaDesc: UITableView!
    @IBOutlet weak var paginadoImagenes: ViewPager!
    var evento:String = ""
    let arrSections = ["Qué haremos", "Qué incluirá","Dónde estaremos"]
    var headerTable = UIView()
    var arregloDescripciones:[String] = []
    var arrIconeus:[String:String] = [:]
    var date = ""
    var hour = ""
    var tipView:EasyTipView? = nil
    var lati = ""
    var long = ""
    var idEvent = ""
    var fullEnrollment = false
    var subEventIn = ""
    var participantId = ""
    
    @IBOutlet weak var hourLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    @IBOutlet var iconeusImgView: [UIButton]!
    
    func fullEnrollmentEventNormie(){
        let secondQueue = DispatchQueue.global()
        secondQueue.async {
            var request = URLRequest(url: URL(string: "https://www.meetneu.com/api/users/fullEnroll")!)
            request.httpMethod = "POST"
            request.addValue("meet_user_for_api", forHTTPHeaderField: "php-auth-user")
            request.addValue("soy_el_password123@", forHTTPHeaderField: "php-auth-pw")
            
            let postString = "participantId=\(self.participantId)"
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
                            print(json)
                            self.isUserEnroll()
                            //SE debe llamar a la otra pantalla
                            
                        }
                        
                    }catch let error as NSError{
                        print(error)
                    }
                }
            }).resume()
        }
    }
    
    @IBAction func pressEnter(_ sender: Any) {
        if UserAppInfo.isUserLoggedIn{
            //Full EnrollMent
            fullEnrollmentEventNormie()
        }else{
            let alert = alertaDefault(titulo: "Alerta", texto: "Para poder ingresar a un evento debes iniciar sesión")
            alert.addAction(UIAlertAction(title: "Ir a log in", style: .default, handler: {action in
                self.present(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginSB") as UIViewController, animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func pressChat(_ sender: Any) {
        if(UserAppInfo.isUserLoggedIn){
            if(fullEnrollment){
                //Presentamos el chat
                let chat = UIStoryboard(name: "Main",bundle: nil).instantiateViewController(withIdentifier: "chatSB") as! ViewControllerChat
                chat.idEvento = evento
                chat.idSubevento = subEventIn
                self.present(chat, animated: true, completion: nil)
            }else{
                let alert = alertaDefault(titulo: "Alerta", texto: "Para poder ingresar al chat de un evento debes entrar en el")
                alert.addAction(UIAlertAction(title: "Entrar", style: .default, handler: {action in
                    self.fullEnrollmentEventNormie()
                    
                }))
                self.present(alert, animated: true, completion: nil)
            }
            
        }else{
            let alert = alertaDefault(titulo: "Alerta", texto: "Para poder ingresar al chat de un evento debes iniciar sesión")
            alert.addAction(UIAlertAction(title: "Ir a log in", style: .default, handler: {action in
                self.present(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginSB") as UIViewController, animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func pressMap(_ sender: UIButton) {
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            UIApplication.shared.openURL(URL(string:
                "comgooglemaps://?q=\(lati),\(long)&zoom=17ruu7&views=traffic")!)
        } else {
            print("Can't use comgooglemaps://");
        }
        //print(url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationController?.navigationBar.topItem?.title = " "
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        tablaDesc.delegate = self
        tablaDesc.dataSource = self
        paginadoImagenes.dataSource = self
        tablaDesc.tableFooterView = UIView()
        tablaDesc.allowsSelection = false
        tablaDesc.allowsMultipleSelection = false
        tablaDesc.rowHeight = UITableViewAutomaticDimension
        tablaDesc.estimatedRowHeight = 140
        paginadoImagenes.backgroundColor = UIColor.black
        //tablaDesc.backgroundColor = UIColor.black
        consumeWebService()
        
        //Checamos si existe un usuario loggeado para hacer el prenro
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        let botonCompartir = UIBarButtonItem(image: #imageLiteral(resourceName: "Share_white (2)"), style: .plain, target: self, action: #selector(pressShare))
        self.navigationItem.rightBarButtonItem = botonCompartir
        if(UserAppInfo.isUserLoggedIn){
            //Si si, vamos a hacer el prenrollment
            prenroll()
            
            isUserEnroll()
        }
    }
    
    func isUserEnroll(){
        let secondQueue = DispatchQueue.global()
        secondQueue.async {
            var request = URLRequest(url: URL(string: "https://www.meetneu.com/api/users/isEnrolled/\(UserLoggedWithMeetNeu.id)/\(self.evento)/1")!)
            request.httpMethod = "GET"
            print(request)
            request.addValue("meet_user_for_api", forHTTPHeaderField: "php-auth-user")
            request.addValue("soy_el_password123@", forHTTPHeaderField: "php-auth-pw")
            
            URLSession.shared.dataTask(with: request, completionHandler: {
                (data, response, error) in
                if(error != nil){
                    print(error)
                }else{
                    do{
                        let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                        
                        DispatchQueue.main.async {
                            print(json!)
                            let regreso = (json!.value(forKey: "isEnrolled") as! Bool)
                            if regreso {
                                self.enterexitBtn.setImage(#imageLiteral(resourceName: "Exit"), for: .normal)
                                self.fullEnrollment = true
                            }
                            
                        }
                        
                    }catch let error as NSError{
                        print(error)
                    }
                }
            }).resume()
        }
    }
    
    func prenroll(){
        let secondQueue = DispatchQueue.global()
        secondQueue.async {
            var request = URLRequest(url: URL(string: "https://www.meetneu.com/api/events/preenroll")!)
            request.httpMethod = "POST"
            request.addValue("meet_user_for_api", forHTTPHeaderField: "php-auth-user")
            request.addValue("soy_el_password123@", forHTTPHeaderField: "php-auth-pw")
            
            let postString = "eventId=\(self.evento)&userId=\(UserLoggedWithMeetNeu.id)"
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
                            print("Ya se hizo preenroll")
                            print("\n\n\n\(json)\n\n\n")
                            self.subEventIn = "\(json?.value(forKey: "subEventId") as! Int)"
                            self.participantId = "\(json?.value(forKey: "participantId") as! Int)"
                        }
                        
                    }catch let error as NSError{
                        print(error)
                    }
                }
            }).resume()
        }
    }
    
    func consumeWebService(){
        let secondQueue = DispatchQueue.global()
        secondQueue.async {
            
            let urlStr = "https://meetneu.com/api/events/\(self.evento)"
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
                            self.decode(json: json!)
                            self.tablaDesc.reloadData()
                            //self.tablaDesc.layoutIfNeeded()
                            var ind = 0
                            for iconito in self.arrIconeus{
                                //print(iconito.key)
                                self.iconeusImgView[ind].setImage(UIImage(named: GlobalVariables.diccionarioIconeus[iconito.key]!), for: .normal)
                                self.iconeusImgView[ind].tag = Int(iconito.key)!
                                self.iconeusImgView[ind].addTarget(self, action: #selector(self.showEasyTip(_:)), for: .touchDown)
                                self.iconeusImgView[ind].addTarget(self, action: #selector(self.hideEasyTip), for: [.touchDragExit,.touchUpInside])
                                ind = ind + 1
                            }
                            self.dateLbl.text = self.date
                            self.hourLbl.text = self.hour
                            
                        }
                        
                    }catch let error as NSError{
                        print(error)
                    }
                }
            }).resume()
        }

    }
    
    func showEasyTip(_ sender:UIButton){
        if(tipView == nil){
            tipView = EasyTipView(text: (arrIconeus as NSDictionary).value(forKey: "\(sender.tag)") as! String)
            tipView?.show(forView: sender, withinSuperview: self.view)
        }
        
    }
    
    func hideEasyTip(){
        tipView?.dismiss()
        tipView = nil
    }
    
    func decode(json:NSDictionary){
        let descrip = json.value(forKey: "descriptions") as! NSArray
        
        for ind in 0...2{
            arregloDescripciones.append((descrip[ind] as! NSDictionary).value(forKey: "text") as! String)
        }
        
        let iconeusFromWeb = json.value(forKey: "iconeus") as! NSArray
        
        for iconWeb in iconeusFromWeb{
            let icon = iconWeb as! NSDictionary
            arrIconeus["\(String(describing: icon.value(forKey: "id_image")!))"] = icon.value(forKey: "tooltip") as? String
        }
        let model = json.value(forKey: "model") as! NSDictionary
        
        date = model.value(forKey: "event_date") as! String
        hour = "\(model.value(forKey: "event_time")!) - \(model.value(forKey: "event_time_end")!)"
        
        lati = model.value(forKey: "latitude") as! String
        long = model.value(forKey: "longitude") as! String
        idEvent = "\(String(describing: model.value(forKey: "id")!))"
    }
    
    
    
    func pressShare(){
        let mensaje	=	"https://www.meetneu.com/events/\(idEvent)"
        let items:	[Any]	=	[mensaje]
        let ac =	UIActivityViewController(activityItems:	items,	applicationActivities:	nil)
        ac.excludedActivityTypes =	[.print]
        self.present(ac,	animated:	true,	completion:	nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /////////////// PageView
    func numberOfItems(viewPager: ViewPager) -> Int {
        return 4
    }
    
    func viewAtIndex(viewPager: ViewPager, index: Int, view: UIView?) -> UIView {
        let ima = UIImageView(frame: paginadoImagenes.frame)
        let urlImg = URL(string: "https://www.meetneu.com/admin/event/banners/\(evento)/\(index+1).jpg")
        ima.contentMode = .scaleAspectFit
        ima.clipsToBounds = true
        ima.sd_setImage(with: urlImg, placeholderImage: UIImage.animatedImageNamed("loader-", duration: TimeInterval(exactly: 1.0)!))
        
        return ima
    }
    
    func didSelectedItem(index: Int) {
        //print(index)
    }
    ///////////
    ///Table View
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        if(arregloDescripciones.count > indexPath.section){
            cell.textLabel?.text = arregloDescripciones[indexPath.section]
            
        }else{
            
            cell.textLabel?.text = "Cargando"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vista = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 20))
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 20))
        label.text = arrSections[section]
        label.textColor = UIColor.white
        label.backgroundColor = hexStringToUIColor(hex: "1483A2")
        vista.addSubview(label)
        return vista
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
   
    ////////
    

}
