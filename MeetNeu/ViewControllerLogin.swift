//
//  ViewControllerLogin.swift
//  MeetNeu
//
//  Created by Abraham Soto on 04/06/17.
//  Copyright © 2017 Abraham. All rights reserved.
//

import UIKit
import FacebookLogin

class ViewControllerLogin: UIViewController,GIDSignInUIDelegate,LoginButtonDelegate {
    @IBOutlet weak var signInButton: GIDSignInButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        NotificationCenter.default.addObserver(self,selector: #selector(loginGoogleWithMeet),name: NSNotification.Name(rawValue: "notif"),object: nil)
        
        let loginButton = LoginButton(readPermissions: [ .publicProfile,.email ])
        loginButton.center = view.center
        loginButton.delegate = self
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeDownFunc))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
        
        view.addSubview(loginButton)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func pressDownArrow(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func swipeDownFunc(){
        self.dismiss(animated: true, completion: nil)
    }

    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        print("bai")
    }
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        let graphRequest:FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"first_name,email, picture.type(large),gender,name"])
        
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                print("Error: \(error)")
            }
            else
            {
                let data:[String:AnyObject] = result as! [String : AnyObject]
                //print(data)
               
                UserAppInfo.isUserLoggedIn = true
                UserAppInfo.email = data["email"] as! String
                UserAppInfo.social_media = "2"
                let pictureData = data["picture"] as! NSDictionary
              
                UserAppInfo.avatar = (pictureData.value(forKey: "data")! as! NSDictionary).value(forKey: "url")! as! String
                UserAppInfo.social_id_no = data["id"] as! String
                UserAppInfo.gender = data["gender"] as! String
                UserAppInfo.complete_name = data["name"] as! String
                UserAppInfo.first_name = data["first_name"] as! String
                self.loginGoogleWithMeet()
                
            }
        })
        
        
    }
    
    
    func loginGoogleWithMeet(){
        
        let secondQueue = DispatchQueue.global()
        secondQueue.async {
            
            var request = URLRequest(url: URL(string: "https://meetneu.com/api/login")!)
            request.httpMethod = "POST"
            request.addValue("meet_user_for_api", forHTTPHeaderField: "php-auth-user")
            request.addValue("soy_el_password123@", forHTTPHeaderField: "php-auth-pw")
            let postString = "avatar=\(UserAppInfo.avatar)&social_media=\(UserAppInfo.social_media)&email=\(UserAppInfo.email)&social_id_no=\(UserAppInfo.social_id_no)&gender=\(UserAppInfo.gender)&complete_name=\(UserAppInfo.complete_name)&first_name=\(UserAppInfo.first_name)&platform=\(UserAppInfo.platform)&is_debug=\(UserAppInfo.is_debug)"
            request.httpBody = postString.data(using: .utf8)
            
            URLSession.shared.dataTask(with: request, completionHandler: {
                (data, response, error) in
                if(error != nil){
                    print("error")
                }else{
                    do{
                        let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                        
                        DispatchQueue.main.async {
                            let usua = json?.value(forKey: "user") as! NSDictionary
                            UserLoggedWithMeetNeu.email = usua.value(forKey: "email") as! String
                            UserLoggedWithMeetNeu.first_name = usua.value(forKey: "first_name") as! String
                            UserLoggedWithMeetNeu.gender = "\(String(describing: usua.value(forKey: "gender")))"
                            UserLoggedWithMeetNeu.id = "\(String(describing: usua.value(forKey: "id")!))"
                            UserLoggedWithMeetNeu.last_name = usua.value(forKey: "last_name") as! String
                            UserLoggedWithMeetNeu.profile_img = usua.value(forKey: "profile_img") as! String
                            UserLoggedWithMeetNeu.short_name = usua.value(forKey: "short_name") as! String
                            UserLoggedWithMeetNeu.social_id_no = usua.value(forKey: "social_id_no") as! String
                            
                            let newVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "profileSB") as UIViewController
                            /*var vcArray = self.navigationController?.viewControllers
                            vcArray!.removeLast()
                            vcArray!.append(newVc)*/
                            //self.navigationController?.pushViewController(newVc, animated: true)
                            //(self.parent as! ViewControllerEventLists).consumeWebServices()
                            print(self.parent)
                            self.dismiss(animated: true, completion: nil)
                            //self.present(newVc, animated: true, completion: nil)
                            
                        }
                        
                    }catch let error as NSError{
                        print(error)
                    }
                }
            }).resume()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
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
