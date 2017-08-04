//
//  PrincipalViewController.swift
//  MeetNeu
//
//  Created by Abraham Soto on 26/06/17.
//  Copyright © 2017 Abraham. All rights reserved.
//

import UIKit

class PrincipalViewController: UITabBarController, UITabBarControllerDelegate {
    var isSelectedCat = false

    override func viewDidLoad() {
        self.delegate = self
        super.viewDidLoad()
        let p2 = #imageLiteral(resourceName: "Plus2")
        //p2.withRenderingMode(.alwaysOriginal)
        self.viewControllers?[2].tabBarItem.selectedImage = #imageLiteral(resourceName: "Plus2X")
        self.viewControllers?[2].tabBarItem.image = p2
        
        // Do any additional setup after loading the view.
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
       /* if viewController.title == "cat"{
            if(isSelectedCat){
                print("se debe cambiar a anterior")
                tabBarController.selectedIndex = 0
                
            }
            isSelectedCat = true
            return true
        }
        isSelectedCat = false*/
        return true
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
