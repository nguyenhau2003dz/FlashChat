//
//  ChatViewController.swift
//  FlashChat
//
//  Created by Hậu Nguyễn on 12/3/25.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    let db = Firestore.firestore()
    var messages: [Message]=[]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    
    func setupData() {
        tableView.dataSource = self
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        loadMessages()
    }

    func setupUI() {
        self.title = "⚡️FlashChat"
        let textAttributes: [NSAttributedString.Key: Any] = [
          .foregroundColor: UIColor.white,
              .font: UIFont.boldSystemFont(ofSize: 24)
          ]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
      
        navigationItem.hidesBackButton = true
      
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(loggoutTapped))
        logoutButton.tintColor = .white
        navigationItem.rightBarButtonItem = logoutButton
    }
    
    func loadMessages(){
        
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener { querySnapshot, error in
            self.messages = []
            if let e = error{
                print("There was issue retriving data from Firestore")
            }else{
                if let snapshotDocuments = querySnapshot?.documents{
                    for doc in snapshotDocuments{
                        let data = doc.data()
                    
                        if let messageSender = data[K.FStore.senderField] as? String, let messageBody = data[K.FStore.bodyField] as? String{
                            let newMessage = Message(sender: messageSender, body: messageBody)
                            self.messages.append(newMessage)
                        
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                
                                //vua vao thi load tu cuoi len
                                let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                            }
                        }
                    }
                }
            }
        }
    }

    @IBAction func sendPressed(_ sender: Any) {
        if let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email{
            db.collection(K.FStore.collectionName).addDocument(data: [
                K.FStore.senderField: messageSender,
                K.FStore.bodyField: messageBody,
                K.FStore.dateField: Date().timeIntervalSince1970
            ]) { (error) in
                if let e = error{
                    print("There was an issue saving data to firestore.  \(e)")
                }else{
                    print("Successfully saved data in Firebase")
                    DispatchQueue.main.async {
                        self.messageTextfield.text = ""
                    }
                }
            }
        }
    }
    
    @objc func loggoutTapped() {
        let firebaseAuth = Auth.auth()
        do{
            try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
        }catch let signOutError as NSError{
            print(signOutError)
        }
    }
}

extension ChatViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messages[indexPath.row]
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        cell.Label.text = message.body
        
        //this is a message from current user
        if message.sender == Auth.auth().currentUser?.email{
            cell.leftimageView.isHidden = true
            cell.rightimageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell.Label.textColor = UIColor(named: K.BrandColors.purple)
            //this is message from other user
        }else{
            cell.leftimageView.isHidden = false
            cell.rightimageView.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
            cell.Label.textColor = UIColor(named: K.BrandColors.lightPurple)

        }
        return cell
    }
}
