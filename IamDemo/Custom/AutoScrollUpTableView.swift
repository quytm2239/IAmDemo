//
//  CustomTableView.swift
//  IamDemo
//
//  Created by Trần Mạnh Quý on 10/1/20.
//

import UIKit

class AutoScrollUpTableView: UITableView {

    private var currentItem: Int = 0

    override func reloadData() {
        super.reloadData()
        guard currentItem > 0 else { return }
        self.scrollToRow(
            at: IndexPath(row: currentItem - 1, section: 0),
            at: .top,
            animated: true
        )
    }

    func setCurrentItem(_ item: Int) {
        self.currentItem = item
    }
}
