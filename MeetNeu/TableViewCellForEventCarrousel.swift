//
//  TableViewCellForEventCarrousel.swift
//  MeetNeu
//
//  Created by Abraham Soto on 31/05/17.
//  Copyright © 2017 Abraham. All rights reserved.
//

import UIKit
import SDWebImage

class TableViewCellForEventCarrousel: UITableViewCell,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    var eventos:[[String:String]] = []
    var categoria:String = ""
    var color:String = ""
    var latitude = ""
    var longitug = ""
    var iconeus:[String:[String:[String]]] = [:]
    var seccion:Int = -1
    var vista:ViewControllerEventLists = ViewControllerEventLists()
    var OTG = [#imageLiteral(resourceName: "Bailar"),#imageLiteral(resourceName: "Jugar"),#imageLiteral(resourceName: "Entrenar"),#imageLiteral(resourceName: "Cultivarnos"),#imageLiteral(resourceName: "Beber"),#imageLiteral(resourceName: "Concierto"),#imageLiteral(resourceName: "Comer")]
    var OTGTitles = ["bailar","jugar","entrenar","arte","beber","concierto","comer"]
    var OTGCatInts = [200,600,300,400,100,700,500]
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
        
    convenience init(eventos:[[String:String]] = [[:],[:],[:],[:],[:],[:],[:]],categoria:String = "",color:String = "",iconosParam:[String:[String:[String]]]=[:],vista:ViewControllerEventLists,seccion:Int,latitud:String="",longitud:String="") {
        self.init(style: .default, reuseIdentifier: nil)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        var heig = 400
        if(seccion == 0){
            heig = heig-61
        }
        let col = UICollectionView(frame: CGRect(x: 0, y: 0, width: 375, height: heig),collectionViewLayout: layout)
        //print("hey")
        col.dataSource = self
        col.delegate = self
        col.backgroundColor = UIColor.white
        self.eventos = eventos
        self.categoria = categoria
        self.color = color
        self.longitug = longitud
        self.latitude = latitud
        self.vista = vista
        self.seccion = seccion
        //col.register(EventMiniature.self, forCellWithReuseIdentifier: "Cell")
        col.register(UINib(nibName: "EventMiniature", bundle: nil), forCellWithReuseIdentifier: "Cell")
       
        self.addSubview(col)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return eventos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! EventMiniature;
        if(seccion == 0){
            cell.mainImage.image = OTG[indexPath.row]
            cell.footViewSmall.isHidden = true
        }else{
        
        //cell.backgroundColor = UIColor.blue
        let miEvento = (eventos[indexPath.row] as NSDictionary)
        cell.backgroundColor = UIColor.white
        //cell.footViewSmall.backgroundColor = color
        cell.descLbl.text = miEvento.value(forKey: "name") as? String
        cell.priceLbl.text = miEvento.value(forKey: "cost") as? String
        let rating = miEvento.value(forKey: "overall_rating") as? String
        if(rating == "0.00"){
            cell.starImg.isHidden = true
            cell.ratingLbl.isHidden = true
        }else{
            cell.starImg.isHidden = false
            cell.ratingLbl.text = rating
            cell.ratingLbl.isHidden = false
        }
        
        
        
        let event_ban:String = (miEvento.value(forKey: "event_banner") as? String)!
        let urlImg = URL(string: "https://www.meetneu.com/\(event_ban)")
        cell.mainImage.sd_setImage(with: urlImg, placeholderImage: UIImage.animatedImageNamed("loader-", duration: TimeInterval(exactly: 1.0)!))
        }
        return cell
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
                    print(error!)
                }else{
                    do{
                        let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                        
                        DispatchQueue.main.async {
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
               //print(timeout)
        
        let create = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "createOnTheGoSB") as! ViewControllerCreateOnTheGo
        let timeout = json.value(forKey: "kickTime")
        if(timeout != nil){
            create.time = timeout as! String
        }

        create.cat = catName
        create.code = code
        
        self.vista.navigationController?.pushViewController(create, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(seccion == 0){
            llamaWebServiceOTG(cat: OTGTitles[indexPath.row], catNumber: OTGCatInts[indexPath.row])
        }else{
        let miEvento = (eventos[indexPath.row] as NSDictionary)
        
        let eventDetailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "eventDetailSB") as! ViewControllerEventDetail
        eventDetailVC.evento = miEvento.value(forKey: "id") as! String
        
        let tlabel = UILabel(frame: CGRect(x:0, y:0, width:200, height:40))
        tlabel.text = miEvento.value(forKey: "name") as? String
        tlabel.textColor = UIColor.black
        tlabel.font = UIFont(name: "Helvetica-Bold", size: 30.0)
        tlabel.backgroundColor = UIColor.clear
        tlabel.textAlignment = .center
        tlabel.adjustsFontSizeToFitWidth = true
        eventDetailVC.navigationItem.titleView = tlabel
        
        if(UserAppInfo.isUserLoggedIn){
            //Llamamos a prenroll
        }
        
        self.vista.navigationController?.pushViewController(eventDetailVC, animated: true)
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow:CGFloat = 1.60
        let hardCodedPadding:CGFloat = 5
        
        let itemWidth = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
        let itemHeight = collectionView.bounds.height - (2 * hardCodedPadding)
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
}
