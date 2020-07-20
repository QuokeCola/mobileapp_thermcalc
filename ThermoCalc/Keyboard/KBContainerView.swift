//
//  KBContainerView.swift
//  ThermoCalc
//
//  Created by 钱晨 on 2020/6/23.
//  Copyright © 2020年 钱晨. All rights reserved.
//

import UIKit

class KBContainerView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var keyboardComponents: KeyboardComponents!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.translatesAutoresizingMaskIntoConstraints = false
        keyboardComponents = KeyboardComponents(frame: frame)
        self.addSubview(keyboardComponents)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        translatesAutoresizingMaskIntoConstraints = false
        
        guard let superview = superview else { return }
        
        var lastView: UIView! = self
        while lastView.superview != nil {
            lastView = lastView.superview
        }
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalTo: lastView.heightAnchor, multiplier: 0.5, constant: 0),
            widthAnchor.constraint(equalTo: superview.widthAnchor),
            centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor)
            ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        keyboardComponents.frame = self.frame
    }
}
