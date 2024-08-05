//
//  SecondView.swift
//  iconfinder
//
//  Created by Vermut xxx on 05.08.2024.
//

import UIKit

final class SecondView: UIView {
    
    private enum ViewMetrics {
        static let layoutMargins = UIEdgeInsets(top: .zero, left: 16, bottom: .zero, right: 16)
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.layoutMargins = ViewMetrics.layoutMargins
        tableView.contentInsetAdjustmentBehavior = .automatic
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    var tableViewDelegate: UITableViewDelegate? {
        didSet {
            tableView.delegate = tableViewDelegate
        }
    }
    
    var tableViewDataSource: UITableViewDataSource? {
        didSet {
            tableView.dataSource = tableViewDataSource
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    private func setupLayout() {
        backgroundColor = .white
        addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
