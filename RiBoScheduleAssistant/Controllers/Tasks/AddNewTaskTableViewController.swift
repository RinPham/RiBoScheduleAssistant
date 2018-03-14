//
//  AddNewTaskTableViewController.swift
//  RiBoScheduleAssistant
//
//  Created by Rin Pham on 3/14/18.
//  Copyright © 2018 Rin Pham. All rights reserved.
//

import UIKit
import RealmSwift
import DatePickerDialog

class AddNewTaskTableViewController: UITableViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var time = Date()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func setup() {
        self.timeLabel.text = self.time.toTimeString
    }
    
    @IBAction func didTouchUpInsideSaveButton(sender: UIBarButtonItem) {
        self.saveTaskToRealm()
        self.navigationController?.popViewController(animated: true)
    }
    
    fileprivate func saveTaskToRealm() {
        let newTask = RTask(value: ["id": UUID().uuidString, "title": self.titleTextField.text!, "time": self.time, "des": self.descriptionTextView.text, "isDone": false])
        let realm = try! Realm()
        try! realm.write {
            realm.add(newTask)
        }
    }
    
    fileprivate func showDatePicker() {
        DatePickerDialog().show("Change Time", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", defaultDate: self.time, minimumDate: nil, maximumDate: nil, datePickerMode: .dateAndTime) { (date) in
            if let date = date {
                self.time = date
                self.setup()
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath == IndexPath(row: 1, section: 0) {
            self.showDatePicker()
        }
    }
}
