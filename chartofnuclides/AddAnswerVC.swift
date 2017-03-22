//
//  AddAnswerVC.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 3/20/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit

class AddAnswerVC: UIViewController {

    @IBOutlet weak var activityMonitorView: InspectableBorderView!
    @IBOutlet weak var newAnswerView: NewQuestionView!
    @IBOutlet weak var bodyTextView: UITextView!
    let bodyPlaceholder = "Type a detailed description of your answer here."
    var user: User!
    var question: Post!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bodyTextView.delegate = self
        bodyTextView.becomeFirstResponder()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        if  bodyTextView.text == bodyPlaceholder || bodyTextView.text == "" {
            view.endEditing(true)
            dismiss(animated: true, completion: nil)
            return
        }
        
        let ac = UIAlertController(title: "Are you sure you want to cancel?", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (UIAlertAction) in
            self.view.endEditing(true)
            self.dismiss(animated: true, completion: nil)
        }))
        ac.addAction(UIAlertAction(title: "No", style: .default, handler: { (UIAlertAction) in
            ac.dismiss(animated: true, completion: nil)
        }))
        present(ac, animated: true, completion: nil)
    }
    
    @IBAction func postPressed(_ sender: Any) {
        // make sure the user has entered text into the title and body before submitting question
        if bodyTextView.text == bodyPlaceholder || bodyTextView.text.isEmpty {
            let ac = UIAlertController(title: "Error", message: "You must input an answer to submit", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Gotcha", style: .cancel, handler: nil))
            present(ac, animated: true, completion: nil)
        } else {
            let ac = UIAlertController(title: "Are you sure you are ready to post?", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (UIAlertAction) in
                self.postAnswer()
            }))
            ac.addAction(UIAlertAction(title: "No", style: .default, handler: { (UIAlertAction) in
                ac.dismiss(animated: true, completion: nil)
            }))
            present(ac, animated: true, completion: nil)
        }
    }
    
    func postAnswer() {
        
        newAnswerView.isHidden = true
        activityMonitorView.isHidden = false
        
        let newAnswer = Post(title: nil, body: bodyTextView.text, uid: user.uid, votes: 0, postType: .answer)
        
        DataService.instance.submitAnswer(answer: newAnswer, for: self.question) { (error) in
            // now unhide the answer view and hide the activity monitro
            self.newAnswerView.isHidden = false
            self.activityMonitorView.isHidden = true
            
            if error != nil {
                let message = ErrorHandler.handleFirebaseError(error: error!)
                let ac = UIAlertController(title: "Error please try again", message: message, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
                self.present(ac, animated: true, completion: nil)
            } else {
                if let parent = self.parent as? QuestionDetailVC {
                    parent.refreshView()
                }
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}

extension AddAnswerVC: UITextViewDelegate {
    
    // all of the below functions are to give the textview placeholder functionality like a label
    
    
    func setCursorToBeginning(_ textView: UITextView) {
        let position = textView.beginningOfDocument
        textView.selectedTextRange = textView.textRange(from: position, to: position)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        // for some reason doing this with a delay works, but not otherwise
        if textView.text.isEmpty || textView.text == bodyPlaceholder {
            self.perform(#selector(setCursorToBeginning(_:)), with: textView, afterDelay: 0.001)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = bodyPlaceholder
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if textView.text == bodyPlaceholder && text != "" {
            textView.text = ""
        }
        
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = bodyPlaceholder
            setCursorToBeginning(textView)
        }
    }
}
