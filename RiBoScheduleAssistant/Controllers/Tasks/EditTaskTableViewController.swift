//
//  EditTaskTableViewController.swift
//  RiBoScheduleAssistant
//
//  Created by Rin Pham on 3/14/18.
//  Copyright © 2018 Rin Pham. All rights reserved.
//

import UIKit
import DatePickerDialog

class EditTaskTableViewController: UITableViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var task: Task!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func setup() {
        self.titleTextField.text = self.task.title
        self.timeLabel.text = self.task.time.toDateAndTimeString
        self.descriptionTextView.text = self.task.content
    }

    fileprivate func showDatePicker() {
        DatePickerDialog().show("Change Time", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", defaultDate: self.task.time, minimumDate: nil, maximumDate: nil, datePickerMode: .dateAndTime) { (date) in
            if let date = date {
                self.task.time = date
                self.timeLabel.text = self.task.time.toDateAndTimeString
            }
        }
    }
    
    @IBAction func didTouchUpInsideEditButton(sender: UIBarButtonItem) {
        TaskService.editTask(with: Task(id: self.task.id, title: self.titleTextField.text!, time: self.task.time, content: self.descriptionTextView.text, isDone: self.task.isDone, userId: self.task.userId, intentId: self.task.intentId)) { (data, statusCode, errorText) in
            if let errorText = errorText {
                self.showAlert(title: "Notice", message: errorText, option: .alert, btnCancel: UIAlertAction(title: "OK", style: .cancel, handler: nil), buttonNormal: [])
                return
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }

    @IBAction func didTouchUpInsideDeleteButton(sender: UIButton) {
        TaskService.deleteTask(with: self.task) { (data, statusCode, errorText) in
            if let errorText = errorText {
                self.showAlert(title: "Notice", message: errorText, option: .alert, btnCancel: UIAlertAction(title: "OK", style: .cancel, handler: nil), buttonNormal: [])
                return
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath == IndexPath(row: 1, section: 0) {
            self.showDatePicker()
        }
    }
}
