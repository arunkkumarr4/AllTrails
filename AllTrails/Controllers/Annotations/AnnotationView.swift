//
//  AnnotationView.swift
//  AnnotationView
//
//  Created by Arun Kumar on 9/15/21.
//

import MapKit

final class AnnotationView: MKAnnotationView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        if (hitView != nil) {
            self.superview?.bringSubviewToFront(self)
        }
        
        return hitView
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let rect = bounds
        var isInside: Bool = rect.contains(point)
        if(isInside != true) {
            subviews.forEach { view in
                isInside = view.frame.contains(point)
                if isInside == true {
                    return
                }
            }
        }
        
        return isInside
    }
}


