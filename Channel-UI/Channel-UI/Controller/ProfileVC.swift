//
//  ProfileVC.swift
//  Smack
//
//  Created by William Huang on 12/06/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import UIKit
import CommonService

class ProfileVC: UIViewController {

    //Outlets
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var bgView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeModalPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        UserDataService.instance.logoutUser()
        NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    func setUpView(){
        userName.text = UserDataService.instance.name
        userEmail.text = UserDataService.instance.email
        profileImg.image = UIImage(named: UserDataService.instance.avatarName)
        profileImg.backgroundColor = UserDataService.instance.returnUIColor(components: UserDataService.instance.avatarColor)
        
        let closeGesture = UITapGestureRecognizer(target: self, action: #selector(ProfileVC.closeTapProfile))
        bgView.addGestureRecognizer(closeGesture)
    }
    
    @objc func closeTapProfile(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editProfilePressed(_ sender: Any) {
//        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
//        let editVC = storyboard.instantiateViewController(withIdentifier: "editProfileVC")
        //AuthService.instance.isEditable = true
        let editVC = EditProfileVC()
        editVC.delegate = self
        editVC.modalPresentationStyle = .custom
        self.present(editVC, animated: true, completion: nil)
        
    }
}


extension ProfileVC: UpdateProfile{
    func updateProfile(name: String) {
        self.userName.text = name
    }
}
