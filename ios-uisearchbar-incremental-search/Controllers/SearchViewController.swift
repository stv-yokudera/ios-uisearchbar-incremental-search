//
//  ViewController.swift
//  ios-uisearchbar-incremental-search
//
//  Created by OkuderaYuki on 2018/04/29.
//  Copyright © 2018年 OkuderaYuki. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

final class SearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            let nib = UINib(nibName: SearchResultCell.identifier, bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: SearchResultCell.identifier)
        }
    }

    private let item = Resource.suggest
    private let dataSource = DataSource()
    private let disposeBag = DisposeBag()

    private var incrementalText: Driver<String> {
        return rx
            .methodInvoked(#selector(UISearchBarDelegate.searchBar(_:shouldChangeTextIn:replacementText:)))
            .debounce(0.3, scheduler: MainScheduler.instance).flatMap { [weak self] _ -> Observable<String> in
                .just(self?.searchBar.text ?? "")
            }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: "")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    private func setup() {

        incrementalText
            .flatMap { [weak self] text -> Driver<[String]> in
                guard let weakSelf = self else {
                    return .just([])
                }
                return .just(weakSelf.item.filter {
                    $0.contains(text)
                })
            }
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

extension SearchViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar,
                   shouldChangeTextIn range: NSRange,
                   replacementText text: String) -> Bool {
        return true
    }
}
