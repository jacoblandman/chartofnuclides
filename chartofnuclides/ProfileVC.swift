//
//  ProfileVC.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 2/27/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit
import RSKImageCropper
import Firebase
import FBSDKLoginKit

class ProfileVC: UIViewController {

    @IBOutlet weak var profileImgView: CircleImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var answersLbl: UILabel!
    @IBOutlet weak var questionsLbl: UILabel!
    @IBOutlet weak var repuationLbl: UILabel!
    @IBOutlet weak var activityIndicatorView: InspectableBorderView!
    var user: User!
    var profileImage: UIImage!
    var imageIsSet = false
    
    var delegate: SendDataToPreviousControllerDelegate?
    
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        profileImgView.image = profileImage
        
        activityIndicatorView.isHidden = false
        user?.loadUserInfo(completed: { 
            self.updateUI()
            if self.imageIsSet { self.activityIndicatorView.isHidden = true }
           
        })
    }
    
    func updateUI() {
        // we know a user exists at this point
        self.usernameLbl.text = user!.username
        self.answersLbl.text = "\(user!.answers)"
        self.questionsLbl.text = "\(user!.questions)"
        self.repuationLbl.text = "\(user!.reputation)"
        
        if imageIsSet { return }
        
        if user!.imageURL != "" {
            DataService.instance.getImage(fromURL: user!.imageURL) { (error, image) in
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
        
        let ac = UIAlertController(title: "Change Profile Photo", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Remove Current Photo", style: UIAlertActionStyle.destructive, handler: { (UIAlertAction) in
            self.deleteImage(URL: self.user.imageURL)
        }))
        ac.addAction(UIAlertAction(title: "Choose from Library", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(ac, animated: true, completion: nil)
        
        
    }
    
    @IBAction func logOutPressed(_ sender: Any) {
        let ac = UIAlertController(title: "Signing Out", message: "Are you sure about this?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        ac.addAction(UIAlertAction(title: "Yes, I'm sure", style: .default, handler: { (alert: UIAlertAction!) in
            AuthService.instance.signOutCurrentUser()
            CustomFileManager.removeCurrentImage()
            self.delegate?.signalRefresh()
            self.dismiss(animated: true, completion: nil)
        }))
        present(ac, animated: true, completion: nil)
        
    }
    
    @IBAction func deleteAccountPressed(_ sender: Any) {
        // present action controller to verify user wants to log out

        guard let uid = user?.uid, let username = user?.username, let imageURL = user?.imageURL else { return }
        
        let ac = UIAlertController(title: "Deleting Account", message: "Are you sure about this? There is no going back...", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        ac.addAction(UIAlertAction(title: "Yes, I'm sure", style: .default, handler: { (alert: UIAlertAction!) in
            AuthService.instance.deleteCurrentUser(uid: uid, username: username, imageURL: imageURL, completed: { (error) in
                
                if error != nil {
                    let needsReauthentication = ErrorHandler.handleDeletionError(error: error!)
                    if needsReauthentication {
                        self.reauthenticateUser()
                    } else {
                        let ac = UIAlertController(title: "Error", message: "An error occurred. Please log out and log back in.", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
                        self.present(ac, animated: true, completion: nil)
                    }
                } else {
                    CustomFileManager.removeCurrentImage()
                    self.delegate?.signalRefresh()
                    self.dismiss(animated: true, completion: nil)
                }
            })
        }))
            
        present(ac, animated: true, completion: nil)
    }
    
    func reauthenticateUser() {
        let ac = UIAlertController(title: "Reauthentication Needed", message: "In order to delete this account we need you to re-enter your credentials. Then try again.", preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Email Authentication", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
            self.performSegue(withIdentifier: "ReauthenticateVC", sender: nil)
        }))
        ac.addAction(UIAlertAction(title: "Facebook Authentication", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
            self.reauthenticateWithFacebook()
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(ac, animated: true, completion: nil)
    }
    
    func reauthenticateWithFacebook() {
        
        if FBSDKAccessToken.current() != nil {
            let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            AuthService.instance.reauthenticateUser(withCredential: credential) { (error, user) in
                if error != nil {
                    // an error occurred
                    print("JACOB: An error occured trying to reauthenticate the user: ", error!.debugDescription)
                    let message = ErrorHandler.handleFirebaseError(error: error!)
                    let ac = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
                    self.present(ac, animated: true, completion: nil)
                    
                } else {
                    // the reauthentication was a success
                    let ac = UIAlertController(title: "Reauthentication Successful", message: nil, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
                    self.present(ac, animated: true, completion: nil)
                }
            }
        } else {
            
            // if the access token is nil then log back into facebook
            AuthService.instance.authenticateWithFacebook(fromVC: self, reauthenticating: true, completed: { (error, user) in
                if error != nil {
                    let message = ErrorHandler.handleFirebaseError(error: error!)
                    self.presentAlert(with: message)
                }
            }, cancelCompletion: { 
                // do nothing if the user cancelled
            })
        }
    }
    
    func presentAlert(with message: String) {
        let ac = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        present(ac, animated: true, completion: nil)
    }

    @IBAction func exitPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func deleteImage(URL: String) {
        guard !URL.isEmpty else { return }
        activityIndicatorView.isHidden = false
        CustomFileManager.removeCurrentImage()
        DataService.instance.deleteImage(forURL: URL, uid: user.uid, completed: { (error) in
            if error != nil {
                print("JACOB: Error deleting old image. Please try again.")
            } else {
                self.profileImgView.image = UIImage(named: "profile_icon_big")
                self.activityIndicatorView.isHidden = true
                self.user.imageURL = ""
                let dict = ["image": self.profileImgView.image!, "imageURL": ""] as [String : Any]
                self.delegate?.sendDataToA(data: dict)
            }
        })
    }
}

extension ProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            var imageCropVC : RSKImageCropViewController!
            imageCropVC = RSKImageCropViewController(image: image, cropMode: RSKImageCropMode.circle)
            imageCropVC.avoidEmptySpaceAroundImage = true
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
    }
    
    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat) {

        let oldImageURL = user.imageURL
        
        DataService.instance.deleteImage(forURL: oldImageURL, uid: user.uid, completed: { (error) in
            if error != nil {
                print("JACOB: Error deleting old image. Please try again.")
            } else {
                self.user.imageURL = ""
                // continue on and set the new image
                self.profileImgView.image = croppedImage
                DataService.instance.saveProfileImage(image: croppedImage, uid: self.user.uid, completed: { (error, url) in
                    if error == nil && url != nil {
                        self.user.imageURL = url!
                        let dict = ["image": croppedImage, "imageURL": url!] as [String : Any]
                        self.delegate?.sendDataToA(data: dict)
                        CustomFileManager.saveImageToDisk(image: croppedImage)
                    }
                })
            }
        })
    
        imagePicker.dismiss(animated: false, completion: nil)
        self.presentedViewController?.dismiss(animated: true, completion: nil)
        
    }
    
    func imageCropViewController(_ controller: RSKImageCropViewController, willCropImage originalImage: UIImage) {
    }
    
}
