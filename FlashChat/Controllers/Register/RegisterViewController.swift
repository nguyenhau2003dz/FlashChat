//
//  RegisterViewController.swift
//  FlashChat
//
//  Created by Hậu Nguyễn on 12/3/25.
//

import UIKit
import FirebaseCore
import FirebaseAuth

class RegisterViewController: UIViewController {

    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func registerPressed(_ sender: Any) {
        if let email = emailTextfield.text, let password = passwordTextfield.text{
            Auth.auth().createUser(withEmail: email, password: password){authResult, error in
                if let e = error{
                    print(e)
                }else{
                    self.navigationController?.pushViewController(ChatViewController(), animated: true)
                }
            }
        }
    }
    
}
