//
//  WelcomeViewController.swift
//  FlashChat
//
//  Created by Hậu Nguyễn on 12/3/25.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = ""
        var charIndex = 0.0
        let titleText = K.appName
        for letter in titleText{
            Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) { (timer) in
                self.titleLabel.text?.append(letter)
            }
            
            charIndex += 1
        }
    }

    @IBAction func registerPress(_ sender: Any) {
        self.navigationController?.pushViewController(RegisterViewController(), animated: true)
    }
    
    @IBAction func loginPress(_ sender: Any) {
        self.navigationController?.pushViewController(LoginViewController(), animated: true)
    }
    
}
