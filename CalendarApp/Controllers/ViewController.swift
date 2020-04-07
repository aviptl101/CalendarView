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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = Constants.april
        setCollectionView()
        tableView.allowsSelection = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
    }
    
    func setCollectionView() {
        flowLayout.invalidateLayout()
        
        flowLayout.minimumLineSpacing = Constants.lineSpacing
        itemWidth = (collectionView.frame.width - Constants.lineSpacing - (6 * Constants.lineSpacing)) / 7
        
        let edgeInsets = UIEdgeInsets(top: 0, left: Constants.lineSpacing / 2, bottom: 0, right: Constants.lineSpacing / 2)
        flowLayout.sectionInset = edgeInsets
        
        let indexPath = IndexPath(item: 3, section: 0)
        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .right)
    }
    
    func markCurrentTime() {
        let hours = Utils.getHours()
        selectedTableIndexPath = IndexPath(row: hours, section: 0)
        tableView.reloadData()
        tableView.scrollToRow(at: selectedTableIndexPath, at: .middle, animated: true)
    }
    
    func reloadData() {
        markCurrentTime()
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Constants.daysPerWeek * 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.dateCell, for: indexPath) as! DateCellView
        
        if indexPath.item >= 0 && indexPath.item <= 2 {
            cell.dateLabel.text = "\(29 + indexPath.item)"
        } else if indexPath.item > 32 {
            cell.dateLabel.text = "\(indexPath.row - 32)"
        } else {
            cell.dateLabel.text = "\(indexPath.row - 2)"
        }
        
        let day = Utils.getDay()

        if indexPath == selectedCollectionIndexPath {
            if day == indexPath.item - 2 {
                cell.backgroundColor = .red
                cell.dateLabel.textColor = .white
            } else {
                cell.backgroundColor = .white
                cell.dateLabel.textColor = .black
            }
        } else {
            if day == indexPath.item - 2 {
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
        let day = Utils.getDay()
        
        if day == indexPath.item - 2 {
            cell.backgroundColor = .red
            cell.dateLabel.textColor = .white
            // If its today, display marker
            selectedTableIndexPath = indexPath
            reloadData()
        } else {
            cell.backgroundColor = .white
            cell.dateLabel.textColor = .black
            selectedTableIndexPath = IndexPath(item: 100, section: 0)
            tableView.reloadData()
        }
        
        if indexPath.item <= 2 {
            titleLabel.text = Constants.march
        } else if indexPath.item > 2 && indexPath.item <= 32 {
            titleLabel.text = Constants.april
        } else {
            titleLabel.text = Constants.may
        }
        selectedCollectionIndexPath = indexPath
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? DateCellView else { return }
        cell.backgroundColor = .clear
        cell.dateLabel.textColor = .white
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 25
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.hourTableCell, for: indexPath) as! HourTableCell
        
        if indexPath.row == 0 || indexPath.row == 24 {
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
