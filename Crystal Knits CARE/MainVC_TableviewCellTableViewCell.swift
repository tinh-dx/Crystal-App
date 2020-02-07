//
//  MainVC_TableviewCellTableViewCell.swift
//  Crystal Knits CARE
//
//  Created by REGISDMAC01 on 10/4/19.
//  Copyright © 2019 TinhDX. All rights reserved.
//

import UIKit

class MainVC_TableviewCellTableViewCell: UITableViewCell {

    @IBOutlet weak var lbRemark: UILabel!
    @IBOutlet weak var lbContents: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        imgView.layer.masksToBounds = true
        imgView.layer.borderWidth = 0.7
        imgView.layer.borderColor = UIColor.lightGray.cgColor
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
