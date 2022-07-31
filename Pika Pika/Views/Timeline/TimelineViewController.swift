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
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        fetch()
    }
    

    func addNewFeed(description: String) {
        if let uid = FirebaseAuthService.currentUser?.uid,
           let fullname = AuthenticationViewModel.loggedInUser?.fullname {
            // Insert to tableView first for performance
            let feed = Feed.make(description: description, uid: uid, fullname: fullname)
            datasource.insert(feed, at: 0)
            tableView.performBatchUpdates {
                tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
            }

            // Upload to Server
            Task.detached {
                let result = await self.viewModel.post(feed: feed)
                Task { @MainActor in
                    switch result {
                    case .success(let id):
                        // Update auto-id
                        self.datasource[0].id = id
                    case .failure(let error):
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
    
}


////////////////////////////////////////////////////////////////
//MARK: - Datasource
////////////////////////////////////////////////////////////////


extension TimelineViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(FeedTableViewCell.self)", for: indexPath) as? FeedTableViewCell else { return UITableViewCell() }
        let feed = datasource[indexPath.row]
        cell.configure(feed: feed)
        cell.didTappedThreedot = { [weak self] in
            TimelineRouter.showPopover(belongsToCurrentUser: feed.belongsToCurrentUser, sourceVC: self, sourceView: cell.threeDotsButton) { menu in
                switch menu.title {
                case ThreedotMenu.Delete.rawValue:
                    self?.delete(feed: feed, indexPath: indexPath)
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
