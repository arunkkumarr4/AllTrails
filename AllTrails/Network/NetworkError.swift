//
//  NetworkError.swift
//  NetworkError
//
//  Created by Arun Kumar on 9/16/21.
//

import Foundation

// MARK: - NetworkError
enum NetworkError: Error {
    case cannotProcessData
    case urlNotFound
    case internetOffline
}
