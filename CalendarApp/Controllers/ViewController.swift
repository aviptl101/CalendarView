//
//  ViewController.swift
//  CalendarApp
//
//  Created by Avinash J Patel on 04/04/20.
//  Copyright © 2020 Avinash. All rights reserved.
//

import UIKit

fileprivate enum Constants {
    static let daysPerWeek = 7
    static let lineSpacing: CGFloat = 20
    static let dateCell = "DateCell"
    static let hourTableCell = "HourTableCell"
    static let cellHeight: CGFloat = 60
    static let hours12 = 12
    static let april = "April"
    static let march = "March"
    static let may = "May"
}

class ViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var titleLabel: UILabel!
    private var itemWidth: CGFloat = 0
    private var selectedTableIndexPath = IndexPath(item: 100, section: 0)
    private var selectedCollectionIndexPath = IndexPath(item: 100, section: 0)
    
    private let day = Utils.getDay()
    private let currentMonth = Utils.getMonth()
    private let firstDayIndexOffset = Utils.getFirstDayIndexOffset()
    
    private var currentMonthDays = 0
    private var previousMonthDays = 0
    private var nextMonthDays = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = Constants.april
        setCollectionView()
        tableView.allowsSelection = false
        
        currentMonthDays = Utils.getNumberOfDaysIn(month: currentMonth)
        previousMonthDays = Utils.getNumberOfDaysIn(month: currentMonth - 1)
        nextMonthDays = Utils.getNumberOfDaysIn(month: currentMonth + 1)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
        scrollToCurrentDay()
    }

    private func setCollectionView() {
        flowLayout.invalidateLayout()
        
        flowLayout.minimumLineSpacing = Constants.lineSpacing
        itemWidth = (collectionView.frame.width - Constants.lineSpacing - (6 * Constants.lineSpacing)) / 7
        
        let edgeInsets = UIEdgeInsets(top: 0, left: Constants.lineSpacing / 2, bottom: 0, right: Constants.lineSpacing / 2)
        flowLayout.sectionInset = edgeInsets
        
        selectedCollectionIndexPath = IndexPath(item: day + firstDayIndexOffset, section: 0)
    }
    
    private func scrollToCurrentDay() {
        let currentDayIndex = day + firstDayIndexOffset
        let weekday = Utils.getWeekDay()
        let currentWeekMidDayIndex = currentDayIndex + (4 - weekday)
        let indexPath = IndexPath(item: currentWeekMidDayIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        markCurrentTime()
    }
    
    private func markCurrentTime() {
        let hours = Utils.getHours()
        selectedTableIndexPath = IndexPath(row: hours, section: 0)
        tableView.reloadData()
        tableView.scrollToRow(at: selectedTableIndexPath, at: .middle, animated: true)
    }
    
    private func reloadData() {
        markCurrentTime()
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Constants.daysPerWeek * 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.dateCell, for: indexPath) as! DateCellView
        
        if indexPath.item >= 0 && indexPath.item <= firstDayIndexOffset {
            cell.dateLabel.text = "\((previousMonthDays - firstDayIndexOffset) + indexPath.item)"
        } else if indexPath.item > (currentMonthDays + firstDayIndexOffset) {
            cell.dateLabel.text = "\(indexPath.row - (currentMonthDays + firstDayIndexOffset))"
        } else {
            cell.dateLabel.text = "\(indexPath.row - firstDayIndexOffset)"
        }

        if indexPath == selectedCollectionIndexPath || (indexPath.item % 7) == (selectedCollectionIndexPath.item % 7) {
            selectedCollectionIndexPath = indexPath
            if day == indexPath.item - firstDayIndexOffset {
                cell.backgroundColor = .red
                cell.dateLabel.textColor = .white
                // show marker
                displayCurrentTimeMarker()
            } else {
                cell.backgroundColor = .white
                cell.dateLabel.textColor = .black
                // hide marker
                hideCurrentTimeMarker()
            }
            updateMonthLabel(indexPath: indexPath)
        } else {
            if day == indexPath.item - firstDayIndexOffset {
                cell.dateLabel.textColor = .red
            } else {
                cell.backgroundColor = .clear
                cell.dateLabel.textColor = .white
            }
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? DateCellView else { return }
        
        deSelectCurrentCell()
        selectedCollectionIndexPath = indexPath
        
        if day == indexPath.item - firstDayIndexOffset {
            cell.backgroundColor = .red
            cell.dateLabel.textColor = .white
            // If its today, display marker
            displayCurrentTimeMarker()
        } else {
            cell.backgroundColor = .white
            cell.dateLabel.textColor = .black
            hideCurrentTimeMarker()
        }
        
        updateMonthLabel(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? DateCellView else { return }
        cell.backgroundColor = .clear
        cell.dateLabel.textColor = .white
    }
    
    private func updateMonthLabel(indexPath: IndexPath) {
        if indexPath.item <= firstDayIndexOffset {
            titleLabel.text = Utils.getMonthString(month: currentMonth - 1)
        } else if indexPath.item > firstDayIndexOffset && indexPath.item <= (currentMonthDays + firstDayIndexOffset) {
            titleLabel.text = Utils.getMonthString(month: currentMonth)
        } else {
            titleLabel.text = Utils.getMonthString(month: currentMonth + 1)
        }
    }
    
    private func deSelectCurrentCell() {
        guard let cell = collectionView.cellForItem(at: selectedCollectionIndexPath) as? DateCellView else { return }
        
        if day == selectedCollectionIndexPath.item - firstDayIndexOffset {
            cell.backgroundColor = .clear
            cell.dateLabel.textColor = .red
        } else {
            cell.backgroundColor = .clear
            cell.dateLabel.textColor = .white
        }
    }
    
    private func displayCurrentTimeMarker() {
        reloadData()
    }
    
    private func hideCurrentTimeMarker() {
        selectedTableIndexPath = IndexPath(item: 100, section: 0)
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.hours12 * 2 + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.hourTableCell, for: indexPath) as! HourTableCell
        
        if indexPath.row == 0 || indexPath.row == Constants.hours12 * 2 {
            cell.timeLabel.text = "12 AM"
        } else if indexPath.row == Constants.hours12 {
            cell.timeLabel.text = "12 PM"
        } else if indexPath.row < Constants.hours12  {
            cell.timeLabel.text = "\(indexPath.row) AM"
        } else {
            cell.timeLabel.text = "\(indexPath.row - Constants.hours12) PM"
        }
        
        if indexPath == selectedTableIndexPath {
            cell.showCurrentTimeMark()
        } else {
            cell.hideCurrentTimeMark()
        }
        
        let minutes = Utils.getMinutes()
        
        if minutes >= 53 && indexPath.row == selectedTableIndexPath.row + 1 {
            cell.timeLabel.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.cellHeight
    }
}
