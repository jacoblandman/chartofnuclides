//
//  User.swift
//  spaceChat
//
//  Created by Jacob Landman on 1/24/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit
import Firebase

typealias userDownloadComplete = () -> ()

class User {
    private var _uid: String
    private var _username: String!
    private var _repuation: String!
    private var _questions: String!
    private var _comments: String!
    
    var uid: String {
        return _uid
    }
    
    var username: String {
        if _username == nil {
            _username = ""
        }
        return _username
    }
    
    var reputation: String {
        if _repuation == nil {
            _repuation = ""
        }
        return _repuation
    }
    
    var questions: String {
        if _questions == nil {
            _questions = ""
        }
        return _questions
    }
    
    var comments: String {
        if _comments == nil {
            _comments = ""
        }
        return _comments
    }
    
    init(uid: String) {
        _uid = uid
    }
    
    func loadUserInfo(completed: @escaping userDownloadComplete) {
        let userRef = DataService.instance.usersRef.child(self.uid)
        
        userRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
        let profileSnap = snapshot.childSnapshot(forPath: "profile")
            print("JACOB: Found profile")
            if let profileDict = profileSnap.value as? Dictionary<String, AnyObject> {
                if let questionsAsked = profileDict["questionsAsked"] as? String {
                    self._questions = questionsAsked
                }
                if let comments = profileDict["comments"] as? String {
                    self._comments = comments
                }
                if let reputation = profileDict["reputation"] as? String {
                    self._repuation = reputation
                    print("REPUTATION: ", reputation)
                }
            }
            
        let usernameSnap = snapshot.childSnapshot(forPath: "username")
            print("JACOB: Found username")
            if let usernameDict = usernameSnap.value as? Dictionary<String, AnyObject> {
                if let username = usernameDict["username"] as? String {
                    self._username = username
                }
            }
        
        completed()
            
        })
        
    }
    
    deinit {
        print("JACOB: User object has been deinited")
    }
}
