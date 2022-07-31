//
//  PopoverViewController.swift
//  Pika Pika
//
//  Created by KoingDev on 31/7/22.
//

import UIKit
import SnapKit

struct PopoverModel {
    let title: String
    let tintColor: UIColor
}

final class PopoverViewController: UIViewController {
    
    private var datasource: [PopoverModel] = []
    var didSelectRow: ((PopoverModel) -> Void)?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsMultipleSelection = false
        tableView.rowHeight = 44
        tableView.separatorInset = .zero
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        return tableView
    }()
    
    init(datasource: [PopoverModel], sourceView: UIView) {
        self.datasource = datasource
        super.init(nibName: nil, bundle: nil)
        // Set up
        modalPresentationStyle = .popover
        popoverPresentationController?.sourceView = sourceView
        popoverPresentationController?.sourceRect = sourceView.bounds
        popoverPresentationController?.permittedArrowDirections = []
        preferredContentSize = CGSize(width: 120, height: Int(tableView.rowHeight) * datasource.count)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async { [self] in
            tableView.reloadData()
        }
    }
    
}

extension PopoverViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        guard let data = datasource[safe: indexPath.row] else { return cell }
        cell.textLabel?.text = data.title
        cell.textLabel?.textColor = data.tintColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let data = datasource[safe: indexPath.row]
        {
            didSelectRow?(data)
        }
        dismiss(animated: true)
    }
}
