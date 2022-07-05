//
//  SongTableViewCell.swift
//  iTunesSearch
//
//  Created by 이혜수 on 2022/07/04.
//

import UIKit

final class SongTableViewCell: UITableViewCell {

    // MARK: Cell Identifier

    static let identifier = "SongTableViewCell"


    // MARK: Namespace

    enum Padding {
        static let horizontal: CGFloat = 20
        static let vertical: CGFloat = 10
    }


    // MARK: UI Properties

    let nameLabel = UILabel().then {
        $0.font = .preferredFont(forTextStyle: .headline)
    }

    let artistLabel = UILabel().then {
        $0.font = .preferredFont(forTextStyle: .body)
    }


    // MARK: Initializer

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: Private Methods

    private func configureUI() {
        self.selectionStyle = .none
        
        self.addSubview(self.nameLabel)
        self.addSubview(self.artistLabel)

        self.nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Padding.vertical)
            $0.leading.equalToSuperview().offset(Padding.horizontal)
            $0.trailing.equalToSuperview().offset(-Padding.horizontal)
        }

        self.artistLabel.snp.makeConstraints {
            $0.top.equalTo(self.nameLabel.snp.bottom).offset(Padding.vertical)
            $0.leading.equalTo(self.nameLabel.snp.leading)
            $0.trailing.equalTo(self.nameLabel.snp.trailing)
        }
    }
}
