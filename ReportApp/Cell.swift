//
//  Cell.swift
//  ReportApp
//
//  Created by DonauMorgen on 16/03/18.
//  Copyright © 2018 Los Ponis. All rights reserved.
//

import UIKit

class Cell: UITableViewCell {

    @IBOutlet weak var mImage: UIImageView!
    @IBOutlet weak var mDateLabel: UILabel!
    @IBOutlet weak var mStatusLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
