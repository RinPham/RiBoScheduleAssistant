//
//  AddNewTaskTableViewController.swift
//  RiBoScheduleAssistant
//
//  Created by Rin Pham on 3/14/18.
//  Copyright © 2018 Rin Pham. All rights reserved.
//

import UIKit
import RealmSwift

class AddNewTaskTableViewController: UITableViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var time = Date()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTouchUpInsideSaveButton(sender: UIBarButtonItem) {
        self.saveTaskToRealm()
    }
    
    fileprivate func saveTaskToRealm() {
        let newTask = RTask(value: ["id": UUID().uuidString, "title": self.titleTextField.text!, "time": self.time, "des": self.descriptionTextView.text, "isDone": false])
        let realm = try! Realm()
        try! realm.write {
            realm.add(newTask)
        }
    }

    // MARK: - Table view data source


}
