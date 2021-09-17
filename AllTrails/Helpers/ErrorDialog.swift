//
//  ErrorDialog.swift
//  ErrorDialog
//
//  Created by Arun Kumar on 9/15/21.
//

import UIKit

/// Utility for custom error alerts
struct ErrorDialogHelper {
    static func displayError(parent: UIViewController, title: String, message: String, buttonTitle: String) {
                let alert = UIAlertController(title: title, message:message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: nil))

                parent.present(alert, animated: true)
    }
    
    static func displayNetworkFailureError(parent: UIViewController) {
        ErrorDialogHelper.displayError(parent: parent, title: l10n.Error.networkFailedTitle, message: l10n.Error.networkFailedMessage, buttonTitle: l10n.General.okText)
    }
    
    static func presentNoLocationFoundAlert() -> UIAlertController {
        let alert = UIAlertController(title: l10n.Alert.Stores.noStoresTitle, message: l10n.Alert.Stores.noStoresMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: l10n.General.okText, style: .default, handler: { action in
            // We can decide on custom actions on these buttons
        }))
        
        return alert
    }
}
