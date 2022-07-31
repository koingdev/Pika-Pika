//
//  TimelineRouter.swift
//  Pika Pika
//
//  Created by KoingDev on 31/7/22.
//

import Foundation
import UIKit

struct TimelineRouter {
    static func showPopover(
        belongsToCurrentUser: Bool,
        sourceVC: UIViewController?,
        sourceView: UIView,
        didSelectRow: @escaping (PopoverModel) -> Void
    ) {
        guard let sourceVC = sourceVC else {
            return
        }
        let deleteMenu = PopoverModel(title: ThreedotMenu.Delete.rawValue, tintColor: .red)
        let shareMenu = PopoverModel(title: ThreedotMenu.Share.rawValue, tintColor: .label)
        let datasource = belongsToCurrentUser ? [deleteMenu, shareMenu] : [shareMenu]
        let vc = PopoverViewController(datasource: datasource, sourceView: sourceView)
        vc.popoverPresentationController?.delegate = sourceVC as? UIPopoverPresentationControllerDelegate
        vc.didSelectRow = { row in
            didSelectRow(row)
        }
        sourceVC.present(vc, animated: true)
    }
}
