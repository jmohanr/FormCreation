//
//  TableViewCell.swift
//  Handzap
//
//  Created by Jagan on 19/01/20.
//  Copyright © 2020 Jagan. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet weak var formTitleLabel:UILabel!
    @IBOutlet weak var startDateLabel:UILabel!
    @IBOutlet weak var viewsLabel:UILabel!
    @IBOutlet weak var rateLabel:UILabel!
    @IBOutlet weak var jobTermLabel:UILabel!
    @IBOutlet weak var postSettingButton:UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
