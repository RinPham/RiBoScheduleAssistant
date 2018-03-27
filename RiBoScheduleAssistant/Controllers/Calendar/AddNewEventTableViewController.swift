//
//  AddNewEventTableViewController.swift
//  RiBoScheduleAssistant
//
//  Created by Rin Pham on 3/14/18.
//  Copyright © 2018 Rin Pham. All rights reserved.
//

import UIKit
import DatePickerDialog

class AddNewEventTableViewController: UITableViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var startsLabel: UILabel!
    @IBOutlet weak var endsLabel: UILabel!
    @IBOutlet weak var noteTextView: UITextView!
    
    var startsDay = Date()
    var endsDay = Date()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func setup() {
        self.startsLabel.text = self.startsDay.toDateAndTimeString
        self.endsLabel.text = self.endsDay.toDateAndTimeString
    }

    @IBAction func didTouchUpInsideSaveButton(sender: UIBarButtonItem) {
        let event = Event(id: "", title: self.titleTextField.text!, location: self.locationTextField.text!, startDate: self.startsDay, endDate: self.endsDay, des: self.noteTextView.text)
        EventService.createNewEvent(with: event) { (data, statusCode, errorText) in
            if let errorText = errorText {
                self.showAlert(title: "Notice", message: errorText, option: .alert, btnCancel: UIAlertAction(title: "OK", style: .cancel, handler: nil), buttonNormal: [])
                return
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
        
    }
    
    fileprivate func showStartDatePicker() {
        DatePickerDialog().show("Change Starts", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", defaultDate: self.startsDay, minimumDate: nil, maximumDate: nil, datePickerMode: .dateAndTime) { (date) in
            if let date = date {
                self.startsDay = date
                self.startsLabel.text = date.toDateAndTimeString
            }
        }
    }
    
    fileprivate func showEndsDatePicker() {
        DatePickerDialog().show("Change Time", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", defaultDate: self.endsDay, minimumDate: nil, maximumDate: nil, datePickerMode: .dateAndTime) { (date) in
            if let date = date {
                self.endsDay = date
                self.endsLabel.text = date.toDateAndTimeString
            }
        }
    }
    //MARK: - TableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath {
        case IndexPath(row: 0, section: 1):
            self.showStartDatePicker()
        case IndexPath(row: 1, section: 1):
            self.showEndsDatePicker()
        default:
            break
        }
    }
}
