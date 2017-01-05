//
//  SortTableViewCell.swift
//  Yard2
//
//  Created by Caitlyn Chen on 1/4/17.
//  Copyright © 2017 Caitlyn Chen. All rights reserved.
//

import UIKit

class SortTableViewCell: UITableViewCell {

    @IBOutlet weak var chkbutton: UIButton!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var sortLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
