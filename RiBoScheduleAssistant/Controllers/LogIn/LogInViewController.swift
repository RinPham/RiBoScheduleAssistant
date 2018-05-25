//
//  LogInViewController.swift
//  RiBoScheduleAssistant
//
//  Created by Rin Pham on 3/21/18.
//  Copyright © 2018 Rin Pham. All rights reserved.
//

import UIKit
import GoogleSignIn
import UserNotifications

class LogInViewController: UIViewController {

    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var hostTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let _ = self.checkReachability()
    }
    
    fileprivate func setup() {
        
        self.logInButton.layer.cornerRadius = 20
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
        }
    
    }
    
    @IBAction func didTouchUpInsideLogInButton(_ sender: UIButton) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func didTouchUpInsideSetupButton(_ sender: UIButton) {
        if let host = self.hostTextField.text, host != "" {
            AppLinks.LINK_API = "http://" + host + "/api/v1"
            AppLinks.LINK_SOCKET = "ws://" + host + "/"
            self.hostTextField.resignFirstResponder()
        }
    }
    
}

extension LogInViewController: GIDSignInUIDelegate {
    // pressed the Sign In button
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        
    }
    
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension LogInViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard error == nil else {
            print("Error Google Signin: \(error.localizedDescription)")
            self.showAlert(title: "Notice", message: "Error Google Signin: \(error.localizedDescription)", option: .alert, btnCancel: UIAlertAction(title: "OK", style: .cancel, handler: nil), buttonNormal: [])
            return
        }
        if let code = user.serverAuthCode {
            self.showActivityIndicator()
            UserService.loginGoogleAccount(code: code, completion: { (result, statusCode, errorText) in
                if errorText == nil, let userData = result as? User {
                    let dict = ["id": userData.id, "email": userData.email, "token": userData.token, "firstName": userData.firstName, "lastName": userData.lastName, "avatar": userData.avatar]
                    AppDelegate.shared().currentUser = userData
                    UserDefaults.standard.set(dict, forKey: UserDefaultsKey.GOOGLE_USER)
                    UserDefaults.standard.synchronize()
                    AppLinks.header = ["Authorization": "token \(userData.token)"]
                    AppDelegate.shared().changeRootViewToTabbar()
                }
                self.stopActivityIndicator()
            })
        } else {
            self.showAlert(title: "Notice", message: "Error Google Signin", option: .alert, btnCancel: UIAlertAction(title: "OK", style: .cancel, handler: nil), buttonNormal: [])
        }
        print(user.serverAuthCode)
        print(user.userID)
        print(user.profile.email)
        
    }
}
