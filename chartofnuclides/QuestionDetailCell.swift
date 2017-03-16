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
    @IBOutlet weak var profileImageView: CircleImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func update(question: Question) {
        bodyLbl.text = question.body
        titleLbl.text = question.title
    }
    
    func update(answer: Answer) {
        
    }

}
