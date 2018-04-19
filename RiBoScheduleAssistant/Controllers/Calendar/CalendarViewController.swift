//
//  CalendarViewController.swift
//  RiBoScheduleAssistant
//
//  Created by Rin Pham on 3/14/18.
//  Copyright © 2018 Rin Pham. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendar: FSCalendar!

    var events = [Event]()
    var datas = [[DateEvent]]()
    var datasTemp = [DateEvent]()
    
    var loadingView: UIActivityIndicatorView!
    
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
        
        self.getData()
    }
    
    fileprivate func setup() {
        
        self.navigationItem.title = "CALENDAR"
        
        self.setupCalendar()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.contentInset.bottom = 70
        
        self.loadingView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        self.loadingView.hidesWhenStopped = true
        self.tableView.backgroundView = self.loadingView
    }
    
    fileprivate func setupCalendar() {
        self.calendar.scope = .month
        self.calendar.delegate = self
        self.calendar.dataSource = self
    }
    
    fileprivate func getData() {
        self.loadingView.startAnimating()
        self.datasTemp = []
        self.getDateEventOfEvent()
    }
    
    fileprivate func getDateEventOfTask() {
        
        TaskService.getListTask { (tasks, statusCode, errorText) in
            if let tasks = tasks as? [Task] {
                for task in tasks {
                    let dateEvent = DateEvent(event: task, date: task.time, start: "", endDate: "", isAllDay: false)
                    if task.time > Date() {
                         self.datasTemp.append(dateEvent)
                    }
                }
                self.sortDatas()
            }
        }
        
    }
    
    fileprivate func getDateEventOfEvent() {
        EventService.getListEvent { (datas, statusCode, errorText) in
            if let datas = datas as? [Event] {
                self.events = datas
                for event in self.events {
                    self.datasTemp.append(contentsOf: self.getAllDateEvent(event: event))
                }
                self.getDateEventOfTask()
            }
        }
    }
    
    fileprivate func sortDatas() {
        if datasTemp.count == 0 {
            return
        }
        datasTemp.sort{ $0.date < $1.date}
        self.datas = [[DateEvent]]()
        var dateEvents = [DateEvent]()
        var dateEventCheck = datasTemp[0]
        for (index, dateEvent) in datasTemp.enumerated() {
            if Calendar.current.isDate(dateEventCheck.date, inSameDayAs: dateEvent.date) {
                dateEvents.append(dateEvent)
            } else {
                self.datas.append(dateEvents)
                dateEvents = []
                dateEventCheck = datasTemp[index]
                dateEvents.append(dateEvent)
            }
            if index == datasTemp.count - 1 {
                self.datas.append(dateEvents)
            }
        }
        
        self.tableView.reloadData()
        self.loadingView.stopAnimating()
        self.calendar.reloadData()
        self.scrollToEventComingSoon()
    }
    
    func getAllDateEvent(event: Event) -> [DateEvent] {
        if Calendar.current.isDate(event.startDate, inSameDayAs: event.endDate) {
            let dateEvent = DateEvent(event: event, date: event.startDate, start: event.startDate.toTimeString, endDate: event.endDate.toTimeString, isAllDay: false)
            return [dateEvent]
        }
        
        var result = [DateEvent]()
        var temp = event.startDate
        while !Calendar.current.isDate(temp, inSameDayAs: event.endDate) {
            if temp == event.startDate {
                let dateEvent = DateEvent(event: event, date: temp, start: event.startDate.toTimeString, endDate: "23:59", isAllDay: false)
                result.append(dateEvent)
            } else {
                let dateEvent = DateEvent(event: event, date: temp, start: "00:00", endDate: "23:59", isAllDay: true)
                result.append(dateEvent)
            }
            if let nextDate = Calendar.current.date(byAdding: Calendar.Component.day, value: 1, to: temp) {
                temp = nextDate
            }
        }
        if Calendar.current.isDate(temp, inSameDayAs: event.endDate){
            let dateEvent = DateEvent(event: event, date: temp, start: "00:00", endDate: event.endDate.toTimeString, isAllDay: false)
            result.append(dateEvent)
        }
        
        return result
    }
    
    fileprivate func scrollToEventComingSoon() {
        for (section, dateEvents) in self.datas.enumerated() {
            for (row, dateEvent) in dateEvents.enumerated() {
                if Date() < dateEvent.date {
                    self.tableView.scrollToRow(at: IndexPath(row: row, section: section), at: .top, animated: true)
                    return
                }
            }
        }
        DispatchQueue.main.async {
            self.tableView.scrollToRow(at: IndexPath(row: self.datas[self.datas.count - 1].count - 1, section: self.datas.count - 1), at: .top, animated: false)
        }

    }
    
    @IBAction func didTouchUpInsideAddButton(sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: AppID.IDCalendarVCToAddNewEventVC, sender: nil)
    }
    
    @IBAction func didTouchUpInsideChatButton(_ sender: UIButton) {
        if let vc = ChatViewController.shared() {
            self.present(vc, animated: true, completion: nil)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier, id == AppID.IDCalendarToEventDetailVC, let vc = segue.destination as? EventDetailViewController, let event = sender as? Event {
            vc.event = event
        } else if let id = segue.identifier, id == AppID.IDCalendarToEditTaskVC, let vc = segue.destination as? EditTaskTableViewController, let task = sender as? Task {
            vc.task = task
        }
    }
}

