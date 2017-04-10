//
//  LoginViewController.swift
//  OMDBMovieApp
//
//  Created by Karumba Samuel on 24/02/2017.
//  Copyright © 2017 IBM. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import FBSDKLoginKit


class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var loginButton: FBSDKLoginButton!
    @IBOutlet weak var lblProfileName: UILabel!
    @IBOutlet weak var imgUserProfilePic: UIImageView!
    
    @IBAction func loginButtonClicked(_ sender: AnyObject) {
        
               
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        if (FBSDKAccessToken.current() == nil) {
            print("Not loged in..")
        } else {
            print("Loged in...")
        }
        
        let loginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        loginButton.center = self.view.center
        loginButton.delegate = self
        
        self.view.addSubview(loginButton)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: -- Facebook Login
    
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        
        if error == nil
        {
            print("login completed...")
            self.performSegue(withIdentifier: "showNew", sender: self)
        }
        else
        {
            print(error.localizedDescription)
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("User Loged out...")
    }
    
        
    
}
