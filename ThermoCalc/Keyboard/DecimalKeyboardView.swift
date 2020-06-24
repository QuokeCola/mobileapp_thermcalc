//
//  DecimalKeyboard.swift
//  ThermoCalc
//
//  Created by 钱晨 on 2020/4/4.
//  Copyright © 2020年 钱晨. All rights reserved.
//

import UIKit

class DecimalKeyboardView: UIView {
    enum KeyboardType {
        case Decimal
        case State
    }
    private var BGColor = UIColor(red: 214/255, green: 215/255, blue: 220/255, alpha: 0.0)
    private var imagineWordSet = [String](repeating: "Unit", count: 10)
    private var totalHeight = CGFloat(0.0)
    private var totalWidth  = CGFloat(0.0)
    private var DecimalButton = [KeyboardButton?](repeating: nil, count: 12)
    private var StateButton = [KeyboardButton?](repeating: nil, count: 8)
    private var ImagineView = UIScrollView(frame: CGRect(x: UIScreen.main.bounds.width, y: 0.0, width: UIScreen.main.bounds.width, height: CGFloat(55.0)))
    private var StateKeys:[String] = ["Pressure","Spc.Vol","Temp","Int.Engy","Enthalpy","MassFac","Entropy"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateKeyboardPlacement()
        NotificationCenter.default.addObserver(self, selector: #selector(handleSwitchDecimal), name: NSNotification.Name(rawValue: NotificationKeyboardSwitchDecimalKey), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleSwitchState), name: NSNotification.Name(rawValue: NotificationKeyboardSwitchStateKey), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateKeyboardPlacement), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateKeyboardPlacement()
        NotificationCenter.default.addObserver(self, selector: #selector(handleSwitchDecimal), name: NSNotification.Name(rawValue: NotificationKeyboardSwitchDecimalKey), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleSwitchState), name: NSNotification.Name(rawValue: NotificationKeyboardSwitchStateKey), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateKeyboardPlacement), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    @IBAction func DecimalKeyPressed(sender: KeyboardButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationKeyboardDecimalPressedKey), object: sender)
    }
    
    @IBAction func ImagineKeyPressed(sender: ImagineButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationKeyboardImaginePressedKey), object: sender)
    }
    
    @IBAction func StateKeyPressed(sender: KeyboardButton) {
        NotificationCenter.default.post(name: NSNotification.Name(NotificationKeyboardStatePressedKey), object: sender)
    }
    
