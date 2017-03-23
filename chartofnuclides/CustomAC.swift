//
//  CustomAC.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 3/22/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit

enum PostActionType {
    case cancel, post
}

class CustomAC: UIViewController {

    @IBOutlet weak var alertTitle: UILabel!
    @IBOutlet weak var toolBar: UIToolbar!
    
    var delegate: CustomACCommunicationDelegate!
    
    var postActionType: PostActionType!
    
    var postTitle: String?
    var body: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if postActionType == .post {
            alertTitle.text = "Ready to post?"
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        toolBar.isTranslucent = true
    }
    
    @IBAction func yesPressed(_ sender: Any) {
        
        if postActionType == .post {
            // post the answer/question to the database
            delegate.post()
            

            // set the parent view controller's needsDismiss to true
            delegate.set(needsDismiss: true)
            
        } else {
            // set the parent view controller's needsDismiss to true
            delegate.set(needsDismiss: true)
            
        }
        
        self.dismiss(animated: true, completion: { self.delegate.dismiss() })
    }
    
    @IBAction func noPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
