//
//  EventMiniature.swift
//  MeetNeu
//
//  Created by Abraham Soto on 31/05/17.
//  Copyright © 2017 Abraham. All rights reserved.
//

import UIKit

class EventMiniature: UICollectionViewCell {
    
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var footViewSmall: UIView!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var starImg: UIImageView!
    @IBOutlet weak var downContainerView: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        downContainerView!.layer.shadowOpacity = 0.8
        downContainerView!.layer.shadowOffset = CGSize(width: 0, height: 3)
        downContainerView!.layer.shadowRadius = 4.0
        
        let shadowRect: CGRect = downContainerView!.bounds.insetBy(dx: 0, dy: 4);  // inset top/bottom
        
        downContainerView!.layer.shadowPath = UIBezierPath(rect: shadowRect).cgPath
        
        mainImage!.layer.shadowOpacity = 0.8
        mainImage!.layer.shadowOffset = CGSize(width: 0, height: 3)
        mainImage!.layer.shadowRadius = 4.0
        
        let shadowRect2: CGRect = mainImage!.bounds.insetBy(dx: 0, dy: 4);  // inset top/bottom
        
        mainImage!.layer.shadowPath = UIBezierPath(rect: shadowRect2).cgPath
    }
}
