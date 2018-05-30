//
//  EventDetailViewController.swift
//  RiBoScheduleAssistant
//
//  Created by Rin Pham on 3/27/18.
//  Copyright © 2018 Rin Pham. All rights reserved.
//

import UIKit

class EventDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    var event: Event!
    
    var isHiddenEditButton = false
    var datasForSection1: [(title: String, content: String)] = []

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
        self.navigationController?.navigationBar.isHidden = true
        self.getEvent()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }

    fileprivate func setup() {
        self.editButton.isHidden = isHiddenEditButton
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.estimatedRowHeight = 200
    }
    
    fileprivate func getEvent() {
        if Internet.haveInternet {
            self.showActivityIndicator()
            EventService.getEvent(with: self.event.id) { (data, statusCode, errorText) in
                self.stopActivityIndicator()
                if let event = data as? Event {
                    self.event = event
                }
                self.setupData()
            }
        } else {
            if let rEvent = REvent.getWithId(id: self.event.id) {
                self.event = Event.init(rEvent)
                self.setupData()
            }
        }
        
    }
    
    fileprivate func setupData() {
        
        self.datasForSection1 = []
        if self.event.location == "" {
            self.datasForSection1.append(("Location", "No location set"))
        } else {
            self.datasForSection1.append(("Location", self.event.location))
        }
        self.datasForSection1.append(("Description", self.event.des))
        self.tableView.reloadData()
    }
    
    @IBAction func didTouchUpInsideEditButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: AppID.IDEventDetailToEditEventVC, sender: nil)
    }
    
    @IBAction func didTouchUpInsideCloseButton(_ sender: UIButton) {
        if self.isHiddenEditButton {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier, id == AppID.IDEventDetailToEditEventVC, let vc = segue.destination as? EditEventViewController {
            vc.event = self.event
        }
    }
}

extension EventDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return self.datasForSection1.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AppID.IDHeaderEventTableViewCell, for: indexPath) as? HeaderEventTableViewCell else { return UITableViewCell() }
            cell.titleLabel.text = self.event.title
            cell.timeLabel.text = self.event.startDate.toDateAndTimeString + " - " + self.event.endDate.toDateAndTimeString
            cell.selectionStyle = .none
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AppID.IDEventDetailTableViewCell, for: indexPath) as? EventDetailTableViewCell else { return UITableViewCell() }
            cell.titleLabel.text = self.datasForSection1[indexPath.row].title.uppercased()
            cell.contentLabel.text = self.datasForSection1[indexPath.row].content
            cell.selectionStyle = .none
            return cell
        default:
            return UITableViewCell()
        }
    }
}

extension EventDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 160
        default:
            return UITableViewAutomaticDimension
        }
    }
    
}
