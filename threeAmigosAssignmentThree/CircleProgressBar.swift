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
        createCircularPath()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        createCircularPath()
    }
    
    func createCircularPath() {
        
        let shape = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0),
                                 radius: 100,
                                 startAngle: startPoint,
                                 endAngle: endPoint,
                                 clockwise: true)
        circleLayer.path = shape.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineWidth = 10.0
        circleLayer.strokeEnd = 1.0
        circleLayer.strokeColor = UIColor.clear.cgColor
        circleLayer.lineCap = .round
        layer.addSublayer(circleLayer)
        
        progressLayer.path = shape.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineWidth = 10.0
        progressLayer.strokeEnd = 0.0
        progressLayer.lineCap = .round
        layer.addSublayer(progressLayer)
    }
    
    func increaseBy(steps: Int, color: CGColor = UIColor.green.cgColor) {
        let progressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        progressAnimation.toValue = Float(steps)/Float(storage.integer(forKey: "dailyGoal"))
        progressAnimation.fillMode = .forwards
        progressAnimation.isRemovedOnCompletion = false
        progressAnimation.duration = 2
        progressLayer.add(progressAnimation, forKey:"progressAnim")
        progressLayer.strokeColor = color
    }
}
