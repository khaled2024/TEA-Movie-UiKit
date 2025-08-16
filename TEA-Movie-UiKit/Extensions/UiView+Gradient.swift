//
//  UiView+Gradient.swift
//  TEA-Movie-UiKit
//
//  Created by KhaleD HuSsien on 16/08/2025.
//

import UIKit
extension UIViewController{
    func applyRedOrangeGradient(to view: UIView) {
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        
        gradient.colors = [
            UIColor.systemRed.cgColor,
            UIColor.systemOrange.cgColor
        ]
        
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        
        view.layer.insertSublayer(gradient, at: 0)
    }
}