    // Set up imagine box.
    fileprivate func reloadImagineWords() {
        self.ImagineView.backgroundColor = BGColor
        self.ImagineView.delaysContentTouches = false
        self.ImagineView.showsVerticalScrollIndicator = false
        self.ImagineView.showsHorizontalScrollIndicator = false
        _ = ImagineView.subviews.map { $0.removeFromSuperview() }
        var imagineButtons = [ImagineButton?](repeating: nil, count: imagineWordSet.count)
        let imagineButtonHeight = CGFloat(35.0)
        let imagineSpacingX = CGFloat(20.0)
        let imagineSpacingY = (ImagineView.bounds.height - imagineButtonHeight)/2.0
        var x = imagineSpacingX
        for i in 0...imagineButtons.count-1 {
            imagineButtons[i] = ImagineButton(frame: CGRect(x: x, y: imagineSpacingY, width: CGFloat(imagineWordSet[i].count)*20.0+20.0, height: imagineButtonHeight))
            imagineButtons[i]?.setTitle(imagineWordSet[i], for: .normal)
            x += (imagineButtons[i]!.bounds.width + imagineSpacingX)
        }
        ImagineView.contentSize = CGSize(width: x, height: ImagineView.bounds.height)
        for i in 0...imagineButtons.count-1 {
            imagineButtons[i]?.addTarget(self, action: #selector(ImagineKeyPressed), for: .touchUpInside)
            ImagineView.addSubview(imagineButtons[i]!)
        }
    }
    
    fileprivate func PortraitSetup() {
        _ = self.subviews.map { $0.removeFromSuperview() }
        var x = CGFloat(0.0)
        var y = CGFloat(0.0)
        self.frame = CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.5)
        self.backgroundColor = BGColor
        totalHeight = self.frame.height - getBottomHeight() - ImagineView.bounds.height
        totalWidth  = UIScreen.main.bounds.width
        
        let stateButtonWidth = totalWidth * 0.28
        let stateButtonHeight = (UIScreen.main.bounds.height * 0.5 - getBottomHeight()) * 0.25
        let stateSpacingX = totalWidth * 0.04
        let stateSpacingY = (UIScreen.main.bounds.height * 0.5 - getBottomHeight()) * 0.0625
        
        for i in 0...StateKeys.count-1 {
            x = (stateSpacingX + stateButtonWidth ) * CGFloat(i%3) + stateSpacingX
            y = (stateSpacingY + stateButtonHeight) * CGFloat(i/3) + stateSpacingY
            StateButton[i] = KeyboardButton(frame: CGRect(x: x, y: y, width: stateButtonWidth, height: stateButtonHeight))
            StateButton[i]?.setTitle(StateKeys[i], for: .normal)
            StateButton[i]?.Key = StateKeys[i]
            StateButton[i]?.addTarget(self, action: #selector(StateKeyPressed), for: .touchUpInside)
            StateButton[i]?.isEnabled = (keyboardType == .State)
            self.addSubview(StateButton[i]!)
        }
        let StateDeleteButton = KeyboardButton(frame: CGRect(x: (stateSpacingX+stateButtonWidth)+stateSpacingX, y: (stateSpacingY+stateButtonHeight)*2+stateSpacingY, width: stateButtonWidth*2+stateSpacingX, height: stateButtonHeight))
        StateDeleteButton.setImage(#imageLiteral(resourceName: "Backspace"), for: .normal)
        StateDeleteButton.imageView?.tintColor = UIColor.black
        StateDeleteButton.Key = "StateDelete"
        StateButton[7] = StateDeleteButton
        StateButton[7]?.addTarget(self, action: #selector(StateKeyPressed), for: .touchUpInside)
        StateButton[7]?.isEnabled = (keyboardType == .State)
        self.addSubview(StateButton[7]!)
        let decimalButtonWidth  = totalWidth  * 0.28
        let decimalButtonHeight = totalHeight * 0.2
        let decimalSpacingX = totalWidth * 0.04
        let decimalSpacingY = totalHeight * 0.04
        
        // Set up buttons from 0 to 9
        for i in 0...9 {
            var x = CGFloat(0.0)
            var y = CGFloat(0.0)
            
            let imagineHeight = self.ImagineView.bounds.height
            
            if (i == 0) {
                x = decimalButtonWidth + 2 * decimalSpacingX + totalWidth
                y = 3*decimalButtonHeight + 4 * decimalSpacingY + imagineHeight
            } else {
                x = (decimalSpacingX + decimalButtonWidth ) * CGFloat((i-1)%3) + decimalSpacingX + totalWidth
                y = (decimalSpacingY + decimalButtonHeight) * CGFloat((i-1)/3) + decimalSpacingY + imagineHeight
            }
            DecimalButton[i] = KeyboardButton(frame: CGRect(x: x, y: y, width: decimalButtonWidth, height: decimalButtonHeight))
            DecimalButton[i]?.setTitle("\(i)", for: .normal)
            DecimalButton[i]?.titleLabel!.font = UIFont.boldSystemFont(ofSize: (DecimalButton[i]?.bounds.height)! * 0.5)
            DecimalButton[i]?.Key = "\(i)"
            DecimalButton[i]?.addTarget(self, action: #selector(DecimalKeyPressed), for: .touchUpInside)
            DecimalButton[i]?.isEnabled = (keyboardType == .Decimal)
            self.addSubview(DecimalButton[i]!)
        }
        self.ImagineView.frame.size.width = totalWidth
        self.ImagineView.frame.origin.x = totalWidth
        self.ImagineView.isUserInteractionEnabled = (keyboardType == .Decimal)
        self.addSubview(ImagineView)
        // Set up delete button and dot button
        let DecimalDeleteButton = KeyboardButton(frame: CGRect(x: (decimalSpacingX+decimalButtonWidth)*2+decimalSpacingX+totalWidth, y: (decimalSpacingY+decimalButtonHeight)*3+decimalSpacingY+ImagineView.bounds.height, width: decimalButtonWidth, height: decimalButtonHeight))
        DecimalDeleteButton.setImage(#imageLiteral(resourceName: "Backspace"), for: .normal)
        DecimalDeleteButton.imageView?.tintColor = UIColor.black
        DecimalDeleteButton.Key = "DecimalDelete"
        DecimalButton[10] = DecimalDeleteButton
        DecimalButton[10]?.isEnabled = (keyboardType == .Decimal)
        let DotButton = KeyboardButton(frame: CGRect(x: decimalSpacingX + totalWidth, y: (decimalSpacingY+decimalButtonHeight)*3+decimalSpacingY+ImagineView.bounds.height, width: decimalButtonWidth, height: decimalButtonHeight))
        DotButton.setTitle(".", for: .normal)
        DotButton.setTitleColor(UIColor.black, for: .normal)
        DotButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: decimalButtonHeight*0.5)
        DotButton.Key = "."
        DecimalButton[11] = DotButton
        DecimalButton[11]?.isEnabled = (keyboardType == .Decimal)
        DecimalButton[10]?.addTarget(self, action: #selector(DecimalKeyPressed), for: .touchUpInside)
        DecimalButton[11]?.addTarget(self, action: #selector(DecimalKeyPressed), for: .touchUpInside)
        self.addSubview(DecimalButton[10]!)
        self.addSubview(DecimalButton[11]!)
        if self.keyboardType == .Decimal {
            for i in 0...self.DecimalButton.count - 1 {
                var newFrameOrigin = self.DecimalButton[i]?.frame.origin
                newFrameOrigin!.x -= UIScreen.main.bounds.width
                self.DecimalButton[i]?.frame.origin = newFrameOrigin!
            }
            for i in 0...self.StateButton.count - 1 {
                var newFrameOrigin = self.StateButton[i]?.frame.origin
                newFrameOrigin!.x -= UIScreen.main.bounds.width
                self.StateButton[i]?.frame.origin = newFrameOrigin!
            }
            var newFrameOrigin = self.ImagineView.frame.origin
            newFrameOrigin.x -= UIScreen.main.bounds.width
            self.ImagineView.frame.origin = newFrameOrigin
            for i in 0...self.DecimalButton.count - 1 {
                self.DecimalButton[i]?.isEnabled = true
                self.ImagineView.isUserInteractionEnabled = true
            }
        }
    }
    
    fileprivate func LandscapeSetup() {
        _ = self.subviews.map { $0.removeFromSuperview() }
        var x = CGFloat(0.0)
        var y = CGFloat(0.0)
        self.frame = CGRect(x: getLeftRightSpace(), y: 0.0, width: UIScreen.main.bounds.width-2*getLeftRightSpace(), height: UIScreen.main.bounds.height * 0.5)
        self.backgroundColor = BGColor
        totalHeight = self.frame.height - getBottomHeight() - ImagineView.bounds.height
        totalWidth  = UIScreen.main.bounds.width * 0.5-getLeftRightSpace()
        
        let stateButtonWidth = totalWidth * 0.28
        let stateButtonHeight = (UIScreen.main.bounds.height * 0.5 - getBottomHeight()) * 0.25
        let stateSpacingX = totalWidth * 0.04
        let stateSpacingY = (UIScreen.main.bounds.height * 0.5 - getBottomHeight()) * 0.0625
        
        for i in 0...StateKeys.count-1 {
            x = (stateSpacingX + stateButtonWidth ) * CGFloat(i%3) + stateSpacingX
            y = (stateSpacingY + stateButtonHeight) * CGFloat(i/3) + stateSpacingY
            StateButton[i] = KeyboardButton(frame: CGRect(x: x, y: y, width: stateButtonWidth, height: stateButtonHeight))
            StateButton[i]?.setTitle(StateKeys[i], for: .normal)
            StateButton[i]?.Key = StateKeys[i]
            StateButton[i]?.addTarget(self, action: #selector(StateKeyPressed), for: .touchUpInside)
            StateButton[i]?.isEnabled = (keyboardType == .State)
            self.addSubview(StateButton[i]!)
        }
        let StateDeleteButton = KeyboardButton(frame: CGRect(x: (stateSpacingX+stateButtonWidth)+stateSpacingX, y: (stateSpacingY+stateButtonHeight)*2+stateSpacingY, width: stateButtonWidth*2+stateSpacingX, height: stateButtonHeight))
        StateDeleteButton.setImage(#imageLiteral(resourceName: "Backspace"), for: .normal)
        StateDeleteButton.imageView?.tintColor = UIColor.black
        StateDeleteButton.Key = "StateDelete"
        StateButton[7] = StateDeleteButton
        StateButton[7]?.addTarget(self, action: #selector(StateKeyPressed), for: .touchUpInside)
        StateButton[7]?.isEnabled = (keyboardType == .State)
        let decimalButtonWidth  = totalWidth  * 0.28
        let decimalButtonHeight = totalHeight * 0.2
        let decimalSpacingX = totalWidth * 0.04
        let decimalSpacingY = totalHeight * 0.04
        
        // Set up buttons from 0 to 9
        for i in 0...9 {
            var x = CGFloat(0.0)
            var y = CGFloat(0.0)
            
            let imagineHeight = self.ImagineView.bounds.height
            
            if (i == 0) {
                x = decimalButtonWidth + 2 * decimalSpacingX + totalWidth
                y = 3*decimalButtonHeight + 4 * decimalSpacingY + imagineHeight
            } else {
                x = (decimalSpacingX + decimalButtonWidth ) * CGFloat((i-1)%3) + decimalSpacingX + totalWidth
                y = (decimalSpacingY + decimalButtonHeight) * CGFloat((i-1)/3) + decimalSpacingY + imagineHeight
            }
            DecimalButton[i] = KeyboardButton(frame: CGRect(x: x, y: y, width: decimalButtonWidth, height: decimalButtonHeight))
            DecimalButton[i]?.setTitle("\(i)", for: .normal)
            DecimalButton[i]?.titleLabel!.font = UIFont.boldSystemFont(ofSize: (DecimalButton[i]?.bounds.height)! * 0.5)
            DecimalButton[i]?.Key = "\(i)"
            DecimalButton[i]?.isEnabled = (keyboardType == .Decimal)
            DecimalButton[i]?.addTarget(self, action: #selector(DecimalKeyPressed), for: .touchUpInside)
            self.addSubview(DecimalButton[i]!)
        }
        self.ImagineView.frame.origin.x = totalWidth
        self.ImagineView.frame.size.width = totalWidth
        self.ImagineView.isUserInteractionEnabled = (keyboardType == .Decimal)
        self.addSubview(ImagineView)
        // Set up delete button and dot button
        let DecimalDeleteButton = KeyboardButton(frame: CGRect(x: (decimalSpacingX+decimalButtonWidth)*2+decimalSpacingX+totalWidth, y: (decimalSpacingY+decimalButtonHeight)*3+decimalSpacingY+ImagineView.bounds.height, width: decimalButtonWidth, height: decimalButtonHeight))
        DecimalDeleteButton.setImage(#imageLiteral(resourceName: "Backspace"), for: .normal)
        DecimalDeleteButton.imageView?.tintColor = UIColor.black
        DecimalDeleteButton.Key = "DecimalDelete"
        DecimalButton[10] = DecimalDeleteButton
        DecimalButton[10]?.isEnabled = (keyboardType == .Decimal)
        let DotButton = KeyboardButton(frame: CGRect(x: decimalSpacingX + totalWidth, y: (decimalSpacingY+decimalButtonHeight)*3+decimalSpacingY+ImagineView.bounds.height, width: decimalButtonWidth, height: decimalButtonHeight))
        DotButton.setTitle(".", for: .normal)
        DotButton.setTitleColor(UIColor.black, for: .normal)
        DotButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: decimalButtonHeight*0.5)
        DotButton.Key = "."
        DecimalButton[11] = DotButton
        DecimalButton[11]?.isEnabled = (keyboardType == .Decimal)
        DecimalButton[10]?.addTarget(self, action: #selector(DecimalKeyPressed), for: .touchUpInside)
        DecimalButton[11]?.addTarget(self, action: #selector(DecimalKeyPressed), for: .touchUpInside)
        StateButton[7]?.frame = (DecimalButton[10]?.frame)!
        
        if keyboardType == .State {
            for button in DecimalButton {
                button?.alpha = 0.5
            }
            DecimalButton[10]?.alpha = 0.0
            StateButton[7]?.alpha = 1.0
        } else {
            for button in StateButton {
                button?.alpha = 0.5
            }
            DecimalButton[10]?.alpha = 1.0
            StateButton[7]?.alpha = 0.0
        }
        self.addSubview(StateButton[7]!)
        self.addSubview(DecimalButton[10]!)
        self.addSubview(DecimalButton[11]!)
    }
    
    /**
     Change the imaginary word set
     @params imagineWordSet: a group of string contains imaginary words.
     */
    func updateImaginaryWords(stringSet: [String]) {
        self.imagineWordSet = stringSet
        self.reloadImagineWords()
    }
    /**
     Update the KeyboardPlacement.
     It should be used when rotating.
     */
    @objc func updateKeyboardPlacement() {
        if(UIDevice.modelName.contains(find: "iPad") || UIApplication.shared.statusBarOrientation == .landscapeLeft || UIApplication.shared.statusBarOrientation == .landscapeRight) {
            LandscapeSetup()
            reloadImagineWords()
        } else {
            PortraitSetup()
            reloadImagineWords()
        }
    }
    var keyboardType:KeyboardType = .State{
        didSet{
            switch keyboardType {
            case .Decimal:
                if oldValue != keyboardType {
                    for i in 0...self.DecimalButton.count - 1 {
                        self.DecimalButton[i]?.isEnabled = false
                    }
                    for i in 0...self.StateButton.count - 1 {
                        self.StateButton[i]?.isEnabled = false
                        
                    }
                    if(UIDevice.modelName.contains(find: "iPad") || UIApplication.shared.statusBarOrientation == .landscapeLeft || UIApplication.shared.statusBarOrientation == .landscapeRight) {
                        for i in 0...self.StateButton.count - 2 {
                            self.StateButton[i]?.alpha = 0.5
                        }
                        for i in 0...self.DecimalButton.count - 1 {
                            self.DecimalButton[i]?.isEnabled = true
                            self.ImagineView.isUserInteractionEnabled = true
                            self.DecimalButton[i]?.alpha = 1.0
                        }
                        DecimalButton[10]?.alpha = 1.0
                        StateButton[7]?.alpha = 0.0
                    } else {
                        UIView.animate(withDuration: 0.4, animations: {
                            for i in 0...self.DecimalButton.count - 1 {
                                var newFrameOrigin = self.DecimalButton[i]?.frame.origin
                                newFrameOrigin!.x -= UIScreen.main.bounds.width
                                self.DecimalButton[i]?.frame.origin = newFrameOrigin!
                            }
                            for i in 0...self.StateButton.count - 1 {
                                var newFrameOrigin = self.StateButton[i]?.frame.origin
                                newFrameOrigin!.x -= UIScreen.main.bounds.width
                                self.StateButton[i]?.frame.origin = newFrameOrigin!
                            }
                            var newFrameOrigin = self.ImagineView.frame.origin
                            newFrameOrigin.x -= UIScreen.main.bounds.width
                            self.ImagineView.frame.origin = newFrameOrigin
                        }, completion: {(finished:Bool) in
                            for i in 0...self.DecimalButton.count - 1 {
                                self.DecimalButton[i]?.isEnabled = true
                                self.ImagineView.isUserInteractionEnabled = true
                            }
                        })
                    }
                }
            case .State:
                if oldValue != keyboardType {
                    for i in 0...self.DecimalButton.count - 1 {
                        self.DecimalButton[i]?.isEnabled = false
                    }
                    for i in 0...self.StateButton.count - 1 {
                        self.StateButton[i]?.isEnabled = false
                    }
                    if(UIDevice.modelName.contains(find: "iPad") || UIApplication.shared.statusBarOrientation == .landscapeLeft || UIApplication.shared.statusBarOrientation == .landscapeRight) {
                        for i in 0...self.DecimalButton.count - 1 {
                            self.DecimalButton[i]?.alpha = 0.5
                        }
                        for i in 0...self.StateButton.count - 1 {
                            self.StateButton[i]?.isEnabled = true
                            self.ImagineView.isUserInteractionEnabled = false
                            self.StateButton[i]?.alpha = 1.0
                        }
                        DecimalButton[10]?.alpha = 0.0
                        StateButton[7]?.alpha = 1.0
                    } else {
                        UIView.animate(withDuration: 0.4, animations: {
                            for i in 0...self.DecimalButton.count - 1 {
                                var newFrameOrigin = self.DecimalButton[i]?.frame.origin
                                newFrameOrigin!.x += UIScreen.main.bounds.width
                                self.DecimalButton[i]?.frame.origin = newFrameOrigin!
                            }
                            for i in 0...self.StateButton.count - 1 {
                                var newFrameOrigin = self.StateButton[i]?.frame.origin
                                newFrameOrigin!.x += UIScreen.main.bounds.width
                                self.StateButton[i]?.frame.origin = newFrameOrigin!
                            }
                            var newFrameOrigin = self.ImagineView.frame.origin
                            newFrameOrigin.x += UIScreen.main.bounds.width
                            self.ImagineView.frame.origin = newFrameOrigin
                        }, completion: {(finished:Bool) in
                            for i in 0...self.StateButton.count - 1 {
                                self.StateButton[i]?.isEnabled = true
                                self.ImagineView.isUserInteractionEnabled = false
                            }
                        })
                    }
                }
            }
        }
    }
    
    @objc func handleSwitchDecimal(info: NSNotification) {
        keyboardType = .Decimal
    }
    
    @objc func handleSwitchState(info: NSNotification) {
        keyboardType = .State
    }
}
