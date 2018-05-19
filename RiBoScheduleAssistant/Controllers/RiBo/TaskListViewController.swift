//
//  TaskListViewController.swift
//  RiBoScheduleAssistant
//
//  Created by Rin Pham on 5/15/18.
//  Copyright © 2018 Rin Pham. All rights reserved.
//

import UIKit

class TaskListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var tasks = [Task]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTouchUpInsideCloseButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    fileprivate func setup() {
        
        self.navigationItem.title = "Reminders"
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier, id == AppID.IDTaskListVCToEditTaskVC, let task = sender as? Task , let vc = segue.destination as? EditTaskTableViewController {
            vc.task = task
        }
    }
    
}

extension TaskListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AppID.IDTaskListTableViewCell, for: indexPath) as? TaskListTableViewCell else { return UITableViewCell () }
        let task = self.tasks[indexPath.row]
        cell.nameLabel.text = task.title
        if task.repeatType == .none {
            cell.repeatLabel.text = "No Repeat"
        } else {
            let repeatStrings = ["None", "Daily", "Weekly", "Weekdays", "Weekends", "Monthly"]
            cell.repeatLabel.text = repeatStrings[task.repeatType.rawValue]
        }
        
        switch task.repeatType {
        case .daily, .weekdays, .weekends:
            cell.timeLabel.text = task.time.toString(format: "HH:mm")
        case .weekly:
            cell.timeLabel.text = task.time.toString(format: "EEEE, HH:mm")
        default:
            cell.timeLabel.text = task.time.toDateAndTimeString
        }
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
}

extension TaskListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: AppID.IDTaskListVCToEditTaskVC, sender: self.tasks[indexPath.row])
    }
    
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//
//    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
//        return .delete
//    }
//
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            TaskService.deleteTask(with: self.tasks[indexPath.row], completion: { (data, statusCode, error) in
//                print("DELETE TASK")
//                self.tasks.remove(at: indexPath.row)
//                self.tableView.reloadData()
//            })
//        }
//    }
    
}
