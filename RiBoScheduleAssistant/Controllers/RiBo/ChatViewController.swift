//
//  ChatViewController.swift
//  RiBoScheduleAssistant
//
//  Created by Rin Pham on 4/3/18.
//  Copyright © 2018 Rin Pham. All rights reserved.
//

import UIKit
import SocketRocket
import SwiftyJSON

class ChatViewController: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet var inputBar: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var voiceButton: UIButton!
    
    var socket: SRWebSocket?
    
    override var inputAccessoryView: UIView? {
        get {
            self.inputBar.frame.size.height = self.barHeight
            self.inputBar.clipsToBounds = true
            return self.inputBar
        }
    }
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    //MARK: - Properties
    var messages = [Message]()
    let barHeight: CGFloat = 50
    
    //MARK: ViewController lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.layoutIfNeeded()
        NotificationCenter.default.addObserver(self, selector: #selector(self.showKeyboard(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.setupUI()
        self.getMessages()
    }
    
    class func shared() -> ChatViewController? {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: AppID.IDChatViewController) as? ChatViewController
        return vc
    }
    
    //MARK: - Setup
    fileprivate func setup() {
        self.tableView.estimatedRowHeight = self.barHeight
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.contentInset.bottom = self.barHeight
        self.tableView.scrollIndicatorInsets.bottom = self.barHeight
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.inputTextField.delegate = self
        if let user = AppDelegate.shared().currentUser, let url = URL(string: AppLinks.LINK_SOCKET + "message/" + user.id) {
            self.socket = SRWebSocket(url: url)
        }
    }
    
    fileprivate func setupUI() {
        self.headerView.backgroundColor = App.Color.mainColor
        self.closeButton.setImage(#imageLiteral(resourceName: "ic_cancel").withRenderingMode(.alwaysTemplate), for: .normal)
        self.closeButton.tintColor = UIColor.white
        self.titleLabel.textColor = UIColor.white
        self.sendButton.setBackgroundImage(#imageLiteral(resourceName: "send").withRenderingMode(.alwaysTemplate), for: .normal)
        self.sendButton.tintColor = App.Color.mainDarkColor
        self.voiceButton.setImage(#imageLiteral(resourceName: "ic_microphone").withRenderingMode(.alwaysTemplate), for: .normal)
        self.voiceButton.tintColor = App.Color.mainDarkColor
    }
    
    @IBAction func didTouchUpInsideCloseButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTouchUpInsideSendButton(_ sender: UIButton) {
        self.sendMessage()
    }
    
    @IBAction func didTouchUpInsideSpeechButton(_ sender: UIButton) {
        self.showSpeechVC()
    }

    //MARK: NotificationCenter handlers
    @objc func showKeyboard(notification: Notification) {
        if let frame = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let height = frame.cgRectValue.height
            self.tableView.contentInset.bottom = height
            self.tableView.scrollIndicatorInsets.bottom = height
            self.scrollToBottom()
        }

    }
    
    //MARK: - Support methods
    fileprivate func getMessages() {
        self.showActivityIndicator(type: .ballScaleRippleMultiple)
        self.inputBar.isHidden = true
        MessagesService.getListMessages { (datas, statusCode, errorText) in
            if let messages = datas as? [Message] {
                self.messages = messages.sorted{$0.timestamp < $1.timestamp}
                self.tableView.reloadData()
                self.scrollToBottom()
            }
            self.connectSocket()
            self.stopActivityIndicator()
            self.inputBar.isHidden = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            self.stopActivityIndicator()
            self.inputBar.isHidden = false
        }
    }
    
    fileprivate func connectSocket() {
        
        socket?.open()
        socket?.delegate = self
        
    }
    
    fileprivate func sendMessage() {
        if let text = self.inputTextField.text, text != "" {
            self.sendButton.isEnabled = false
//            if let index = Int(text), index > 0, let lastMessage = self.messages.last, (index - 1 < lastMessage.tasks.count || index - 1 < lastMessage.events.count) {
//                let realmIndex = index - 1
//                if realmIndex < lastMessage.tasks.count {
//                    let dict = "{\"body\":\"\(text)\",\"user_id\":\"\(AppDelegate.shared().currentUser.id)\",\"object_id\":\"\(lastMessage.tasks[realmIndex].id)\"}"
//                    socket?.send(dict)
//                } else if realmIndex < lastMessage.events.count {
//                    let dict = "{\"body\":\"\(text)\",\"user_id\":\"\(AppDelegate.shared().currentUser.id)\",\"object_id\":\"\(lastMessage.events[realmIndex].id)\"}"
//                    socket?.send(dict)
//                }
//            } else {
//                let dict = "{\"body\":\"\(text)\",\"user_id\":\"\(AppDelegate.shared().currentUser.id)\"}"
//                socket?.send(dict)
//            }
            let dict = "{\"body\":\"\(text)\",\"user_id\":\"\(AppDelegate.shared().currentUser.id)\"}"
            socket?.send(dict)
            let message = Message(id: "", owner: .sender, type: .text, content: text, timestamp: Date().timeIntervalSince1970, senderId: "")
            self.messages.append(message)
//            let messageLoading = Message(id: "", owner: .ribo, type: .typing, content: "", timestamp: Date().timeIntervalSince1970, senderId: "")
//            self.messages.append(messageLoading)
            self.tableView.reloadData()
            self.inputTextField.text = ""
            self.scrollToBottom()
        }
    }
    
    fileprivate func scrollToBottom() {
        if self.messages.count > 0 {
            self.tableView.scrollToRow(at: IndexPath.init(row: self.messages.count - 1, section: 0), at: .bottom, animated: false)
        }
    }
    
    fileprivate func showSpeechVC() {
        if let vc = SpeechViewController.shared() {
            self.inputTextField.resignFirstResponder()
            self.addChildViewController(vc)
            vc.view.frame = self.view.frame
            self.view.addSubview(vc.view)
            vc.didMove(toParentViewController: self)
            vc.delegate = self
        }
    }
    
    fileprivate func detectIndexObjectInMessage(text: String) {
        if let index = Int(text), let lastMessage = self.messages.last, index < lastMessage.tasks.count {
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier, id == AppID.IDChatVCToTaskListVC, let tasks = sender as? [Task], let navi = segue.destination as? UINavigationController, let vc = navi.viewControllers.first as? TaskListViewController {
            vc.tasks = tasks
        } else if let id = segue.identifier, id == AppID.IDChatVCToEventListVC, let events = sender as? [Event], let navi = segue.destination as? UINavigationController, let vc = navi.viewControllers.first as? EventListViewController {
            vc.events = events
        } else if let id = segue.identifier, id == AppID.IDChatVCToDetailEventVC, let event = sender as? Event, let vc = segue.destination as? EventDetailViewController {
            vc.event = event
            vc.isHiddenEditButton = true
        } else if let id = segue.identifier, id == AppID.IDChatVCToEditTaskVC, let task = sender as? Task, let vc = segue.destination as? EditTaskTableViewController {
            vc.task = task
        }
    }
}

extension ChatViewController: SpeechViewControllerDelegate {
    func getResultText(text: String) {
        self.inputTextField.text = text
        self.sendMessage()
    }
}

//MARK: - UITextFieldDelegate
extension ChatViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

//MARK: - UITableViewDataSource
extension ChatViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = self.messages[indexPath.row]
        switch message.owner {
        case .sender:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AppID.IDSenderTableViewCell, for: indexPath) as? SenderTableViewCell else {
                return UITableViewCell()
            }
            cell.clearCellData()
            if message.type == .text, let text = message.content as? String {
//                cell.message.text = text + "\n \(Date.init(timeIntervalSince1970: message.timestamp))"
                cell.message.text = text
            }
            
            return cell
        case .ribo:
            if message.type == .typing {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: AppID.IDTypingTableViewCell, for: indexPath) as? TypingTableViewCell else {
                    return UITableViewCell()
                }
                cell.clearCellData()
                if message.type == .text, let text = message.content as? String {
                    cell.message.text = text
                }
                cell.profilePic.image = #imageLiteral(resourceName: "ic_chatbot")
                
                return cell
            }
            if (message.tasks.count > 0 && message.action == .taskGet) || (message.events.count > 0 && message.action == .eventGet) { //Show tasks or events
                guard let cell = tableView.dequeueReusableCell(withIdentifier: AppID.IDShowMoreTableViewCell, for: indexPath) as? ShowMoreTableViewCell else {
                    return UITableViewCell()
                }
                cell.clearCellData()
            
                if let text = message.content as? String {
                    if message.tasks.count > 3 || message.events.count > 3 {
                        cell.message.text = text + "\n . . . \n\n"
                    } else {
                        cell.message.text = text + "\n\n"
                    }
                }
                cell.profilePic.image = #imageLiteral(resourceName: "ic_chatbot")
                cell.delegate = self
                
                return cell
            } else if (message.action == .taskConfirmRemove || message.action == .eventConfirmRemove) { //Confirm when delete event or task
                guard let cell = tableView.dequeueReusableCell(withIdentifier: AppID.IDConfirmTableViewCell, for: indexPath) as? ConfirmTableViewCell else {
                    return UITableViewCell()
                }
                cell.clearCellData()
                if message.type == .text, let text = message.content as? String {
                    cell.message.text = text + "\n\n"
                }
                cell.profilePic.image = #imageLiteral(resourceName: "ic_chatbot")
                cell.delegate = self
                
                return cell
            } else if (message.action == .taskRemove || message.action == .eventRemove) && (message.tasks.count > 1 || message.events.count > 1) {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: AppID.IDShowMoreTableViewCell, for: indexPath) as? ShowMoreTableViewCell else {
                    return UITableViewCell()
                }
                cell.clearCellData()
                
                if let text = message.content as? String {
                    if message.tasks.count > 3 || message.events.count > 3 {
                        cell.message.text = text + "\n . . . \n\n"
                    } else {
                        cell.message.text = text + "\n\n"
                    }
                }
                cell.profilePic.image = #imageLiteral(resourceName: "ic_chatbot")
                cell.delegate = self
                
                return cell
            }
            else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: AppID.IDReceiverTableViewCell, for: indexPath) as? ReceiverTableViewCell else {
                    return UITableViewCell()
                }
                cell.clearCellData()
                if message.type == .text, let text = message.content as? String {
                    cell.message.text = text
                }
                cell.profilePic.image = #imageLiteral(resourceName: "ic_chatbot")
                
                return cell
            }
        }
    }
    
}

