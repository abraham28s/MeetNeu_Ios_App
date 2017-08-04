//
//  ViewControllerSearch.swift
//  MeetNeu
//
//  Created by Abraham Soto on 27/07/17.
//  Copyright © 2017 Abraham. All rights reserved.
//

import UIKit

class ViewControllerSearch: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tablaPrincipal: UITableView!
    @IBOutlet weak var searchTxt: UITextField!
    var categorias:[String] = []
    var eventos:[String:Any] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        tablaPrincipal.tableFooterView = UIView()
        tablaPrincipal.register(UINib(nibName: "TableViewCellForMyEvents", bundle: nil), forCellReuseIdentifier: "b")
        // Do any additional setup after loading the view.
    }
    
    @IBAction func didCrossButtonPress(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func consumeWebServices(cadena:String){
        let secondQueue = DispatchQueue.global()
        secondQueue.async {
            
            let urlStr = "https://www.meetneu.com/api/events/search?searchStr=\(cadena)"
            let urlObject = URL(string: urlStr)
            var req = URLRequest(url: urlObject!)
            req.addValue("meet_user_for_api", forHTTPHeaderField: "php-auth-user")
            req.addValue("soy_el_password123@", forHTTPHeaderField: "php-auth-pw")
            req.httpMethod = "GET"
            print(req)
            URLSession.shared.dataTask(with: req, completionHandler: {
                (data, response, error) in
                if(error != nil){
                    print("error")
                }else{
                    do{
                        let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                        
                        DispatchQueue.main.async {
                            
                            self.parseaJson(json: json!)
                            self.tablaPrincipal.reloadData()
                        }
                        
                    }catch let error as NSError{
                        print(error)
                    }
                }
            }).resume()
        }
    }
    
    func parseaJson(json:NSDictionary){
        
        let eventList = json.value(forKey: "event_list") as?NSDictionary
        eventos = [:]
        if(eventList != nil){
            categorias = eventList?.allKeys as! [String]
            print(categorias)
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
            print(eventos)
        }else{
            categorias = []
            self.present(alertaDefault(titulo: "Alerta", texto: "No hay eventos que coincidan con tu busqueda"), animated: true, completion: nil)
        }
        
        
    }
    
    @IBAction func TxtOnChange(_ sender: UITextField) {
        if(sender.text != ""){
            consumeWebServices(cadena: sender.text!)
        
        }
        
    }
    
    //
    func numberOfSections(in tableView: UITableView) -> Int {
        return categorias.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return categorias[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 117
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "b") as! TableViewCellForMyEvents
        let myEvent = ((eventos[categorias[indexPath.section]]) as! NSArray)[indexPath.row] as! NSDictionary
        let url = URL(string: "https://www.meetneu.com/\(String(describing: myEvent.value(forKey: "event_banner")!))")
        celda.imgView.sd_setImage(with:url! , placeholderImage: UIImage.animatedImageNamed("loader-", duration: TimeInterval(exactly: 1.0)!))
        celda.tituloLb.text = myEvent.value(forKey: "name") as? String
        celda.fechaLb.text = myEvent.value(forKey: "event_date") as? String
        celda.horaLb.text = myEvent.value(forKey: "event_time") as? String
        celda.precioLb.isHidden = false
        celda.precioLb.text = myEvent.value(forKey: "cost") as? String
        return celda
    }
    
    //
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
