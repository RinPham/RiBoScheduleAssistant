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
    var startDate = Date()
    var endDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func setup() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.tableView.addGestureRecognizer(tapGesture)
        self.noteTextView.delegate = self
        self.noteTextView.textColor = UIColor.lightGray
        self.noteTextView.text = "Notes"
        
        self.startDate = self.event.startDate
        self.endDate = self.event.endDate
        self.startsLabel.text = self.startDate.toDateAndTime2String
        self.updateEndDateLabel()
        self.noteTextView.text = self.event.des
        self.titleTextField.text = self.event.title
        self.locationTextField.text = self.event.location
    }
    
    @objc func dismissKeyboard() {
        self.tableView.endEditing(true)
    }
    
    fileprivate func updateEndDateLabel() {
        if Calendar.current.isDate(self.startDate, inSameDayAs: self.endDate) {
            self.endsLabel.text = self.endDate.toTimeString
        } else {
            self.endsLabel.text = self.endDate.toDateAndTime2String
        }
    }
    
    @IBAction func didTouchUpInsideSaveButton(sender: UIBarButtonItem) {
        
        self.event.des = self.noteTextView.text
        self.event.title = self.titleTextField.text!
        self.event.location = self.locationTextField.text!
        self.event.startDate = self.startDate
        self.event.endDate = self.endDate
        
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
        DatePickerDialog().show("Change Starts", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", defaultDate: self.startDate, minimumDate: nil, maximumDate: nil, datePickerMode: .dateAndTime) { (date) in
            if let date = date {
                self.startDate = date
                self.startsLabel.text = date.toDateAndTime2String
                if self.startDate >= self.endDate {
                    if let newDate = Calendar.current.date(byAdding: .hour, value: 1, to: self.event.startDate) {
                        self.endDate = newDate
                    }
                }
                self.updateEndDateLabel()
            }
        }
    }
    
    fileprivate func showEndsDatePicker() {
        DatePickerDialog().show("Change Time", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", defaultDate: self.endDate, minimumDate: self.startDate, maximumDate: nil, datePickerMode: .dateAndTime) { (date) in
            if let date = date {
                self.endDate = date
                self.updateEndDateLabel()
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

extension EditEventViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Notes"
            textView.textColor = UIColor.lightGray
        }
    }
    
}