//MARK: - UITableViewDelegate
extension ChatViewController: UITableViewDelegate {
    
    
}

extension ChatViewController: SRWebSocketDelegate {
    func webSocket(_ webSocket: SRWebSocket!, didReceiveMessage message: Any!) {
        if let string = message as? String {
            let json = JSON.init(parseJSON: string)
            print("Meesage Reveive: \(message)")
            self.messages.append(contentsOf: Message.prepareMessage(json).filter{$0.owner == .ribo})
            self.tableView.reloadData()
            self.scrollToBottom()
            self.sendButton.isEnabled = true
            
        }
    }
    
    func webSocketDidOpen(_ webSocket: SRWebSocket!) {
        print("Connected Server!!!")
    }
    
    func webSocket(_ webSocket: SRWebSocket!, didFailWithError error: Error!) {
        print("Connected Error!!!")
        print(error.localizedDescription)
    }
    
    func webSocket(_ webSocket: SRWebSocket!, didReceivePong pongPayload: Data!) {
        print("Pong: \(pongPayload)")
    }
    
    func webSocket(_ webSocket: SRWebSocket!, didCloseWithCode code: Int, reason: String!, wasClean: Bool) {
        print("Close Socket")
        print(reason)
    }
}

extension ChatViewController: ShowMoreTableViewCellDelegate {
    
