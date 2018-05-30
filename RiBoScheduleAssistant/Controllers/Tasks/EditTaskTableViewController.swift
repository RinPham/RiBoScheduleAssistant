//
//  EditTaskTableViewController.swift
//  RiBoScheduleAssistant
//
//  Created by Rin Pham on 3/14/18.
//  Copyright © 2018 Rin Pham. All rights reserved.
//

import UIKit
import DropDown

class EditTaskTableViewController: UITableViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var repeatButton: UIButton!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    var task: Task!
    let dropDown = DropDown()
    var time = Date()
    var repeatType = RepeatType.none
    var isEditTask = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        if Internet.haveInternet {
            self.getTask()
        } else {
            self.getTaskOffline()
        }
    }
    
    fileprivate func getTask() {
        self.showActivityIndicator()
        TaskService.getTask(with: self.task.id) { (data, statusCode, errorText) in
            self.stopActivityIndicator()
            if let task = data as? Task {
                self.task = task
            }
            self.setup()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            self.stopActivityIndicator()
        }
    }
    
    fileprivate func getTaskOffline() {
        if let rTask = RTask.getWithId(id: self.task.id) {
            self.task = Task.init(rTask)
            self.setup()
        }
    }
    
    fileprivate func setup() {
        self.navigationItem.title = "Reminder"
        self.titleTextField.text = self.task.title
        self.time = self.task.time
        self.repeatType = self.task.repeatType
        self.updateTimeLabel()
        
        self.repeatButton.cornerRadius(5, borderWidth: 1, color: .gray)
        
        self.dropDown.anchorView = self.repeatButton
        self.dropDown.dataSource = ["None", "Daily", "Weekly", "Weekdays", "Weekends", "Monthly"]
        self.dropDown.bottomOffset = CGPoint(x: 0, y: self.repeatButton.bounds.height)
        
        
        self.dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.repeatButton.setTitle(self.dropDown.dataSource[index], for: .normal)
            if let type = RepeatType(rawValue: index) {
                self.repeatType = type
                self.updateTimeLabel()
            }
        }
        self.dropDown.selectRow(self.task.repeatType.rawValue)
        self.repeatButton.setTitle(self.dropDown.dataSource[self.task.repeatType.rawValue], for: .normal)
    }

    fileprivate func showDatePicker() {
        switch self.repeatType {
        case .daily, .weekdays, .weekends:
            DatePickerDialog(buttonColor: App.Color.mainDarkColor, titleLabelColor: App.Color.mainDarkColor).show("Change Time", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", defaultDate: self.task.time, minimumDate: Date(), maximumDate: nil, datePickerMode: .time) { (date) in
                if let date = date {
                    self.time = date
                    self.updateTimeLabel()
                }
            }
        default:
            DatePickerDialog(buttonColor: App.Color.mainDarkColor, titleLabelColor: App.Color.mainDarkColor).show("Change Time", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", defaultDate: self.task.time, minimumDate: Date(), maximumDate: nil, datePickerMode: .dateAndTime) { (date) in
                if let date = date {
                    self.time = date
                    self.updateTimeLabel()
                }
            }
        }
    }
    
    fileprivate func updateTimeLabel() {
        switch self.repeatType {
        case .daily, .weekdays, .weekends:
            self.timeLabel.text = self.time.toString(format: "HH:mm")
        case .weekly:
            self.timeLabel.text = self.time.toString(format: "EEEE, HH:mm")
        default:
            self.timeLabel.text = self.time.toDateAndTimeString
        }
    }
    
    @IBAction func didTouchUpInsideEditButton(sender: UIBarButtonItem) {
        
        if Internet.haveInternet {
            var paramater: [String: Any] = [:]
            if self.task.title != self.titleTextField.text! {
                paramater["title"] = self.titleTextField.text!
            }
            if self.task.time != self.time {
                paramater["at_time"] = self.time.toDateAPIFormat
            }
            if self.task.repeatType != self.repeatType {
                paramater["repeat"] = self.repeatType.rawValue
            }
            
            TaskService.editTask(with: self.task, paramater: paramater) { (data, statusCode, errorText) in
                if let errorText = errorText {
                    self.showAlert(title: "Notice", message: errorText, option: .alert, btnCancel: UIAlertAction(title: "OK", style: .cancel, handler: nil), buttonNormal: [])
                    return
                } else if let updateTask = data as? Task {
                    NotificationService.cancelNotification(task: updateTask)
                    self.showAlertSuccess(message: "The reminder is updated!")
                    self.navigationController?.popViewController(animated: true)
                }
            }
        } else {
            if self.task.title != self.titleTextField.text! {
                self.task.title = self.titleTextField.text!
            }
            if self.task.time != self.time {
                self.task.time = self.time
            }
            if self.task.repeatType != self.repeatType {
                self.task.repeatType = self.repeatType
            }
            if let taskObject = RTask.getWithId(id: self.task.id) {
                if taskObject.isSync {
                    let rTask = RTask.initWithTask(task: self.task, action: 2, isSync: true)
                    rTask.update()
                } else {
                    let rTask = RTask.initWithTask(task: self.task, action: 1, isSync: false)
                    rTask.update()
                }
            }
            NotificationService.cancelNotification(task: self.task)
            self.showAlertSuccess(message: "The reminder is updated!")
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func didTouchUpInsideRepeatButton(_ sender: UIButton) {
        self.dropDown.show()
    }

    @IBAction func didTouchUpInsideDeleteButton(sender: UIButton) {
        //Cancel notification
        NotificationService.cancelNotification(task: self.task)
        
        if Internet.haveInternet {
            TaskService.deleteTask(with: self.task) { (data, statusCode, errorText) in
                if let errorText = errorText {
                    self.showAlert(title: "Notice", message: errorText, option: .alert, btnCancel: UIAlertAction(title: "OK", style: .cancel, handler: nil), buttonNormal: [])
                    return
                } else {
                    RTask.delete(id: self.task.id)
                    self.showAlertSuccess(message: "The reminder is deleted!")
                    self.navigationController?.popViewController(animated: true)
                }
            }
        } else {            
            if let check = RTask.getWithId(id: self.task.id) {
                if check.isSync {
                    let rTask = RTask.initWithTask(task: self.task, action: 3, isSync: true)
                    rTask.update()
                } else {
                    RTask.delete(id: self.task.id)
                }
            }
            self.showAlertSuccess(message: "The reminder is deleted!")
            self.navigationController?.popViewController(animated: true)
        }
       
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath == IndexPath(row: 0, section: 1) {
            self.showDatePicker()
        }
    }
}
