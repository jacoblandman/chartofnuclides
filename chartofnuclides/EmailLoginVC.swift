//
//  EmailLoginVC.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 2/27/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit

class EmailLoginVC: UIViewController {

    @IBOutlet weak var activityIndicatorView: InspectableBorderView!
    @IBOutlet weak var emailField: LoginField!
    @IBOutlet weak var passwordField: LoginField!
    
    let fadeInTransitionAnimator = FadeInAnimator()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        
        AuthService.instance.login(email: email, password: pwd) { (errMsg, data) in
            
            self.activityIndicatorView.isHidden = true
            
            guard errMsg == nil else {
                let ac = UIAlertController(title: "Error Authentication", message: errMsg, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(ac, animated: true)
                return
            }
            
            
            self.performSegue(withIdentifier: "UsernameVC", sender: nil)
            
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
