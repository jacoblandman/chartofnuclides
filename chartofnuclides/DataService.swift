//
//  DataService.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 2/3/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

let FIR_CHILD_USERS = "users"
let FIR_CHILD_USERNAMES = "usernames"
let FIR_CHILD_QUESTIONS = "questions"
let FIR_CHILD_COMMENTS = "comments"
let FILENAME_NUCLIDES = "nuclides"
let FILE_EXTENSION_NUCLIDES = "json"

typealias uniqueUsernameCompletion = (_ isUnique: Bool) -> Void
typealias previousUserCheckCompletion = (_ isPreviousUser: Bool) -> Void

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
    
    var commentsRef: FIRDatabaseReference {
        return mainRef.child(FIR_CHILD_COMMENTS)
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
                                                      "comments": 0 as AnyObject,
                                                      "imageURL": "" as AnyObject]
        
        mainRef.child(FIR_CHILD_USERS).child(uid).child("profile").setValue(profile)
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
}
