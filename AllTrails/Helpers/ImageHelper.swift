//
//  ImageHelper.swift
//  ImageHelper
//
//  Created by Arun Kumar on 9/14/21.
//

import UIKit

public struct ImageHelper {
    
    // MARK: - Helpers
    /// Fetch an image  at the given URL
    /// - Parameters:
    ///   - url: The location of the image data
    ///   - callback: The completion handler when an image is found or nil
    public static func fetchImage(from url: URL, callback: @escaping (UIImage?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            
            DispatchQueue.main.async { /// execute on main thread
                callback(UIImage(data: data))
            }
        }
        task.resume()
    }
}
