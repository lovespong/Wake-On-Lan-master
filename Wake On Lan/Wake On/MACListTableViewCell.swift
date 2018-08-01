//
//  MACListTableViewCell.swift
//  Wake On Lan
//
//  Created by James Tang on 17/7/2018.
//  Copyright © 2018年 JamesTang. All rights reserved.
//

import UIKit

class MACListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ipLabel: UILabel!
    @IBOutlet weak var macLabel: UILabel!
    @IBOutlet weak var pcSwitch: UISwitch!
    @IBOutlet weak var actionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
