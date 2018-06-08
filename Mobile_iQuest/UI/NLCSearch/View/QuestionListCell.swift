//
//  QuestionListCell.swift
//  Mobile_iQuest
//
//  Created by Dhanalakshmi on 22/03/18.
//  Copyright © 2018 IBM. All rights reserved.
//

import UIKit

protocol QuestionCellDelegate {
    func tableViewDidSelect( indexPath: Int)
}

class QuestionListCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var tableView: UITableView!
    let cellIdentifier: String = "tableCell"
    var questionList = [Any]()
    var delegate: QuestionCellDelegate?
    
    @IBOutlet weak var questionLable: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tableView.layer.cornerRadius = 1.0
        tableView.backgroundColor = UIColor(white: 0.90, alpha: 1)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.reloadData()
    }
    //MARK:- Table view datasource and delegates
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: cellIdentifier)
        cell.textLabel?.font = UIFont.init(name: "Avenir", size: 16.0)
        cell.textLabel?.text = questionList[indexPath.row] as? String
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let titleLable = UILabel()
        titleLable.font = UIFont.init(name: "Avenir", size: 18.0)
        titleLable.text = "Related Questions"
        return titleLable.text
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.tableViewDidSelect( indexPath: indexPath.row)
    }
    
}



