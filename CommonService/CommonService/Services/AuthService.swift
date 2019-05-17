//
//  AuthService.swift
//  Smack
//
//  Created by William Huang on 07/06/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

public class AuthService{
    
    public static let instance = AuthService()
    
    public let defaults = UserDefaults.standard
    
    public var isLoggedIn: Bool {
        get{
            return defaults.bool(forKey: LOGGED_IN_KEY)
        }set{
            defaults.set(newValue, forKey: LOGGED_IN_KEY)
        }
    }
    
    public var authToken: String {
        get{
            return defaults.value(forKey: TOKEN_KEY) as! String
        }set{
            defaults.set(newValue, forKey: TOKEN_KEY)
        }
    }
    
    public var userEmail: String{
        get{
            return defaults.value(forKey: USER_EMAIL) as! String
        }set{
            defaults.set(newValue, forKey: USER_EMAIL)
        }
    }
    
    public var isEditable: Bool {
        get{
            return defaults.bool(forKey: EDITABLE)
        }set{
            defaults.set(newValue, forKey: EDITABLE)
        }
    }

    public func updateUser(name: String, completion: @escaping CompletionHandler){
        let user = UserDataService.instance
        let body:[String:Any] = [
            "name": name,
            "avatarColor": user.avatarColor,
            "avatarName": user.avatarName,
            "email": user.email
        ]
        
        Alamofire.request("\(URL_UPDATE_USERNAME)\(user.id)", method: .put, parameters: body, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.result.isSuccess{
                print("Successfully Updated User")
                UserDataService.instance.setUsername(name: name)
                
                completion(true)
            }else{
                print("ERRROR")
                debugPrint(response.result.error as Any)
                completion(false)
            }
        }
    }
    
   public func registerUser(email: String, password: String, completion: @escaping CompletionHandler){
        let lowerCaseEmail = email.lowercased()

        let body: [String:Any] = [
            "email" : lowerCaseEmail,
            "password" : password
        ]
        
        Alamofire.request(URL_REGISTER, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADERS).responseString { (response) in
            if response.result.error == nil { // response.result.isSuccess
                completion(true)
            }else{
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
   public func logInUser(email: String, password:String, completion: @escaping CompletionHandler){
        let lowerCaseEmail = email.lowercased()
        let body: [String:Any] = [
            "email": lowerCaseEmail,
            "password": password
        ]
        
        Alamofire.request(URL_LOGIN, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADERS).responseJSON { (response) in
            if response.result.error == nil{
//                if let json = response.result.value as? Dictionary<String,Any>{
//                    if let usrEmail = json["user"] as? String{
//                        self.userEmail = usrEmail
//                    }
//
//                    if let usrToken = json["token"] as? String{
//                        self.authToken = usrToken
//                    }
//                }
                
                //alternative way using swifty JSON
                guard let data = response.data else {return}
                let userJSON = JSON(data)
                self.userEmail = userJSON["user"].stringValue
                self.authToken = userJSON["token"].stringValue
                
                self.isLoggedIn = true
                completion(true)
                
            }else{
                print("ERROR LOGIN")
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
        
    }
    
   public func createUser(name: String, email:String, avatarName: String, avatarColor: String, completion: @escaping CompletionHandler){
        let lowerCasedEmail = email.lowercased()
        let body:[String:Any] = [
            "name": name,
            "email": lowerCasedEmail,
            "avatarName": avatarName,
            "avatarColor" : avatarColor
        ]
        
       
        Alamofire.request(URL_USER_ADD, method: .post, parameters: body, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.result.error == nil{
                
                guard let data = response.data else {return}
                self.setUserInfo(data: data)
                
                completion(true)
            }else{
                print("ERROR CREATE USER")
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
   public func findUserByEmail(completion: @escaping CompletionHandler){
        print("\(URL_USER_BY_EMAIL)\(userEmail)")
        Alamofire.request("\(URL_USER_BY_EMAIL)\(userEmail)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.result.error == nil{
                guard let data = response.data else {return}
                self.setUserInfo(data: data)
                
                completion(true)
            }else{
                print("ERROR FINDING")
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    public func setUserInfo(data: Data){
        let userJSON = JSON(data)
        UserDataService.instance.setUserData(id: userJSON["_id"].stringValue, avatarColor: userJSON["avatarColor"].stringValue, avatarName: userJSON["avatarName"].stringValue, email: userJSON["email"].stringValue, name: userJSON["name"].stringValue)
    }
    
}
