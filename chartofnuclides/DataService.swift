//
//  DataService.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 2/3/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit
import Firebase

let FIR_CHILD_USERS = "users"
let FIR_CHILD_USERNAMES = "usernames"
let FIR_CHILD_QUESTIONS = "questions"
let FIR_CHILD_ANSWERS = "answers"
let FIR_CHILD_FLAGREASONS = "flagDescriptions"
let FIR_CHILD_FLAGTALLIES = "flagTallies"
let FIR_CHILD_UPVOTES = "upvotes"
let FIR_CHILD_DOWNVOTES = "downvotes"
let FILENAME_NUCLIDES = "nuclides"
let FILE_EXTENSION_NUCLIDES = "json"

typealias uniqueUsernameCompletion = (_ isUnique: Bool) -> Void
typealias previousUserCheckCompletion = (_ isPreviousUser: Bool) -> Void
typealias imageDownloadCompletion = (_ error: NSError?, _ image: UIImage?) -> Void
typealias imageUploadCompletion = (_ error: NSError?, _ url: String?) -> Void
typealias errorCompletion = (_ error: NSError?) -> Void
typealias boolCompletion = (_ bool: Bool) -> Void
typealias errorArrayCompletion = (_ error: NSError?, _ arr: [AnyObject]?) -> Void

class DataService {
    
    private static let _instance = DataService()
    
    static var instance: DataService {
        return _instance
    }
    
    
    // Firebase database/storage stuff
    var mainRef: FIRDatabaseReference {
        return FIRDatabase.database().reference()
    }
    
    var usersRef: FIRDatabaseReference {
        return mainRef.child(FIR_CHILD_USERS)
    }
    
    var usernamesRef: FIRDatabaseReference {
        return mainRef.child(FIR_CHILD_USERNAMES)
    }
    
    var questionsRef: FIRDatabaseReference {
        return mainRef.child(FIR_CHILD_QUESTIONS)
    }
    
    var answersRef: FIRDatabaseReference {
        return mainRef.child(FIR_CHILD_ANSWERS)
    }
    
    var flagReasonsRef: FIRDatabaseReference {
        return mainRef.child(FIR_CHILD_FLAGREASONS)
    }
    
    var flagTalliesRef: FIRDatabaseReference {
        return mainRef.child(FIR_CHILD_FLAGTALLIES)
    }
    
    var upvotesRef: FIRDatabaseReference {
        return mainRef.child(FIR_CHILD_UPVOTES)
    }
    
    var downvotesRef: FIRDatabaseReference {
        return mainRef.child(FIR_CHILD_DOWNVOTES)
    }
    
    var mainStorageRef: FIRStorageReference {
        return FIRStorage.storage().reference()
    }
    
    var imagesStorageRef: FIRStorageReference {
        return mainStorageRef.child("images")
    }
    
    func saveUser(uid: String) {
        let profile: Dictionary<String, AnyObject> = ["reputation": 0 as AnyObject,
                                                      "questionsCount": 0 as AnyObject,
                                                      "answersCount": 0 as AnyObject,
                                                      "imageURL": "" as AnyObject]
        
        usersRef.child(uid).child("profile").setValue(profile)
    }
    
