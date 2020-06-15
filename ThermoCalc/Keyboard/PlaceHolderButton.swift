//
//  PlaceHolderButton.swift
//  ThermoCalc
//
//  Created by 钱晨 on 2020/6/15.
//  Copyright © 2020年 钱晨. All rights reserved.
//

import UIKit

class PlaceHolderButton: UIButton {

    var defaultBG: UIColor = UIColor(red: 12/255, green: 13/255, blue: 18/255, alpha: 0.2)
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
        backgroundColor = isSelected ? pressedBG : defaultBG
        setTitleColor(isSelected ? .white : .black, for: .normal)
    }
    
    fileprivate func setButton(){
        layer.cornerRadius = 5.0
        layer.masksToBounds = false
        self.setTitleColor(UIColor.black, for: .normal)
        super.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
    }
    
    func selectButton() {
        self.isSelected = true
    }
    
    func deselectButton() {
        self.isSelected = false
    }
    
    override func setTitle(_ title: String?, for state: UIControlState) {
        super.setTitle(title, for: state)
        self.sizeToFit()
    }
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var AutoSize = super.sizeThatFits(size)
        AutoSize.height = self.bounds.size.height
        AutoSize.width = AutoSize.width + 10.0
        return AutoSize
    }
}
