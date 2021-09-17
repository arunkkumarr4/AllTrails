//
//  Activity.swift
//  Activity
//
//  Created by Arun Kumar on 9/15/21.
//

import UIKit

// MARK: - Activity
/// Utility for custom activity indicator
public struct Activity {
    static let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    static let loadingView: UIView = UIView()
    static let container: UIView = UIView()
    
    /// Show activity indicator within the view passed
    public static func showActivityIndicatory(view: UIView) {
        container.frame = view.frame
        container.center = view.center
        container.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = view.center
        loadingView.backgroundColor = UIColor.gray.withAlphaComponent(00.3)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        activityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0);
        activityIndicator.style =
        UIActivityIndicatorView.Style.medium
        activityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2,
                                y: loadingView.frame.size.height / 2);
        loadingView.addSubview(activityIndicator)
        container.addSubview(loadingView)
        view.addSubview(container)
        activityIndicator.startAnimating()
    }
    /// Stop the activity indicator
    public static func stopActivityIndicatory() {
        activityIndicator.removeFromSuperview()
        loadingView.removeFromSuperview()
        container.removeFromSuperview()
        activityIndicator.stopAnimating()
    }
}

