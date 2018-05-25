//
//  AllTaskViewController.swift
//  RiBoScheduleAssistant
//
//  Created by Rin Pham on 3/13/18.
//  Copyright © 2018 Rin Pham. All rights reserved.
//

import UIKit
import RealmSwift

class AllTaskViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var riboButton: UIButton!
    
    //var tasks = [RTask]()
    var loadingView: UIActivityIndicatorView!
    var datas = [[Task]]()
    var titleSections: [(title: String, isExpand: Bool)] = [("Older", false), ("Today", true), ("Tomorrow", true), ("Upcoming", false)]

    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let haveInternet = self.checkReachability()
        if haveInternet {
            self.setupData()
        }
        self.riboButton.isEnabled = haveInternet
        self.navigationController?.navigationBar.isHidden = false
    }
    //MARK: - Setup
    
    fileprivate func setup() {
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.loadingView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        self.loadingView.hidesWhenStopped = true
        self.tableView.backgroundView = self.loadingView
        
        self.navigationItem.title = "REMINDERS"
    }
    
    fileprivate func setupData() {
        
        self.loadingView.startAnimating()
        TaskService.getListTask { (tasks, statusCode, errorText) in
            if let tasks = tasks as? [Task] {
                self.getDatasFromTasks(tasks: tasks.sorted{ $0.time < $1.time })
                self.setupNotificationFor(tasks: tasks.sorted{$0.time < $1.time})
                self.loadingView.stopAnimating()
                self.tableView.reloadData()
            }
        }
        
    }
    
    func getDatasFromTasks(tasks: [Task]) {
        self.datas = [[Task](), [Task](), [Task](), [Task]()] //[Older, Today, Tomorrow, Upcoming]
        guard tasks.count > 0 else {
            return
        }
        for task in tasks {
            if !task.time.isSameDayWith(date: Date()) && task.time < Date() {
                self.datas[0].append(task)  //Older
            } else if task.time.isSameDayWith(date: Date()) {
                self.datas[1].append(task)  //Today
            } else if task.time.isTomorrow() {
                self.datas[2].append(task)  //Tomorrow
            } else {
                self.datas[3].append(task)  //Upcoming
            }
            //Task have repeat type
            switch task.repeatType {
            case .daily:
                if !self.datas[1].contains(where: {$0.id == task.id}) {
                    self.datas[1].append(task)
                }
                if !self.datas[2].contains(where: {$0.id == task.id}) {
                    self.datas[2].append(task)
                }
            case .monthly:
                if let day = task.time.component(.day) {
                    if let currentDay = Date().component(.day), day == currentDay, !self.datas[1].contains(where: {$0.id == task.id}) {
                        datas[1].append(task)
                    }
                    if let tomorrowDay = Date().dateFor(.tomorrow).component(.day), day == tomorrowDay, !self.datas[2].contains(where: {$0.id == task.id}) {
                        datas[2].append(task)
                    }
                }
            case .weekdays:
                if Date().compare(.isWeekday) && !self.datas[1].contains(where: {$0.id == task.id}) {
                    self.datas[1].append(task)
                }
                if Date().adjust(.day, offset: 1).compare(.isWeekday) && !self.datas[2].contains(where: {$0.id == task.id}) {
                    self.datas[2].append(task)
                }
            case .weekends:
                if Date().compare(.isWeekend) && !self.datas[1].contains(where: {$0.id == task.id}) {
                    self.datas[1].append(task)
                }
                if Date().adjust(.day, offset: 1).compare(.isWeekend) && !self.datas[2].contains(where: {$0.id == task.id}) {
                    self.datas[2].append(task)
                }
            case .weekly:
                if task.time.toString(format: "EEE") == Date().toString(format: "EEE") && !self.datas[1].contains(where: {$0.id == task.id}) {
                    self.datas[1].append(task)
                }
                if task.time.toString(format: "EEE") == Date().dateFor(.tomorrow).toString(format: "EEE") && !self.datas[2].contains(where: {$0.id == task.id}) {
                    self.datas[2].append(task)
                }
            default:
                break
            }
        }
        
        self.datas[0] = self.datas[0].sorted{$0.time < $1.time}
        self.datas[1] = self.datas[1].sorted(by: { (a, b) -> Bool in
            let dateString = Date().toString(format: "dd/MM/yy") + " " + a.time.toString(format: "HH:mm")
            let dateString2 = Date().toString(format: "dd/MM/yy") + " " + b.time.toString(format: "HH:mm")
            if let taskTime = Date.init(fromString: dateString, format: DateFormatType.custom("dd/MM/yy HH:mm")), let taskTime2 = Date.init(fromString: dateString2, format: DateFormatType.custom("dd/MM/yy HH:mm")) {
                return taskTime < taskTime2
            }
            return true
        })
        self.datas[2] = self.datas[2].sorted(by: { (a, b) -> Bool in
            let dateString = Date().toString(format: "dd/MM/yy") + " " + a.time.toString(format: "HH:mm")
            let dateString2 = Date().toString(format: "dd/MM/yy") + " " + b.time.toString(format: "HH:mm")
            if let taskTime = Date.init(fromString: dateString, format: DateFormatType.custom("dd/MM/yy HH:mm")), let taskTime2 = Date.init(fromString: dateString2, format: DateFormatType.custom("dd/MM/yy HH:mm")) {
                return taskTime < taskTime2
            }
            return true
        })
        self.datas[3] = self.datas[3].sorted{$0.time < $1.time}
    }
    
    fileprivate func setupNotificationFor(tasks: [Task]) {
        for task in tasks {
            NotificationService.confureNotification(task: task)
        }
    }
    
    @IBAction func didTouchUpInsideAddButton(sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: AppID.IDAllTaskVCToAddNewTaskVC, sender: nil)
    }
    
    @IBAction func didTouchUpInsideChatButton(_ sender: UIButton) {
        if let vc = ChatViewController.shared() {
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier, id == AppID.IDAllTaskVCToEditTaskVC, let vc = segue.destination as? EditTaskTableViewController, let task = sender as? Task {
            vc.task = task
        }
    }

}

