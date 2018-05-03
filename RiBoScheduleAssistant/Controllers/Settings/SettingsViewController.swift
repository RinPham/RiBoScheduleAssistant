//
//  SettingsViewController.swift
//  RiBoScheduleAssistant
//
//  Created by Rin Pham on 4/11/18.
//  Copyright © 2018 Rin Pham. All rights reserved.
//

import UIKit
import PINRemoteImage
import GoogleSignIn

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    fileprivate func setup() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    fileprivate func logOut() {
        self.showAlert(title: "Log Out", message: "Are you sure you want to Log out?", option: .alert, btnCancel: UIAlertAction(title: "Cancel", style: .cancel, handler: nil), buttonNormal: [UIAlertAction(title: "Log Out", style: .destructive, handler: { (action) in
            GIDSignIn.sharedInstance().signOut()
            if let signInVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: AppID.IDLogInViewController) as? LogInViewController {
                AppDelegate.shared().window?.rootViewController = signInVC
                AppDelegate.shared().currentUser = nil
                UserDefaults.standard.set(nil, forKey: UserDefaultsKey.GOOGLE_USER)
                UserDefaults.standard.synchronize()
                AppLinks.header = [:]
            }
        })])
    }
}

extension SettingsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AppID.IDUserInfoTableViewCell, for: indexPath) as? UserInfoTableViewCell else { return UITableViewCell() }
            if let dict = UserDefaults.standard.value(forKey: UserDefaultsKey.GOOGLE_USER) as? [String: String] {
                let user = User(dict)
                cell.nameLabel.text = user.firstName + " " + user.lastName
                cell.emailLabel.text = user.email
                cell.avatarImageView.pin_setImage(from: URL.init(string: user.avatar), placeholderImage: #imageLiteral(resourceName: "ic_avatar"))
            }
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        default:
            return UITableViewCell()
        }
    }
    
}

extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 190
        default:
            return 0
        }
    }
    
}

extension SettingsViewController: UserInfoTableViewCellDelegate {
    
    func didTouchUpInsideLogOutButton(_ cell: UserInfoTableViewCell, sender: UIButton) {
        self.logOut()
    }
}
