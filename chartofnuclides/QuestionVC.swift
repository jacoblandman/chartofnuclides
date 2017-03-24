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
    
    var delegate: SendDataToPreviousControllerDelegate?
    
    var user: User!

    let titlePlaceholder = "Type your question here. Try to be specific."
    let bodyPlaceholder = "Type a more detailed description of your question here."
    
    var needsDismiss: Bool = false
    
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

        titleTextView.resignFirstResponder()
        bodyTextView.resignFirstResponder()
        performSegue(withIdentifier: "CustomAC", sender: PostActionType.cancel)
        
    }
    
    @IBAction func postPressed(_ sender: Any) {
        
        titleTextView.text = titleTextView.text.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        bodyTextView.text = bodyTextView.text.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        
        // make sure the user has entered text into the title and body before submitting question
        if titleTextView.text == titlePlaceholder || bodyTextView.text == bodyPlaceholder ||
           titleTextView.text.isEmpty || bodyTextView.text.isEmpty {
            let ac = UIAlertController(title: "Error", message: "You must input both a title and a body", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Gotcha", style: .cancel, handler: nil))
            present(ac, animated: true, completion: nil)
        } else {
            
            titleTextView.resignFirstResponder()
            bodyTextView.resignFirstResponder()
            performSegue(withIdentifier: "CustomAC", sender: PostActionType.post)
        }
    }
    
    func postQuestion() {
        
        // will attempt to post the question to the database
        // while attempting, show an activity monitor
        activityMonitorView.isHidden = false
        
        let newQuestion = Post(title: titleTextView.text, body: bodyTextView.text, uid: user.uid, votes: 0, postType: .question)
        
        DataService.instance.submitQuestion(question: newQuestion, completed: { (error) in
            
            // now hide the activity monitor
            self.activityMonitorView.isHidden = true
            
            if error != nil {
                let message = ErrorHandler.handleFirebaseError(error: error!)
                let ac = UIAlertController(title: "Error please try again", message: message, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
                self.present(ac, animated: true, completion: nil)
            } else {
                self.delegate?.signalRefresh()
                self.dismiss(animated: true, completion: nil)
            }
        })
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
        
        if textView == titleTextView && textView.text == titlePlaceholder {
            textView.text = ""
        } else if textView == bodyTextView && textView.text == bodyPlaceholder {
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

extension QuestionVC: UIViewControllerTransitioningDelegate {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CustomAC" {
            if let destination = segue.destination as? CustomAC {
                if let postActionType = sender as? PostActionType {
                    destination.postActionType = postActionType
                    destination.delegate = self
                    destination.transitioningDelegate = self
                }
            }
        }
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return ACAnimator(withDuration: 0.25, forTransitionType: .presenting, respondingTextView: nil)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        var respondingTextView: UITextView? = bodyTextView
        if needsDismiss {
            respondingTextView = nil
        }
        return ACAnimator(withDuration: 0.25, forTransitionType: .dismissing, respondingTextView: respondingTextView)
    }
}

extension QuestionVC: CustomACCommunicationDelegate {
    func post() {
        postQuestion()
    }
    
    func set(needsDismiss: Bool) {
        self.needsDismiss = true
    }
    
    func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
}

