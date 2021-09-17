//
//  ReviewStarsHelper.swift
//  ReviewStarsHelper
//
//  Created by Arun Kumar on 9/16/21.
//

import Foundation
import UIKit

// MARK: - ReviewStarsHelper
// TODO: - Can be improved with switch statement or implementing `GKStateMachine`
struct ReviewStarsHelper {
    static func setUpReviewStars(for rating: Float,
                                 ratingStar1: UIImageView,
                                 ratingStar2: UIImageView,
                                 ratingStar3: UIImageView,
                                 ratingStar4: UIImageView,
                                 ratingStar5: UIImageView) {
        if rating > 1 && rating < 2 {
            ratingStar1.image = UIImage(systemName: "star.fill")?.withTintColor(.orange, renderingMode: .alwaysOriginal)
            ratingStar2.image = UIImage(systemName: "star.leadinghalf.filled")?.withTintColor(.orange, renderingMode: .alwaysOriginal)
            
        } else if rating > 2 && rating < 3 {
            [ratingStar1, ratingStar2].forEach {
                $0?.image = UIImage(systemName: "star.fill")?.withTintColor(.orange, renderingMode: .alwaysOriginal)
            }
            ratingStar3.image = UIImage(systemName: "star.leadinghalf.filled")?.withTintColor(.orange, renderingMode: .alwaysOriginal)
        } else if rating > 3 && rating < 4 {
            [ratingStar1, ratingStar2, ratingStar3].forEach {
                $0?.image = UIImage(systemName: "star.fill")?.withTintColor(.orange, renderingMode: .alwaysOriginal)
            }
            ratingStar4.image = UIImage(systemName: "star.leadinghalf.filled")?.withTintColor(.orange, renderingMode: .alwaysOriginal)
        } else if rating > 4 && rating < 5 {
            [ratingStar1, ratingStar2, ratingStar3, ratingStar4].forEach {
                $0?.image = UIImage(systemName: "star.fill")?.withTintColor(.orange, renderingMode: .alwaysOriginal)
            }
            ratingStar5.image = UIImage(systemName: "star.leadinghalf.filled")?.withTintColor(.orange, renderingMode: .alwaysOriginal)
        } else if rating == 1 {
            ratingStar1.image = UIImage(systemName: "star.fill")?.withTintColor(.orange, renderingMode: .alwaysOriginal)
        } else if rating == 2 {
            [ratingStar1, ratingStar2].forEach {
                $0?.image = UIImage(systemName: "star.fill")?.withTintColor(.orange, renderingMode: .alwaysOriginal)
            }
        } else if rating == 3 {
            [ratingStar1, ratingStar2, ratingStar3].forEach {
                $0?.image = UIImage(systemName: "star.fill")?.withTintColor(.orange, renderingMode: .alwaysOriginal)
            }
        } else if rating == 4 {
            [ratingStar1, ratingStar2, ratingStar3, ratingStar4].forEach {
                $0?.image = UIImage(systemName: "star.fill")?.withTintColor(.orange, renderingMode: .alwaysOriginal)
            }
        } else if rating == 5 &&  rating > 5 {
            [ratingStar1, ratingStar2, ratingStar3, ratingStar4,ratingStar5].forEach {
                $0?.image = UIImage(systemName: "star.fill")?.withTintColor(.orange, renderingMode: .alwaysOriginal)
            }
        }
    }
}
