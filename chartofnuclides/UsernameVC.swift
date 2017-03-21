//
//  UsernameVC.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 2/27/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit
import FirebaseAuth

class UsernameVC: UIViewController {

    @IBOutlet weak var usernameField: LoginField!
    @IBOutlet weak var activityIndicatorView: InspectableBorderView!
    @IBOutlet weak var usernameMessageLbl: UILabel!
    
    var user: FIRUser!
    
    var delegate: SendDataToPreviousControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func presentAlertWith(_ error: NSError) {
        let message = ErrorHandler.handleFirebaseError(error: error)
        let ac = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(ac, animated: true)
    }
    
    @IBAction func finishLoggingInPressed(_ sender: Any) {
        guard let username = usernameField.text, username.characters.count > 6 else {
            // present a message to the user
            usernameMessageLbl.text = "Username must be greater than 6 characters..."
            return
        }
        
        DataService.instance.verifyIsUnique(username) { (isUnique) in
            
            guard isUnique else {
                // present a message to the user saying the username is already taken
                self.usernameMessageLbl.text = "Username already taken..."
                return
            }
            
            DataService.instance.saveUser(uid: self.user.uid)
            
            // now segue to the profile VC
            if let presentingVC = self.presentingViewController?.presentingViewController?.presentingViewController {
                // if we are here then the user logged in with an email
                presentingVC.dismiss(animated: true, completion: nil)
            } else {
                // if we are here then the user logged in through facebook, so there was one less view controller
                self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
            }
            
            self.delegate?.sendDataToA(data: self.user)
        }
    }
    
    @IBAction func xPressed(_ sender: Any) {
        
        view.endEditing(true)
        let ac = UIAlertController(title: "Cancel sign up", message: nil, preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (alert: UIAlertAction!) in

            AuthService.instance.deleteCurrentUser(uid: self.user.uid, username: nil, imageURL: "", completed: { (error) in
                if error != nil {
                    self.presentAlertWith(error!)
                    return
                } else {
                    self.dismissView()
                }
            })
        }))
        
        ac.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        present(ac, animated: true, completion: nil)
        
    }
    
    @IBAction func usernameReturnPressed(_ sender: Any) {
        usernameField.resignFirstResponder()
        view.endEditing(true)
    }
    
    func dismissView() {
        if let presentingVC = self.presentingViewController?.presentingViewController?.presentingViewController {
            presentingVC.dismiss(animated: true, completion: nil)
        } else {
            self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        }
        // this is just going to make the view controller dismiss
        delegate?.sendDataToA(data: "")
    }
    
}
