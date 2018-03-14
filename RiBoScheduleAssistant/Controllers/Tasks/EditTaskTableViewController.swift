//
//  EditTaskTableViewController.swift
//  RiBoScheduleAssistant
//
//  Created by Rin Pham on 3/14/18.
//  Copyright © 2018 Rin Pham. All rights reserved.
//

import UIKit

class EditTaskTableViewController: UITableViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var task: RTask!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func setup() {
        self.titleTextField.text = self.task.title
        self.timeLabel.text = self.task.time.toTimeString
        self.descriptionTextView.text = self.task.des
    }

    @IBAction func didTouchUpInsideEditButton(sender: UIBarButtonItem) {
        
    }

    @IBAction func didTouchUpInsideDeleteButton(sender: UIButton) {
        
    }
}
