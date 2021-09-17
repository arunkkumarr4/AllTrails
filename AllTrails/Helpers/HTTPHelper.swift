//
//  HTTPHelper.swift
//  HTTPHelper
//
//  Created by Arun Kumar on 9/16/21.
//

import Foundation



struct HTTPHelper {
    /**
     Returns `true` for responses whose codes _ARE_  in [200 299]. Therefore, this will report
     `true` for informational, redirection, client error, and server errors.
     */
    public static func isSuccess(_ httpResponse: HTTPURLResponse) -> Bool {
        return (200...299).contains(httpResponse.statusCode)
    }
}
