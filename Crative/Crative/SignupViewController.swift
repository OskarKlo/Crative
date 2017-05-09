//
//  SignupViewController.swift
//  Crative
//
//  Created by Oskar on 5/8/17.
//  Copyright © 2017 Oskar Klonowski. All rights reserved.
//

import UIKit
import Firebase


class SignupViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var comPwField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nextBtn: UIButton!
    
    let picker = UIImagePickerController()
    var userStorage: FIRStorageReference!
    var ref: FIRDatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        let storage = FIRStorage.storage().reference(forURL: "gs://crative-768bf.appspot.com")
        
        ref = FIRDatabase.database().reference()
        userStorage = storage.child("users")
        
    }

    @IBAction func selectImagePressed(_ sender: Any) {
        
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.imageView.image = image
            nextBtn.isHidden = false
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextPressed(_ sender: Any) {
        
        guard nameField.text != "", emailField.text != "", passwordField.text != "", comPwField.text != "" else { return}
        
        if password.text == comPwField.text {
            FIRAuth.auth()?.createUser(withEmail: emailField.text!, password: password.text, completion: { (user, error) in
                if let error = error {
                    print(error.localizedDescription)
                }
                
                if let user = user {
                    let imageRef = self.userStorage.child("\(user.uid).jpg")
                    
                    let data = UIImageJPEGRepresentation(self.imageView.image!, 0.5)
                    
                    let uploadTask = imageRef.put(data!, metadata: nil, completion: { (metadata, err) in
                        if err != nil {
                            print(err!.localizedDescription)
                        }
                        
                        imageRef.downloadURL(completion: { (url, er) in
                            if er != nil{
                                print(er!.localizedDescription)
                            }
                            
                            if let url = url {
                                
                                let userInfo: [String : Any] = ["uid" : user.uid,
                                                                "full name" : self.nameField.text!,
                                                                "urlToImage" : url.absoluteString]
                                
                                self.ref.child("users").child(user.uid).setValue(userInfo)
                                
                                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "userVC")
                                
                                self.present(vc, animated: true, completion: nil)
                            }
                        })
                    })
                }
            })
            
        } else {
            print("Password does not match")
        }
        
    }
    
}
