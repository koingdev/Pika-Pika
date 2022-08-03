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
    
    
    deinit {
        debugPrint("DEINIT: \(Self.self)")
    }
    
    
    ////////////////////////////////////////////////////////////////
    //MARK: - UI Components
    ////////////////////////////////////////////////////////////////

    
    private lazy var brandingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "PikaPika")
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(44)
        }
        return imageView
    }()
    
    private let refreshControl = UIRefreshControl()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(FeedTableViewCell.self, forCellReuseIdentifier: "\(FeedTableViewCell.self)")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.separatorInset = .zero
        tableView.allowsSelection = false
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(brandingImageView.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        tableView.refreshControl = refreshControl
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        _ = brandingImageView
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        fetch()
    }
    

    func addNewFeed(feed: Feed) {
        // Insert to tableView first for performance
        datasource.insert(feed, at: 0)
        tableView.performBatchUpdates {
            tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
        }

        // Upload to Server
        Task.detached {
            let result = await self.viewModel.post(feed: feed)
            Task { @MainActor in
                switch result {
                case .success(let feed):
                    // new feed contains auto-id and imageURL from Server
                    self.datasource[0] = feed
                case .failure(let error):
                    UIAlertController.errorAlert(message: error.localizedDescription)
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
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    
    private func delete(feed: Feed, indexPath: IndexPath) {
        guard feed.belongsToCurrentUser else {
            return
        }
        UIAlertController.deleteConfirmation { [self] _ in
            // Remove from tableView first
            datasource.remove(at: indexPath.row)
            tableView.performBatchUpdates {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            // Delete from Server
            Task.detached {
                let result = await self.viewModel.delete(feed: feed)
                if case let .failure(error) = result {
                    Task { @MainActor in
                        UIAlertController.errorAlert(message: error.localizedDescription)
                    }
                }
            }
        }
    }
    
    
    @objc private func didPullToRefresh() {
        fetch()
    }
    
}


////////////////////////////////////////////////////////////////
//MARK: - Datasource
////////////////////////////////////////////////////////////////


extension TimelineViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(FeedTableViewCell.self)", for: indexPath) as? FeedTableViewCell,
              let feed = datasource[safe: indexPath.row] else { return UITableViewCell() }

        cell.configure(feed: feed)
        cell.didTappedThreedot = { [weak self] selectedCell in
            // Get the current selectedIndexPath from tableView.indexPath(for:)
            // Because insertRows(at:) and deleteRows(at:) don't refresh the whole cells
            guard let self = self, let selectedIndexPath = tableView.indexPath(for: selectedCell) else { return }
            TimelineRouter.showPopover(belongsToCurrentUser: feed.belongsToCurrentUser, sourceVC: self, sourceView: cell.threeDotsButton) { menu in
                switch menu.title {
                case ThreedotMenu.Delete.rawValue:
                    guard let feed = self.datasource[safe: selectedIndexPath.row] else { return }
                    self.delete(feed: feed, indexPath: selectedIndexPath)
                default:
                    break
                }
            }
        }
        return cell
    }
}


////////////////////////////////////////////////////////////////
//MARK: - PopoverDelegate
////////////////////////////////////////////////////////////////

extension TimelineViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        .none
    }
}
