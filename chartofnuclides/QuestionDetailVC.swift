//
//  QuestionDetailVC.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 3/16/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit
import FirebaseAuth

enum VoteType {
    case upVote
    case downVote
    case none
}

class QuestionDetailVC: UIViewController {

    @IBOutlet weak var loadingTableView: UITableView!
    @IBOutlet weak var activityMonitroView: InspectableBorderView!
    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl: UIRefreshControl!
    
    var question: Post!
    var answers = [Post]()
    
    var postKeyDict = [String: String]()
    var usersDict = [String: User]()
    var imgsDict = [String: UIImage]()
    
    var flags = [String]()
    var upvotes = [String]()
    var downvotes = [String]()
    
    var flagsLoaded = false
    var upvotesLoaded = false
    var downvotesLoaded = false
    var imagesLoaded = false
    
    var currentUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initialize the refresh control
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = GRAY_COLOR
        refreshControl.addTarget(self, action: #selector(refreshView), for: UIControlEvents.valueChanged)
        
        tableView.refreshControl = refreshControl
        tableView.delegate = self
        tableView.dataSource = self
        
        // the loadingTableView is a fake one that will show while the data is loading
        // for now this will show 0 cells, but in the future it could show cells like facebook
        loadingTableView.dataSource = self
        loadingTableView.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        
        loadAnswers()
    }
    
    @IBAction func addAnswerPressed(_ sender: Any) {
        if FIRAuth.auth()?.currentUser != nil {
            let user = User(uid: FIRAuth.auth()!.currentUser!.uid)
            let dict = ["user": user, "question": question] as [String : Any]
            performSegue(withIdentifier: "AddAnswerVC", sender: dict)
        } else {
            let ac = UIAlertController(title: "Hault!", message: "You must be a member of the community to post answers!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Gotcha", style: .cancel, handler: nil))
            present(ac, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddAnswerVC" {
            if let destination = segue.destination as? AddAnswerVC {
                if let dict = sender as? Dictionary<String, Any> {
                    if let user = dict["user"] as? User {
                        destination.user = user
                    }
                    if let question = dict["question"] as? Post {
                        destination.question = question
                    }
                    destination.delegate = self
                }
            }
        } else if segue.identifier == "FlagPostVC" {
            if let destination = segue.destination as? FlagPostVC {
                if let dict = sender as? Dictionary<String, Any> {
                    if let post = dict["post"] as? Post {
                        destination.post = post
                        destination.currentUser = currentUser!
                        destination.delegate = self
                    }
                    
                    if let cellIndexPath = dict["cellIndexPath"] as? IndexPath {
                        destination.cellIndexPath = cellIndexPath
                    }
                }
            }
        }
    }
    
    func loadAnswers() {
        DataService.instance.loadAnswers(for: question) { (error, answers) in
            if error != nil {
                self.presentAlertController(for: error!)
            } else {
                
                // empty the answers array
                self.answers = []
                
                if let answers = answers as? [Post] {
                    for answer in answers {
                        self.answers.append(answer)
                    }
                    
                    self.answers = self.answers.sorted(by: {
                        if $0.votes != $1.votes {
                            return $0.votes > $1.votes
                        } else {
                            return $0.timestamp > $1.timestamp
                        }
                    })
                    self.loadUserData()
                }
            }
        }
    }
    
    func loadFlagsAndVotes() {
        // we know current user is not nil at this point
        DataService.instance.loadFlags(uid: currentUser!.uid) { (error, arr) in
            if let flagsArray = arr as? [String] {
                self.flags = flagsArray
                self.flagsLoaded = true
                self.checkIfNeedsReload(count: nil)
            }
        }
        
        DataService.instance.loadUpVotes(uid: currentUser!.uid) { (error, arr) in
            if let upvotesArray = arr as? [String] {
                self.upvotes = upvotesArray
                self.upvotesLoaded = true
                self.checkIfNeedsReload(count: nil)
            }
        }
        
        DataService.instance.loadDownVotes(uid: currentUser!.uid) { (error, arr) in
            if let downvotesArray = arr as? [String] {
                self.downvotes = downvotesArray
                self.downvotesLoaded = true
                self.checkIfNeedsReload(count: nil)
            }
        }
        
    }
    
