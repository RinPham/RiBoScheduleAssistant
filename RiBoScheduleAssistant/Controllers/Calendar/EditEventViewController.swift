//
//  EditEventViewController.swift
//  RiBoScheduleAssistant
//
//  Created by Rin Pham on 3/27/18.
//  Copyright © 2018 Rin Pham. All rights reserved.
//

import UIKit
import DatePickerDialog

class EditEventViewController: UITableViewController {

    //MARK: - IBOutlet
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var startsLabel: UILabel!
    @IBOutlet weak var endsLabel: UILabel!
    @IBOutlet weak var noteTextView: UITextView!
    
    var event: Event!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func setup() {
        self.startsLabel.text = self.event.startDate.toDateAndTimeString
        self.endsLabel.text = self.event.endDate.toDateAndTimeString
        self.noteTextView.text = self.event.des
        self.titleTextField.text = self.event.title
        self.locationTextField.text = self.event.location
    }
    
    @IBAction func didTouchUpInsideSaveButton(sender: UIBarButtonItem) {
        
        self.event.des = self.noteTextView.text
        self.event.title = self.titleTextField.text!
        self.event.location = self.locationTextField.text!
        
        EventService.editEvent(with: self.event) { (data, statusCode, errorText) in
            if let errorText = errorText {
                self.showAlert(title: "Notice", message: errorText, option: .alert, btnCancel: UIAlertAction(title: "OK", style: .cancel, handler: nil), buttonNormal: [])
                return
            } else {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
        
    }
    
    @IBAction func didTouchUpInsideDeleteButton(sender: UIButton) {
        EventService.deleteEvent(with: self.event) { (data, statusCode, errorText) in
            if let errorText = errorText {
                self.showAlert(title: "Notice", message: errorText, option: .alert, btnCancel: UIAlertAction(title: "OK", style: .cancel, handler: nil), buttonNormal: [])
                return
            } else {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    fileprivate func showStartDatePicker() {
        DatePickerDialog().show("Change Starts", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", defaultDate: self.event.startDate, minimumDate: nil, maximumDate: nil, datePickerMode: .dateAndTime) { (date) in
            if let date = date {
                self.event.startDate = date
                self.startsLabel.text = date.toDateAndTimeString
            }
        }
    }
    
    fileprivate func showEndsDatePicker() {
        DatePickerDialog().show("Change Time", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", defaultDate: self.event.endDate, minimumDate: nil, maximumDate: nil, datePickerMode: .dateAndTime) { (date) in
            if let date = date {
                self.event.endDate = date
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
