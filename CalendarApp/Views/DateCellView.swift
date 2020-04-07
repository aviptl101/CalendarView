//
//  DateCellView.swift
//  CalendarApp
//
//  Created by Avinash J Patel on 05/04/20.
//  Copyright © 2020 Avinash. All rights reserved.
//

import UIKit

class DateCellView: UICollectionViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = self.bounds.height / 3
        clipsToBounds = true
    }
}
