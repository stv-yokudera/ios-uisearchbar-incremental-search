//
//  SearchResultCell.swift
//  ios-uisearchbar-incremental-search
//
//  Created by OkuderaYuki on 2018/04/29.
//  Copyright © 2018年 OkuderaYuki. All rights reserved.
//

import UIKit

final class SearchResultCell: UITableViewCell {

    static var identifier: String {
        return String(describing: self)
    }

    @IBOutlet weak var resultLabel: UILabel!
}
