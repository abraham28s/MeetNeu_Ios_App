//
//  ViewControllerNotifications.swift
//  MeetNeu
//
//  Created by Abraham Soto on 10/07/17.
//  Copyright © 2017 Abraham. All rights reserved.
//

import UIKit

class ViewControllerNotifications: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tablaPrincipal: UITableView!
    var arrNotif:[[String:String]] = []

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
            
             llamarWebService()
        }else{
            var vistaLogIn = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.tablaPrincipal.frame.height))
            vistaLogIn.clipsToBounds = true
            vistaLogIn.contentMode = .scaleToFill
            vistaLogIn.image = #imageLiteral(resourceName: "Porfavor_inicia_sesion")
            tablaPrincipal.tableFooterView = vistaLogIn
            tablaPrincipal.isScrollEnabled = false
        }

    }
    @IBAction func pressProfileButton(_ sender: Any) {
        if(UserAppInfo.isUserLoggedIn){
            self.navigationController?.pushViewController(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "profileSB") as UIViewController, animated: true)
        }else{
            
            self.navigationController?.pushViewController(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginSB") as UIViewController, animated: true)
        }
    }

    func llamarWebService(){
        let secondQueue = DispatchQueue.global()
        secondQueue.async {
            
            let urlStr = "https://www.meetneu.com/api/users/myNotifications/\(UserLoggedWithMeetNeu.id)"
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
                            self.arrNotif = []
                            self.jsonAcomodo(json: json!)
                            self.tablaPrincipal.reloadData()
                        }
                        
                    }catch let error as NSError{
                        print(error)
                    }
                }
            }).resume()
        }

    }
    
    func jsonAcomodo(json:NSDictionary){
        let notif = json.value(forKey: "notifications") as! NSArray
        for not in notif{
             var dic:[String:String] = [:]
            for camp in not as! NSDictionary{
                dic[camp.key as! String] = "\(camp.value)"
            }
            arrNotif.append(dic)
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "hola")
        cell.textLabel?.text = arrNotif[indexPath.row]["name"]
        cell.detailTextLabel?.text = arrNotif[indexPath.row]["text"]
        let url = URL(string: "https://www.meetneu.com/admin/event/\(String(describing: arrNotif[indexPath.row]["event_banner"]!))")
        print("https://www.meetneu.com/admin/event/\(String(describing: arrNotif[indexPath.row]["event_banner"]))")
        cell.imageView?.sd_setImage(with: url!, placeholderImage: UIImage.animatedImageNamed("loader-", duration: TimeInterval(exactly: 1.0)!))
        
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrNotif.count
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
