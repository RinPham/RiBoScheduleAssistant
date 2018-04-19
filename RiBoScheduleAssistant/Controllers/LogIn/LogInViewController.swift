//
//  LogInViewController.swift
//  RiBoScheduleAssistant
//
//  Created by Rin Pham on 3/21/18.
//  Copyright © 2018 Rin Pham. All rights reserved.
//

import UIKit
import GoogleSignIn

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
    
    fileprivate func setup() {
        self.logInButton.layer.cornerRadius = 20
        GIDSignIn.sharedInstance().uiDelegate = self
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
