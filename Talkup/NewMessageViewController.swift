//
//  NewMessageViewController.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 3/13/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

class NewMessageViewController: UIViewController {

    //MARK: - Outlets
    
    @IBOutlet var inputbar: UIView!
    @IBOutlet weak var topicTextField: UITextField!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendMessageButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    override var inputAccessoryView: UIView? {
        get {
            self.inputbar.frame.size.height = self.barHeight
            self.inputbar.clipsToBounds = true
            return self.inputbar
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    var barHeight: CGFloat = 50
    
    //MARK: - UI Actions
    
    @IBAction func newChatButtonTapped(_ sender: Any) {
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

        ChatController.shared.createChatWith(chatTopic: topicText, owner: "phil", firstMessage: message) { (_) in
            self.dismiss(animated: true, completion: nil)
        }
    }
}



















