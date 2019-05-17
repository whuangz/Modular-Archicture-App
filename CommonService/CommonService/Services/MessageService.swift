//
//  MessageService.swift
//  Smack
//
//  Created by William Huang on 13/06/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
public class MessageService{
    public static let instance = MessageService()
    
    public var channels = [Channel]()
    public var messages = [Message]()
    public var unreadChannels = [String]()
    public var selectedChannel : Channel?
    
    public func findAllChannels(completion: @escaping CompletionHandler){
        Alamofire.request(URL_CHANNEL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.result.isSuccess{
                guard let data = response.data else {return}
                //using Decodeable Swift 4
//                do{
//                    self.channels = try JSONDecoder().decode([Channel].self, from: data)
//                }catch let error{
//                    debugPrint(error as Any)
//                }
                
                //usual way
                print("find Channel")
                if let channelJSONArray = JSON(data).array {
                    for item in channelJSONArray{
                        let id = item["_id"].stringValue
                        let name = item["name"].stringValue
                        let description = item["description"].stringValue
                        let channel = Channel(channelName: name, channelDesc: description, id: id)
                        
                        self.channels.append(channel)
                    }
                    NotificationCenter.default.post(name: NOTIF_CHANNEL_LOADED, object: nil)
                    completion(true)
                }
                
                
            }else{
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    public func clearChannels(){
        channels.removeAll()
    }
    
   public func clearMessages(){
        messages.removeAll()
    }
    
    public func findAllMessagesForChannel(channelId: String, completion: @escaping CompletionHandler){
        Alamofire.request("\(URL_GET_MESSAGES)/\(channelId)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.result.isSuccess{
                self.clearMessages()
                guard let data = response.data else {return}
                if let messageJSON = JSON(data).array {
                    for msg in messageJSON{
                        
                        var name = msg["userName"].stringValue
                        if msg["userId"].stringValue == UserDataService.instance.id && AuthService.instance.isLoggedIn{
                            name = UserDataService.instance.name
                        }else{
                            name = msg["userName"].stringValue
                        }
                        
                        let message = Message(message: msg["messageBody"].stringValue, userName: name, channelId: msg["channelId"].stringValue, userId: msg["userId"].stringValue, userAvatar: msg["userAvatar"].stringValue, userAvatarColor: msg["userAvatarColor"].stringValue, id: msg["_id"].stringValue, timeStamp: msg["timeStamp"].stringValue)
                        self.messages.append(message)
                    }
                }
                completion(true)
            }else{
                debugPrint(response.result.error ?? "")
                completion(false)
            }
        }
    }
    
}
