//
//  CAGradientLayer+Extensions.swift
//  TaskBrainStorm
//
//  Created by Rafael Nalbandyan on 04.09.23.
//

import Foundation
import UIKit


extension CAGradientLayer {
    
    func setGradientLayer(gradientColors: [UIColor]) {
        let leftColor: UIColor
        let rightColor: UIColor
        
        let gradientColors = gradientColors
        leftColor = gradientColors.first ?? .red
        rightColor = gradientColors.last ?? .yellow
        
        
        let startPointX: CGFloat = 0
        let startPointY: CGFloat = 0.5
        let endPointX: CGFloat = 1
        let endPointY: CGFloat = 0.5
        
        self.colors = [leftColor.cgColor, rightColor.cgColor]
        self.startPoint = CGPoint(x: startPointX, y: startPointY)
        self.endPoint = CGPoint(x: endPointX, y: endPointY)
        self.locations = [0, 1]
    }
}