extension CalendarViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.datas.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datas[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dateEvent = self.datas[indexPath.section][indexPath.row]
        if let event = dateEvent.event as? Event {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AppID.IDCalendarTableViewCell, for: indexPath) as? CalendarTableViewCell else { return UITableViewCell() }
            
            cell.titleLabel.text = event.title
            cell.timeLabel.text = dateEvent.isAllDay ? "All Day" : "\(dateEvent.start) - \(dateEvent.endDate)"
            if dateEvent.date < Date() {
                cell.effectView.isHidden = false
            } else {
                cell.effectView.isHidden = true
            }
            return cell
        } else if let task = dateEvent.event as? Task {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AppID.IDAllTaskTableViewCell, for: indexPath) as? AllTaskTableViewCell else { return UITableViewCell() }
            
            cell.titleLabel.text = task.title
            cell.timeLabel.text = task.time.toTimeString
            if task.isDone {
                cell.lineView.isHidden = false
                cell.titleLabel.textColor = UIColor.darkGray
                cell.doneButton.setImage(#imageLiteral(resourceName: "ic_done_task"), for: .normal)
            } else {
                cell.lineView.isHidden = true
                cell.titleLabel.textColor = UIColor.black
                cell.doneButton.setImage(#imageLiteral(resourceName: "ic_circle"), for: .normal)
            }
            cell.delegate = self
            return cell
        } else {
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AppID.IDHeaderSectionTableViewCell) as? HeaderSectionTableViewCell else { return nil }
        cell.titleLabel.text = self.datas[section].first?.date.toDate2String
        
        return cell
    }
}

extension CalendarViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dateEvent = self.datas[indexPath.section][indexPath.row]
        if let event = dateEvent.event as? Event {
            self.performSegue(withIdentifier: AppID.IDCalendarToEventDetailVC, sender: event)
        } else if let task = dateEvent.event as? Task {
            self.performSegue(withIdentifier: AppID.IDCalendarToEditTaskVC, sender: task)
        }
        self.calendar.select(dateEvent.date)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let indexpath = self.tableView.indexPathsForVisibleRows?.first {
            self.calendar.select(self.datas[indexpath.section][indexpath.row].date)
        }
    }
}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        for dateEvents in self.datas {
            if let dateEvent = dateEvents.first, Calendar.current.isDate(dateEvent.date, inSameDayAs: date) {
                return dateEvents.count
            }
        }
        return 0
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print(date)
        for (section, dateEvents) in self.datas.enumerated() {
            for (row, dateEvent) in dateEvents.enumerated() {
                if Calendar.current.isDate(date, inSameDayAs: dateEvent.date) {
                    self.tableView.scrollToRow(at: IndexPath(row: row, section: section), at: .top, animated: true)
                    return
                }
            }
        }
    }
}

//MARK: - AllTaskTableViewCellDelegate
extension CalendarViewController: AllTaskTableViewCellDelegate {
    
    func didTouchUpInsideDoneButton(cell: AllTaskTableViewCell, sender: UIButton) {
        guard let indexPath = tableView.indexPath(for: cell), let task = self.datas[indexPath.section][indexPath.row].event as? Task else { return }
        task.isDone = !task.isDone
        TaskService.editTask(with: task) { (data, statusCode, errorText) in
            if let task = data as? Task {
                print("Update task ok")
                print(task.isDone)
            }
        }
        
        if task.isDone {
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
