//
//  ViewRounding.swift
//  ViewRounding
//
//  Created by Arun Kumar on 9/16/21.
//

import UIKit

// Utility to customize view
struct ViewRounding {
    static func customizeView(for containerView: UIView) {
        // corner radius
        containerView.layer.cornerRadius = 10

        // border
        containerView.layer.borderWidth = 1.0
        containerView.layer.borderColor = UIColor.lightGray.cgColor

        // shadow
        containerView.layer.shadowColor = UIColor.lightGray.cgColor
        containerView.layer.shadowOffset = CGSize(width: 3, height: 3)
        containerView.layer.shadowOpacity = 0.7
        containerView.layer.shadowRadius = 4.0
    }
}
