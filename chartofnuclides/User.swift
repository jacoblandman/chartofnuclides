//
//  User.swift
//  spaceChat
//
//  Created by Jacob Landman on 1/24/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit

struct User {
    private var _username: String
    private var _uid: String
    private var _repuation: String
    private var _questions: String
    private var _comments: String
    
    var uid: String {
        return _uid
    }
    
    var username: String {
        return _username
    }
    
    var reputation: String {
        return _repuation
    }
    
    var questions: String {
        return _questions
    }
    
    var comments: String {
        return _comments
    }
    
    init(uid: String, username: String, reputation: String, questions: String, comments: String) {
        _uid = uid
        _username = username
        _repuation = reputation
        _questions = questions
        _comments = comments
    }
}
