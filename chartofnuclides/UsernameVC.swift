//
//  UsernameVC.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 2/27/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit

class UsernameVC: UIViewController {

    @IBOutlet weak var usernameField: LoginField!
    @IBOutlet weak var activityIndicatorView: InspectableBorderView!
    @IBOutlet weak var usernameMessageLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
            
            // now segue to the profile VC
            if let presentingVC = self.presentingViewController?.presentingViewController?.presentingViewController {
                presentingVC.dismiss(animated: false, completion: nil)
            } else {
                self.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
            }
        }
    }
    
    @IBAction func xPressed(_ sender: Any) {
        
        if let presentingVC = self.presentingViewController?.presentingViewController?.presentingViewController {
            presentingVC.dismiss(animated: false, completion: nil)
        } else {
            self.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
        }
        
    }
    
    @IBAction func usernameReturnPressed(_ sender: Any) {
        usernameField.resignFirstResponder()
        view.endEditing(true)
    }
    
}
