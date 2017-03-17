//
//  EmailLoginVC.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 2/27/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit
import FirebaseAuth

class EmailLoginVC: UIViewController {

    @IBOutlet weak var emailTxtLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var activityIndicatorView: InspectableBorderView!
    @IBOutlet weak var emailField: LoginField!
    @IBOutlet weak var passwordField: LoginField!
    var loginType: LoginType!
    var delegate: SendDataToPreviousControllerDelegate?
    
    let fadeInTransitionAnimator = FadeInAnimator()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateBtnText()
    }
    
    func updateBtnText() {
        switch loginType! {
        case .login:
            emailTxtLbl.text = "LOG IN"
            titleLbl.text = "LOG IN"
            break
        case .signUp:
            emailTxtLbl.text = "SIGN UP"
            titleLbl.text = "SIGN UP"
            break
            
        }
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        view.endEditing(true)
        
        guard let email = emailField.text, !email.isEmpty else {
            print("The email field needs to be populated")
            let ac = UIAlertController(title: "Email inValid", message: "You must enter a valid email", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(ac, animated: true)
            return
        }
        
        guard let pwd = passwordField.text, pwd.characters.count > 6 else {
            print("The password field needs to be populated with more than 6 characters")
            let ac = UIAlertController(title: "Password inValid", message: "You must enter a password longer than 6 characters", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(ac, animated: true)
            return
        }
        
        activityIndicatorView.isHidden = false
        
        switch loginType! {
            
        case .login:
            loginUser()
            break

        case .signUp:
            signUpUser()
            break

        }
    }
    
    func presentAlertWith(_ error: NSError) {
        let message = ErrorHandler.handleFirebaseError(error: error)
        let ac = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(ac, animated: true)
    }
    
    func loginUser() {
        AuthService.instance.login(email: emailField.text!, password: passwordField.text!) { (error, user) in
            
            self.activityIndicatorView.isHidden = true
            
            if error != nil {
                self.presentAlertWith(error!)
                return
            } else {
                
                if let currentUser = user as? FIRUser {
                    self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                    self.delegate?.sendDataToA(data: currentUser)
                } else {
                    self.presentAlertWith(NSError())
                }
                
            }
        }
    }
    
    func signUpUser() {
        AuthService.instance.attemptCreateUser(withEmail: emailField.text!, password: passwordField.text!) { (error, user) in
            
            self.activityIndicatorView.isHidden = true
            
            if error != nil {
                self.presentAlertWith(error!)
                return
            } else {
                if let currentUser = user as? FIRUser {
                    self.performSegue(withIdentifier: "UsernameVC", sender: currentUser)
                } else {
                    self.presentAlertWith(NSError())
                }
            }
        }
    }

    @IBAction func xPressed(_ sender: Any) {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)

    }
    
    @IBAction func emailReturnPressed(_ sender: Any) {
        emailField.resignFirstResponder()
        passwordField.becomeFirstResponder()

    }

    @IBAction func passwordReturnPressed(_ sender: Any) {
        passwordField.resignFirstResponder()
        view.endEditing(true)
    }
}

extension EmailLoginVC: UIViewControllerTransitioningDelegate {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "UsernameVC" {
            if let destination = segue.destination as? UsernameVC {
                destination.transitioningDelegate = self
                destination.delegate = self.delegate
                
                if let user = sender as? FIRUser {
                    destination.user = user
                }
            }
        }
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        fadeInTransitionAnimator.animationDuration = 0.7
        return fadeInTransitionAnimator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return fadeInTransitionAnimator
    }
    
}
