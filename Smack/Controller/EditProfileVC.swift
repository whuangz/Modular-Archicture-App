//
//  EditProfileVC.swift
//  Smack
//
//  Created by William Huang on 20/07/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import UIKit

class EditProfileVC: UIViewController {

    
    @IBOutlet weak var nameTxtField: UITextField!
    
    var delegate: UpdateProfile?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func updateBtnPressed(_ sender: Any) {
        guard let name = nameTxtField.text, nameTxtField.text != "" else {return}
        AuthService.instance.updateUser(name: name) { (success) in
            if success{
                NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                self.delegate?.updateProfile(name: name)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}

public protocol UpdateProfile {
    public func updateProfile(name:String)
}
