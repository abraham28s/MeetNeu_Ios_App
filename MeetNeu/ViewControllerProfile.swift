//
//  ViewControllerProfile.swift
//  MeetNeu
//
//  Created by Abraham Soto on 19/06/17.
//  Copyright © 2017 Abraham. All rights reserved.
//

import UIKit
import SDWebImage
import FacebookLogin
import FacebookCore

class ViewControllerProfile: UIViewController, GIDSignInUIDelegate {
    @IBOutlet weak var profileImg: UIImageView!

    @IBOutlet weak var profileName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Perfil"
        profileImg.sd_setImage(with: URL(string: "https://meetneu.com/\(UserLoggedWithMeetNeu.profile_img)"), placeholderImage: UIImage(named: "Perfil.png"))
        profileName.text = UserLoggedWithMeetNeu.short_name
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeDownFunc))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
        
        //llamaWebServiceNotif(idUsuario: UserLoggedWithMeetNeu.id, tabBarItem: ((self.parent?.parent as! UITabBarController).viewControllers?[3].tabBarItem)!)
        // Do any additional setup after loading the view.
    }
    @IBAction func touchDownArrow(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func swipeDownFunc(){
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func pressSignOutBut(_ sender: Any) {
        if(UserAppInfo.social_media == "3"){
            GIDSignIn.sharedInstance().signOut()
            
        }else if(UserAppInfo.social_media == "2"){
            let lm = LoginManager()
            lm.logOut()
        }
        UserAppInfo.isUserLoggedIn = false
        self.dismiss(animated: true, completion: nil)
        
        
    }
    @IBAction func pressInviteFriends(_ sender: Any) {
        let mensaje	=	"*URL para AppStore*"
        let items:	[Any]	=	[mensaje]
        let ac =	UIActivityViewController(activityItems:	items,	applicationActivities:	nil)
        ac.excludedActivityTypes =	[.print]
        self.present(ac,	animated:	true,	completion:	nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
