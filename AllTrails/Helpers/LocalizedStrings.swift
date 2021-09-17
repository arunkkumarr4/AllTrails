//
//  LocalizedStrings.swift
//  LocalizedStrings
//
//  Created by Arun Kumar on 9/15/21.
//

import Foundation

import Foundation

typealias l10n = LocalizedString
public enum LocalizedString {
    enum General {
        static let okText = NSLocalizedString("General.okText",
                                              tableName: nil,
                                              bundle: .main,
                                              value: "OK",
                                              comment: "describing the word OK")
        
        static let enableText = NSLocalizedString("General.enableText",
                                              tableName: nil,
                                              bundle: .main,
                                              value: "Enable",
                                              comment: "describing the word Enable")
        
        static let cancelText = NSLocalizedString("General.cancelText",
                                              tableName: nil,
                                              bundle: .main,
                                              value: "Cancel",
                                              comment: "describing the word Cancel")
        
        static let searchPlaceholder = NSLocalizedString("General.searchPlaceholder",
                                              tableName: nil,
                                              bundle: .main,
                                              value: "Search Restaurant",
                                              comment: "placeholder for search field")
    }
    
    enum Error {
        static let networkFailedTitle = NSLocalizedString("Error.networkFailedTitle",
                                                          tableName: nil,
                                                          bundle: .main,
                                                          value: "Network Failed",
                                                          comment: "title describing the network failed")
        
        static let networkFailedMessage = NSLocalizedString("Error.networkFailedMessage",
                                                            tableName: nil,
                                                            bundle: .main,
                                                            value: "Please check your network and try again.",
                                                            comment: "message asking the user to check their network and try the operation again")
    }
    
    enum Alert {
        enum Permissions {
            static let locationRequestTitle = NSLocalizedString("Alert.Permissions.locationRequestTitle",
                                                  tableName: nil,
                                                  bundle: .main,
                                                  value: "We need your location",
                                                  comment: "communicating to the user that their location is needed")
            
            static let locationRequestMessage = NSLocalizedString("Alert.Permissions.locationRequestMessage",
                                                  tableName: nil,
                                                  bundle: .main,
                                                  value: "We use this to show you nearby stores.",
                                                  comment: "describing to the user why their location is needed")
        }
        
        enum Stores {
            static let noStoresTitle = NSLocalizedString("Alert.Stores.noStoresTitle",
                                                  tableName: nil,
                                                  bundle: .main,
                                                  value: "No Stores Found",
                                                  comment: "describing that there are no store found")
            
            static let noStoresMessage = NSLocalizedString("Alert.Stores.noStoresMessage",
                                                  tableName: nil,
                                                  bundle: .main,
                                                  value: "Looks like no stores match your search. Please try again.",
                                                  comment: "describing that there are no stores matching input and to try the input again")
        }
    }
}
