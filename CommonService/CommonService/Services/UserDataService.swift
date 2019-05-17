//
//  UserDataService.swift
//  Smack
//
//  Created by William Huang on 08/06/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import Foundation

public class UserDataService{
    public static let instance = UserDataService()
    private(set) public var id = ""
    private(set) public var avatarColor = ""
    private(set) public var avatarName = ""
    private(set) public var email = ""
    private(set) public var name = ""
    
    public func setUserData(id: String, avatarColor: String, avatarName: String, email: String, name: String){
        self.id = id
        self.avatarColor = avatarColor
        self.avatarName = avatarName
        self.email = email
        self.name = name
    }
    
    public func setAvatarName(avatarName: String){
        self.avatarName = avatarName
    }
    
    public func setUsername(name: String){
        self.name = name
    }
    
    public func returnUIColor(components : String)-> UIColor{
        let scanner = Scanner(string: components)
        let skipper = CharacterSet(charactersIn: "[], ")
        let comma = CharacterSet(charactersIn: ",")
        
        scanner.charactersToBeSkipped = skipper
        
        var r,g,b,a:NSString?
        scanner.scanUpToCharacters(from: comma, into: &r)
        scanner.scanUpToCharacters(from: comma, into: &g)
        scanner.scanUpToCharacters(from: comma, into: &b)
        scanner.scanUpToCharacters(from: comma, into: &a)
        
        let defaultColor = UIColor.lightGray
        guard let rUnwrapped = r else {return defaultColor}
        guard let gUnwrapped = g else {return defaultColor}
        guard let bUnwrapped = b else {return defaultColor}
        guard let aUnwrapped = a else {return defaultColor}
        
        let rChannel = CGFloat(rUnwrapped.doubleValue)
        let gChannel = CGFloat(gUnwrapped.doubleValue)
        let bChannel = CGFloat(bUnwrapped.doubleValue)
        let aChannel = CGFloat(aUnwrapped.doubleValue)
        
        return UIColor(red: rChannel, green: gChannel, blue: bChannel, alpha: aChannel)
    }
    
    
    public func logoutUser(){
        self.id = ""
        self.avatarColor = ""
        self.avatarName = ""
        self.email = ""
        self.name = ""
        AuthService.instance.isLoggedIn = false
        AuthService.instance.isEditable = false
        AuthService.instance.authToken = ""
        AuthService.instance.userEmail = ""
        MessageService.instance.clearChannels()
        MessageService.instance.clearMessages()
    }
}
