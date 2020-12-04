//
//  MyDiaryCell.swift
//  Diary App
//
//  Created by Bhavik Darji on 04/12/20.
//

import UIKit

class MyDiaryCell: UITableViewCell {

    @IBOutlet weak var lbldays: UILabel!
    @IBOutlet weak var viewinformation: UIView!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var lblDiaryTitle: UILabel!
    @IBOutlet weak var lblDiaryContent: UILabel!
    @IBOutlet weak var lblTimeline: UILabel!
    @IBOutlet weak var btnCancel: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
