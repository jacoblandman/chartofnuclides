//
//  FlagPostVC.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 3/20/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit

class FlagPostVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var delegate: SendDataToPreviousControllerDelegate!
    
    var post: Post!
    var currentUser: User!
    var cellIndexPath: IndexPath!
    
    let questionReasons = ["Inappropriate content",
                           "Inappropriate profile image",
                           "Content off topic",
                           "Duplicate question",
                           "Too broad",
                           "Unclear",
                           "Spam"]
    
    let answerReasons = ["Inappropriate content",
                         "Inappropriate profile image",
                         "Content off topic",
                         "Rude or abusive",
                         "Not an answer",
                         "Low quality",
                         "Spam"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
    }

    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension FlagPostVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return post.postType == .question ? questionReasons.count : answerReasons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportCell", for: indexPath) as! ReportCell
        let reason = post.postType == .question ? questionReasons[indexPath.row] : answerReasons[indexPath.row]
        cell.update(text: reason)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let reason = post.postType == .question ? questionReasons[indexPath.row] : answerReasons[indexPath.row]
        
        let ac = UIAlertController(title: "Report post as \(reason.lowercased())", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (UIAlertAction) in
            self.report(reason: reason)
        }))
        ac.addAction(UIAlertAction(title: "No", style: .default, handler: { (UIAlertAction) in
            ac.dismiss(animated: true, completion: nil)
        }))
        present(ac, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func report(reason: String) {
        DataService.instance.flagPost(post: post, reason: reason) { (error) in
            if error != nil {
                let message = ErrorHandler.handleFirebaseError(error: error!)
                let ac = UIAlertController(title: "Error please try again!", message: message, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
                self.present(ac, animated: true, completion: nil)
            } else {
                // the report was successfull
                self.delegate.sendDataToA(data: self.cellIndexPath)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
