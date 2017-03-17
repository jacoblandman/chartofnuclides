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
let FIR_CHILD_DETAILS = "applicationDetails"
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
    
    var applicationDetailsRef: FIRDatabaseReference {
        return mainRef.child(FIR_CHILD_DETAILS)
    }
    
    var mainStorageRef: FIRStorageReference {
        return FIRStorage.storage().reference()
    }
    
    var imagesStorageRef: FIRStorageReference {
        return mainStorageRef.child("images")
    }
    
    func saveUser(uid: String) {
        let profile: Dictionary<String, AnyObject> = ["reputation": 0 as AnyObject,
                                                      "questionsAsked": 0 as AnyObject,
                                                      "answers": 0 as AnyObject,
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
    
    func deleteUserDataWith(_ uid: String) {
        // here we actually want to delete the username, then modify it to say "Unknown User"
        // then we can delete the profile
        // this is because a user may wish to delete their account, but may have questions or answers
        // we don't want to delete those questions and answers, instead just specify that its from an unknown user
        usersRef.child(uid).child("username").removeValue()
        usersRef.updateChildValues(["\(uid)/username/username": "User Unknown"])
        usersRef.child(uid).child("profile").removeValue()
        
    }
    
    func delete(_ username: String) {
        usernamesRef.child(username).removeValue()
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
                print("JACOB: Image downloaded from Firebase storage")
                if let imgData = data {
                    if let img = UIImage(data: imgData) {
                        completed(nil, img)
                    }
                }
            }
        })
    }
    
    func deleteImage(forURL url: String, completed: @escaping errorCompletion) {
        
        guard url != "" else {
            completed(nil)
            return
        }
        let ref = FIRStorage.storage().reference(forURL: url)
        
        ref.delete { (error) in
            if error != nil {
                print("JACOB: Error deleting image")
                completed(error as NSError?)
            } else {
                print("JACOB: Successfully deleted image from storage")
                completed(nil)
            }
        }
    }
    
    func submitQuestion(question: Question, completed: @escaping errorCompletion) {
        
        // create the dictionary that will be posted to the database
        let newQuestion: Dictionary<String, AnyObject> = [
            "title": question.title as AnyObject,
            "body": question.body as AnyObject,
            "userid": question.uid as AnyObject,
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
                completed(nil)
            }
        }
    }
    
    func loadQuestions(startTimestamp: Int?, numberOfItemsPerPage: Int, completed: @escaping errorArrayCompletion) {
        
        var count = numberOfItemsPerPage
        
        var query = questionsRef.queryOrdered(byChild: "timestamp")
        
        if startTimestamp != nil {
            query = query.queryEnding(atValue: startTimestamp)
            count += 1
        }
        
        query.queryLimited(toLast: UInt(count)).observeSingleEvent(of: .value, with: { (snapshot) in
            guard var children = snapshot.children.allObjects as? [FIRDataSnapshot] else {
                // handle error here
                let error = NSError()
                completed(error, nil)
                return
            }
            
            if startTimestamp != nil && !children.isEmpty {
                children.removeLast()
            }
            
            // now do something with the children
            var newQuestions = [Question]()
            for child in children {
                if let questionDict = child.value as? Dictionary<String, AnyObject> {
                    newQuestions.append(Question(questionKey: child.key, questionData: questionDict))
                }
            }
            
            completed(nil, newQuestions)
        })
        
    }
}
