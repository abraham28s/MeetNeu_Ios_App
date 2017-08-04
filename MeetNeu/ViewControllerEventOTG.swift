//
//  ViewControllerEventOTG.swift
//  MeetNeu
//
//  Created by Abraham Soto on 23/07/17.
//  Copyright © 2017 Abraham. All rights reserved.
//

import UIKit

class ViewControllerEventOTG: UIViewController,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    var cat = ""
    
    @IBOutlet weak var headerImgVw: UIImageView!
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var participantsCollectionView: UICollectionView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        switch cat {
        case "beber":
            headerImgVw.image = #imageLiteral(resourceName: "Head_beber")
            titleLb.text = "Quitate lo aburrido y tomate unos tragos coquetos"
            titleLb.textColor = hexStringToUIColor(hex: "bc2bc9")
        case "arte":
            headerImgVw.image = #imageLiteral(resourceName: "Head_arte")
            titleLb.text = "Descubre, aprende y diviertete viviendo esta experiencia"
            titleLb.textColor = hexStringToUIColor(hex: "1daa4c")
            
        case "entrenar":
            headerImgVw.image = #imageLiteral(resourceName: "Head_Entrenar")
            titleLb.text = "Mejora tu rendimiento fisico entrenando"
            titleLb.textColor = hexStringToUIColor(hex: "2ab5ca")
        case "jugar":
            headerImgVw.image = #imageLiteral(resourceName: "Head_Jugar")
            titleLb.text = "¿Aburrido? Diviertete con este partido de"
            titleLb.textColor = hexStringToUIColor(hex: "296dd2")
        case "concierto":
            headerImgVw.image = #imageLiteral(resourceName: "Head_Concierto")
            titleLb.text = "Grita y canta con todas tus fuerzas a lado de"
            titleLb.textColor = hexStringToUIColor(hex: "28e6b6")
        case "comer":
            headerImgVw.image = #imageLiteral(resourceName: "Head_Comer")
            titleLb.text = "¿Hambre? Llena el estomago y alegra el corazón"
            titleLb.textColor = hexStringToUIColor(hex: "f38c15")
        case "bailar":
            headerImgVw.image = #imageLiteral(resourceName: "Head_Bailar")
            titleLb.text = "Usa tus mejores pass y deslumbra a todos en la pista"
            titleLb.textColor = hexStringToUIColor(hex: "e8359b")
        default:
            print("nothing")
        }
        
        participantsCollectionView.register(UINib(nibName: "ProfileMiniature", bundle: nil), forCellWithReuseIdentifier: "pcell")
        // Do any additional setup after loading the view.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow:CGFloat = 4
        let hardCodedPadding:CGFloat = 5
        
        let itemWidth = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
        let itemHeight = collectionView.bounds.height - (2 * hardCodedPadding)
        
        return CGSize(width: itemWidth, height: itemHeight)
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
