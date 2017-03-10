//
//  CommunityVC.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 2/25/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit
import FirebaseAuth

class CommunityVC: UIViewController {

    
    @IBOutlet weak var searchBar: BorderlessSearchBar!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mostRecentBtn: UIButton!
    @IBOutlet weak var topBtn: UIButton!
    @IBOutlet weak var unansweredBtn: UIButton!
    @IBOutlet weak var questionFilterView: UIView!
    @IBOutlet weak var questionFilterTopConstraint: NSLayoutConstraint!
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    
    var refreshControl: UIRefreshControl!
    var indicatorFooter: UIActivityIndicatorView!
    
    let GRAY_COLOR = UIColor(hexString: "DCDCDC")
    
    var user: User?
    var profileURL: String?
    var imageIsSet: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionFilterView.addLightShadow()
        
        // initialize the refresh control
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = GRAY_COLOR
        refreshControl.addTarget(self, action: #selector(getLatestQuestions), for: UIControlEvents.valueChanged)
    
        // initalize indicator footer
        indicatorFooter = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 44))
        indicatorFooter.color = GRAY_COLOR
        indicatorFooter.startAnimating()
        tableView.tableFooterView = indicatorFooter
        
        tableView.refreshControl = refreshControl
        tableView.delegate = self
        tableView.dataSource = self
        
        searchBar.delegate = self
        tapGesture.isEnabled = false

    }
    
    func loadUserImage() {
        // this function is mainly to get the image and the image url
        
        // make sure a user has been authorized by firebase
        // if not  then reset the profile image and return
        guard FIRAuth.auth()?.currentUser != nil else {
            self.profileURL = nil
            profileImgView.image = UIImage(named: "profile_icon_big")
            return
        }
        
        // make the user if we havnt yet
        if user == nil {
            user = User(uid: FIRAuth.auth()!.currentUser!.uid)
        }
        
        // load the user data and load the image if it changed
        user?.loadImageURL {
            if self.user!.imageURL != "" {
                // only load the image if it has changed
                if self.profileURL != self.user!.imageURL {
                    print("JACOB: Image url not equal to profile url")
                    print(self.user!.imageURL)
                    DataService.instance.setImage(forURL: self.user!.imageURL) { (error, image) in
                        if error != nil {
                            print("JACOB: Error downloading image from firebase storage")
                        } else {
                            print("JACOB: Image download successful")
                            if let img = image {
                                self.profileImgView.image = img
                                self.profileURL = self.user!.imageURL
                                self.imageIsSet = true
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadUserImage()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ProfileVC {
            
            destination.delegate = self
            
            if let dict = sender as? Dictionary<String, Any> {
                if let user = dict["user"] as? User {
                    destination.user = user
                }
                
                if let image = dict["profileImage"] as? UIImage {
                    destination.profileImage = image
                }
                
                if let setImage = dict["imageIsSet"] as? Bool {
                    destination.imageIsSet = setImage
                }
            }
        }
    }
    
    @IBAction func AddQuestionTapped(_ sender: Any) {
    }
    
    @IBAction func profileTapped(_ sender: Any) {
        if FIRAuth.auth()?.currentUser != nil {
            // User is signed in.
            // segue to the profile view controller
            print("Current User Found")
            let dict = ["user": user!, "profileImage": profileImgView.image!, "imageIsSet": imageIsSet] as [String : Any]
            performSegue(withIdentifier: "ProfileVC", sender: dict)
        } else {
            // No user is signed in.
            performSegue(withIdentifier: "LoginVC", sender: nil)
        }
    }

    @IBAction func mostRecentPressed(_ sender: Any) {
        topBtn.setTitleColor(GRAY_COLOR, for: .normal)
        unansweredBtn.setTitleColor(GRAY_COLOR, for: .normal)
        mostRecentBtn.setTitleColor(GREEN_COLOR, for: .normal)
    }

    @IBAction func topPressed(_ sender: Any) {
        topBtn.setTitleColor(GREEN_COLOR, for: .normal)
        unansweredBtn.setTitleColor(GRAY_COLOR, for: .normal)
        mostRecentBtn.setTitleColor(GRAY_COLOR, for: .normal)
    }
    
    @IBAction func unansweredPressed(_ sender: Any) {
        topBtn.setTitleColor(GRAY_COLOR, for: .normal)
        unansweredBtn.setTitleColor(GREEN_COLOR, for: .normal)
        mostRecentBtn.setTitleColor(GRAY_COLOR, for: .normal)
    }
    
    func getLatestQuestions() {
        
        UIView.animate(withDuration: 0.0, delay: 1.0, options: [], animations: { 
            self.refreshControl.endRefreshing()
        }, completion: nil)
        
    }
    
    func showQuestionFilter() {
        UIView.animate(withDuration: 0.35, delay: 0.0, options: [], animations: {
            self.questionFilterTopConstraint.constant = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func hideQuestionFilter() {
        UIView.animate(withDuration: 0.35, delay: 0.0, options: [], animations: {
            self.questionFilterTopConstraint.constant = -44
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @IBAction func endEditing(_ sender: Any) {
        view.endEditing(true)
        tapGesture.isEnabled = false
    }
}

extension CommunityVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell", for: indexPath) as! QuestionCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // show or hide the question filter scrollView
        
        let translation = scrollView.panGestureRecognizer.translation(in: scrollView)
        
        if translation.y < 0 {
            hideQuestionFilter()
        }
        
        // some number near the top to inform the question filter to be shown
        if scrollView.contentOffset.y < 75 {
            showQuestionFilter()
        }

    }
    
}

extension CommunityVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        view.endEditing(true)
        tapGesture.isEnabled = false
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        tapGesture.isEnabled = true
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        tapGesture.isEnabled = false
        searchBar.showsCancelButton = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        tapGesture.isEnabled = false
        view.endEditing(true)
    }
}

extension CommunityVC: SendDataToPreviousControllerDelegate {
    
    func sendDataToA(data: Any) {
        if let dict = data as? Dictionary<String, Any> {
            if let imageURL = dict["imageURL"] as? String {
                profileURL = imageURL
            }
            if let image = dict["image"] as? UIImage {
                profileImgView.image = image
            }
        }
    }
}
