//
//  ReauthenticateVC.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 3/1/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit

class ReauthenticateVC: UIViewController {

    @IBOutlet weak var emailField: LoginField!
    @IBOutlet weak var passwordField: LoginField!
    @IBOutlet weak var activityIndicatorView: InspectableBorderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func reauthenticatePressed(_ sender: Any) {
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
        reauthenticateWith(credential)
    }
    
    @IBAction func emailReturned(_ sender: Any) {
        emailField.resignFirstResponder()
        passwordField.becomeFirstResponder()
    }
    
    @IBAction func passwordReturned(_ sender: Any) {
        passwordField.becomeFirstResponder()
        view.endEditing(true)
    }
    
    @IBAction func xPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func reauthenticateWith(_ credential: FIRAuthCredential) {
        activityIndicatorView.isHidden = false
        AuthService.instance.reauthenticateUser(withCredential: credential) { (error, user) in
            self.activityIndicatorView.isHidden = true
            if error != nil {
                // an error occurred
                print("JACOB: An error occured trying to reauthenticate the user: ", error!.debugDescription)
                let message = ErrorHandler.handleFirebaseError(error: error!)
                let ac = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
                self.present(ac, animated: true, completion: nil)
            } else {
                // the reauthentication was a success
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
