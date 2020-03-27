//
//  TemporaryCell.swift
//  SwiftUIAPIForUICollectionView
//
//  Created by Zihan Qi on 3/26/20.
//  Copyright © 2020 Zihan Qi. All rights reserved.
//

import UIKit

class TemporaryCell: UICollectionViewCell {
    let label = UILabel()
    static let reuseIdentifier = "temporary-cell-reuse-identifier"

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure(using: "Default")
    }
    required init?(coder: NSCoder) {
        fatalError("not implemnted")
    }
}

extension TemporaryCell {
    func configure(using text: String) {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .center
        label.text = text
        contentView.addSubview(label)
        contentView.backgroundColor = .systemTeal
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        let inset = CGFloat(10)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset)
        ])
    }
}
