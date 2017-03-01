//
//  ProfileVC.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 2/27/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileVC: UIViewController {

    @IBOutlet weak var profileImgView: CircleImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var commentsLbl: UILabel!
    @IBOutlet weak var questionsLbl: UILabel!
    @IBOutlet weak var repuationLbl: UILabel!
    @IBOutlet weak var activityIndicatorView: InspectableBorderView!
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let currentUser = FIRAuth.auth()?.currentUser {
            activityIndicatorView.isHidden = false
            user = User(uid: currentUser.uid)
            user?.loadUserInfo(completed: { 
                self.updateUI()
            })
        } else {
            print("JACOB: Error current user not found")
        }
    }
    
    func updateUI() {
        // we know a user exists at this point
        self.usernameLbl.text = user!.username
        self.commentsLbl.text = "\(user!.comments)"
        self.questionsLbl.text = "\(user!.questions)"
        self.repuationLbl.text = "\(user!.reputation)"
        activityIndicatorView.isHidden = true
    }

    @IBAction func changeProfileImgPressed(_ sender: Any) {
    }
    
    @IBAction func logOutPressed(_ sender: Any) {
        let ac = UIAlertController(title: "Signing Out", message: "Are you sure about this?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        ac.addAction(UIAlertAction(title: "Yes, I'm sure", style: .default, handler: { (alert: UIAlertAction!) in
            AuthService.instance.signOutCurrentUser()
            self.dismiss(animated: true, completion: nil)
        }))
        present(ac, animated: true, completion: nil)
        
    }
    
    @IBAction func deleteAccountPressed(_ sender: Any) {
        // present action controller to verify user wants to log out

        guard let uid = user?.uid, let username = user?.username else { return }
        
        let ac = UIAlertController(title: "Deleting Account", message: "Are you sure about this? There is no going back...", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        ac.addAction(UIAlertAction(title: "Yes, I'm sure", style: .default, handler: { (alert: UIAlertAction!) in
            AuthService.instance.deleteCurrentUser(uid: uid, username: username, completed: { (errorCode) in
                self.handle(errorCode)
            })
        }))
            
        present(ac, animated: true, completion: nil)
    }
    
    func handle(_ errCode: FIRAuthErrorCode?) {
        
        if let errorCode = errCode {
            print("JACOB Error code: ", errorCode.rawValue)
            switch(errorCode) {
            case .errorCodeUserMismatch:
                let ac = UIAlertController(title: "Incorrect user", message: "Please log out of the current account and sign back in before attempting to delete.", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
                present(ac, animated: true, completion: nil)
                break
            
            case .errorCodeInvalidUserToken:
                reauthenticateUser()
                break
                
            case .errorCodeRequiresRecentLogin:
                print("JACOB: Need to reauthenticte")
                reauthenticateUser()
                break
                
            default:
                break
            }
        } else {
            // the user deletion was a success
            print("JACOB: Deletion success. About to dismiss the view")
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func reauthenticateUser() {
        performSegue(withIdentifier: "ReauthenticateVC", sender: nil)
    }

    @IBAction func exitPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
