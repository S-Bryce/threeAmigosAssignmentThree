//
//  CircleProgressBar.swift
//  threeAmigosAssignmentThree
//
//  Created by Bryce Shurts on 10/11/23.
//

import UIKit

class CircleProgressBar: UIView {
    
    // MARK: Private Properties
    private var circleLayer = CAShapeLayer()
    private var progressLayer = CAShapeLayer()
    private var startPoint = CGFloat(-Double.pi / 2)
    private var endPoint = CGFloat(3 * Double.pi / 2)
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func createCircularPath() {
        
        // TODO: Draw the rest of the owl...
    }
    
    func progressAnimation(duration: TimeInterval) {
        // Have a duration to control how quickly the bar fills up, might allow for smoother animation?
    }
}
