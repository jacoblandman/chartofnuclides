//
//  LoginVC.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 2/27/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginVC: UIViewController, UIViewControllerTransitioningDelegate {

    var delegate: SendDataToPreviousControllerDelegate?
    @IBOutlet weak var fbTxtLbl: UILabel!
    @IBOutlet weak var EmailTxtLbl: UILabel!
    @IBOutlet weak var activityIndicatorView: InspectableBorderView!
    let fadeInTransitionAnimator = FadeInAnimator()
    var loginType: LoginType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateBtnText()

    }
    
    func updateBtnText() {
        switch loginType! {
        case .login:
            fbTxtLbl.text = "LOGIN WITH FACEBOOK"
            EmailTxtLbl.text = "LOGIN"
            break
        case .signUp:
            fbTxtLbl.text = "SIGN UP WITH FACEBOOK"
            EmailTxtLbl.text = "SIGN UP"
            break
            
        }
    }
    
    @IBAction func emailLoginPressed(_ sender: Any) {
        performSegue(withIdentifier: "EmailLoginVC", sender: nil)
    }

    @IBAction func facebookLoginPressed(_ sender: Any) {
        
        // authenticate with facebook
        activityIndicatorView.isHidden = false
        AuthService.instance.authenticateWithFacebook(fromVC: self) { (errorMsg, user) in
            
            if let errMsg = errorMsg {
                // if the user cancelled we don't need to do anything
                print("JACOB: An error occured while logging in with facebook")
                print(errMsg)
            } else {
                
                // facebook login was a success
                print("JACOB: Facebook login successful")
                if let currentUser = user as? FIRUser {
                    _ = DataService.instance.checkIfPreviousUser(uid: currentUser.uid, completed: { (isPreviousUser) in
                        if (isPreviousUser) {
                            self.dismiss(animated: true, completion: nil)
                            self.delegate?.sendDataToA(data: currentUser)
                        } else {
                            self.performSegue(withIdentifier: "UsernameVC", sender: currentUser)
                        }
                        
                        self.activityIndicatorView.isHidden = true
                    })
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "EmailLoginVC" {
            if let destination = segue.destination as? EmailLoginVC {
                destination.transitioningDelegate = self
                destination.loginType = self.loginType
                destination.delegate = self.delegate
            }
        } else if segue.identifier == "UsernameVC" {
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

    @IBAction func xPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
