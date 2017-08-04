//
//  TableViewCellForMyEvents.swift
//  MeetNeu
//
//  Created by Abraham Soto on 26/06/17.
//  Copyright © 2017 Abraham. All rights reserved.
//

import UIKit

class TableViewCellForMyEvents: UITableViewCell {
    @IBOutlet weak var tituloLb: UILabel!
    @IBOutlet weak var fechaLb: UILabel!
    @IBOutlet weak var horaLb: UILabel!
    @IBOutlet weak var precioLb: UILabel!

    @IBOutlet weak var imgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
