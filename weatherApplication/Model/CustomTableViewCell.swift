//
//  CustomTableViewCell.swift
//  weatherApplication
//
//  Created by Hao on 9/28/17.
//  Copyright © 2017 Hao. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    @IBOutlet weak var dateOfWeekLabel: UILabel!
    
    @IBOutlet weak var tempMinInDayLabel: UILabel!
    @IBOutlet weak var tempMaxInDayLabel: UILabel!
    @IBOutlet weak var conditionOfDay: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
