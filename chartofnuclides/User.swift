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
    private var _repuation: Int!
    private var _questions: Int!
    private var _comments: Int!
    private var _imageURL: String!
    
    var uid: String {
        return _uid
    }
    
    var username: String {
        if _username == nil {
            _username = ""
        }
        return _username
    }
    
    var reputation: Int {
        if _repuation == nil {
            _repuation = 0
        }
        return _repuation
    }
    
    var questions: Int {
        if _questions == nil {
            _questions = 0
        }
        return _questions
    }
    
    var comments: Int {
        if _comments == nil {
            _comments = 0
        }
        return _comments
    }
    
    var imageURL: String {
        get {
            if _imageURL == nil {
                _imageURL = ""
            }
            return _imageURL
        }
        
        set {
            _imageURL = newValue
        }
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
                if let questionsAsked = profileDict["questionsAsked"] as? Int {
                    self._questions = questionsAsked
                }
                if let comments = profileDict["comments"] as? Int {
                    self._comments = comments
                }
                if let reputation = profileDict["reputation"] as? Int {
                    self._repuation = reputation
                }
                if let imageURL = profileDict["imageURL"] as? String {
                    self._imageURL = imageURL
                    print("ImageURL: ", imageURL)
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
    
    func loadImageURL(completed: @escaping userDownloadComplete) {
        let userRef = DataService.instance.usersRef.child(self.uid)
        
        userRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            let profileSnap = snapshot.childSnapshot(forPath: "profile")
            print("JACOB: Found profile")
            if let profileDict = profileSnap.value as? Dictionary<String, AnyObject> {

                if let imageURL = profileDict["imageURL"] as? String {
                    self._imageURL = imageURL
                    print("ImageURL: ", imageURL)
                }
            }
            
            completed()
        })
    }
    
    deinit {
        print("JACOB: User object has been deinited")
    }
}
