//
//  QuestionCell.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 2/25/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit

class QuestionCell: UITableViewCell {

    @IBOutlet weak var questionTitle: UILabel!
    @IBOutlet weak var questionDescription: UILabel!
    @IBOutlet weak var mainView: InspectableShadowView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if (highlighted) {
            UIView.animate(withDuration: 0.35, delay: 0.0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
                self.mainView.backgroundColor = UIColor.lightGray
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.35, delay: 0.0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
                self.mainView.backgroundColor = UIColor.white
            }, completion: nil)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        self.selectionStyle = UITableViewCellSelectionStyle.default
    }
}
