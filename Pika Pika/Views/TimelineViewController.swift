//
//  TimelineViewController.swift
//  Pika Pika
//
//  Created by KoingDev on 30/7/22.
//

import Foundation
import UIKit
import SnapKit

final class TimelineViewController: UIViewController {
    
    private var datasource: [Feed] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private let viewModel = TimelineViewModel()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        Task {
            datasource = await viewModel.fetch()
        }
    }
    
    // TODO
    func addNewFeed(description: String) {
        if let uid = FirebaseAuthService.currentUser?.uid {
            let feed = Feed.make(description: description, uid: uid)
            datasource.append(feed)
            Task {
                await viewModel.post(feed: feed)
            }
        }
    }
    
}

extension TimelineViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        let feed = datasource[indexPath.row]
        cell.textLabel?.text = feed.description
        return cell
    }
}