    func loadUserData() {
        
        // first we need the users
        // there will be two dictionaries
        
        // the first dictionary is user uid to user
        // the second dictionary is question/answer key to uid
        postKeyDict = [question.postKey: question.uid]
        usersDict = [question.uid: User(uid: question.uid)]
        
        for answer in answers {
            if usersDict[answer.uid] == nil {
                usersDict[answer.uid] = User(uid: answer.uid)
            }
            postKeyDict[answer.postKey] = answer.uid
        }
        
        // get votes and flags
        if currentUser != nil {
            loadFlagsAndVotes()
        } else {
            flagsLoaded = true
            upvotesLoaded = true
            downvotesLoaded = true
        }
        
        // now we need to load each users info
        // and load the images and cache them
        var count = 0
        for (uid, user) in usersDict {
            user.loadUserInfo {
                if user.imageURL != "" {
                    // first check to see if the image is already cached
                    if let img = CommunityVC.imageCache.object(forKey: user.imageURL as NSString) {
                        self.imgsDict[uid] = img
                        count += 1
                        self.checkIfNeedsReload(count: count)
                    } else {
                        // if the image is not cached then load it from firebase (this will also cache it)
                        DataService.instance.getImage(fromURL: user.imageURL, completed: { (error, img) in
                            if error != nil {
                                self.presentAlertController(for: error!)
                            } else {
                               self.imgsDict[uid] = img
                            }
                            count += 1
                            self.checkIfNeedsReload(count: count)
                        })
                    }
                }
            }
        }
    }
    
    func checkIfNeedsReload(count: Int?) {
        
        if !imagesLoaded {
            if let count = count {
                if count == usersDict.count {
                    imagesLoaded = true
                }
            }
        }
        
        if flagsLoaded && upvotesLoaded && downvotesLoaded && imagesLoaded {
            tableView.reloadData()
            
            loadingTableView.isHidden = true
            activityMonitroView.isHidden = true
            tableView.isHidden = false
            
            self.refreshControl.endRefreshing()
        }
    }
    
    func presentAlertController(for error: NSError) {
        let message = ErrorHandler.handleFirebaseError(error: error)
        let ac = UIAlertController(title: "Error please try loading again", message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        self.present(ac, animated: true, completion: nil)
    }
    
    func refreshView() {
        flagsLoaded = false
        upvotesLoaded = false
        downvotesLoaded = false
        imagesLoaded = false
        self.loadAnswers()
    }
    
}

extension QuestionDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionDetailCell", for: indexPath) as! QuestionDetailCell
        if !tableView.isHidden {
            if indexPath.row == 0 {
                // first cell is the question
                if let user = usersDict[question.uid] {
                    let flagged = flags.contains(question.postKey)
                    let downvoted = downvotes.contains(question.postKey)
                    let upvoted = upvotes.contains(question.postKey)
                    cell.update(post: question, userPosted: user, img: imgsDict[user.uid],
                                currentUser: currentUser, cellIndexPath: indexPath,
                                flagged: flagged, downvoted: downvoted, upvoted: upvoted)
                } else {
                    return cell
                }
            } else {
                // all other cells are answers
                let answer = answers[indexPath.row - 1]
                if let user = usersDict[answer.uid] {
                    let flagged = flags.contains(answer.postKey)
                    let downvoted = downvotes.contains(answer.postKey)
                    let upvoted = upvotes.contains(answer.postKey)
                    cell.update(post: answer, userPosted: user, img: imgsDict[user.uid],
                                currentUser: currentUser, cellIndexPath: indexPath,
                                flagged: flagged, downvoted: downvoted, upvoted: upvoted)
                } else {
                    return cell
                }
            }
        }
        
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == loadingTableView {
            return 0
        } else {
            return 1 + answers.count
        }
    }
}

extension QuestionDetailVC: CellToVCCommunicationDelegate {
    
    func callSegueFromCell(sender: Any?) {
        // double check that the current user is not nil 
        if currentUser != nil {
            performSegue(withIdentifier: "FlagPostVC", sender: sender)
        }
    }
    
    func addFlag(postKey: String) {
        flags.append(postKey)
    }
    
    func addDownvote(postKey: String) {
        downvotes.append(postKey)
    }
    
    func addUpvote(postKey: String) {
        upvotes.append(postKey)
    }
    
    func removeUpVote(postKey: String) {
        if let index = upvotes.index(of: postKey) {
            upvotes.remove(at: index)
        }
    }
    
    func removeDownvote(postKey: String) {
        if let index = downvotes.index(of: postKey) {
            downvotes.remove(at: index)
        }
    }
    
    
}

extension QuestionDetailVC: SendDataToPreviousControllerDelegate {
    
    func sendDataToA(data: Any) {
        if let cellIndexPath = data as? IndexPath {
            let cell = tableView.cellForRow(at: cellIndexPath) as! QuestionDetailCell
            cell.markAsFlagged()
        }
    }
    
    func signalRefresh() {
        self.refreshView()
    }
}
