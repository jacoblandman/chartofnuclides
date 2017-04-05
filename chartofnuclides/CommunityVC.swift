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
    @IBOutlet weak var activityMonitorView: InspectableBorderView!
    
    var refreshControl: UIRefreshControl!
    var indicatorFooter: UIActivityIndicatorView!

    var user: User?
    var imageIsSet: Bool = false
    
    var questions = [Post]()
    var questions_copy = [Post]()
    var searchQuestions = [Post]()
    var loadedSearchQuestions = false
    var loadedAllQuestions = false
    var _searchText = ""
    
    var _startKey: String? = nil
    var _startValue: Int? = nil
    let questionsPerPage = 10
    
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
        
        tableView.refreshControl = refreshControl
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        
        searchBar.delegate = self
        tapGesture.isEnabled = false
        
        loadQuestions(startValue: nil, startKey: nil)
    }
    
    func loadQuestions(startValue: Int?, startKey: String?) {
        
        DataService.instance.loadQuestions(startValue: startValue, startKey: startKey,
                                           numberOfItemsPerPage: questionsPerPage,
                                           queryType: queryType) { (error, questionArray) in
        
            if error != nil {
                let message = ErrorHandler.handleFirebaseError(error: error!)
                let ac = UIAlertController(title: "Error please try again", message: message, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
                self.present(ac, animated: true, completion: nil)
            } else {
                
                
                
                // if starting fresh then empty the questions array
                if startValue == nil {
                    self.questions = []
                }
                
                if let newQuestions = questionArray as? [Post] {
                    if newQuestions.count < self.questionsPerPage {
                        self.tableView.tableFooterView = nil
                        self.loadedAllQuestions = true
                    } else {
                        self.tableView.tableFooterView = self.indicatorFooter
                        self.loadedAllQuestions = false
                    }
                    for question in newQuestions.reversed() {
                        self.questions.append(question)
                    }
                    
                    // if array is empty the first/last property is nil, so unwrap it
                    // use the first item because we aren't reversing the array this time
                    if let lastQuestion = newQuestions.first {
                        
                        switch self.queryType {
                        case .recent:
                            self._startValue = lastQuestion.timestamp
                            break
                        case .top:
                            self._startValue = lastQuestion.votes
                            break
                        default:
                            break
                        }
                        
                        self._startKey = lastQuestion.postKey
                    }
                }
            }
            
            // set the content off set if loading data from scrolling to the bototm of tableview
            if startValue != nil {
                var contentOffset = self.tableView.contentOffset
                if self.tableView.tableFooterView == nil {
                    contentOffset.y = contentOffset.y + 18
                }
    
                self.tableView.reloadData()
                self.tableView.layoutIfNeeded()
                self.tableView.setContentOffset(contentOffset, animated: false)
                
            } else {
                self.tableView.reloadData()
                self.tableView.isHidden = false
                self.activityMonitorView.isHidden = true
            }
                                           
            // questions copy is for reseting after searching with the search bar
            self.questions_copy = self.questions
                                 
            // always end refreshing even if the questions weren't loaded using the refresh control
            self.refreshControl.endRefreshing()
        }
    }
    
    func loadAllQuestions() {
        activityMonitorView.isHidden = false
        DataService.instance.loadQuestions(startValue: nil, startKey: nil,
                                           numberOfItemsPerPage: 1000,
                                           queryType: queryType) { (error, questionArray) in
                                            
            if error != nil {
                let message = ErrorHandler.handleFirebaseError(error: error!)
                let ac = UIAlertController(title: "Error please try again", message: message, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
                self.present(ac, animated: true, completion: nil)
            } else {
            
                if let newQuestions = questionArray as? [Post] {
    
                    for question in newQuestions.reversed() {
                        self.searchQuestions.append(question)
                    }
                }
            }
            
            // we've now loaded all the questions (really the 1000 most recent questions)
            self.loadedSearchQuestions = true
            self.activityMonitorView.isHidden = true
        }
    }
    
    func enableUI(enable: Bool) {
        self.navigationItem.leftBarButtonItem?.isEnabled = enable
        self.navigationItem.rightBarButtonItem?.isEnabled = enable
    }
    
    func loadUserImage() {
        // this function is mainly to get the image and the image url
        
        // disenable the nav bar buttons while loading
        enableUI(enable: false)
        
        // make sure a user has been authorized by firebase
        // if not  then reset the profile image and return
        guard FIRAuth.auth()?.currentUser != nil else {
            profileImgView.image = UIImage(named: "profile_icon_big")
            enableUI(enable: true)
            return
        }
    
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            user = nil
            AuthService.instance.signOutCurrentUser()
            profileImgView.image = UIImage(named: "profile_icon_big")
            enableUI(enable: true)
            return
        }
        
        // the user data does exists in the database
        // make the user if we havnt yet
        if self.user == nil {
            self.user = User(uid: FIRAuth.auth()!.currentUser!.uid)
        }
        
        // load the user data and load the image if it changed
        // first check to see if it is saved to disk
        let imageFromDisk = CustomFileManager.getImage()
        
        if imageFromDisk != nil {
            self.profileImgView.image = imageFromDisk
            self.imageIsSet = true
            self.enableUI(enable: true)
            return
        }
        
        AuthService.instance.checkUserExists(uid: uid, existsCompleted: {
            self.user?.loadImageURL {
                if self.user!.imageURL != "" {
                    DataService.instance.getImage(fromURL: self.user!.imageURL) { (error, image) in
                        self.enableUI(enable: true)
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
                } else {
                    self.enableUI(enable: true)
                }
            }

        }) {
            
            // user does not exists
            self.user = nil
            AuthService.instance.signOutCurrentUser()
            self.profileImgView.image = UIImage(named: "profile_icon_big")
            self.enableUI(enable: true)
            return
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
                destination.delegate = self
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
            let dict = ["user": user!, "profileImage": profileImgView.image!, "imageIsSet": imageIsSet] as [String : Any]
            performSegue(withIdentifier: "ProfileVC", sender: dict)
        } else {
            // No user is signed in.
            performSegue(withIdentifier: "SignUpLoginVC", sender: nil)
        }
    }

    @IBAction func mostRecentPressed(_ sender: Any) {
        
        if queryType == .recent {
            return
        }
        
        // change query type
        queryType = .recent
        
        // change button colors to show which one is highlighted
        topBtn.setTitleColor(GRAY_COLOR, for: .normal)
        contributingBtn.setTitleColor(GRAY_COLOR, for: .normal)
        mostRecentBtn.setTitleColor(GREEN_COLOR, for: .normal)
        
        if _searchText != "" {
            // if currently searching then just resort
            questions = filterQuestions(text: _searchText)
            questions = sort(by: queryType)
            tableView.reloadData()
        } else {
            // load the new questions based off the new query
            activityMonitorView.isHidden = false
            loadQuestions(startValue: nil, startKey: nil)
        }
    }

    @IBAction func topPressed(_ sender: Any) {
        
        if queryType == .top {
            return
        }
        
        // change query type
        queryType = .top
        
        // change button colors to show which one is highlighted
        topBtn.setTitleColor(GREEN_COLOR, for: .normal)
        contributingBtn.setTitleColor(GRAY_COLOR, for: .normal)
        mostRecentBtn.setTitleColor(GRAY_COLOR, for: .normal)
        
        if _searchText != "" {
            // if currently searching then just resort
            questions = filterQuestions(text: _searchText)
            questions = sort(by: queryType)
            tableView.reloadData()
        } else {
            // load the new questions based off the new query
            activityMonitorView.isHidden = false
            loadQuestions(startValue: nil, startKey: nil)
        }
    }
    
    @IBAction func unansweredPressed(_ sender: Any) {
        
        if queryType == .contributing {
            return
        }
        
        // change query type
        queryType = .contributing
        
        // change button colors to show which one is highlighted
        topBtn.setTitleColor(GRAY_COLOR, for: .normal)
        contributingBtn.setTitleColor(GREEN_COLOR, for: .normal)
        mostRecentBtn.setTitleColor(GRAY_COLOR, for: .normal)
        
        if _searchText != "" {
            // if currently searching then just resort
            questions = sort(by: queryType)
            tableView.reloadData()
        } else {
            // load the new questions based off the new query
            activityMonitorView.isHidden = false
            loadQuestions(startValue: nil, startKey: nil)
        }
    }
    
    func sort(by queryType: QueryType) -> [Post] {
        switch queryType {
        case .recent:
            return questions.sorted(by: {
                if $0.timestamp != $1.timestamp {
                    return $0.timestamp > $1.timestamp
                } else {
                    return $0.timestamp > $1.timestamp
                }
            })
        case .top:
            return questions.sorted(by: {
                if $0.votes != $1.votes {
                    return $0.votes > $1.votes
                } else {
                    return $0.timestamp > $1.timestamp
                }
            })
            
        case .contributing:
            return questions.filter({
                $0.uid == FIRAuth.auth()?.currentUser?.uid
            })
        }
    }
    
    func getLatestQuestions() {
        
        tableView.tableFooterView = indicatorFooter
        loadQuestions(startValue: nil, startKey: nil)
        
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
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
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
            if tableView.tableFooterView != nil {
                loadQuestions(startValue: _startValue, startKey: _startKey)
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
        
        if !loadedSearchQuestions {
            loadAllQuestions()
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        tapGesture.isEnabled = false
        searchBar.showsCancelButton = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        tapGesture.isEnabled = false
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == "" {
            
            tableView.refreshControl = refreshControl
            if !loadedAllQuestions {
                tableView.tableFooterView = indicatorFooter
            }
            
            questions = questions_copy
            tableView.reloadData()
            _searchText = ""
            view.endEditing(true)
            
        } else {
            
            _searchText = searchBar.text!
            self.tableView.tableFooterView = nil
            tableView.refreshControl = nil
            
            questions = filterQuestions(text: searchBar.text!)
            
            tableView.reloadData()
        }
    }
    
    func filterQuestions(text: String) -> [Post] {
        let lower = text.lowercased()
        return searchQuestions.filter({
                $0.title?.lowercased().range(of: lower) != nil ||
                $0.body.lowercased().range(of: lower) != nil
        })
    }
}

extension CommunityVC: SendDataToPreviousControllerDelegate {
    
    func sendDataToA(data: Any) {
        if let dict = data as? Dictionary<String, Any> {
            if let image = dict["image"] as? UIImage {
                profileImgView.image = image
            }
            
            if let url = dict["imageURL"] as? String {
                user?.imageURL = url
            }
        }
    }
    
    func signalRefresh() {
        loadQuestions(startValue: nil, startKey: nil)
    }
    
    
}
