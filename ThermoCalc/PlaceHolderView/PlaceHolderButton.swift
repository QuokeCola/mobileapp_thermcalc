//
//  PlaceHolderButton.swift
//  ThermoCalc
//
//  Created by 钱晨 on 2020/6/15.
//  Copyright © 2020年 钱晨. All rights reserved.
//

import UIKit

class PlaceHolderButton: UIButton {

    var defaultBG: UIColor = UIColor(red:229/255, green: 229/255, blue: 229/255, alpha: 1.0)
    var pressedBG: UIColor = UIColor(red: 49/255, green: 155/255, blue: 245/255, alpha: 0.75)
    
    enum PlaceHolderButtonType {
        case Header
        case Unit
    }
    
    var placeHolderButtonType: PlaceHolderButtonType?
    
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
        self.addTarget(self, action: #selector(selfActivated), for: .touchDown)
    }
    
    func selectButton() {
        self.isSelected = true
        self.layer.removeAllAnimations()
        for subview in self.subviews {
            subview.layer.removeAllAnimations()
        }
        if(self.placeHolderButtonType == .Header) {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationKeyboardSwitchStateKey), object: self)
        } else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationKeyboardSwitchDecimalKey), object: self)
        }
    }
    
    func deselectButton() {
        self.isSelected = false
    }
    
    override func setTitle(_ title: String?, for state: UIControlState) {
        super.setTitle(title, for: state)
        self.sizeToFit()
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let TxtButton = UIButton(frame: .zero)
        TxtButton.setTitle(self.titleLabel?.text, for: .normal)
        TxtButton.titleLabel?.font = UIFont.systemFont(ofSize: 17.0)
        TxtButton.sizeToFit()
        let AutoSize = CGSize(width: TxtButton.bounds.size.width, height: self.bounds.size.height)
        return AutoSize
    }
    
    @objc func selfActivated() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationSearchSubViewActivateKey), object: self)
    }
}
