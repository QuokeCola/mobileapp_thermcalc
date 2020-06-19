//
//  PlaceHolderTextField.swift
//  ThermoCalc
//
//  Created by 钱晨 on 2020/6/15.
//  Copyright © 2020年 钱晨. All rights reserved.
//

import UIKit

class PlaceHolderTextField: UITextField {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    func setup() {
        self.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0)
        self.addTarget(self, action: #selector(textFieldEditingChanged(textField:)), for: .editingChanged)
        self.addTarget(self, action: #selector(selfActivated), for: .touchDown)
        self.font = UIFont.systemFont(ofSize: 17.0)
        self.tintColor = UIColor(red: 49/255, green: 112/255, blue: 228/255, alpha: 0.9)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func getWidth(text: String) -> CGFloat {
        let txtField = UITextField(frame: .zero)
        txtField.text = ",  "+text
        txtField.font = self.font
        txtField.sizeToFit()
        return txtField.frame.size.width
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var newSize = self.frame.size
        newSize.width = getWidth(text: self.text!)
        return newSize
    }
    
    @objc func textFieldEditingChanged(textField: UITextField) {
        let width = getWidth(text: self.text!)
        var newFrame = self.frame
        newFrame.size = CGSize(width: width, height: newFrame.size.height)
        self.frame = newFrame
    }
    
    @objc func selfActivated() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationSearchSubViewActivateKey), object: self)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationKeyboardSwitchDecimalKey), object: self)
    }
    
    override func becomeFirstResponder() -> Bool {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationKeyboardSwitchDecimalKey), object: self)
        return super.becomeFirstResponder()
    }
}
