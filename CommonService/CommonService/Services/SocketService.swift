//
//  SocketService.swift
//  Smack
//
//  Created by William Huang on 15/06/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import UIKit
import SocketIO

public class SocketService: NSObject {
    public static let instance = SocketService()
    private var manager : SocketManager
    public var socket : SocketIOClient

    override public init() {
        manager = SocketManager(socketURL: URL(string: BASE_URL)!, config: [.log(true), .compress])
        socket = manager.defaultSocket
        super.init()
    }

    public func establishConnection(){
        socket.connect()
    }

    public func closeConnection(){
        socket.disconnect()
    }

    public func addChannel(channelName: String, channelDesc: String, completion: @escaping CompletionHandler){
        socket.emit("newChannel", channelName, channelDesc)
        completion(true)
    }

    public func getChannel(completion: @escaping CompletionHandler){
        socket.on("channelCreated") { (dataArray, ack) in
            guard let name = dataArray[0] as? String else {return}
            guard let desc = dataArray[1] as? String else {return}
            guard let id = dataArray[2] as? String else {return}

            let channel = Channel(channelName: name, channelDesc: desc, id: id)
            MessageService.instance.channels.append(channel)
            completion(true)
        }
    }

    public func addMessage(messageBody: String, user_id: String, channel_id: String, completion: @escaping CompletionHandler){
        let user = UserDataService.instance
        socket.emit("newMessage", messageBody, user_id, channel_id, user.name, user.avatarName, user.avatarColor)
        completion(true)
    }

   public func getMessages(completion: @escaping (_ newMessage: Message) -> Void){
        socket.on("messageCreated") { (dataArray, ack) in
            guard let msg = dataArray[0] as? String else {return}
            guard let userId = dataArray[1] as? String else {return}
            guard let channelId = dataArray[2] as? String else {return}
            guard let userName = dataArray[3] as? String else {return}
            guard let userAvatar = dataArray[4] as? String else {return}
            guard let userAvatarColor = dataArray[5] as? String else {return}
            guard let msgId = dataArray[6] as? String else {return}
            guard let msgTimeStamp = dataArray[7] as? String else {return}

            let newMessage = Message(message: msg, userName: userName, channelId: channelId, userId: userId, userAvatar: userAvatar, userAvatarColor: userAvatarColor, id: msgId, timeStamp: msgTimeStamp)


            completion(newMessage)
        }
    }

   public func getTypingUser(completionHandler: @escaping (_ typingUsers: [String:String])-> Void){
        socket.on("userTypingUpdate") { (dataArray, ack) in
            guard let typingUser = dataArray[0] as? [String:String] else {return}
            completionHandler(typingUser)
        }
    }
}
