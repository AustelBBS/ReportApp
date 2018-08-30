//
//  MessageCell.swift
//  ReportApp
//
//  Created by Omar Rico on 8/21/18.
//  Copyright © 2018 Los Ponis. All rights reserved.
//

import Foundation
import UIKit

class MessageCell: UITableViewCell {
    
    public static let reuseId: String = "messageCell"
    @IBOutlet weak var mMessageLabel: UILabel!
    @IBOutlet weak var mWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var mBubbleView: UIView!
    
    @IBOutlet weak var mLeadingSpaceConstraint: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mBubbleView.layer.cornerRadius = 7	
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

