//
//  RegisterVC.swift
//  Smack
//
//  Created by William Huang on 27/05/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import UIKit
import CommonService

class RegisterVC: UIViewController {

    //Outlets
    @IBOutlet weak var updateAccountBtn: RoundedBtn!
    @IBOutlet weak var generateAccBtn: RoundedBtn!
    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var pwdTxt: UITextField!
    @IBOutlet weak var conPwdTxt: UITextField!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    //Variables
    var avatarName: String = "profileDefault"
    var avatarColor: String = "[0.5, 0.5, 0.5, 1]"
    var bgColor: UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(UserDataService.instance.avatarName != ""){
            userImg.image = UIImage(named: UserDataService.instance.avatarName)
            avatarName = UserDataService.instance.avatarName
            if avatarName.contains("light") && bgColor == nil {
                userImg.backgroundColor = UIColor.lightGray
            }
        }
    }
    
    @IBAction func pickAvatarPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_AVATARPCIKER, sender: nil)
    }
    
    @IBAction func pickBgColorPressed(_ sender: Any) {
        let r = CGFloat(arc4random_uniform(255)) / 255
        let g = CGFloat(arc4random_uniform(255)) / 255
        let b = CGFloat(arc4random_uniform(255)) / 255
        bgColor = UIColor(red: r, green: g, blue: b, alpha: 1)
        avatarColor = "[\(r), \(g), \(b), 1]"
        UIView.animate(withDuration: 0.25, animations: {
            self.userImg.backgroundColor = self.bgColor
        })
    }
    
    
    @IBAction func createAccPressed(_ sender: Any) {
        spinner.isHidden = false
        spinner.startAnimating()
        
        guard let name = userNameTxt.text, userNameTxt.text != "" else{return}
        guard let email = emailTxt.text, emailTxt.text != "" else{return}
        guard let password = pwdTxt.text, pwdTxt.text != "" else{return}
        guard let conPassword = conPwdTxt.text, conPwdTxt.text != "" else{return}
        
        if password == conPassword{
            AuthService.instance.registerUser(email: email, password: password, completion: { (success) in
                if success {
                    print("Register User")
                    AuthService.instance.logInUser(email: email, password: password, completion: { (success) in
                        if success{
                            print("Successfully logged in", AuthService.instance.authToken)
                            //performSegue(withIdentifier: TO_LOGIN, sender: (Any).self)
                            print(name, " ", email, " ", password, " ", self.avatarName , " ", self.avatarColor)
                            AuthService.instance.createUser(name: name, email: email, avatarName: self.avatarName, avatarColor: self.avatarColor, completion: { (success) in
                                if success{
                                    print(UserDataService.instance.name, UserDataService.instance.avatarName)
                                    self.performSegue(withIdentifier: UNWIND , sender: nil)
                                    NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                                    self.spinner.isHidden = true
                                    self.spinner.stopAnimating()
                                }
                            })
                        }
                    })
                }
            })
        }else{
            print("Unmatched Password")
            pwdTxt.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedStringKey.foregroundColor : UIColor.red])
            pwdTxt.text = ""
            conPwdTxt.attributedPlaceholder = NSAttributedString(string: "Confirm Password", attributes: [NSAttributedStringKey.foregroundColor : UIColor.red])
            conPwdTxt.text = ""
            self.spinner.isHidden = true
            self.spinner.stopAnimating()
        }
    
    }
    
    func setUpView(){
        spinner.isHidden = true
        userNameTxt.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedStringKey.foregroundColor: SMACKPURPLEPLACEHOLDER])
        emailTxt.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedStringKey.foregroundColor: SMACKPURPLEPLACEHOLDER])
        pwdTxt.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedStringKey.foregroundColor : SMACKPURPLEPLACEHOLDER])
        conPwdTxt.attributedPlaceholder = NSAttributedString(string: "Confirm Password", attributes: [NSAttributedStringKey.foregroundColor : SMACKPURPLEPLACEHOLDER])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(RegisterVC.handleTap))
        self.view.addGestureRecognizer(tap)
        
    }
    
    @objc func handleTap(){
        view.endEditing(true)
    }
    
    @IBAction func updateAccount(_ sender: Any) {
    }
    
//    func toggleEditable(){
//        if AuthService.instance.isLoggedIn && AuthService.instance.isEditable && AuthService.instance.userEmail == UserDataService.instance.email{
//            updateAccountBtn.isHidden = false
//            generateAccBtn.isHidden = true
//        }
//    }
}
