//
//  MessageTableCell.swift
//  IamDemo
//
//  Created by Trần Mạnh Quý on 10/1/20.
//

import UIKit

class MessageTableCell: UITableViewCell {

    @IBOutlet weak var imageAvatar: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelMsg: UILabel!
    @IBOutlet weak var labelTime: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        imageAvatar.layer.cornerRadius = imageAvatar.bounds.height / 2
        imageAvatar.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
