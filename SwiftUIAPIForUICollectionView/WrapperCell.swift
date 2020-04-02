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
    var cellContentController: UIHostingController<Group<Content>>!
    var layoutContraints: [NSLayoutConstraint]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Sets the cell's view content.
    /// - Parameter content: The SwiftUI View that the cell needs to display.
    func setContent(_ content: Content) {
        // wraps the content inside of a `Group` so that content behaves correctly
        self.cellContentController = UIHostingController(rootView: Group { content })
        let groupWrapperView = cellContentController.view!
        // Removes all current subviews
        self.contentView.subviews.forEach { $0.removeFromSuperview() }
        // Adds the cell content as a subview
        self.contentView.addSubview(groupWrapperView)
        
        // FIXME: Should respect .background() modifier if exists.
        self.contentView.backgroundColor = .systemBackground
        
        // Pin all four edges of the group wrapper view
        groupWrapperView.translatesAutoresizingMaskIntoConstraints = false
        if let constraints = self.layoutContraints {
            NSLayoutConstraint.deactivate(constraints)
        }
        layoutContraints = [
            groupWrapperView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            groupWrapperView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            groupWrapperView.topAnchor.constraint(equalTo: contentView.topAnchor),
            groupWrapperView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            // FIXME: Debugging only
            //            groupWrapperView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            //            groupWrapperView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ]
        NSLayoutConstraint.activate(layoutContraints!)
        setNeedsLayout()
        
        // FIXME: Debugging only
        //        self.contentView.layer.borderColor = UIColor.black.cgColor
        //        self.contentView.layer.borderWidth = 1
        //        groupWrapperView.backgroundColor = .red
    }
}

let kWrapperCellReuseIdentifier = "wrapper-cell-reuse-identifier"
