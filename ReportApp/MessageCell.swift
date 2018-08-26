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
    @IBOutlet weak var mStackView: UIStackView!
    @IBOutlet weak var mMessageLabel: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mMessageLabel.layer.cornerRadius = 10
        mMessageLabel.layer.masksToBounds = true
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
