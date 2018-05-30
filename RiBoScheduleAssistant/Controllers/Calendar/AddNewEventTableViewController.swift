//
//  AddNewEventTableViewController.swift
//  RiBoScheduleAssistant
//
//  Created by Rin Pham on 3/14/18.
//  Copyright © 2018 Rin Pham. All rights reserved.
//

import UIKit

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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.tableView.addGestureRecognizer(tapGesture)
        self.noteTextView.delegate = self
        self.noteTextView.textColor = UIColor.lightGray
        self.noteTextView.text = "Notes"
        self.startsLabel.text = self.startsDay.toDateAndTime2String
        
        if let date = Calendar.current.date(byAdding: .hour, value: 1, to: self.startsDay) {
            self.endsDay = date
        }
        self.updateEndDateLabel()
        
    }
    
    fileprivate func updateEndDateLabel() {
        if Calendar.current.isDate(self.startsDay, inSameDayAs: self.endsDay) {
            self.endsLabel.text = self.endsDay.toTimeString
        } else {
            self.endsLabel.text = self.endsDay.toDateAndTime2String
        }
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }

    @IBAction func didTouchUpInsideSaveButton(sender: UIBarButtonItem) {
        let event = Event(id: UUID().uuidString, title: self.titleTextField.text!, location: self.locationTextField.text!, startDate: self.startsDay, endDate: self.endsDay, des: self.noteTextView.text)
        if Internet.haveInternet {
            EventService.createNewEvent(with: event) { (data, statusCode, errorText) in
                if let errorText = errorText {
                    self.showAlert(title: "Notice", message: errorText, option: .alert, btnCancel: UIAlertAction(title: "OK", style: .cancel, handler: nil), buttonNormal: [])
                    return
                } else {
                    self.showAlertSuccess(message: "The event is created!")
                    self.navigationController?.popViewController(animated: true)
                }
            }
        } else {
            let rEvent = REvent.initWithEvent(event: event, action: 1, isSync: false)
            rEvent.update()
            self.showAlertSuccess(message: "The event is created!")
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    fileprivate func showStartDatePicker() {
        DatePickerDialog(buttonColor: App.Color.mainDarkColor, titleLabelColor: App.Color.mainDarkColor).show("Change Starts", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", defaultDate: self.startsDay, minimumDate: nil, maximumDate: nil, datePickerMode: .dateAndTime) { (date) in
            if let date = date {
                self.startsDay = date
                self.startsLabel.text = date.toDateAndTime2String
                if self.startsDay >= self.endsDay {
                    if let newDate = Calendar.current.date(byAdding: .hour, value: 1, to: self.startsDay) {
                        self.endsDay = newDate
                    }
                }
                self.updateEndDateLabel()
            }
        }
    }
    
    fileprivate func showEndsDatePicker() {
        DatePickerDialog(buttonColor: App.Color.mainDarkColor, titleLabelColor: App.Color.mainDarkColor).show("Change Time", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", defaultDate: self.endsDay, minimumDate: self.startsDay, maximumDate: nil, datePickerMode: .dateAndTime) { (date) in
            if let date = date {
                self.endsDay = date
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

extension AddNewEventTableViewController: UITextViewDelegate {
    
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
