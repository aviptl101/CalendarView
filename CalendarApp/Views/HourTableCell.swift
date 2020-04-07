//
//  HourTableCell.swift
//  CalendarApp
//
//  Created by Avinash J Patel on 06/04/20.
//  Copyright © 2020 Avinash. All rights reserved.
//

import UIKit

fileprivate enum Constants {
    static let hours12 = 12
}


class HourTableCell: UITableViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var topSeparator: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var currentTimeMark: UILabel!
    @IBOutlet weak var currentTimeTopSpace: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func showCurrentTimeMark() {
        let minutes = Utils.getMinutes()
        
        if minutes <= 7 {
            timeLabel.isHidden = true
        } else {
            timeLabel.isHidden = false
        }

        let height = contentView.frame.size.height - 5
        let minHeightUnit = height / 60
        let markerHeight = CGFloat(minutes) * minHeightUnit
        currentTimeTopSpace.constant = markerHeight
        currentTimeMark.isHidden = false
        currentTimeLabel.isHidden = false
        setCurrentTimeLabel()
    }
    
    func hideCurrentTimeMark() {
        currentTimeMark.isHidden = true
        currentTimeLabel.isHidden = true
    }
    
    private func setCurrentTimeLabel() {
        var hours = Utils.getHours()
        let minutes = Utils.getMinutes()
        
        if hours == 0 {
            hours = Constants.hours12
        } else if hours > Constants.hours12 {
            hours -= Constants.hours12
            currentTimeLabel.text = "\(hours):\(minutes) PM"
        } else {
            currentTimeLabel.text = "\(hours):\(minutes) AM"
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        timeLabel.isHidden = false
    }
}
