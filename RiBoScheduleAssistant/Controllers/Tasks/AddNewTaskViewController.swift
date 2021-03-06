//
//  AddNewTaskViewController.swift
//  RiBoScheduleAssistant
//
//  Created by Rin Pham on 4/6/18.
//  Copyright © 2018 Rin Pham. All rights reserved.
//

import UIKit
import DropDown

class AddNewTaskViewController: UIViewController {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var timeTitleLabel: UILabel!
    @IBOutlet weak var repeatLabel: UILabel!
    @IBOutlet weak var timeContentLabel: UILabel!
    @IBOutlet weak var repeatButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var speechButton: UIButton!
    
    var time = Date()
    var typeTasks: [(image: UIImage, name: String)] = [(#imageLiteral(resourceName: "ic_task_call"), "Call"), (#imageLiteral(resourceName: "ic_task_email"), "Email"), (#imageLiteral(resourceName: "ic_task_check"), "Check"), (#imageLiteral(resourceName: "ic_task_get"), "Get"), (#imageLiteral(resourceName: "ic_task_buy"), "Buy"), (#imageLiteral(resourceName: "ic_task_meet"), "Meet"), (#imageLiteral(resourceName: "ic_task_clean"), "Clean"), (#imageLiteral(resourceName: "ic_task_take"), "Take"), (#imageLiteral(resourceName: "ic_task_send"), "Send"), (#imageLiteral(resourceName: "ic_task_pay"), "Pay"), (#imageLiteral(resourceName: "ic_task_make"), "Make"), (#imageLiteral(resourceName: "ic_task_finish"), "Finish"), (#imageLiteral(resourceName: "ic_task_print"), "Print"), (#imageLiteral(resourceName: "ic_task_read"), "Read"), (#imageLiteral(resourceName: "ic_task_study"), "Study"), (#imageLiteral(resourceName: "ic_task_work"), "Work")]
    let dropDown = DropDown()
    var repeatType = RepeatType.none
    var taskType: TaskType = .normal

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func setup() {
        
        self.navigationController?.navigationBar.isHidden = true
        self.titleTextField.becomeFirstResponder()
        self.titleTextField.addTarget(self, action: #selector(self.textFieldChange(_:)), for: UIControlEvents.editingChanged)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.updateTimeLabel()
        self.headerView.createShadow(color: UIColor.black, opacity: 0.3, width: 0, height: 0, shadowRadius: 5)
        
        self.repeatButton.cornerRadius(5, borderWidth: 1, color: .gray)
        
        self.dropDown.anchorView = self.repeatButton
        self.dropDown.dataSource = ["None", "Daily", "Weekly", "Weekdays", "Weekends", "Monthly"]
        self.dropDown.bottomOffset = CGPoint(x: 0, y: self.repeatButton.bounds.height)
        self.dropDown.selectRow(0)
        self.dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.repeatButton.setTitle(self.dropDown.dataSource[index], for: .normal)
            if let type = RepeatType(rawValue: index) {
                self.repeatType = type
                self.updateTimeLabel()
            }
        }
        
        self.saveButton.cornerRadius(self.saveButton.bounds.height/2, borderWidth: 1, color: App.Color.mainDarkColor)
        self.saveButton.setTitleColor(App.Color.mainDarkColor, for: .normal)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.showKeyboard(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
    }
    
    @IBAction func didTouchUpInsideCloseButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTouchUpInsideSaveButton(_ sender: UIButton) {
        self.createNewTask()
    }
    
    @IBAction func didTouchUpInsideTimeButton(_ sender: UIButton) {
        self.showDatePicker()
    }
    
    @IBAction func didTouchUpInsideRepeatButton(_ sender: UIButton) {
        self.dropDown.show()
    }
    
    @IBAction func didTouchUpInsideSpeechButton(_ sender: UIButton) {
        self.showSpeechVC()
    }

    @objc func textFieldChange(_ sender: UITextField) {
        if sender.text! != "" {
            self.tableView.isHidden = true
            self.speechButton.isHidden = true
        } else {
            self.tableView.isHidden = false
            self.speechButton.isHidden = false
            self.taskType = .normal
        }
    }
    
    
    fileprivate func createNewTask() {

        let newTask = Task(id: UUID().uuidString, title: self.titleTextField.text!, time: self.time, type: self.taskType, isDone: false, userId: "", intentId: "", repeatType: self.repeatType)
        if Internet.haveInternet {
            TaskService.createNewTask(with: newTask) { (data, statusCode, errorText) in
                if let errorText = errorText {
                    self.showAlert(title: "Notice", message: errorText, option: .alert, btnCancel: UIAlertAction(title: "OK", style: .cancel, handler: nil), buttonNormal: [])
                    return
                } else {
                    self.showAlertSuccess(message: "The reminder is created!")
                    self.navigationController?.popViewController(animated: true)
                }
            }
        } else {
            let rTask = RTask.initWithTask(task: newTask, action: 1, isSync: false)
            rTask.update()
            self.showAlertSuccess(message: "The reminder is created!")
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    fileprivate func showDatePicker() {
        switch self.repeatType {
        case .daily, .weekdays, .weekends:
            DatePickerDialog(buttonColor: App.Color.mainDarkColor, titleLabelColor: App.Color.mainDarkColor).show("Change Time", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", defaultDate: self.time, minimumDate: Date(), maximumDate: nil, datePickerMode: .time) { (date) in
                if let date = date {
                    self.time = date
                    self.updateTimeLabel()
                }
            }
        default:
            DatePickerDialog(buttonColor: App.Color.mainDarkColor, titleLabelColor: App.Color.mainDarkColor).show("Change Time", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", defaultDate: self.time, minimumDate: Date(), maximumDate: nil, datePickerMode: .dateAndTime) { (date) in
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
            self.timeContentLabel.text = self.time.toString(format: "HH:mm")
        case .weekly:
            self.timeContentLabel.text = self.time.toString(format: "EEEE, HH:mm")
        default:
            self.timeContentLabel.text = self.time.toDateAndTimeString
        }
    }
    
    fileprivate func showSpeechVC() {
        if let vc = SpeechViewController.shared() {
            self.titleTextField.resignFirstResponder()
            self.addChildViewController(vc)
            vc.view.frame = self.view.frame
            self.view.addSubview(vc.view)
            vc.didMove(toParentViewController: self)
            vc.delegate = self
        }
    }
    
    //MARK: NotificationCenter handlers
    @objc func showKeyboard(notification: Notification) {
        if let frame = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let height = frame.cgRectValue.height
            self.tableView.contentInset.bottom = height
            self.tableView.scrollIndicatorInsets.bottom = height
        }
    }
}


extension AddNewTaskViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.typeTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AppID.IDTypeTaskTableViewCell, for: indexPath) as? TypeTaskTableViewCell else { return UITableViewCell() }
        cell.iconImageView.image = self.typeTasks[indexPath.row].image.withRenderingMode(.alwaysTemplate)
        cell.iconImageView.tintColor = App.Color.mainDarkColor
        cell.nameLabel.text = self.typeTasks[indexPath.row].name
        
        return cell
    }
    
}

extension AddNewTaskViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.titleTextField.text = self.typeTasks[indexPath.row].name + " "
        tableView.isHidden = true
        switch indexPath.row {
        case 0:
            self.taskType = .call
        case 1:
            self.taskType = .email
        default:
            self.taskType = .normal
        }
    }
    
}

extension AddNewTaskViewController: SpeechViewControllerDelegate {
    
    func getResultText(text: String) {
        self.titleTextField.text = text
        self.textFieldChange(self.titleTextField)
    }
}
