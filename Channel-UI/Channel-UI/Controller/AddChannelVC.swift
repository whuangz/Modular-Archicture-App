//
//  AddChannelVC.swift
//  Smack
//
//  Created by William Huang on 14/06/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import UIKit
import CommonService

class AddChannelVC: UIViewController {

    //Outlets
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var channelDesc: UITextField!
    @IBOutlet weak var bgView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        // Do any additional setup after loading the view.
    }
    
    
    
    @objc func setUserInfo(_ notif: Notification){
        nameTxt.text = UserDataService.instance.name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addChannelPressed(_ sender: Any) {
        guard let name = nameTxt.text, nameTxt.text != "" else {return}
        guard let desc = channelDesc.text else {return}
        SocketService.instance.addChannel(channelName: name, channelDesc: desc) { (success) in
            if success{
                print(name, desc)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func setUp(){
        nameTxt.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSAttributedString.Key.foregroundColor : SMACKPURPLEPLACEHOLDER])
        channelDesc.attributedPlaceholder = NSAttributedString(string: "Description", attributes: [NSAttributedString.Key.foregroundColor : SMACKPURPLEPLACEHOLDER])
        let closeTap = UITapGestureRecognizer(target: self, action: #selector(AddChannelVC.handleCloseTap(_:)))
        bgView.addGestureRecognizer(closeTap)
    }
    
    @objc func handleCloseTap(_ recognizer: UITapGestureRecognizer){
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
