//
//  WrapperCell.swift
//  SwiftUIAPIForUICollectionView
//
//  Created by Zihan Qi on 3/29/20.
//  Copyright © 2020 Zihan Qi. All rights reserved.
//

import UIKit
import SwiftUI

class WrapperCell<Content>: UICollectionViewCell where Content : View {
    var cellContentController: UIHostingController<Content>!
    var layoutContraints: [NSLayoutConstraint]?
    
    /// Sets the cell's view content.
    /// - Parameter content: The SwiftUI View that the cell needs to display.
    func setContent(_ content: Content) {
        self.cellContentController = UIHostingController(rootView: content)
        let cellContentView = cellContentController.view!
        // Removes all current subviews
        self.contentView.subviews.forEach { $0.removeFromSuperview() }
        // Adds the cell content as a subview
        self.contentView.addSubview(cellContentView)
        // FIXME: This should respect .background() modifier if it exists
        self.contentView.backgroundColor = .systemBackground
        
        // FIXME:
        self.contentView.layer.borderColor = UIColor.black.cgColor
        self.contentView.layer.borderWidth = 1
        
        // Pin all four edges of the cell content view
        cellContentView.translatesAutoresizingMaskIntoConstraints = false
        if let constraints = self.layoutContraints {
            NSLayoutConstraint.deactivate(constraints)
        }
        layoutContraints = [
            cellContentView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            cellContentView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        NSLayoutConstraint.activate(layoutContraints!)
        setNeedsLayout()
    }
}

let kWrapperCellReuseIdentifier = "wrapper-cell-reuse-identifier"
