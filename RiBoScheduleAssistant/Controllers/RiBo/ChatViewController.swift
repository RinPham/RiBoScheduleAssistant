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
        
        MessagesService.getListMessages { (datas, statusCode, errorText) in
            if let messages = datas as? [Message] {
                self.messages = messages.sorted{$0.timestamp < $1.timestamp}
                self.tableView.reloadData()
                self.scrollToBottom()
            }
            self.connectSocket()
        }
        
    }
    
    fileprivate func connectSocket() {
        
        socket?.open()
        socket?.delegate = self
        
    }
    
    fileprivate func sendMessage() {
        if let text = self.inputTextField.text, text != "" {
            let message = Message(id: "", owner: .sender, type: .text, content: text, timestamp: Date().timeIntervalSince1970, senderId: "")
            self.messages.append(message)
            self.tableView.reloadData()
            self.inputTextField.text = ""
            self.scrollToBottom()
            
            let dict = "{\"body\":\"\(text)\",\"user_id\":\"\(AppDelegate.shared().currentUser.id)\"}"
            socket?.send(dict)
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
                cell.message.text = text + "\n \(Date.init(timeIntervalSince1970: message.timestamp))"
            }
            
            return cell
        case .ribo:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AppID.IDReceiverTableViewCell, for: indexPath) as? ReceiverTableViewCell else {
                return UITableViewCell()
            }
            cell.clearCellData()
            if message.type == .text, let text = message.content as? String {
                cell.message.text = text + "\n \(Date.init(timeIntervalSince1970: message.timestamp))"
            }
            cell.profilePic.image = #imageLiteral(resourceName: "ic_chatbot")
            
            return cell
        }
    }
    
}

//MARK: - UITableViewDelegate
extension ChatViewController: UITableViewDelegate {
    
    
}

extension ChatViewController: SRWebSocketDelegate {
    func webSocket(_ webSocket: SRWebSocket!, didReceiveMessage message: Any!) {
        print("Meesage Reveive: \(message)")
        if let string = message as? String {
            let json = JSON.init(parseJSON: string)
            print(json)
            self.messages.append(contentsOf: Message.prepareMessage(json).filter{$0.owner == .ribo})
            self.tableView.reloadData()
            self.scrollToBottom()
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
