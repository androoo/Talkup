//
//  EditPhotoViewController.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 8/20/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import UIKit

protocol EditPhotoViewControllerDelegate {
    func editPhotoViewControllerSelected(_ image: UIImage)
}

class EditPhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    //MARK: - Properties 
    
    var delegate: EditPhotoViewControllerDelegate?
    
    @IBOutlet weak var userPhotoImageView: UIImageView!

    @IBAction func AddPhotoButtonTapped(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let alert = UIAlertController(title: "Select Photo Location", message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (_) in
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            }))
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_) in
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }

    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            delegate?.editPhotoViewControllerSelected(image)
            userPhotoImageView.image = image
        }
        
    }
    
}
