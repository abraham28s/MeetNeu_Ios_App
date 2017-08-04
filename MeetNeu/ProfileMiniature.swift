//
//  ProfileMiniature.swift
//  MeetNeu
//
//  Created by Abraham Soto on 19/06/17.
//  Copyright © 2017 Abraham. All rights reserved.
//

import UIKit

class ProfileMiniature: UICollectionViewCell {
    @IBOutlet weak var profilePicture: UIImageView!
    
    @IBOutlet weak var profileName: UILabel!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
