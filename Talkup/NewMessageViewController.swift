//
//  NewMessageViewController.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 3/13/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit
import CloudKit

class NewMessageViewController: UIViewController, UITextFieldDelegate, SearchResultsControllerDelegate {
    
    //MARK: - Properties
    
    var searchTerm: String?
    
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
    
    override func viewDidLoad() {
        messageTextField.delegate = self
        sendMessageButton.isEnabled = false
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
    }
    
    var barHeight: CGFloat = 65
    
    //MARK: - UI Actions
    
    @IBAction func newChatButtonTapped(_ sender: Any) {
        createChat()
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func messageTextFieldEditingChanged(_ sender: Any) {
        guard messageTextField.text != "" && searchTerm != "" else { sendMessageButton.isEnabled = false; return }
        sendMessageButton.isEnabled = true
    }
    //MARK: - Methods
    
    func createChat() {
        guard let topicText = searchTerm,
            let message = messageTextField.text,
            !topicText.isEmpty,
            message != "",
            let owner = UserController.shared.currentUser
            else { return }
        
        ChatController.shared.createChatWith(chatTopic: topicText, owner: owner, firstMessage: message, isDirectChat: false) { (_) in
            
            self.dismiss(animated: true, completion: nil)
            
        }
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchTermEntered" {
            let embedSearchController = segue.destination as? SearchResultsController
            embedSearchController?.delegate = self
        }
    }
    
    //MARK: - Search Controller Delegate 
    
    func searchTermsEntered(_ term: String) {
        self.searchTerm = term
    }
}



















