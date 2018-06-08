//
//  QuestionListCell.swift
//  Mobile_iQuest
//
//  Created by Dhanalakshmi on 22/03/18.
//  Copyright © 2018 IBM. All rights reserved.
//

import UIKit

public protocol QuestionCellDelegate {
    func tableViewDidSelect( indexPath: Int)
}

public class MQQuestionListCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak  public var tableView: UITableView?
    public let cellIdentifier: String = "tableCell"
    public var questionList = [Any]()
    public var delegate: QuestionCellDelegate?
    
    let nibName = "MQQuestionListCell"
    var tableContentView: UIView!
    
    @IBOutlet weak var questionLable: UILabel!
    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
       
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        tableView?.layer.cornerRadius = 1.0
        tableView?.backgroundColor = UIColor(white: 0.90, alpha: 1)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView?.reloadData()
     
    }

    //MARK:- Table view datasource and delegates
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: cellIdentifier)
        cell.textLabel?.font = UIFont.init(name: "Avenir", size: 16.0)
        cell.textLabel?.text = questionList[indexPath.row] as? String
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        return cell
    }
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let titleLable = UILabel()
        titleLable.font = UIFont.init(name: "Avenir", size: 18.0)
        titleLable.text = "Related Questions"
        return titleLable.text
    }
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.tableViewDidSelect( indexPath: indexPath.row)
    }
    
}



