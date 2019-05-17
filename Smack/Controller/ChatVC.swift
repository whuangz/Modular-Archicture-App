//
//  ChatVC.swift
//  Smack
//
//  Created by William Huang on 23/05/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import UIKit
import CommonService
import Channel_UI

class ChatVC: UIViewController {

    //MARK: - Outlet
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var channelName: UILabel!
    @IBOutlet weak var msgTxtBox: UITextField!
    @IBOutlet weak var height: NSLayoutConstraint!
    @IBOutlet weak var msgTableView: UITableView!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var usrTypingLbl: UILabel!
    
    //variables
    var typing = false

    override func viewDidLoad() {
        super.viewDidLoad()
        //view.bindToKeyboard()
        sendBtn.isHidden = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(ChatVC.handleTap))
        view.addGestureRecognizer(tap)
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.selectedChannel(_:)), name: NOTIF_CHANNEL_SELECTED, object: nil)
        
//        SocketService.instance.getMessages { (success) in
//            if success{
//                self.msgTableView.reloadData()
//                if MessageService.instance.messages.count > 0 {
//                    let idxpath = IndexPath(row: MessageService.instance.messages.count-1, section: 0)
//                    self.msgTableView.scrollToRow(at: idxpath, at: .bottom, animated: false)
//                }
//            }
//        }
        
        SocketService.instance.getMessages { (newMessage) in
            if newMessage.channelId == MessageService.instance.selectedChannel?.id && AuthService.instance.isLoggedIn {
                MessageService.instance.messages.append(newMessage)
                self.msgTableView.reloadData()
                if MessageService.instance.messages.count > 0 {
                    let idxPath = IndexPath(row: MessageService.instance.messages.count-1, section: 0)
                    self.msgTableView.scrollToRow(at: idxPath, at: .bottom, animated: false)
                }
            }
        }
        
        SocketService.instance.getTypingUser { (typingUsers) in
            guard let channelId = MessageService.instance.selectedChannel?.id else {return}
            var names = ""
            var numberOfTypers = 0
            for (typingUser, channel) in typingUsers {
                print(typingUsers , ": " , typingUser)
                if typingUser != UserDataService.instance.name && channel == channelId {
                    if names == ""{
                        names = typingUser
                    }else {
                        names = "\(names), \(typingUser)"
                    }
                    numberOfTypers += 1
                }
            }
            
            if numberOfTypers > 0 && AuthService.instance.isLoggedIn{
                var verb = "is"
                if numberOfTypers > 1 {
                    verb = "are"
                }
                self.usrTypingLbl.text = "\(names) \(verb) typing..."
            }else{
                self.usrTypingLbl.text = ""
            }
        }
        
        if AuthService.instance.isLoggedIn{
            AuthService.instance.findUserByEmail(completion: { (success) in
                NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
            })
        }
        
        msgTxtBox.delegate = self
        msgTableView.delegate = self
        msgTableView.dataSource = self
        msgTableView.estimatedRowHeight = 80
        msgTableView.rowHeight = UITableViewAutomaticDimension
    }

    @objc func userDataDidChange(_ notif: Notification){
        if AuthService.instance.isLoggedIn{
            //loaded Channel
            onLoginGetMessages()
        }else{
            channelName.text = "Please Log in"
            msgTableView.reloadData()
        }
    }
    
    @objc func selectedChannel(_ notif: Notification){
        updateWithChannel()
    }
    
    func updateWithChannel(){
        let title = MessageService.instance.selectedChannel?.channelName ?? ""
        channelName.text = "#\(title)"
        getMessages()
    }
    
    @IBAction func msgBoxEditing(_ sender: Any) {
        let userName = UserDataService.instance.name
        guard let channelId = MessageService.instance.selectedChannel?.id else {return}
        
        if msgTxtBox.text == "" {
            typing = false
            sendBtn.isHidden = true
            SocketService.instance.socket.emit("stopType", userName, channelId)
        }else{
            if typing == false {
                sendBtn.isHidden = false
                SocketService.instance.socket.emit("startType", userName, channelId)
            }
            typing = true
        }
    }
    
    
    func onLoginGetMessages(){
        MessageService.instance.findAllChannels { (success) in
            if success{
                if MessageService.instance.channels.count > 0 {
                    MessageService.instance.selectedChannel = MessageService.instance.channels[0]
                    self.updateWithChannel()
                }else{
                    self.channelName.text = "No available Channel"
                }
            }
        }
    }
    
    
    func getMessages(){
        guard let channelId = MessageService.instance.selectedChannel?.id else {return}
        MessageService.instance.findAllMessagesForChannel(channelId: channelId) { (success) in
            if success{
                self.msgTableView.reloadData()
            }
        }
    }
    
    @IBAction func sendMsgPressed(_ sender: Any) {
        if AuthService.instance.isLoggedIn{
            guard let channelId = MessageService.instance.selectedChannel?.id else {return}
            guard let msgBody = msgTxtBox.text else {return}
            
            SocketService.instance.addMessage(messageBody: msgBody, user_id: UserDataService.instance.id, channel_id: channelId, completion: { (success) in
                if success {
                    self.msgTxtBox.text = ""
                    self.msgTxtBox.resignFirstResponder()
                    SocketService.instance.socket.emit("stopType", UserDataService.instance.name, channelId)
                }
            })
        }else{
            channelName.text = "Please Login"
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let heightOfKeyboard = Int(KeyboardService.keyboardHeight())
        self.height.constant = CGFloat(heightOfKeyboard + 40)
        UIView.animate(withDuration: 0.5) {
            self.loadViewIfNeeded()
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.height.constant = 40
            self.loadViewIfNeeded()
        }
    }

    @objc func handleTap(){
        self.view.endEditing(true)
    }
}

extension ChatVC : UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as? MessageCell {
            let message = MessageService.instance.messages[indexPath.row]
            cell.configureCell(msg: message)
            return cell
        }else{
            return MessageCell()
        }
    }
}
