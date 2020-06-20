//
//  PlaceHolderView.swift
//  ThermoCalc
//
//  Created by 钱晨 on 2020/6/16.
//  Copyright © 2020年 钱晨. All rights reserved.
//

import UIKit

class PlaceHolderView: UIView {
    var selectedIndex: Int?
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    /**
     When the Unit placeholder is in the front, there will be no entry for add Header and amount. So Add a animated placeholder indicator before it.
     */
    var placeHolders = [UIView]() {
        didSet {
            if placeHolders.count == 0{
                return
            }
            for i in 0...placeHolders.count - 1 {
                guard let UnitButton = self.placeHolders[i] as? PlaceHolderButton else {continue}
                if UnitButton.placeHolderButtonType == .Unit {
                    if i != 0 {
                        guard placeHolders[i-1] is InterView else {continue}
                        let opts: UIViewAnimationOptions = [.autoreverse , .repeat]
                        self.addPlaceHolderButton(placeHolderString: " ", type: .Header, index: i)
                        if let button = self.placeHolders[i] as? PlaceHolderButton {
                            button.deselectButton()
                        }
                        self.placeHolders[i].alpha = 0.5
                        UIView.animate(withDuration: 1.5, delay: 0, options: opts, animations: {
                            self.placeHolders[i].alpha = 0.5
                            self.placeHolders[i].subviews[0].frame.size.width = 10.0
                        })
                    } else {
                        let opts: UIViewAnimationOptions = [.autoreverse , .repeat]
                        self.addPlaceHolderButton(placeHolderString: " ", type: .Header, index: i)
                        if let button = self.placeHolders[i] as? PlaceHolderButton {
                            button.deselectButton()
                        }
                        self.placeHolders[i].alpha = 0.5
                        UIView.animate(withDuration: 1.5, delay: 0, options: opts, animations: {
                            self.placeHolders[i].alpha = 0.5
                            self.placeHolders[i].subviews[0].frame.size.width = 10.0
                        })
                    }
                }
            }
            for i in 0...placeHolders.count - 1 {
                if self.placeHolders[i] is PlaceHolderTextField {
                    if i != 0 {
                        if let previousButton = placeHolders[i-1] as? PlaceHolderButton {
                            if previousButton.placeHolderButtonType == .Unit {
                                let opts: UIViewAnimationOptions = [.autoreverse , .repeat]
                                self.addPlaceHolderButton(placeHolderString: " ", type: .Header, index: i)
                                if let button = self.placeHolders[i] as? PlaceHolderButton {
                                    button.deselectButton()
                                }
                                self.placeHolders[i].alpha = 0.5
                                UIView.animate(withDuration: 1.5, delay: 0, options: opts, animations: {
                                    self.placeHolders[i].alpha = 0.5
                                    self.placeHolders[i].subviews[0].frame.size.width = 10.0
                                })
                            }
                        } else if placeHolders[i-1] is InterView {
                            let opts: UIViewAnimationOptions = [.autoreverse , .repeat]
                            self.addPlaceHolderButton(placeHolderString: " ", type: .Header, index: i)
                            if let button = self.placeHolders[i] as? PlaceHolderButton {
                                button.deselectButton()
                            }
                            self.placeHolders[i].alpha = 0.5
                            UIView.animate(withDuration: 1.5, delay: 0, options: opts, animations: {
                                self.placeHolders[i].alpha = 0.5
                                self.placeHolders[i].subviews[0].frame.size.width = 10.0
                            })
                        }
                        
                    } else {
                        let opts: UIViewAnimationOptions = [.autoreverse , .repeat]
                        self.addPlaceHolderButton(placeHolderString: " ", type: .Header, index: i)
                        if let button = self.placeHolders[i] as? PlaceHolderButton {
                            button.deselectButton()
                        }
                        UIView.animate(withDuration: 1.5, delay: 0, options: opts, animations: {
                            self.placeHolders[i].alpha = 0.5
                            self.placeHolders[i].subviews[0].frame.size.width = 10.0
                        })
                    }
                }
            }
            self.refreshPlaceHolderView()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationPlaceHolderIsEmpty), object: placeHolders.count == 0)
        }
    }
    var placeHolderHeight = CGFloat(25.0)
    var placeHolderY = CGFloat(0.0)
    var tagUpperBound = 20
    
    func setup() {
        backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        self.alpha = 1.0
        NotificationCenter.default.addObserver(self, selector: #selector(searchBarSizeChange), name: NSNotification.Name(rawValue: NotificationSearchBarSizeChangeKey), object: nil)
        self.clipsToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
    @objc func searchBarSizeChange(info:NSNotification) {
        if let bounds = info.object as? CGRect {
            let newButtonHeight = max(bounds.height - (52.0 - placeHolderHeight),0.0)
            let newTextFieldHeight = max(bounds.height - (52.0 - self.bounds.height), 0.0)
            if placeHolders.count != 0 {
                for i in 0...self.placeHolders.count-1 {
                    if let button = placeHolders[i] as? PlaceHolderButton {
                        button.frame.size = CGSize(width: placeHolders[i].bounds.width, height: newButtonHeight)
                        button.titleLabel?.alpha = max(3.0*newButtonHeight/placeHolderHeight-2.0, 0.0)
                        button.alpha = min(4.0 * newButtonHeight/placeHolderHeight - 1.0, 1.0)
                    }
                    if let textField = placeHolders[i] as? PlaceHolderTextField {
                        textField.frame.size = CGSize(width: placeHolders[i].bounds.width, height: newTextFieldHeight)
                        textField.alpha = max(2.0 * newTextFieldHeight/self.bounds.height - 1.0, 0.0)
                    }
                }
            }
        }
    }
    
    /**
     For the maxima situation, here should be only four (As two state and two unit).
     */
    func addPlaceHolderButton(placeHolderString: String, type: PlaceHolderButton.PlaceHolderButtonType, index: Int?) {
        placeHolderY = (self.bounds.height - placeHolderHeight)/2.0
        let placeHolderX = CGFloat(0.0)
        let button = PlaceHolderButton(frame: CGRect(x: placeHolderX, y: placeHolderY, width: 80.0, height: placeHolderHeight))
        button.setTitle(placeHolderString, for: .normal)
        button.placeHolderButtonType = type
        if index == nil {
            self.placeHolders.append(button)
        } else {
            self.placeHolders.insert(button, at: index!)
        }
        self.refreshPlaceHolderView()
        
    }
    
    func addPlaceHolderTextField(Keyboard: UIView, Index: Int?) {
        placeHolderY = CGFloat(0.0)
        let placeHolderX = CGFloat(0.0)
        let newTextField = PlaceHolderTextField(frame: CGRect(x: placeHolderX, y: placeHolderY, width: 80.0, height: self.frame.height))
        newTextField.text = ""
        newTextField.inputView = Keyboard
        newTextField.sizeToFit()
        if let index = Index {
            self.placeHolders.insert(newTextField, at: index)
            self.addSubview(placeHolders[index])
        } else {
            self.placeHolders.append(newTextField)
            self.addSubview(placeHolders[placeHolders.count-1])
        }
        self.refreshPlaceHolderView()
        self.placeHolders[self.placeHolders.count-1].becomeFirstResponder()
    }
    
    func removePlaceHolders(Index: Int) {
        self.placeHolders[Index].removeFromSuperview()
        self.placeHolders.remove(at: Index)
        if placeHolders.count == 0 {
            selectedIndex = nil
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationPlaceHolderIsEmpty), object: placeHolders.count == 0)
        self.refreshPlaceHolderView()
    }
    
    func refreshPlaceHolderView() {
        placeHolderY = CGFloat(0.0)
        var placeHolderX = CGFloat(0.0)
        if placeHolders.count == 0 {return}
        for i in 0...placeHolders.count-1 {
            placeHolders[i].frame.origin.x = placeHolderX
            placeHolders[i].tag = i + 1
            if let button = placeHolders[i] as? PlaceHolderButton {
                if button.titleLabel?.text == " " {
                    placeHolderX += 30.0
                } else {
                    placeHolderX += placeHolders[i].frame.size.width
                }
                if button.placeHolderButtonType == .Header {
                    placeHolderX += 10.0
                }
            } else {
                placeHolderX += placeHolders[i].frame.size.width
            }
            self.addSubview(placeHolders[i])
        }
        self.frame.size.width = placeHolderX + 10.0
        
        if self.frame.size.width > CGFloat((superview?.frame.size.width)! - 28.0) {
            if let index = selectedIndex {
                if(index < placeHolders.count) {
                    if (self.frame.size.width - placeHolders[index].frame.minX) > CGFloat((superview?.frame.size.width)! - 28.0) {
                        UIView.animate(withDuration: 0.3, animations: {
                            self.frame.origin.x = -self.placeHolders[index].frame.minX + 28.0
                        })
                    } else {
                        UIView.animate(withDuration: 0.3, animations: {
                            self.frame.origin.x = (self.superview?.frame.size.width)! - self.frame.size.width
                        })
                    }
                }
            }

        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.frame.origin.x = 28.0
            })
        }
    }

    override open func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        guard self.point(inside: point, with: event) else { return nil }
        for subview in subviews.reversed() {
            let convertedPoint = subview.convert(point, from: self)
            if let candidate = subview.hitTest(convertedPoint, with: event) {
                if let button = subview as? PlaceHolderButton {
                    self.selectComponent(Index: button.tag-1)
                }
                if let textField = subview as?  PlaceHolderTextField {
                    self.selectComponent(Index: textField.tag-1)
                }
                if let interView = subview as? InterView {
                    self.selectComponent(Index: interView.tag-1)
                }
                return candidate
            }
        }
        return self
    }
    
    func selectComponent(Index: Int?) {
        guard let index = Index else {
            selectedIndex = nil
            return
        }
        if placeHolders.count == 0 {return}
        for i in 0...placeHolders.count-1 {
            if i != index {
                if let Button = placeHolders[i] as? PlaceHolderButton {
                    Button.deselectButton()
                    if Button.titleLabel?.text == " "{
                        Button.alpha = 0.5
                        let opts: UIViewAnimationOptions = [.autoreverse , .repeat]
                        UIView.animate(withDuration: 1.5, delay: 0, options: opts, animations: {
                            Button.alpha = 0.5
                            Button.frame.size.width = 10.0
                        })
                    }
                }
                placeHolders[i].resignFirstResponder()
            } else {
                if let Button = placeHolders[i] as? PlaceHolderButton {
                    Button.selectButton()
                    if Button.titleLabel?.text == " " {
                        Button.layer.removeAllAnimations()
                        Button.sizeToFit()
                        Button.alpha = 1.0
                    }
                    Button.becomeFirstResponder()
                } else if let Textfield = placeHolders[i] as? PlaceHolderTextField {
                    Textfield.tintColor = UIColor(red: 49/255, green: 112/255, blue: 228/255, alpha: 0.9)
                    _ = Textfield.becomeFirstResponder()
                } else if let interView = placeHolders[i] as? InterView {
                    interView.textView.tintColor = UIColor(red: 49/255, green: 112/255, blue: 228/255, alpha: 0.9)
                    _ = interView.becomeFirstResponder()
                }
            }
        }
        selectedIndex = index
        if (self.frame.size.width - placeHolders[index].frame.minX) > CGFloat((superview?.frame.size.width)! - 28.0) {
            UIView.animate(withDuration: 0.3, animations: {
                self.frame.origin.x = -self.placeHolders[index].frame.minX + 28.0
            })
        }
    }
    
    func addInterView(Keyboard: UIView, index: Int?) {
        let interView = InterView(frame: self.frame)
        interView.setupKeyboard(Keyboard: Keyboard)
        guard let Index = index else {
            placeHolders.append(interView)
            return
        }
        placeHolders.insert(interView, at: Index)
    }
}
