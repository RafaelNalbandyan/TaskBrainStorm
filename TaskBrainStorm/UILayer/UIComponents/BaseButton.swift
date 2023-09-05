//
//  BaseButton.swift
//  TaskBrainStorm
//
//  Created by Rafael Nalbandyan on 04.09.23.
//

import UIKit

final class BaseButton: UIButton {
    
    enum ButtonState: Int {
        case greenLiner = 1
        case grayLiner = 2
    }
    
    @IBInspectable var stateAdapter: Int {
        get {
            return self.buttonState.rawValue
        }
        set(typeIndex) {
            self.buttonState = ButtonState(rawValue: typeIndex) ?? .greenLiner
        }
    }
    
    // MARK: - Private properties
    
    private var buttonState: ButtonState = .greenLiner
    private var gradientLayer: CAGradientLayer!
    
    // MARK: - Override methods
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height / 2
        
        switch buttonState {
        case .greenLiner:
            self.tintColor = UIColor.white
            self.gradientLayer = self.layer as? CAGradientLayer
            let greenLinerFirst = UIColor(named: Constants.ButtonsGradientColor.greenLinerFirst.rawValue) ?? .red
            let greenLinerLast = UIColor(named: Constants.ButtonsGradientColor.greenLinerLast.rawValue) ?? .yellow
            gradientLayer.setGradientLayer(gradientColors: [greenLinerFirst, greenLinerLast])
        case .grayLiner:
            self.gradientLayer = self.layer as? CAGradientLayer
            let grayLinerFirst = UIColor(named: Constants.ButtonsGradientColor.grayLinerFirst.rawValue) ?? .blue
            let grayLinerLast = UIColor(named: Constants.ButtonsGradientColor.grayLinerLast.rawValue) ?? .green
            gradientLayer.setGradientLayer(gradientColors: [grayLinerLast, grayLinerFirst])
            self.tintColor = UIColor.black
        }
    }
}

