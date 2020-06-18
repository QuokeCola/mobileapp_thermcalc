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
    var placeHolders = [UIView]()
    var placeHolderHeight = CGFloat(25.0)
    var placeHolderY = CGFloat(0.0)
    var tagUpperBound = 20
    
    func setup() {
        backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        NotificationCenter.default.addObserver(self, selector: #selector(searchBarSizeChange), name: NSNotification.Name(rawValue: NotificationSearchBarSizeChangeKey), object: nil)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
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
                        placeHolders[i] = button
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
    func addPlaceHolderButton(placeHolderString: String, type: PlaceHolderButton.PlaceHolderButtonType) {
        placeHolderY = (self.bounds.height - placeHolderHeight)/2.0
        var placeHolderX = CGFloat(0.0)
        for view in placeHolders {
            placeHolderX += view.frame.size.width
        }
        let button = PlaceHolderButton(frame: CGRect(x: placeHolderX, y: placeHolderY, width: 80.0, height: placeHolderHeight))
        button.setTitle(placeHolderString, for: .normal)
        button.placeHolderButtonType = type
        self.placeHolders.append(button)
        self.placeHolders[self.placeHolders.count-1].tag = self.placeHolders.count
        self.addSubview(placeHolders[placeHolders.count-1])
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationSearchBarIsEmpty), object: placeHolders.count == 0)
    }
    
    func addPlaceHolderTextField(Keyboard: UIView, Index: Int?) {
        placeHolderY = CGFloat(0.0)
        let placeHolderX = CGFloat(0.0)
        let newTextField = PlaceHolderTextField(frame: CGRect(x: placeHolderX, y: placeHolderY, width: 80.0, height: self.frame.height))
        newTextField.text = ""
        newTextField.inputView = Keyboard
        if let index = Index {
            self.placeHolders.insert(newTextField, at: index)
            self.placeHolders[index].tag = index + 1
            for i in index+1...placeHolders.count-1 {
                placeHolders[i].tag += 1
            }
        } else {
            self.placeHolders.append(newTextField)
            self.placeHolders[self.placeHolders.count-1].tag = self.placeHolders.count
        }
        self.refreshPlaceHolderView()
        self.addSubview(placeHolders[placeHolders.count-1])
        self.placeHolders[self.placeHolders.count-1].becomeFirstResponder()
    }
    
    func removePlaceHolders(Index: Int) {
        let leftMovement = placeHolders[Index].frame.size.width
        if (Index < self.placeHolders.count - 1) {
            for i in (Index + 1)...self.placeHolders.count-1 {
                self.placeHolders[i].frame.origin.x -= leftMovement
                self.placeHolders[i].tag -= 1
            }
        }
        self.placeHolders[Index].removeFromSuperview()
        self.placeHolders.remove(at: Index)

        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationSearchBarIsEmpty), object: placeHolders.count == 0)
        if placeHolders.count == 0 {
            selectedIndex = nil
        }
    }
    
    func refreshPlaceHolderView() {
        placeHolderY = CGFloat(0.0)
        var placeHolderX = CGFloat(0.0)
        for i in 0...placeHolders.count-1 {
            placeHolders[i].frame.origin.x = placeHolderX
            placeHolderX += placeHolders[i].frame.size.width
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
                return candidate
            }
        }
        return self
    }
    
    func selectComponent(Index: Int) {
        for i in 0...placeHolders.count-1 {
            if i != Index {
                if let Button = placeHolders[i] as? PlaceHolderButton {
                    Button.deselectButton()
                    placeHolders[i] = Button
                }
                placeHolders[i].resignFirstResponder()
            } else {
                if let Button = placeHolders[i] as? PlaceHolderButton {
                    Button.selectButton()
                    placeHolders[i] = Button
                }
                placeHolders[i].becomeFirstResponder()
            }
        }
        selectedIndex = Index
    }
    

}