    func didTouchUpInsideShowButton(_ cell: ShowMoreTableViewCell, sender: UIButton) {
        guard let indexPath = self.tableView.indexPath(for: cell) else { return }
        let message = self.messages[indexPath.row]
        if (message.action == .taskRemove || message.action == .eventRemove) && (message.tasks.count > 1 || message.events.count > 1) {
            self.inputTextField.resignFirstResponder()
            if message.action == .taskRemove {
                let chosseItemView = ChooseItemView.instance(ratio: 0.8, type: ChooseItemView.TypeItem.task, title: "Select reminder you want delete", tasks: message.tasks)
                chosseItemView.delegate = self
                chosseItemView.open(supView: self.view) {
                    
                }
            } else {
                let chosseItemView = ChooseItemView.instance(ratio: 0.8, type: ChooseItemView.TypeItem.event, title: "Select event you want delete", events: message.events)
                chosseItemView.delegate = self
                chosseItemView.open(supView: self.view) {
                    
                }
            }
            self.inputBar.isHidden = true
            return
        }
        if message.tasks.count > 1 {
            self.performSegue(withIdentifier: AppID.IDChatVCToTaskListVC, sender: message.tasks)
        } else if message.events.count > 1 {
            self.performSegue(withIdentifier: AppID.IDChatVCToEventListVC, sender: message.events)
        } else if message.tasks.count == 1 {
            //self.performSegue(withIdentifier: AppID.IDChatVCToEditTaskVC, sender: message.tasks[0])
        } else if message.events.count == 1 {
            self.performSegue(withIdentifier: AppID.IDChatVCToDetailEventVC, sender: message.events[0])
        }
        
    }
    
}

extension ChatViewController: ConfirmTableViewCellDelegate {
    
    func didTouchUpInsideNoButton(_ cell: ConfirmTableViewCell, sender: UIButton) {
        self.inputTextField.text = "No"
        self.sendMessage()
    }
    
    func didTouchUpInsideYesButton(_ cell: ConfirmTableViewCell, sender: UIButton) {
        self.inputTextField.text = "Yes"
        self.sendMessage()
    }
}

extension ChatViewController: ChooseItemViewDelegate {
    
    func eventChoosed(_ chooseItemView: ChooseItemView, event: Event) {
        self.inputTextField.text = "Remove event about \(event.title)"
        self.sendMessage()
    }
    
    func taskChoosed(_ chooseItemView: ChooseItemView, task: Task) {
        self.inputTextField.text = "Remove task about \(task.title)"
        self.sendMessage()
    }
    
    func chooseItemViewClosed() {
        self.inputBar.isHidden = false
    }
}
