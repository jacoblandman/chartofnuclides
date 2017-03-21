//
//  Question.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 3/15/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit
import FirebaseDatabase

enum PostType {
    case answer
    case question
}

class Post: NSObject {


    private var _postType: PostType!
    private var _title: String?
    private var _body: String!
    private var _uid: String!
    private var _votes: Int!
    private var _postKey: String!
    private var _postRef: FIRDatabaseReference!
    private var _timestamp: Int!
    
    var title: String? {
        return _title
    }
    
    var body: String {
        return _body
    }
    
    var uid: String {
        return _uid
    }
    
    var votes: Int {
        return _votes
    }
    
    var postKey: String {
        return _postKey
    }
    
    var timestamp: Int {
        return _timestamp
    }
    
    var postType: PostType {
        return _postType
    }
    
    init(title: String?, body: String, uid: String, votes: Int, postType: PostType) {
        // if the title is nil, then the post is an answer, not a question
        if title != nil {
            _title = title
        }
        
        _body = body
        _uid = uid
        _votes = votes
        _postType = postType
    }
    
    // this will be used to convert the firebase data
    init(postKey: String, postData: Dictionary<String, AnyObject>, postType: PostType) {
        self._postKey = postKey
        
        if let title = postData["title"] as? String {
            self._title = title
        }
        
        if let body = postData["body"] as? String {
            self._body = body
        }
        
        if let votes = postData["votes"] as? Int {
            self._votes = votes
        }
        
        if let uid = postData["uid"] as? String {
            self._uid = uid
        }
        
        if let timestamp = postData["timestamp"] as? Int {
            self._timestamp = timestamp
        }
        
        _postType = postType
        
        if postType == .question {
            _postRef = DataService.instance.questionsRef.child(postKey)
        } else {
            _postRef = DataService.instance.answersRef.child(postKey)
        }
        
    }
    
    func adjustVotes(addVote: Bool) {
        if addVote {
            _votes = _votes + 1
        } else {
            _votes = _votes - 1
        }
        _postRef.child("votes").setValue(_votes)
    }
}
