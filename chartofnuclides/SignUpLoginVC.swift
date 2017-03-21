//
//  SignUpLoginVC.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 3/17/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit
import Firebase

enum LoginType {
    case signUp
    case login
}

class SignUpLoginVC: UIViewController {

    let fadeInTransitionAnimator = FadeInAnimator()
    var loginType: LoginType!
    @IBOutlet weak var activitiyMonitorView: InspectableBorderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUpPressed(_ sender: Any) {
        loginType = .signUp
        performSegue(withIdentifier: "LoginVC", sender: loginType)
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        loginType = .login
        performSegue(withIdentifier: "LoginVC", sender: loginType)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginVC" {
            if let destination = segue.destination as? LoginVC {
                if let loginType = sender as? LoginType {
                    destination.loginType = loginType
                    destination.transitioningDelegate = self
                    destination.delegate = self
                }
            }
        }
    }
    
    @IBAction func exitPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension SignUpLoginVC: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        fadeInTransitionAnimator.animationDuration = 0.7
        return fadeInTransitionAnimator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return fadeInTransitionAnimator
    }

}

extension SignUpLoginVC: SendDataToPreviousControllerDelegate {
    
    func sendDataToA(data: Any) {
        // do something with the data sent back here
        activitiyMonitorView.isHidden = false
        
        if let user = data as? FIRUser {
            // now load the user and his image and hide the activty monitor after
            // then dismiss
            let uid = user.uid
            let user = User(uid: uid)
            user.loadUserInfo {
                self.loadUserImage(user: user)
            }
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    func loadUserImage(user: User) {
        if user.imageURL != "" {
            DataService.instance.getImage(fromURL: user.imageURL) { (error, image) in
                if error != nil {
                    print("JACOB: Error downloading image from firebase storage")
                    ErrorHandler.handleImageDownloadError(error: error!)
                } else {
                    print("JACOB: Image download successful")
                    if let img = image {
                        CustomFileManager.saveImageToDisk(image: img)
                    }
                    self.dismiss(animated: true, completion: nil)
                }
            }
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
}
