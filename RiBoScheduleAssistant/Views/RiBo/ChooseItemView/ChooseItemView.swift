//
//  ChooseItemView.swift
//  RiBoScheduleAssistant
//
//  Created by Rin Pham on 5/20/18.
//  Copyright © 2018 Rin Pham. All rights reserved.
//

import UIKit

protocol ChooseItemViewDelegate: class {
    
    func eventChoosed(_ chooseItemView: ChooseItemView, event: Event)
    func taskChoosed(_ chooseItemView: ChooseItemView, task: Task)
    func chooseItemViewClosed()
    
}

class ChooseItemView: UIView {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    
    fileprivate var largeView: UIView!
    var events = [Event]()
    var tasks = [Task]()
    weak var delegate: ChooseItemViewDelegate?
    
    enum TypeItem {
        case event
        case task
    }
    
    var type = TypeItem.event
    
    class func instance(ratio: CGFloat, type: ChooseItemView.TypeItem, title: String, events: [Event] = [], tasks: [Task] = []) -> ChooseItemView {
        let view = UIView.loadFromNibNamed(nibNamed: "ChooseItemView") as! ChooseItemView
        view.events = events
        view.tasks = tasks
        view.type = type
        view.titleLabel.text = title
        
        view.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
        view.frame.size = CGSize(width: UIScreen.main.bounds.width*ratio, height: UIScreen.main.bounds.height*0.7)
        view.largeView = UIView.createBlurView(rect: UIScreen.main.bounds, style: .dark)
        view.largeView.backgroundColor = UIColor.darkGray
        let tap = UITapGestureRecognizer(target: view, action: #selector(view.didTouchUpInsideLargeView(_:)))
        view.largeView.addGestureRecognizer(tap)
        view.setup()
        
        return view
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutIfNeeded()
        
    }
    
    fileprivate func setup() {
                
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.backgroundColor = UIColor.white
        self.cornerRadius(5, borderWidth: 0, color: .white)
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.titleLabel.textColor = App.Color.mainDarkColor
    }
    
    func open(supView: UIView, completion: @escaping () -> Void) {
        self.center = CGPoint(x: supView.center.x, y: supView.center.y)
        supView.addSubview(largeView)
        supView.addSubview(self)
        largeView.alpha = 0.3
        self.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.largeView.alpha = 1
            self?.transform = CGAffineTransform(scaleX: 1, y: 1)
        }) { (_) in
            completion()
        }
    }
    
    func close(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.largeView.alpha = 0
            self?.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        }) { [weak self] (_) in
            if self?.superview != nil {
                self?.removeFromSuperview()
            }
            if self?.largeView.superview != nil {
                self?.largeView.removeFromSuperview()
            }
            completion()
        }
        delegate?.chooseItemViewClosed()
    }

    //#MARK: - Button Clicked
    @objc fileprivate func didTouchUpInsideLargeView(_ gesture: UIGestureRecognizer) {
        self.close {}
    }
    
}

extension ChooseItemView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.type == .event ? self.events.count : self.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        if self.type == .event {
            let event = self.events[indexPath.row]
            cell.textLabel?.text = event.title
            cell.detailTextLabel?.text = "From " + event.startDate.toDateAndTimeString + " to " + event.endDate.toDateAndTimeString
        } else {
            let task = self.tasks[indexPath.row]
            cell.textLabel?.text = task.title
            var text = ""
            switch task.repeatType {
            case .daily, .weekdays, .weekends:
                text = task.time.toString(format: "HH:mm")
            case .weekly:
                text = task.time.toString(format: "EEEE, HH:mm")
            default:
                text = task.time.toDateAndTimeString
            }
            text += ", "
            if task.repeatType == .none {
                text = "No Repeat"
            } else {
                let repeatStrings = ["None", "Daily", "Weekly", "Weekdays", "Weekends", "Monthly"]
                text = repeatStrings[task.repeatType.rawValue]
            }
            cell.detailTextLabel?.text = text
        }
        
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
}

extension ChooseItemView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if self.type == .event {
            self.delegate?.eventChoosed(self, event: self.events[indexPath.row])
        } else {
            self.delegate?.taskChoosed(self, task: self.tasks[indexPath.row])
        }
        self.close {
            
        }
    }
    
}
