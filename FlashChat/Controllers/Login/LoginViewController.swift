//
//  LoginViewController.swift
//  FlashChat
//
//  Created by Hậu Nguyễn on 12/3/25.
//

import UIKit
import FirebaseCore
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()    
    }

    @IBAction func loginPressed(_ sender: Any) {
        if let email = emailTextfield.text, let pass = passwordTextfield.text{
            Auth.auth().signIn(withEmail: email, password: pass){authResult, error in
                if let e = error{
                    print(e)
                }else{
                    self.navigationController?.pushViewController(ChatViewController(), animated: true)
                }
            }
        }
    }
    
}
