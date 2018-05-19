//
//  EventListViewController.swift
//  RiBoScheduleAssistant
//
//  Created by Rin Pham on 5/15/18.
//  Copyright © 2018 Rin Pham. All rights reserved.
//

import UIKit

class EventListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var events = [Event]()

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
        if let id = segue.identifier, id == AppID.IDEventListVCToEditEventVC, let event = sender as? Event, let vc = segue.destination as? EventDetailViewController {
            vc.event = event
        }
    }
}

extension EventListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AppID.IDEventListTableViewCell, for: indexPath) as? EventListTableViewCell else { return UITableViewCell() }
        let event = self.events[indexPath.row]
        cell.nameLabel.text = event.title
        cell.timeLabel.text = "From " + event.startDate.toDateAndTimeString + " to " + event.endDate.toDateAndTimeString
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
}

extension EventListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: AppID.IDEventListVCToEditEventVC, sender: self.events[indexPath.row])
    }
}
