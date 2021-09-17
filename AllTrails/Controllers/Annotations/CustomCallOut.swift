//
//  CustomCallOut.swift
//  CustomCallOut
//
//  Created by Arun Kumar on 9/15/21.
//

import UIKit

final class CustomCallOut: UIView {
    @IBOutlet private var rating1: UIImageView!
    @IBOutlet private var rating2: UIImageView!
    @IBOutlet private var rating3: UIImageView!
    @IBOutlet private var rating4: UIImageView!
    @IBOutlet private var rating5: UIImageView!
    @IBOutlet private var subText: UILabel!
    @IBOutlet private var totalReview: UILabel!
    @IBOutlet private var title: UILabel!
    @IBOutlet private var mainContainer: UIStackView!
    @IBOutlet private var image: UIImageView! {
        didSet {
            ViewRounding.customizeView(for: image)
        }
    }
    
    func configure(in view: UIView, with annotationView: StoreLocationAnnotation) {
        backgroundColor = .systemBackground
        
        // Setting up store's title
        self.title.text = annotationView.heading
        
        // Appending the `$` dynamically depends on price level
        var priceLevelString: String = ""
        for _ in 0..<annotationView.priceLevel { priceLevelString += "$" }
       
        // Appending Price level with desc in one single label
        if let desc = annotationView.subText {
            subText.text = "\(priceLevelString) . \(desc)"
        }
        
        // Fetch image from url and setup image
        if let url = annotationView.storeImage {
            ImageHelper.fetchImage(from: url) { [weak self] (image) in
                guard let self = self else { return }
                self.image.image = image
            }
        }
        
        // Rounding of the view
        ViewRounding.customizeView(for: self)
        
        // Setting up the review stars depending on the rating value
        ReviewStarsHelper.setUpReviewStars(for: annotationView.rating,
                                              ratingStar1: rating1,
                                              ratingStar2: rating2,
                                              ratingStar3: rating3,
                                              ratingStar4: rating4,
                                              ratingStar5: rating5)
    }
        
//    // MARK: - roundedView
//    private func roundedView(for view: UIView) {
//        // Radius
//        view.layer.cornerRadius = 10
//        // border
//        view.layer.borderWidth = 1.0
//        view.layer.borderColor = UIColor.lightGray.cgColor
//        // shadow
//        view.layer.shadowColor = UIColor.lightGray.cgColor
//        view.layer.shadowOffset = CGSize(width: 3, height: 3)
//        view.layer.shadowOpacity = 0.7
//        view.layer.shadowRadius = 4.0
//    }
    
    // MARK: - instanceFromNib
    class func instanceFromNib() -> CustomCallOut? {
        guard let customCallOutView = UINib(nibName: "CustomCallOut", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? CustomCallOut else { return nil }
        
        return customCallOutView
    }
    
    // MARK: - getMainStackViewHeight
    func getMainStackViewHeight(newWidth: CGFloat) -> CGFloat {
        frame = CGRect(x: 0, y: 0, width: newWidth, height: frame.height)
        mainContainer.layoutIfNeeded()
        return mainContainer.frame.height
    }
}


