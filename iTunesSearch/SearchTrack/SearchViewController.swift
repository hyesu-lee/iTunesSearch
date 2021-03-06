//
//  SearchViewController.swift
//  iTunesSearch
//
//  Created by 이혜수 on 2022/07/04.
//

import AVKit
import UIKit

import ReactorKit
import RxCocoa
import SnapKit

final class SearchViewController: UIViewController, View {

    // MARK: Stored Properties

    let searchController = UISearchController(searchResultsController: nil).then {
        $0.searchBar.placeholder = "곡 제목이나 아티스트로 검색하기"
    }

    let tableView = UITableView().then {
        $0.register(TrackTableViewCell.self, forCellReuseIdentifier: TrackTableViewCell.identifier)
        $0.rowHeight = 70
    }

    let activityIndicatorView = UIActivityIndicatorView(style: .large)

    var disposeBag = DisposeBag()


    // MARK: Initializer

    init(reactor: SearchViewReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
    }


    // MARK: Private Methods

    private func configureUI() {
        self.navigationController?.navigationBar.prefersLargeTitles = true

        self.navigationItem.do {
            $0.title = "iTunes Search"
            $0.hidesSearchBarWhenScrolling = false
            $0.searchController = self.searchController
        }

        self.view.do {
            $0.addSubview(self.tableView)
            $0.addSubview(self.activityIndicatorView)
        }

        self.setupConstraints()
    }

    private func setupConstraints() {
        self.tableView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing)
            $0.bottom.equalTo(self.view.snp.bottom)
        }

        self.activityIndicatorView.snp.makeConstraints {
            $0.center.equalTo(self.tableView.snp.center)
        }
    }


    // MARK: Binding

    func bind(reactor: SearchViewReactor) {
        self.searchController.searchBar.rx.searchButtonClicked
            .map { [weak self] in
                let query = self?.searchController.searchBar.text
                return Reactor.Action.updateQuery(query)
            }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)

        self.searchController.searchBar.rx.cancelButtonClicked
            .map { Reactor.Action.updateQuery(nil) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)

        self.tableView.rx.itemSelected
            .map { Reactor.Action.trackSelected($0) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)

        reactor.state
            .map { $0.tracks }
            .bind(to: self.tableView.rx.items(cellIdentifier: TrackTableViewCell.identifier, cellType: TrackTableViewCell.self)) { row, track, cell in
                cell.nameLabel.text = track.name
                cell.artistLabel.text = track.artist
            }
            .disposed(by: self.disposeBag)

        reactor.state
            .map { $0.isLoading }
            .bind(to: self.activityIndicatorView.rx.isAnimating)
            .disposed(by: self.disposeBag)

        reactor.state
            .compactMap { $0.audioURL }
            .subscribe(onNext: { [weak self] url in
                let player = AVPlayer(url: url)
                let avPlayerViewController = AVPlayerViewController().then {
                    $0.player = player
                }
                self?.present(avPlayerViewController, animated: true)
                player.play()
            })
            .disposed(by: self.disposeBag)
    }
}
