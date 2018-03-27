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
        self.calendar.scope = .month
        self.calendar.delegate = self
        self.calendar.dataSource = self
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
    }
    
    fileprivate func getData() {
        
        EventService.getListEvent { (datas, statusCode, errorText) in
            if let datas = datas as? [Event] {
                self.events = datas
                self.sortEvent()
            }
        }
        
    }
    
    fileprivate func sortEvent() {
        if self.events.count == 0 {
            return
        }
        var datasTemp = [DateEvent]()
        for event in self.events {
            datasTemp.append(contentsOf: self.getAllDateEvent(event: event))
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
        self.calendar.reloadData()
    }
    
    func getAllDateEvent(event: Event) -> [DateEvent] {
        if Calendar.current.isDate(event.startDate, inSameDayAs: event.endDate) {
            let dateEvent = DateEvent(event: event, date: event.startDate, start: event.startDate.toTimeString, endDate: event.endDate.toTimeString)
            return [dateEvent]
        }
        
        var result = [DateEvent]()
        var temp = event.startDate
        while temp <= event.endDate {
            if temp == event.startDate {
                let dateEvent = DateEvent(event: event, date: temp, start: event.startDate.toTimeString, endDate: "23:59")
                result.append(dateEvent)
            } else if Calendar.current.isDate(temp, inSameDayAs: event.endDate){
                let dateEvent = DateEvent(event: event, date: temp, start: "00:00", endDate: event.endDate.toTimeString)
                result.append(dateEvent)
            } else {
                let dateEvent = DateEvent(event: event, date: temp, start: "00:00", endDate: "23:59")
                result.append(dateEvent)
            }
            if let nextDate = Calendar.current.date(byAdding: Calendar.Component.day, value: 1, to: temp) {
                temp = nextDate
            }
        }
        
        return result
    }
    
    @IBAction func didTouchUpInsideAddButton(sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: AppID.IDCalendarVCToAddNewEventVC, sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier, id == AppID.IDCalendarToEventDetailVC, let vc = segue.destination as? EventDetailViewController, let event = sender as? Event {
            vc.event = event
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AppID.IDCalendarTableViewCell, for: indexPath) as? CalendarTableViewCell else { return UITableViewCell() }
        let dateEvent = self.datas[indexPath.section][indexPath.row]
        cell.titleLabel.text = dateEvent.event.title
        cell.timeLabel.text = "\(dateEvent.start) - \(dateEvent.endDate)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.datas[section].first?.date.toDateString
    }
}

extension CalendarViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: AppID.IDCalendarToEventDetailVC, sender: self.datas[indexPath.section][indexPath.row].event)
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
    
    
}
