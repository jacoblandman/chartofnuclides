//
//  QuestionVC.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 3/13/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit

class QuestionVC: UIViewController {

    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var questionView: NewQuestionView!
    @IBOutlet weak var activityMonitorView: InspectableBorderView!
    
    var user: User!

    let titlePlaceholder = "Type your question here. Try to be specific."
    let bodyPlaceholder = "Type a more detailed description of your question here."
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleTextView.delegate = self
        bodyTextView.delegate = self
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        titleTextView.becomeFirstResponder()
        
        view.endEditing(false)
        
    }

    @IBAction func cancelPressed(_ sender: Any) {
        
        if titleTextView.text == titlePlaceholder && bodyTextView.text == bodyPlaceholder ||
           titleTextView.text == "" && bodyTextView.text == bodyPlaceholder ||
           titleTextView.text == titlePlaceholder && bodyTextView.text == "" {
            view.endEditing(true)
            dismiss(animated: true, completion: nil)
            return
        }

        let ac = UIAlertController(title: "Are you sure you want to cancel?", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (UIAlertAction) in
            self.view.endEditing(true)
            self.dismiss(animated: true, completion: nil)
        }))
        ac.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        present(ac, animated: true, completion: nil)
        
    }
    
    @IBAction func postPressed(_ sender: Any) {
        
        // make sure the user has entered text into the title and body before submitting question
        if titleTextView.text == titlePlaceholder || bodyTextView.text == bodyPlaceholder ||
           titleTextView.text.isEmpty || bodyTextView.text.isEmpty {
            let ac = UIAlertController(title: "Error", message: "You must input both a title and a body", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Gotcha", style: .cancel, handler: nil))
            present(ac, animated: true, completion: nil)
        } else {
            
            // will attempt to post the question to the database
            // while attempting hide the question view and show an activity monitor
            questionView.isHidden = true
            activityMonitorView.isHidden = false
            
            let newQuestion = Post(title: titleTextView.text, body: bodyTextView.text, uid: user.uid, votes: 0, postType: .question)
            
            DataService.instance.submitQuestion(question: newQuestion, completed: { (error) in
                
                // now unhide the question view and hide the activity monitor
                self.questionView.isHidden = false
                self.activityMonitorView.isHidden = true
                
                if error != nil {
                    let message = ErrorHandler.handleFirebaseError(error: error!)
                    let ac = UIAlertController(title: "Error please try again", message: message, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
                    self.present(ac, animated: true, completion: nil)
                } else {
                    self.dismiss(animated: true, completion: nil)
                }
            })
        }
    }
}

extension QuestionVC: UITextViewDelegate {
    
    func setCursorToBeginning(_ textView: UITextView) {
        let position = textView.beginningOfDocument
        textView.selectedTextRange = textView.textRange(from: position, to: position)
//        textView.selectedRange = 
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
 
        // for some reason doing this with a delay works, but not otherwise
        if textView == titleTextView && textView.text == titlePlaceholder {
            self.perform(#selector(setCursorToBeginning(_:)), with: textView, afterDelay: 0.001)
        } else if textView == bodyTextView && textView.text == bodyPlaceholder {
            self.perform(#selector(setCursorToBeginning(_:)), with: textView, afterDelay: 0.001)
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            if textView == titleTextView {
                textView.text = titlePlaceholder
            } else {
                textView.text = bodyPlaceholder
            }
        }
        
        textView.resignFirstResponder()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if textView == titleTextView && textView.text == titlePlaceholder && text != "" {
            textView.text = ""
        } else if textView == bodyTextView && textView.text == bodyPlaceholder && text != "" {
            textView.text = ""
        }
        
        // make the body the responder if return is pressed when entering the question title
        if textView == titleTextView && text == "\n" {
            textView.resignFirstResponder()
            bodyTextView.becomeFirstResponder()
            return false
        } else {
            return true
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text == "" {
            if textView == titleTextView {
                textView.text = titlePlaceholder
            } else {
                textView.text = bodyPlaceholder
            }
            setCursorToBeginning(textView)
        }
    }
    
}
