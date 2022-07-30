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
    
    private var datasource: [Feed] = []
    
    private let viewModel = TimelineViewModel()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.allowsSelection = false
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
        fetch()
    }
    

    func addNewFeed(description: String) {
        if let uid = FirebaseAuthService.currentUser?.uid {
            let feed = Feed.make(description: description, uid: uid)
            datasource.insert(feed, at: 0)
            tableView.performBatchUpdates {
                tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
            }
            Task.detached {
                let result = await self.viewModel.post(feed: feed)
                if case let .failure(error) = result {
                    Task { @MainActor in
                        UIAlertController.errorAlert(message: error.localizedDescription)
                    }
                }
            }
        }
    }
    
    
    
    ////////////////////////////////////////////////////////////////
    //MARK: - Private
    ////////////////////////////////////////////////////////////////

    private func fetch() {
        Task.detached { [self] in
            let result = await self.viewModel.fetch()
            Task { @MainActor in
                self.datasource = result
                self.tableView.reloadData()
            }
        }
    }
    
}


////////////////////////////////////////////////////////////////
//MARK: - Datasource
////////////////////////////////////////////////////////////////


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
