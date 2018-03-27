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
    
    //var tasks = [RTask]()
    
    var datas = [[Task]]()

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
        
        self.setupData()
    }
    //MARK: - Setup
    
    fileprivate func setup() {
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        self.navigationItem.title = "ALL TASK"
    }
    
    fileprivate func setupData() {
//        let realm = try! Realm()
//        let tasks = Array(realm.objects(RTask.self)).sorted{$0.time < $1.time}
//        self.sortTasks(tasks: tasks)
        TaskService.getListTask { (tasks, statusCode, errorText) in
            if let tasks = tasks as? [Task] {
                self.sortTasks(tasks: tasks.sorted{ $0.time < $1.time })
                self.tableView.reloadData()
            }
        }
        
        
    }
    
    func sortTasks(tasks: [Task]) {
        if tasks.count == 0 {
            return
        }
        self.datas = [[Task]]()
        var tasksTemp = [Task]()
        var taskCheck = tasks[0]
        for (index, task) in tasks.enumerated() {
            if Calendar.current.isDate(task.time, inSameDayAs: taskCheck.time) {
                tasksTemp.append(task)
            } else {
                self.datas.append(tasksTemp)
                tasksTemp = []
                taskCheck = tasks[index]
                tasksTemp.append(task)
            }
            if index == tasks.count - 1 {
                self.datas.append(tasksTemp)
            }
        }
        
    }
    
    @IBAction func didTouchUpInsideAddButton(sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: AppID.IDAllTaskVCToAddNewTaskVC, sender: nil)
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
        return self.datas[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AppID.IDAllTaskTableViewCell, for: indexPath) as? AllTaskTableViewCell else { return UITableViewCell() }
        cell.delegate = self
        let task = self.datas[indexPath.section][indexPath.row]
        cell.titleLabel.text = task.title
        cell.timeLabel.text = task.time.toTimeString
        cell.lineView.isHidden = !task.isDone
        cell.titleLabel.textColor = task.isDone ? UIColor.darkGray : UIColor.black
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.datas[section].first?.time.toDateString
    }
    
}

//MARK: - UITableViewDelegate
extension AllTaskViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: AppID.IDAllTaskVCToEditTaskVC, sender: self.datas[indexPath.section][indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("DELETE TASK")
        }
    }
}

//MARK: - AllTaskTableViewCellDelegate
extension AllTaskViewController: AllTaskTableViewCellDelegate {
    
    func didTouchUpInsideDoneButton(cell: AllTaskTableViewCell, sender: UIButton) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
//        let realm = try! Realm()
//        try! realm.write {
//            self.datas[indexPath.section][indexPath.row].isDone = !self.datas[indexPath.section][indexPath.row].isDone
//        }
        self.datas[indexPath.section][indexPath.row].isDone = !self.datas[indexPath.section][indexPath.row].isDone
        TaskService.editTask(with: self.datas[indexPath.section][indexPath.row]) { (data, statusCode, errorText) in
            
        }
        
        if self.datas[indexPath.section][indexPath.row].isDone {
            cell.lineView.isHidden = false
            cell.titleLabel.textColor = UIColor.darkGray
            sender.setImage(#imageLiteral(resourceName: "ic_done_task"), for: .normal)
        } else {
            cell.lineView.isHidden = true
            cell.titleLabel.textColor = UIColor.black
            sender.setImage(#imageLiteral(resourceName: "ic_circle"), for: .normal)
        }
    }
    
}
