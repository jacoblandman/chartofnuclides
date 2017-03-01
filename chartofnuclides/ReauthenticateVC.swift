//
//  ReauthenticateVC.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 3/1/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit
import FirebaseAuth

class ReauthenticateVC: UIViewController {

    @IBOutlet weak var emailField: ReauthenticateField!
    @IBOutlet weak var passwordField: ReauthenticateField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func authenticatePressed(_ sender: Any) {
        
        guard let email = emailField.text, !email.isEmpty else {
            print("The email field needs to be populated")
            let ac = UIAlertController(title: "Email invalid", message: "You must enter a valid email", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(ac, animated: true)
            return
        }
        
        guard let pwd = passwordField.text, pwd.characters.count > 6 else {
            print("The password field needs to be populated with more than 6 characters")
            let ac = UIAlertController(title: "Password invalid", message: "You must enter a password longer than 6 characters", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(ac, animated: true)
            return
        }
        
        // now reauthenticate the current user
        let credential = FIREmailPasswordAuthProvider.credential(withEmail: email, password: pwd)

        AuthService.instance.reauthenticateUser(withCredential: credential) { (errMsg) in
            
            if let errorMsg = errMsg {
                // an error occurred
                print("JACOB: An error occured trying to reauthenticate the user: ", errorMsg)
            } else {
                // the reauthentication was a success
                print("JACOB: about to dismiss")
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func emailReturned(_ sender: Any) {
        emailField.resignFirstResponder()
        passwordField.becomeFirstResponder()
    }
    
    @IBAction func passwordReturned(_ sender: Any) {
        passwordField.becomeFirstResponder()
        view.endEditing(true)
    }
    
}