//MARK: - UITableViewDataSource
extension AllTaskViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.datas.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titleSections[section].isExpand ? self.datas[section].count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AppID.IDAllTaskTableViewCell, for: indexPath) as? AllTaskTableViewCell else { return UITableViewCell() }
        cell.delegate = self
        let task = self.datas[indexPath.section][indexPath.row]
        cell.titleLabel.text = task.title
        if indexPath.section == 1 || indexPath.section == 2 {
            cell.timeLabel.text = task.time.toTimeString
        } else {
            cell.timeLabel.text = task.time.toDateAndTimeString
        }
        switch task.type {
        case .call:
            cell.typeActionButton = .call
        case .email:
            cell.typeActionButton = .email
        default:
            cell.typeActionButton = .none
        }
        if task.isDone {
            cell.lineView.isHidden = false
            cell.titleLabel.textColor = UIColor.darkGray
            cell.doneButton.setImage(#imageLiteral(resourceName: "ic_done_task"), for: .normal)
            cell.typeActionButton = .delete
            cell.selectionStyle = .none
        } else {
            cell.lineView.isHidden = true
            cell.titleLabel.textColor = UIColor.black
            cell.doneButton.setImage(#imageLiteral(resourceName: "ic_circle"), for: .normal)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableCell(withIdentifier: AppID.IDHeaderTaskTableViewCell) as? HeaderTaskTableViewCell else { return nil }
        headerView.titleLabel.text = self.titleSections[section].title
        headerView.titleLabel.textColor = App.Color.mainDarkColor
        headerView.toggleButton.tag = section
        headerView.toggleButton.addTarget(self, action: #selector(self.toggleExpandSection(_:)), for: .touchUpInside)
        headerView.toggleButton.tintColor = App.Color.mainDarkColor
        if self.titleSections[section].isExpand {
            headerView.toggleButton.setImage(#imageLiteral(resourceName: "ic_expand_button").withRenderingMode(.alwaysTemplate), for: .normal)
        } else {
            headerView.toggleButton.setImage(#imageLiteral(resourceName: "ic_up_button").withRenderingMode(.alwaysTemplate), for: .normal)
        }
        switch self.datas[section].count {
        case 0:
            headerView.countTasksLabel.text = "empty"
        case 1:
            headerView.countTasksLabel.text = "1 reminder"
        default:
            headerView.countTasksLabel.text = "\(self.datas[section].count) reminders"
        }
        
        return headerView.contentView
    }
    
    @objc func toggleExpandSection(_ sender: UIButton) {
        self.titleSections[sender.tag].isExpand = !self.titleSections[sender.tag].isExpand
        self.tableView.reloadSections(IndexSet(integer: sender.tag), with: .automatic)
    }
}

//MARK: - UITableViewDelegate
extension AllTaskViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !self.datas[indexPath.section][indexPath.row].isDone {
            self.performSegue(withIdentifier: AppID.IDAllTaskVCToEditTaskVC, sender: self.datas[indexPath.section][indexPath.row])
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            TaskService.deleteTask(with: self.datas[indexPath.section][indexPath.row], completion: { (data, statusCode, error) in
                print("DELETE TASK")
                self.setupData()
            })
        }
    }
}

//MARK: - AllTaskTableViewCellDelegate
extension AllTaskViewController: AllTaskTableViewCellDelegate {
    
    func didTouchUpInsideDoneButton(cell: AllTaskTableViewCell, sender: UIButton) {
        
        sender.isEnabled = false
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        self.datas[indexPath.section][indexPath.row].isDone = !self.datas[indexPath.section][indexPath.row].isDone
        TaskService.editTask(with: self.datas[indexPath.section][indexPath.row], paramater: ["done": self.datas[indexPath.section][indexPath.row].isDone]) { (data, statusCode, errorText) in
            if let task = data as? Task {
                print("Update task ok")
                print(task.isDone)
                sender.isEnabled = true
            }
        }
        self.tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    func didTouchUpInsideActionButton(cell: AllTaskTableViewCell, sender: UIButton) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        switch cell.typeActionButton {
        case .delete:
            TaskService.deleteTask(with: self.datas[indexPath.section][indexPath.row], completion: { (data, statusCode, error) in
                print("DELETE TASK")
                self.setupData()
            })
        case .call:
            if let url = URL(string: "tel://") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        case .email:
            if let url = URL(string: "mailto:") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        default:
            break
        }
    }
    
}
