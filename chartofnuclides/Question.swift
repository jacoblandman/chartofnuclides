//
//  Question.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 3/15/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit
import FirebaseDatabase

class Question: NSObject {

    private var _title: String!
    private var _body: String!
    private var _uid: String!
    private var _votes: Int!
    private var _questionKey: String!
    private var _questionRef: FIRDatabaseReference!
    
    var title: String {
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
    
    var questionKey: String {
        return _questionKey
    }
    
    init(title: String, body: String, uid: String, votes: Int) {
        _title = title
        _body = body
        _uid = uid
        _votes = votes
    }
    
    // this will be used to convert the firebase data
    init(questionKey: String, questionData: Dictionary<String, AnyObject>) {
        self._questionKey = questionKey
        
        if let title = questionData["title"] as? String {
            self._title = title
        }
        
        if let body = questionData["body"] as? String {
            self._body = body
        }
        
        if let votes = questionData["votes"] as? Int {
            self._votes = votes
        }
        
        if let uid = questionData["userid"] as? String {
            self._uid = uid
        }
        
        _questionRef = DataService.instance.questionsRef.child(questionKey)
    }
    
    func adjustVotes(addVote: Bool) {
        if addVote {
            _votes = _votes + 1
        } else {
            _votes = _votes - 1
        }
        _questionRef.child("votes").setValue(_votes)
    }
}
