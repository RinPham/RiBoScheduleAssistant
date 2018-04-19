//
//  AppDelegate.swift
//  RiBoScheduleAssistant
//
//  Created by Rin Pham on 3/8/18.
//  Copyright © 2018 Rin Pham. All rights reserved.
//

import UIKit
import GoogleSignIn
import SocketRocket

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var currentUser: User!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        self.configureNavigationBarAppearance()
        GIDSignIn.sharedInstance().clientID = "310203758762-gmpbthekhtbh5d4e112agava0v585ate.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().serverClientID = "310203758762-vkc9hocnecbbcshsgf2ufctttp74pbgm.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().scopes = ["https://www.googleapis.com/auth/calendar"]
        GIDSignIn.sharedInstance().delegate = self
        
        if let dict = UserDefaults.standard.value(forKey: UserDefaultsKey.GOOGLE_USER) as? [String: String] {
            let user = User(dict)
            print("HAVE USER: \(user)")
            self.currentUser = user
            AppLinks.header = ["Authorization": "token \(user.token)"]
            //AppLinks.header = ["Authorization": "token QL7RXWUJKDIISITBDLPRUPQZAXD81XYEHZ4HPL5J"]
            self.changeRootViewToTabbar()
        }
        //self.connectSocket()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    }
    
    class func shared() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    fileprivate func changeRootViewToTabbar() {
        let mainTabbar = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: AppID.IDMainTabbarController) as? UITabBarController
        mainTabbar?.tabBar.items![0].selectedImage = #imageLiteral(resourceName: "ic_tb_task").withRenderingMode(.alwaysTemplate)
        mainTabbar?.tabBar.items![1].selectedImage = #imageLiteral(resourceName: "ic_tb_calendar").withRenderingMode(.alwaysTemplate)
        mainTabbar?.tabBar.items![2].selectedImage = #imageLiteral(resourceName: "ic_tb_settings").withRenderingMode(.alwaysTemplate)
        mainTabbar?.tabBar.tintColor = App.Color.mainColor
        self.configureTabBar()
        self.window?.rootViewController = mainTabbar
        
    }
    
    func configureNavigationBarAppearance() {
        UINavigationBar.appearance().barTintColor = App.Color.mainColor
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
    }
    
    func configureTabBar() {
        let tabbarItem = UITabBarItem.appearance()
        tabbarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: App.Color.mainColor], for: .selected)
        //tabbarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.white], for: .normal)
    }
    
    fileprivate func connectSocket() {
        
        let socket = SRWebSocket(url: URL(string: "ws://192.168.1.15:8888/message/5aabf738e3d8ee4a91e48f0d")!)
        socket?.open()
        socket?.delegate = self
        
    }
}

extension AppDelegate: SRWebSocketDelegate {
    func webSocket(_ webSocket: SRWebSocket!, didReceiveMessage message: Any!) {
        
    }
    
    func webSocketDidOpen(_ webSocket: SRWebSocket!) {
        print("OPEND")
        let dict = "{\"text\":\"hehe\"}"
        webSocket.send(dict)
    }
    
    
    
}

extension AppDelegate: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard error == nil else {
            print("Error Google Signin: \(error.localizedDescription)")
            return
        }
        if let code = user.serverAuthCode {
            UserService.loginGoogleAccount(code: code, completion: { (result, statusCode, errorText) in
                if errorText == nil, let userData = result as? User {
                    let dict = ["id": userData.id, "email": userData.email, "token": userData.token, "firstName": userData.firstName, "lastName": userData.lastName, "avatar": userData.avatar]
                    self.currentUser = userData
                    UserDefaults.standard.set(dict, forKey: UserDefaultsKey.GOOGLE_USER)
                    UserDefaults.standard.synchronize()
                    AppLinks.header = ["Authorization": "token \(userData.token)"]
                    self.changeRootViewToTabbar()
                }
            })
        }
        print(user.serverAuthCode)
        print(user.userID)
        print(user.profile.email)
        
    }
}
