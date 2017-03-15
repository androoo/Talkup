//
//  NewMessageViewController.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 3/13/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

class NewMessageViewController: UIViewController {
    
    //MARK: - Properties
    
    
    //MARK: - Outlets
    
    @IBOutlet weak var topicTextField: UITextField!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendMessageButton: UIButton!
    
    //MARK: - UI Actions
    
    
    @IBAction func sendMessageButtonTapped(_ sender: Any) {
        createChat()
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Methods 
    
    func createChat() {
        guard let topicText = topicTextField.text,
            let message = messageTextField.text else { return }
       
        let chat = Chat(topic: topicText)
        ChatController.addChatToCloudKit(chatTopic: topicText, owner: "bob", firstMessage: message) { 
            
            
        }
        dismiss(animated: true, completion: nil)
    }

}



















