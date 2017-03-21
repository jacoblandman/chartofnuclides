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
    
    var delegate: PerformSegueFromCellDelegate!
    
    var post: Post!
    var userPosted: User!
    
    var upVoteTap: UITapGestureRecognizer? = nil
    var downVoteTap: UITapGestureRecognizer? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func addFlagTap() {
        // flag tap
        let flagTap = UITapGestureRecognizer(target: self, action: #selector(flagTapped))
        flagTap.numberOfTapsRequired = 1
        flagImgView.addGestureRecognizer(flagTap)
        flagImgView.isUserInteractionEnabled = true
    }
    
    func flagTapped() {
        delegate.callSegueFromCell(sender: post)
    }
    
    func addDownVoteTap() {
        downVoteTap = UITapGestureRecognizer(target: self, action: #selector(downVoteTapped))
        downVoteTap!.numberOfTapsRequired = 1
        arrowDownImgView.addGestureRecognizer(downVoteTap!)
        arrowDownImgView.isUserInteractionEnabled = true
    }
    
    func downVoteTapped(sender: UITapGestureRecognizer) {
        // disenable both the down and upvote taps
        // the user can only vote once
        
        downVoteTap?.isEnabled = false
        upVoteTap?.isEnabled = false
        
        arrowDownImgView.image = UIImage(named: "arrow_down_color")
        
    }
    
    func addUpVoteTap() {
        upVoteTap = UITapGestureRecognizer(target: self, action: #selector(upVoteTapped))
        upVoteTap!.numberOfTapsRequired = 1
        arrowUpImgView.addGestureRecognizer(upVoteTap!)
        arrowUpImgView.isUserInteractionEnabled = true
    }
    
    func upVoteTapped(sender: UITapGestureRecognizer) {
        // disenable both the down and upvote taps
        // the user can only vote once
        
        downVoteTap?.isEnabled = false
        upVoteTap?.isEnabled = false
        
        arrowUpImgView.image = UIImage(named: "arrow_up_color")
        
    }
    
    func update(post: Post, user: User, img: UIImage?, flagged: Bool, vote: VoteType, currentUser: User?) {
        
        self.post = post
        self.userPosted = user
        
        if let title = post.title {
            titleLbl.text = title
        }
        
        bodyLbl.text = post.body
        
        if let image = img {
            profileImageView.image = image
        } else {
            profileImageView.image = UIImage(named: "profile_icon_big")
        }
                
        profileUsernameLbl.text = user.username
        reputationLbl.text = "\(user.reputation)"
        votesLbl.text = "\(post.votes)"
        
        if flagged {
            flagImgView.image = UIImage(named: "flag_color")
        } else {
            if currentUser != nil {
                addFlagTap()
            }
        }
        
        switch vote {
        case .none:
            arrowUpImgView.image = UIImage(named: "arrow_up")
            arrowDownImgView.image = UIImage(named: "arrow_down")
            if currentUser != nil {
                addUpVoteTap()
                addDownVoteTap()
            }
            break
            
        case .upVote:
            arrowUpImgView.image = UIImage(named: "arrow_up_color")
            arrowDownImgView.image = UIImage(named: "arrow_down")
            break
            
        case .downVote:
            arrowUpImgView.image = UIImage(named: "arrow_up")
            arrowDownImgView.image = UIImage(named: "arrow_down_color")
            break
            
        }
    }
}
