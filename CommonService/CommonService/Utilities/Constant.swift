//
//  Constant.swift
//  Smack
//
//  Created by William Huang on 25/05/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import Foundation
//Type Alias
public typealias CompletionHandler = (_ success: Bool) -> ()
                             
//colors
public let SMACKPURPLEPLACEHOLDER = #colorLiteral(red: 0.3254901961, green: 0.4196078431, blue: 0.7764705882, alpha: 0.5)


//URL Constant
public let BASE_URL = "https://chatychatting1.herokuapp.com/v1/"
public let URL_REGISTER = "\(BASE_URL)account/register"
public let URL_LOGIN = "\(BASE_URL)account/login"
public let URL_USER_ADD = "\(BASE_URL)user/add"
public let URL_USER_BY_EMAIL = "\(BASE_URL)user/byEmail/"
public let URL_CHANNEL = "\(BASE_URL)channel"
public let URL_GET_MESSAGES = "\(BASE_URL)message/byChannel"
public let URL_UPDATE_USERNAME = "\(BASE_URL)user/"

//Notification Constants
public let NOTIF_USER_DATA_DID_CHANGE = Notification.Name("notifUserDataDidChange")
public let NOTIF_CHANNEL_LOADED = Notification.Name("channelLoaded")
public let NOTIF_CHANNEL_SELECTED = Notification.Name("channelSelected")

//headers
public let HEADERS = [
    "Content-Type" : "application/json; charset=utf-8"
]

public let BEARER_HEADER = [
    "Authorization" : "Bearer \(AuthService.instance.authToken)",
    "Content-Type" : "application/json; charset=utf-8"
]


//segues
public let TO_LOGIN = "GotoLogin"
public let TO_REGISTER = "GotoRegister"
public let UNWIND = "unwindtochannel"
public let TO_AVATARPCIKER = "toAvatarPicker"


//user defaults
public let EDITABLE = "editable"
public let TOKEN_KEY = "token"
public let LOGGED_IN_KEY = "loggedIn"
public let USER_EMAIL = "userEmail"
