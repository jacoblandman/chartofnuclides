//
//  QuestionDetailCell.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 3/16/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit

class QuestionDetailCell: UITableViewCell {

    @IBOutlet weak var bodyLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var profileUsernameLbl: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var votesLbl: UILabel!
    @IBOutlet weak var arrowUpImgView: UIImageView!
    @IBOutlet weak var arrowDownImgView: UIImageView!
    @IBOutlet weak var flagImgView: UIImageView!
    @IBOutlet weak var reputationLbl: UILabel!
    
    var delegate: CellToVCCommunicationDelegate!
    
    var post: Post!
    var userPosted: User!
    var currentUser: User?
    
    var downVoteTap: UITapGestureRecognizer!
    var upVoteTap: UITapGestureRecognizer!
    var flagTap: UITapGestureRecognizer!
    
    var cellIndexPath: IndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.isUserInteractionEnabled = true
        
        addFlagTapGesture()
        addDownVoteTapGesture()
        addUpVoteTapGesture()
        
        upVoteTap.isEnabled = false
        downVoteTap.isEnabled = false
    }
    
    func addFlagTapGesture() {
        // flag tap
        flagTap = UITapGestureRecognizer(target: self, action: #selector(flagTapped))
        flagTap.numberOfTapsRequired = 1
        flagImgView.addGestureRecognizer(flagTap)
        flagImgView.isUserInteractionEnabled = true
    }
    
    func addUpVoteTapGesture() {
        upVoteTap = UITapGestureRecognizer(target: self, action: #selector(upVoteTapped))
        upVoteTap.numberOfTapsRequired = 1
        arrowUpImgView.addGestureRecognizer(upVoteTap)
        arrowUpImgView.isUserInteractionEnabled = true
    }
    
    func addDownVoteTapGesture() {
        downVoteTap = UITapGestureRecognizer(target: self, action: #selector(downVoteTapped))
        downVoteTap.numberOfTapsRequired = 1
        arrowDownImgView.addGestureRecognizer(downVoteTap)
        arrowDownImgView.isUserInteractionEnabled = true
    }
    
    func flagTapped() {
        let dict = ["post": post, "cellIndexPath": cellIndexPath] as [String : Any]
        delegate.callSegueFromCell(sender: dict)
    }
    
    func downVoteTapped(sender: UITapGestureRecognizer) {
        
        // disenable both the down and upvote taps
        // the user can only vote once
        downVoteTap.isEnabled = false
        upVoteTap.isEnabled = false
        
        arrowDownImgView.image = UIImage(named: "arrow_down_color")
        adjustVotes(addVote: false)
        
        guard let currentUser = currentUser else { return }
        
        delegate.addDownvote(postKey: post.postKey)
        
        DataService.instance.logDownVote(post: post, userPosted: userPosted, currentUser: currentUser) { 
            self.arrowDownImgView.image = UIImage(named: "arrow_down")
            self.downVoteTap.isEnabled = true
            self.upVoteTap.isEnabled = true
            self.adjustVotes(addVote: true)
            self.delegate.removeDownvote(postKey: self.post.postKey)
            return
        }
    }

    func upVoteTapped(sender: UITapGestureRecognizer) {
        
        // disenable both the down and upvote taps
        // the user can only vote once
        downVoteTap.isEnabled = false
        upVoteTap.isEnabled = false
        
        arrowUpImgView.image = UIImage(named: "arrow_up_color")
        adjustVotes(addVote: true)
        
        guard let currentUser = currentUser else { return }
        
        delegate.addUpvote(postKey: post.postKey)
        
        DataService.instance.logUpVote(post: post, userPosted: userPosted, currentUser: currentUser) {
            self.arrowUpImgView.image = UIImage(named: "arrow_up")
            self.downVoteTap.isEnabled = true
            self.upVoteTap.isEnabled = true
            self.adjustVotes(addVote: false)
            self.delegate.removeUpVote(postKey: self.post.postKey)
            return
        }
    }
    
    func markAsFlagged() {
        flagTap.isEnabled = false
        flagImgView.image = UIImage(named: "flag_color")
        delegate.addFlag(postKey: post.postKey)
    }
    
    func adjustVotes(addVote: Bool) {
        post.adjustVotes(addVote: addVote)
        votesLbl.text = "\(post.votes)"
    }
    
    func update(post: Post, userPosted: User, img: UIImage?,
                currentUser: User?, cellIndexPath: IndexPath,
                flagged: Bool, downvoted: Bool, upvoted: Bool) {
        
        self.cellIndexPath = cellIndexPath
        self.currentUser = currentUser
        self.post = post
        self.userPosted = userPosted
        
        if let title = post.title {
            titleLbl.text = title
        }
        
        bodyLbl.text = post.body
        
        if let image = img {
            profileImageView.image = image
        } else {
            profileImageView.image = UIImage(named: "profile_icon_grey")
        }
                
        profileUsernameLbl.text = userPosted.username
        reputationLbl.text = "\(userPosted.reputation)"
        votesLbl.text = "\(post.votes)"
        
        // decide if to enable the flag
        if flagged {
            flagImgView.image = UIImage(named: "flag_color")
            flagTap.isEnabled = false
        } else {
            flagImgView.image = UIImage(named: "flag_white")
            if currentUser != nil {
                flagTap.isEnabled = true
            }
        }
        
        // decide if to enable the upvote and downvote buttons
        if upvoted {
            arrowUpImgView.image = UIImage(named: "arrow_up_color")
            arrowDownImgView.image = UIImage(named: "arrow_down")
            
            upVoteTap.isEnabled = false
            downVoteTap.isEnabled = false
        } else if downvoted {
            arrowUpImgView.image = UIImage(named: "arrow_up")
            arrowDownImgView.image = UIImage(named: "arrow_down_color")

            upVoteTap.isEnabled = false
            downVoteTap.isEnabled = false
        } else {
            arrowUpImgView.image = UIImage(named: "arrow_up")
            arrowDownImgView.image = UIImage(named: "arrow_down")
            if currentUser != nil {
                upVoteTap.isEnabled = true
                downVoteTap.isEnabled = true
            }
        }
    }
}
