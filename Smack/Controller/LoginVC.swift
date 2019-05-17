//
//  LoginVC.swift
//  Smack
//
//  Created by William Huang on 25/05/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import UIKit
import CommonService

class LoginVC: UIViewController {

    //Outlets
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var pwdTxt: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        // Do any additional setup after loading the view.
    }

    @IBAction func closeBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func linkToRegister(_ sender: Any) {
        performSegue(withIdentifier: TO_REGISTER , sender: nil)
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        spinner.isHidden = false
        spinner.startAnimating()
        guard let email = emailTxt.text, emailTxt.text != "" else {return}
        guard let password = pwdTxt.text, pwdTxt.text != "" else {return}
        
        AuthService.instance.logInUser(email: email, password: password, completion: { (success) in
            if success{
                AuthService.instance.findUserByEmail(completion: { (success) in
                    if success{
                        NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                        self.dismiss(animated: true, completion: nil)
                    }
                })
            }
            self.spinner.isHidden = true
            self.spinner.stopAnimating()
        })
    }
    
    func setUpView(){
        spinner.isHidden = true
        emailTxt.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedStringKey.foregroundColor: SMACKPURPLEPLACEHOLDER])
        pwdTxt.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedStringKey.foregroundColor : SMACKPURPLEPLACEHOLDER])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(LoginVC.handleTap))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(){
        self.view.endEditing(true)
    }
}
