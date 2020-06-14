//
//  ImagineButton.swift
//  ThermoCalc
//
//  Created by 钱晨 on 2020/6/14.
//  Copyright © 2020年 钱晨. All rights reserved.
//

import UIKit

class ImagineButton: UIButton {

    var defaultBG: UIColor = UIColor(red: 192/255, green: 193/255, blue: 198/255, alpha: 0.5)
    var pressedBG: UIColor = UIColor(red: 49/255, green: 112/255, blue: 228/255, alpha: 0.9)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setButton()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = isHighlighted ? pressedBG : defaultBG
        setTitleColor(isHighlighted ? .white : .black, for: .normal)
    }
    
    fileprivate func setButton(){
        layer.cornerRadius = 5.0
        layer.masksToBounds = false
        self.setTitleColor(UIColor.black, for: .normal)
    }
    
}