    func checkIfPreviousUser(uid: String, completed: @escaping previousUserCheckCompletion ) {
        let usernameRef = usersRef.child(uid).child("username").child("username")
        usernameRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                print("JACOB: Not previous user")
                completed(false)
            } else {
                print("JACOB: PREVIOUS USER")
                completed(true)
            }
        })
    }
    
    func verifyIsUnique(_ username: String, completion: @escaping uniqueUsernameCompletion) {
        
        let user = FIRAuth.auth()!.currentUser
        mainRef.updateChildValues([ "users/\(user!.uid)/username/username": username,
                                    "usernames/\(username)": user!.uid], withCompletionBlock: { (error, reference) in
            if (error != nil) {
                
                print("JACOB: The username already exists")
                completion(false)
                // Write was disallowed because username exists
                    
            } else {
                print("JACOB: The username is unique")
                completion(true)
            }
        })
    }
    
    // nuclide data stuff
    var numberOfIsotopes: Int = 0
    
    func parse_json() -> [Element] {
        
        var returnElements = [Element]()
        
        if let path = Bundle.main.path(forResource: FILENAME_NUCLIDES, ofType: FILE_EXTENSION_NUCLIDES) {
            if let jsonData = NSData(contentsOfFile: path) {
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: jsonData as Data, options: []) as? Dictionary<String, Any> {
                        if let elements = jsonResult["element"] as? [Dictionary<String, Any>] {
                            for (index, element) in elements.enumerated() {
                                returnElements.append(Element(element: element, elementIndex: index))
                            }
                        }
                    }
                } catch  {
                    // error the json serialization didnt work
                    print("JACOB: The json Serialization didn't work")
                }
            }
        }
        
        return returnElements
    }
    
    func deleteUserDataWith(_ uid: String, username: String) {
        // here we actually want to delete the username, then modify it to say "Unknown User"
        // then we can delete the profile
        // this is because a user may wish to delete their account, but may have questions or answers
        // we don't want to delete those questions and answers, instead just specify that its from an unknown user
        
        usernamesRef.child(username).removeValue()
        usersRef.child(uid).child("username").removeValue()
        usersRef.updateChildValues(["\(uid)/username/username": "User unknown"])
        usersRef.child(uid).child("profile").removeValue()
        
        // delete downvotes
        downvotesRef.child(uid).removeValue()
        
        // delete upvotes
        upvotesRef.child(uid).removeValue()
        
        // delete flag tallies
        flagTalliesRef.child(uid).removeValue()
        
    }
    
    func saveProfileImage(image: UIImage, uid: String, completed: @escaping imageUploadCompletion ) {
        
        if let imgData = UIImageJPEGRepresentation(image, 0.2) {
            
            let imgUid = NSUUID().uuidString
            let metaData = FIRStorageMetadata()
            metaData.contentType = "image/jpeg"
            
            imagesStorageRef.child(imgUid).put(imgData, metadata: metaData, completion: { (metadata, error) in
                
                if error != nil {
                    print(error.debugDescription)
                    print("JACOB: Unable to upload image to Firebase storage")
                    completed(error as NSError?, nil)
                } else {
                    
                    print("JACOB: Successfully uploaded image to Firebase storage")
                    let downloadURL = metadata?.downloadURL()?.absoluteString
                    if let url = downloadURL {
                        self.usersRef.child(uid).child("profile").child("imageURL").setValue(url as AnyObject, withCompletionBlock: { (error, ref) in
                            completed(error as NSError?, url)
                        })
                    }
                }
            })
        }
    }
    
    func getImage(fromURL url: String, completed: @escaping imageDownloadCompletion) {
        let ref = FIRStorage.storage().reference(forURL: url)
        // max size is 2 MB
        ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
            if error != nil {
                print("JACOB: Unable to download image from Firebase storage")
                completed(error as NSError?, nil)
            } else {
                if let imgData = data {
                    if let img = UIImage(data: imgData) {
                        // everytime we get an image from firebase we can store it in the image cache
                        CommunityVC.imageCache.setObject(img, forKey: url as NSString)
                        completed(nil, img)
                    }
                }
            }
        })
    }
    
    func deleteImage(forURL url: String, uid: String, completed: errorCompletion?) {
        
        guard url != "" else {
            completed?(nil)
            return
        }
        let ref = FIRStorage.storage().reference(forURL: url)
        
        ref.delete { (error) in
            if error != nil {
                print("JACOB: Error deleting image from storage: ", error!.localizedDescription)
                completed?(error as NSError?)
            } else {
                completed?(nil)
                self.usersRef.child(uid).child("profile").child("imageURL").setValue("", withCompletionBlock: { (error, ref) in
                    if error != nil {
                        completed?(error! as NSError?)
                    } else {
                        completed?(nil)
                    }
                })

            }
        }
    }
    
    func submitQuestion(question: Post, completed: @escaping errorCompletion) {
        
        // create the dictionary that will be posted to the database
        let newQuestion: Dictionary<String, AnyObject> = [
            "title": question.title as AnyObject,
            "body": question.body as AnyObject,
            "uid": question.uid as AnyObject,
            "votes": question.votes as AnyObject,
            "timestamp": FIRServerValue.timestamp() as AnyObject
        ]
        
        // automatically get an id for the post
        let firebasePost = DataService.instance.questionsRef.childByAutoId()
        firebasePost.setValue(newQuestion) { (error, ref) in
            if error != nil {
                // an error occurred
                completed(error as NSError?)
            } else {
                // no error occurred
                self.incrementRep(uid: question.uid, by: 5)
                self.incrementQuestionsTally(uid: question.uid)
                completed(nil)
            }
        }
    }
    
    func submitAnswer(answer: Post, for question: Post, completed: @escaping errorCompletion) {
        
        // create the dictionary that will be posted to the database
        let newAnswer: Dictionary<String, AnyObject> = [
            "body": answer.body as AnyObject,
            "uid": answer.uid as AnyObject,
            "votes": answer.votes as AnyObject,
            "question": question.postKey as AnyObject,
            "timestamp": FIRServerValue.timestamp() as AnyObject
        ]
        
        // automatically get an id for the post
        let answerKey = answersRef.childByAutoId().key

        // we also need to add this posts id to the questions answers
        let childPosts = ["\(FIR_CHILD_ANSWERS)/\(answerKey)": newAnswer] as [String : Any]
        
        // now update everything at once
        mainRef.updateChildValues(childPosts) { (error, ref) in
            if error != nil {
                // an error occurred
                completed(error as NSError?)
            } else {
                // no error occurred
                self.incrementRep(uid: answer.uid, by: 5)
                self.incrementAnswersTally(uid: answer.uid)
                completed(nil)
            }
        }
    }
    
    func loadQuestions(startValue: Int?, startKey: String?, numberOfItemsPerPage: Int,
                       queryType: QueryType, completed: @escaping errorArrayCompletion) {
        
        var count = numberOfItemsPerPage
        
        var query: FIRDatabaseQuery
        
        switch queryType {
        case .recent:
            query = questionsRef.queryOrdered(byChild: "timestamp")
            break
        case .top:
            query = questionsRef.queryOrdered(byChild: "votes")
            break
        case .contributing:
            query = questionsRef.queryOrdered(byChild: "uid").queryEqual(toValue: FIRAuth.auth()?.currentUser?.uid)
            break
        }
        
        if queryType != .contributing {
            if startKey != nil {
                count += 1
                query = query.queryEnding(atValue: startValue, childKey: startKey).queryLimited(toLast: UInt(count))
            } else {
                query = query.queryLimited(toLast: UInt(count))
            }
        }
        
        query.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                guard var children = snapshot.children.allObjects as? [FIRDataSnapshot] else {
                    // handle error here
                    let error = NSError()
                    completed(error, nil)
                    return
                }
                
                if startValue != nil && !children.isEmpty {
                    children.removeLast()
                }
                
                // now do something with the children
                var newQuestions = [Post]()
                for child in children {
                    if let questionDict = child.value as? Dictionary<String, AnyObject> {
                        newQuestions.append(Post(postKey: child.key, postData: questionDict, postType: .question))
                    }
                }
                
                completed(nil, newQuestions)
            } else {
                completed(nil, [])
            }
        })
        
    }
    
    func loadAnswers(for question: Post, completed: @escaping errorArrayCompletion) {
        // first we need the answer keys associated with the questions
        let query = answersRef.queryOrdered(byChild: "question").queryEqual(toValue: question.postKey)
        query.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                guard let children = snapshot.children.allObjects as? [FIRDataSnapshot] else {
                    // handle error here
                    let error = NSError()
                    completed(error, nil)
                    return
                }
                
                var answers = [Post]()
                for child in children {
                    if let answerDict = child.value as? Dictionary<String, AnyObject> {
                        answers.append(Post(postKey: child.key, postData: answerDict, postType: .answer))
                    }
                }
                
                completed(nil, answers)
            } else {
                // the snapshot didn't exist
                completed(nil, [])
            }
        })
    }
    
    func loadFlags(uid: String, completed: @escaping errorArrayCompletion) {
        
        flagTalliesRef.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                if let dict = snapshot.value as? Dictionary<String, AnyObject> {
                    let keys = Array(dict.keys) 
                    completed(nil, keys as [AnyObject]?)
                }
            } else {
                // the snapshot didn't exist
                // so return an empty array because there are no flags for this post
                completed(nil, [])
            }
        })
    }
    
    func loadUpVotes(uid: String, completed: @escaping errorArrayCompletion) {
        
        upvotesRef.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                if let dict = snapshot.value as? Dictionary<String, AnyObject> {
                    let keys = Array(dict.keys)
                    completed(nil, keys as [AnyObject]?)
                }
            } else {
                // the snapshot didn't exist
                // so return an empty array because there are no flags for this post
                completed(nil, [])
            }
        })
    }
    
    func loadDownVotes(uid: String, completed: @escaping errorArrayCompletion) {
        
        downvotesRef.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                if let dict = snapshot.value as? Dictionary<String, AnyObject> {
                    let keys = Array(dict.keys)
                    completed(nil, keys as [AnyObject]?)
                }
            } else {
                // the snapshot didn't exist
                // so return an empty array because there are no flags for this post
                completed(nil, [])
            }
        })
    }
    
    func logUpVote(post: Post, userPosted: User, currentUser: User, errorCompletion: @escaping ()->() ) {
        
        upvotesRef.child(currentUser.uid).child(post.postKey).setValue(true) { (error, ref) in
            
            if error != nil {
                errorCompletion()
            } else {
                // increment the votes for the post
                self.upvote(post: post)
                
                if currentUser.uid != userPosted.uid {
                    // add 1 rep to the user that posted
                    self.incrementRep(uid: currentUser.uid, by: 1)
                    
                    // add 1 rep to the user that voted
                    self.incrementRep(uid: userPosted.uid, by: 1)
                }
            }
        }
    }
    
    func logDownVote(post: Post, userPosted: User, currentUser: User, errorCompletion: @escaping ()->() ) {
        
        downvotesRef.child(currentUser.uid).child(post.postKey).setValue(true) { (error, ref) in
            
            if error != nil {
                errorCompletion()
            } else {
                // increment the votes for the post
                self.downvote(post: post)
                
                if currentUser.uid != userPosted.uid {
                    // subtract 1 rep to the user that posted
                    self.incrementRep(uid: currentUser.uid, by: -1)
                    
                    // add 1 rep to the user that voted
                    self.incrementRep(uid: userPosted.uid, by: 1)
                }
            }
        }
    }
    
    func upvote(post: Post) {
        
        let ref: FIRDatabaseReference
        
        if post.postType == .question {
            ref = questionsRef.child(post.postKey).child("votes")
        } else {
            ref = answersRef.child(post.postKey).child("votes")
        }
        
        ref.runTransactionBlock({ (currentData: FIRMutableData) -> FIRTransactionResult in
            
            //value of the counter before an update
            var value = currentData.value as? Int
            
            //checking for nil data is very important when using
            //transactional writes
            if value == nil {
                value = 0
            }
            
            //actual update
            currentData.value = value! + 1
            return FIRTransactionResult.success(withValue: currentData)
            
        }) { (error, commited, snapshot) in
            
            if error != nil {
                //call error callback function if you want
                print("JACOB: An error occurred when upvoting")
            }
        }
    }
    
    func downvote(post: Post) {
        
        let ref: FIRDatabaseReference
        
        if post.postType == .question {
            ref = questionsRef.child(post.postKey).child("votes")
        } else {
            ref = answersRef.child(post.postKey).child("votes")
        }
        
        ref.runTransactionBlock({ (currentData: FIRMutableData) -> FIRTransactionResult in
            
            //value of the counter before an update
            var value = currentData.value as? Int
            
            //checking for nil data is very important when using
            //transactional writes
            if value == nil {
                value = 0
            }
            
            //actual update
            currentData.value = value! - 1
            return FIRTransactionResult.success(withValue: currentData)
            
        }) { (error, commited, snapshot) in
            
            if error != nil {
                //call error callback function if you want
                print("JACOB: An error occurred when downvoting")
            }
        }
    }
    
    func incrementRep(uid: String, by newValue: Int) {
        
        let ref = usersRef.child(uid).child("profile").child("reputation")
        ref.runTransactionBlock({ (currentData: FIRMutableData) -> FIRTransactionResult in
            
            //value of the counter before an update
            var value = currentData.value as? Int
            
            //checking for nil data is very important when using
            //transactional writes
            if value == nil {
                value = 0
            }
            
            //actual update
            currentData.value = value! + newValue
            return FIRTransactionResult.success(withValue: currentData)
            
        }) { (error, commited, snapshot) in
            
            if error != nil {
                //call error callback function if you want
                print("JACOB: An error occurred incrementing the rep")
            }
        }
    }
    
    func incrementAnswersTally(uid: String) {
        
        let ref = usersRef.child(uid).child("profile").child("answersCount")
        ref.runTransactionBlock({ (currentData: FIRMutableData) -> FIRTransactionResult in
            
            //value of the counter before an update
            var value = currentData.value as? Int
            
            //checking for nil data is very important when using
            //transactional writes
            if value == nil {
                value = 0
            }
            
            //actual update
            currentData.value = value! + 1
            return FIRTransactionResult.success(withValue: currentData)
            
        }) { (error, commited, snapshot) in
            
            if error != nil {
                //call error callback function if you want
                print("JACOB: An error occurred incrementing the answers tally")
            }
        }
        
    }
    
    func incrementQuestionsTally(uid: String) {
        
        let ref = usersRef.child(uid).child("profile").child("questionsCount")
        ref.runTransactionBlock({ (currentData: FIRMutableData) -> FIRTransactionResult in
            
            //value of the counter before an update
            var value = currentData.value as? Int
            
            //checking for nil data is very important when using
            //transactional writes
            if value == nil {
                value = 0
            }
            
            //actual update
            currentData.value = value! + 1
            return FIRTransactionResult.success(withValue: currentData)
            
        }) { (error, commited, snapshot) in
            
            if error != nil {
                //call error callback function if you want
                print("JACOB: An error occurred incrementing the questions tally")
            }
        }
    }
    
    func flagPost(post: Post, reason: String, uid: String, completed: @escaping errorCompletion) {
        
        let key = flagReasonsRef.child(post.postKey).childByAutoId().key
        
        let flagReasonDict: Dictionary<String, AnyObject> = [
            "reason": reason as AnyObject,
            "uid": uid as AnyObject,
            "timestamp": FIRServerValue.timestamp() as AnyObject
        ]
        
        let childPosts = ["\(FIR_CHILD_FLAGREASONS)/\(post.postKey)/\(key)": flagReasonDict,
                          "\(FIR_CHILD_FLAGTALLIES)/\(uid)/\(post.postKey)": true] as [String : Any]
        
        mainRef.updateChildValues(childPosts) { (error, ref) in
            if error != nil {
                // an error occurred
                completed(error as NSError?)
            } else {
                // no error occurred
                completed(nil)
            }
        }
    }
}
