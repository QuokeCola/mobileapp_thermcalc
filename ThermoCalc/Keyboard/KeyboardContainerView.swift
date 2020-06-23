//
//  KeyboardContainerView.swift
//  ThermoCalc
//
//  Created by 钱晨 on 2020/6/23.
//  Copyright © 2020年 钱晨. All rights reserved.
//

import UIKit

class KeyboardContainerView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.autoresizesSubviews = false
        NotificationCenter.default.addObserver(self, selector: #selector(updateKeyboardPlacement), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func updateKeyboardPlacement() {
        self.frame.size.width = UIScreen.main.bounds.width
        self.frame.size.height = UIScreen.main.bounds.height*0.5
        
    }
    
}
