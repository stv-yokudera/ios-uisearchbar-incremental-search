//
//  DataSource.swift
//  ios-uisearchbar-incremental-search
//
//  Created by OkuderaYuki on 2018/04/29.
//  Copyright © 2018年 OkuderaYuki. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

final class DataSource: NSObject, UITableViewDataSource, RxTableViewDataSourceType {

    typealias Element = [String]

    private var items: Element = []

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: SearchResultCell.identifier,
            for: indexPath) as! SearchResultCell
        
        cell.resultLabel.text = "\(items[indexPath.row])"

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, observedEvent: Event<Element>) {

        Binder(self) { (dataSource, items) in
            if dataSource.items == items {
                return
            }
            dataSource.items = items
            tableView.reloadData()
            }
            .on(observedEvent)
    }
}
