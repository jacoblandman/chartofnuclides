//
//  CommunityVC.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 2/25/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit
import FirebaseAuth

enum QueryType {
    case recent
    case top
    case contributing
}

class CommunityVC: UIViewController {
    
    @IBOutlet weak var searchBar: BorderlessSearchBar!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mostRecentBtn: UIButton!
    @IBOutlet weak var topBtn: UIButton!
    @IBOutlet weak var contributingBtn: UIButton!
    @IBOutlet weak var questionFilterView: UIView!
    @IBOutlet weak var questionFilterTopConstraint: NSLayoutConstraint!
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    
    var refreshControl: UIRefreshControl!
    var indicatorFooter: UIActivityIndicatorView!

    var user: User?
    var imageIsSet: Bool = false
    
    var questions = [Post]()
    var _startTimestamp: Int? = nil
    var startKey: String? = nil
    let questionsPerPage = 10
    var reachedBottom = false
    
    var queryType = QueryType.recent
    
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
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
        
        loadQuestions(startTimestamp: nil)
    }
    
    func loadQuestions(startTimestamp: Int?) {
        
        DataService.instance.loadQuestions(startTimestamp: startTimestamp,
                                           numberOfItemsPerPage: questionsPerPage,
                                           queryType: queryType) { (error, questionArray) in
            
            if error != nil {
                let message = ErrorHandler.handleFirebaseError(error: error!)
                let ac = UIAlertController(title: "Error please try again", message: message, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
                self.present(ac, animated: true, completion: nil)
            } else {
                
                // if starting fresh then empty the questions array
                if startTimestamp == nil {
                    self.questions = []
                }
                
                if let newQuestions = questionArray as? [Post] {
                    if newQuestions.count < self.questionsPerPage { self.tableView.tableFooterView = nil }
                    for question in newQuestions.reversed() {
                        self.questions.append(question)
                    }
                    
                    // if array is empty the first/last property is nil, so unwrap it
                    // use the first item because we aren't reversing the array this time
                    if let lastQuestion = newQuestions.first {
                        self._startTimestamp = lastQuestion.timestamp
                    }
                }
            }
            
            
            // set the content off set if loading data from scrolling to the bototm of tableview
            if startTimestamp != nil {
                var contentOffset = self.tableView.contentOffset
                if self.tableView.tableFooterView == nil { contentOffset.y = contentOffset.y + 44 }
                self.tableView.reloadData()
                self.tableView.layoutIfNeeded()
                self.tableView.setContentOffset(contentOffset, animated: false)
            } else {
                self.tableView.reloadData()
            }
        
            self.refreshControl.endRefreshing()
        }
    }
    
    func loadUserImage() {
        // this function is mainly to get the image and the image url
        
        // make sure a user has been authorized by firebase
        // if not  then reset the profile image and return
        guard FIRAuth.auth()?.currentUser != nil else {
            profileImgView.image = UIImage(named: "profile_icon_big")
            return
        }
        
        // make the user if we havnt yet
        if user == nil {
            user = User(uid: FIRAuth.auth()!.currentUser!.uid)
        }
        
        // load the user data and load the image if it changed
        // first check to see if it is saved to disk
        let imageFromDisk = CustomFileManager.getImage()
        
        if imageFromDisk != nil {
            profileImgView.image = imageFromDisk
            imageIsSet = true
            return
        }
        
        user?.loadImageURL {
            if self.user!.imageURL != "" {
                DataService.instance.getImage(fromURL: self.user!.imageURL) { (error, image) in
                    if error != nil {
                        print("JACOB: Error downloading image from firebase storage")
                    } else {
                        print("JACOB: Image download successful")
                        if let img = image {
                            CustomFileManager.saveImageToDisk(image: img)
                            self.profileImgView.image = img
                            self.imageIsSet = true
                        }
                    }
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadUserImage()
        
        if FIRAuth.auth()?.currentUser == nil {
            user = nil
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ProfileVC" {
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
        } else if segue.identifier == "QuestionVC" {
            if let destination = segue.destination as? QuestionVC {
                
                destination.user = self.user
            }
        } else if segue.identifier == "QuestionDetailVC" {
            if let destination = segue.destination as? QuestionDetailVC {
                if let dict = sender as? Dictionary<String, Any> {
                    if let question = dict["question"] as? Post {
                        destination.question = question
                    }
                    
                    if let user = dict["currentUser"] as? User? {
                        destination.currentUser = user
                    }
                }
            }
        }
        
    }
    
    @IBAction func AddQuestionTapped(_ sender: Any) {
        
        if FIRAuth.auth()?.currentUser != nil {
            performSegue(withIdentifier: "QuestionVC", sender: nil)
        } else {
            let ac = UIAlertController(title: "Hault!", message: "You must be a member of the community to post questions!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Gotcha", style: .cancel, handler: nil))
            present(ac, animated: true, completion: nil)
        }
        
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
            performSegue(withIdentifier: "SignUpLoginVC", sender: nil)
        }
    }

    @IBAction func mostRecentPressed(_ sender: Any) {
        topBtn.setTitleColor(GRAY_COLOR, for: .normal)
        contributingBtn.setTitleColor(GRAY_COLOR, for: .normal)
        mostRecentBtn.setTitleColor(GREEN_COLOR, for: .normal)
    }

    @IBAction func topPressed(_ sender: Any) {
        topBtn.setTitleColor(GREEN_COLOR, for: .normal)
        contributingBtn.setTitleColor(GRAY_COLOR, for: .normal)
        mostRecentBtn.setTitleColor(GRAY_COLOR, for: .normal)
    }
    
    @IBAction func unansweredPressed(_ sender: Any) {
        topBtn.setTitleColor(GRAY_COLOR, for: .normal)
        contributingBtn.setTitleColor(GREEN_COLOR, for: .normal)
        mostRecentBtn.setTitleColor(GRAY_COLOR, for: .normal)
    }
    
    func getLatestQuestions() {
        
        tableView.tableFooterView = indicatorFooter
        loadQuestions(startTimestamp: nil)
        
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
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell", for: indexPath) as! QuestionCell
        let question = questions[indexPath.row]
        cell.update(question: question)
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
        
        let question = questions[indexPath.row]
        let dict = ["question": question, "currentUser": user as Any] as [String : Any]
        performSegue(withIdentifier: "QuestionDetailVC", sender: dict)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // show or hide the question filter scrollView
        
        let translation = scrollView.panGestureRecognizer.translation(in: scrollView)
        
        if translation.y < 0 && scrollView.contentOffset.y > 75 {
            hideQuestionFilter()
        }
        
        // some number near the top to inform the question filter to be shown
        if scrollView.contentOffset.y < 75 && questionFilterTopConstraint.constant != 0 {
            showQuestionFilter()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        // check if scrolled to bottom to load more data
        if tableView.contentOffset.y >= tableView.contentSize.height - tableView.frame.size.height {
            print("JACOB: Loading more data")
            if tableView.tableFooterView != nil {
                loadQuestions(startTimestamp: _startTimestamp)
            }
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
            if let image = dict["image"] as? UIImage {
                profileImgView.image = image
            }
        }
    }
}
