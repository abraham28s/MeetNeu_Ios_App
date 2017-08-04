//
//  ViewControllerMyEvents.swift
//  MeetNeu
//
//  Created by Abraham Soto on 26/06/17.
//  Copyright © 2017 Abraham. All rights reserved.
//

import UIKit
import SDWebImage

class ViewControllerMyEvents: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tablaPrincipal: UITableView!
    var eventos:[NSDictionary] = []

    override func viewDidLoad() {
        super.viewDidLoad()
                // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        if(UserAppInfo.isUserLoggedIn){
            //Si esta loggeado WOHOOOO
            tablaPrincipal.delegate = self
            tablaPrincipal.dataSource = self
            tablaPrincipal.allowsMultipleSelection = false
            tablaPrincipal.tableFooterView = UIView()
            tablaPrincipal.isScrollEnabled = true
            tablaPrincipal.register(UINib(nibName: "TableViewCellForMyEvents", bundle: nil), forCellReuseIdentifier: "a")
            do{
                let datos = try Data(contentsOf: URL(string:UserAppInfo.avatar)!)
                let imagen = UIImage(data: datos)
                profileBtn.setImage(imagen?.circleMasked, for: .normal)
                
            }catch let error {
                print(error.localizedDescription)
            }
            loadWebService()
        }else{
            profileBtn.setImage(#imageLiteral(resourceName: "Perfil"), for: .normal)
            var vistaLogIn = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.tablaPrincipal.frame.height))
            vistaLogIn.clipsToBounds = true
            vistaLogIn.contentMode = .scaleToFill
            vistaLogIn.image = #imageLiteral(resourceName: "Porfavor_inicia_sesion")
            tablaPrincipal.tableFooterView = vistaLogIn
            tablaPrincipal.isScrollEnabled = false
            loadWebService()
        }

    }
    
    
    @IBOutlet weak var profileBtn: UIButton!
    
    func loadWebService(){
        let secondQueue = DispatchQueue.global()
        secondQueue.async {
            
            let urlStr = "https://www.meetneu.com/api/users/myEvents/\(UserLoggedWithMeetNeu.id)"
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
                            //self.eventos = []
                            self.jsonAcomodo(json: json!)
                            self.tablaPrincipal.reloadData()
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
        let arrEventos: NSArray = json.value(forKey: "events") as! NSArray
        eventos = arrEventos as! [NSDictionary]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pressProfileButton(_ sender: Any) {
        if(UserAppInfo.isUserLoggedIn){
            self.present(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "profileSB") as UIViewController, animated: true, completion: nil)
        }else{
            self.present(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginSB") as UIViewController, animated: true, completion: nil)
        }
    }
    //Tabla
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "a") as! TableViewCellForMyEvents
        let miEvento = eventos[indexPath.row]
        let url = URL(string: "https://www.meetneu.com/admin/event/\(String(describing: miEvento.value(forKey: "event_banner")!))")
        //print(url!)
        celda.imgView.sd_setImage(with:url! , placeholderImage: UIImage.animatedImageNamed("loader-", duration: TimeInterval(exactly: 1.0)!))
        celda.tituloLb.text = miEvento.value(forKey: "name") as? String
        celda.fechaLb.text = miEvento.value(forKey: "event_date") as? String
        celda.horaLb.text = miEvento.value(forKey: "event_time") as? String
        //celda.precioLb.text =
        return celda
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventos.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 117
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let miEvento = (eventos[indexPath.row] as NSDictionary)
        let eventDetailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "eventDetailSB") as! ViewControllerEventDetail
        eventDetailVC.evento = "\(String(describing: miEvento.value(forKey: "event_id")!))"
        
        let tlabel = UILabel(frame: CGRect(x:0, y:0, width:200, height:40))
        tlabel.text = miEvento.value(forKey: "name") as? String
        tlabel.textColor = UIColor.black
        tlabel.font = UIFont(name: "Helvetica-Bold", size: 30.0)
        tlabel.backgroundColor = UIColor.clear
        tlabel.textAlignment = .center
        tlabel.adjustsFontSizeToFitWidth = true
        eventDetailVC.navigationItem.titleView = tlabel
        
        
        self.navigationController?.pushViewController(eventDetailVC, animated: true)
        
        
    }
    
    //
    
}
