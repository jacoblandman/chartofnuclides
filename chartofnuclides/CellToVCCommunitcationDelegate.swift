//
//  PerformSegueFromCellDelegate.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 3/20/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

protocol CellToVCCommunicationDelegate {
    
    func callSegueFromCell(sender: Any?)
    
    func addFlag(postKey: String)
    
    func addUpvote(postKey: String)
    
    func addDownvote(postKey: String)
    
    func removeDownvote(postKey: String)
    
    func removeUpVote(postKey: String)
}
