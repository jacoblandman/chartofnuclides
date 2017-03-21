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
    var question: Post!
    var answers = [Post]()
    
    var postKeyDict = [String: String]()
    var usersDict = [String: User]()
    var imgsDict = [String: UIImage]()
    var flagsDict = [String: Bool]()
    var votesDict = [String: VoteType]()
    
    var flagsLoaded = false
    var votesLoaded = false
    var imagesLoaded = false
    
    var currentUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                }
            }
        } else if segue.identifier == "FlagPostVC" {
            if let destination = segue.destination as? FlagPostVC {
                if let post = sender as? Post {
                    destination.post = post
                    destination.currentUser = currentUser!
                }
            }
        }
    }
    
    func loadAnswers() {
        DataService.instance.loadAnswers(for: question) { (error, answers) in
            if error != nil {
                self.presentAlertController(for: error!)
            } else {
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
        if let auth = FIRAuth.auth() {
            if let currentUser = auth.currentUser {
                for key in Array(postKeyDict.keys) {
                    let flagRef = DataService.instance.usersRef.child(currentUser.uid).child("flags").child(key)
                    flagRef.observeSingleEvent(of: .value, with: { (snapshot) in
                        if let _ = snapshot.value as? NSNull {
                            // set flags dict value to false
                            self.flagsDict[key] = false
                            self.checkIfNeedsReload(count: nil)
                        } else {
                            self.flagsDict[key] = true
                            self.checkIfNeedsReload(count: nil)
                        }
                    })
                    
                    let votesRef = DataService.instance.usersRef.child(currentUser.uid).child("votes").child(key)
                    votesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                        if let _ = snapshot.value as? NSNull {
                            // set flags dict value to false
                            self.votesDict[key] = VoteType.none
                            self.checkIfNeedsReload(count: nil)
                        } else {
                            if let voteType = snapshot.value as? String {
                                if voteType == "upvote" {
                                    self.votesDict[key] = VoteType.upVote
                                } else {
                                    self.votesDict[key] = VoteType.downVote
                                }
                            }
                            self.checkIfNeedsReload(count: nil)
                        }
                    })
                }
            }
        }
    }
    
    func setVotesAndFlagsToNone() {
        for key in Array(postKeyDict.keys) {
            flagsDict[key] = false
            votesDict[key] = VoteType.none
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
            votesLoaded = true
            setVotesAndFlagsToNone()
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
        
        
        if !flagsLoaded {
            if flagsDict.count == answers.count + 1 {
                flagsLoaded = true
            }
        }
        
        if !imagesLoaded {
            if let count = count {
                if count == usersDict.count {
                    imagesLoaded = true
                }
            }
        }
        
        if !votesLoaded {
            if votesDict.count == answers.count + 1 {
                votesLoaded = true
            }
        }
        
        if flagsLoaded && votesLoaded && imagesLoaded {
            tableView.reloadData()
            
            loadingTableView.isHidden = true
            activityMonitroView.isHidden = true
            tableView.isHidden = false
            
        }
    }
    
    func presentAlertController(for error: NSError) {
        let message = ErrorHandler.handleFirebaseError(error: error)
        let ac = UIAlertController(title: "Error please try loading again", message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        self.present(ac, animated: true, completion: nil)
    }
    
}

extension QuestionDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionDetailCell", for: indexPath) as! QuestionDetailCell
        if !tableView.isHidden {
            if indexPath.row == 0 {
                // first cell is the question
                let user = usersDict[question.uid]!
                let flagged = flagsDict[question.postKey]!
                let vote = votesDict[question.postKey]!
                cell.update(post: question, user: user, img: imgsDict[user.uid], flagged: flagged, vote: vote, currentUser: currentUser)
            } else {
                // all other cells are answers
                let answer = answers[indexPath.row - 1]
                let user = usersDict[answer.uid]!
                let flagged = flagsDict[answer.postKey]!
                let vote = votesDict[answer.postKey]!
                cell.update(post: answer, user: user, img: imgsDict[user.uid], flagged: flagged, vote: vote, currentUser: currentUser)
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

extension QuestionDetailVC: PerformSegueFromCellDelegate {
    
    func callSegueFromCell(sender: Any?) {
        // double check that the current user is not nil 
        if currentUser != nil {
            performSegue(withIdentifier: "FlagPostVC", sender: sender)
        }
    }
    
}
