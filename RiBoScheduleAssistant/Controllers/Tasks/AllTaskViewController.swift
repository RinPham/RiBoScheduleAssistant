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
    
    var tasks = [RTask]()

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
        let realm = try! Realm()
        self.tasks = Array(realm.objects(RTask.self)).sorted{$0.time < $1.time}
        
        self.tableView.reloadData()
        
    }
    
    @IBAction func didTouchUpInsideAddButton(sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: AppID.IDAllTaskVCToAddNewTaskVC, sender: nil)
    }

}

//MARK: - UITableViewDataSource
extension AllTaskViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AppID.IDAllTaskTableViewCell, for: indexPath) as? AllTaskTableViewCell else { return UITableViewCell() }
        let task = self.tasks[indexPath.row]
        cell.titleLabel.text = task.title
        cell.timeLabel.text = task.time.toTimeString
        
        return cell
    }
}

//MARK: - UITableViewDelegate
extension AllTaskViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
