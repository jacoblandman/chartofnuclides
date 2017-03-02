//
//  ProfileVC.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 2/27/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit
import FirebaseAuth
import RSKImageCropper
import Firebase

class ProfileVC: UIViewController {

    @IBOutlet weak var profileImgView: CircleImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var commentsLbl: UILabel!
    @IBOutlet weak var questionsLbl: UILabel!
    @IBOutlet weak var repuationLbl: UILabel!
    @IBOutlet weak var activityIndicatorView: InspectableBorderView!
    var user: User?
    
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker = UIImagePickerController()
        //imagePicker.allowsEditing = true
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
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
        
        if user!.imageURL != "" {
            DataService.instance.setImage(forURL: user!.imageURL) { (error, image) in
                if error != nil {
                    print("JACOB: Error downloading image from firebase storage")
                } else {
                    print("JACOB: Image download successful")
                    if let img = image {
                        self.profileImgView.image = img
                    }
                }
                
                self.activityIndicatorView.isHidden = true
            }
        } else {
            self.activityIndicatorView.isHidden = true
        }
    }

    @IBAction func changeProfileImgPressed(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
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

extension ProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            print("JACOB: Made it within the imagePickerController")
            var imageCropVC : RSKImageCropViewController!
            imageCropVC = RSKImageCropViewController(image: image, cropMode: RSKImageCropMode.circle)
            imageCropVC.delegate = self
            
            self.presentedViewController?.present(imageCropVC, animated: true, completion: nil)

        } else {
            print("JACOB: A valid image wasn't selected")
        }
    }
}

extension ProfileVC: RSKImageCropViewControllerDelegate {
    
    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect) {
        //self.profileImgView.image = croppedImage.resizeWith(width: 150)
        self.profileImgView.image = croppedImage
        if let user = user {
            DataService.instance.saveProfileImage(image: croppedImage, uid: user.uid)
        }
        
        imagePicker.dismiss(animated: false, completion: nil)
        self.presentedViewController?.dismiss(animated: true, completion: nil)
        
        
    }
    
    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat) {
        //self.profileImgView.image = croppedImage.resizeWith(width: 150)
        self.profileImgView.image = croppedImage
        if let user = user {
            DataService.instance.saveProfileImage(image: croppedImage, uid: user.uid)
        }
        imagePicker.dismiss(animated: false, completion: nil)
        self.presentedViewController?.dismiss(animated: true, completion: nil)
        
    }
    
    func imageCropViewController(_ controller: RSKImageCropViewController, willCropImage originalImage: UIImage) {
    }
}