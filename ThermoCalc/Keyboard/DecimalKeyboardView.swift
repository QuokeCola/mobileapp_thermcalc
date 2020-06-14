//
//  DecimalKeyboard.swift
//  ThermoCalc
//
//  Created by 钱晨 on 2020/4/4.
//  Copyright © 2020年 钱晨. All rights reserved.
//

import UIKit

class DecimalKeyboardView: UIView {
    
    var BGColor = UIColor(red: 214/255, green: 215/255, blue: 220/255, alpha: 1.0)
    var imagineWordSet = [String](repeating: "Unit", count: 10)
    var totalHeight = CGFloat(0.0)
    var totalWidth  = CGFloat(0.0)
    var DecimalButton = [KeyboardButton?](repeating: nil, count: 10)
    var ImagineView = UIScrollView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: CGFloat(55.0)))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        if(UIDevice.modelName.contains(find: "iPad") || UIApplication.shared.statusBarOrientation == .landscapeLeft || UIApplication.shared.statusBarOrientation == .landscapeRight) {
            
        } else {
            PortraitSetup()
            reloadImagineWords()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if(UIDevice.modelName.contains(find: "iPad") || UIApplication.shared.statusBarOrientation == .landscapeLeft || UIApplication.shared.statusBarOrientation == .landscapeRight) {
            
        } else {
            PortraitSetup()
            reloadImagineWords()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if(UIDevice.modelName.contains(find: "iPad") || UIApplication.shared.statusBarOrientation == .landscapeLeft || UIApplication.shared.statusBarOrientation == .landscapeRight) {
            
        } else {
            PortraitSetup()
            reloadImagineWords()
        }
    }
    
    // Set up imagine box.
    fileprivate func reloadImagineWords() {
        self.ImagineView.backgroundColor = BGColor
        self.ImagineView.delaysContentTouches = false
        self.ImagineView.showsVerticalScrollIndicator = false
        self.ImagineView.showsHorizontalScrollIndicator = false
        ImagineView.subviews.map { $0.removeFromSuperview() }
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
            ImagineView.addSubview(imagineButtons[i]!)
        }
    }
    
    fileprivate func PortraitSetup() {
        self.frame = CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.5)
        self.backgroundColor = BGColor
        totalHeight = self.frame.height - getBottomHeight() - ImagineView.bounds.height
        totalWidth  = UIScreen.main.bounds.width
        
        let buttonWidth  = totalWidth  * 0.3
        let buttonHeight = totalHeight * 0.2
        let spacingX = totalWidth * 0.025
        let spacingY = totalHeight * 0.04
        
        // Set up buttons from 0 to 9
        for i in 0...9 {
            var x = CGFloat(0.0)
            var y = CGFloat(0.0)
            
            let imagineHeight = self.ImagineView.bounds.height
            
            if (i == 0) {
                x = buttonWidth + 2 * spacingX
                y = 3*buttonHeight + 4 * spacingY + imagineHeight
            } else {
                x = (spacingX + buttonWidth ) * CGFloat((i-1)%3) + spacingX
                y = (spacingY + buttonHeight) * CGFloat((i-1)/3) + spacingY + imagineHeight
            }
            DecimalButton[i] = KeyboardButton(frame: CGRect(x: x, y: y, width: buttonWidth, height: buttonHeight))
            DecimalButton[i]?.setTitle("\(i)", for: .normal)
            DecimalButton[i]?.titleLabel!.font = UIFont.boldSystemFont(ofSize: (DecimalButton[i]?.bounds.height)! * 0.5)
            self.addSubview(DecimalButton[i]!)
            self.addSubview(ImagineView)
        }
        // Set up delete button and dot button
        let DeleteButton = KeyboardButton(frame: CGRect(x: (spacingX+buttonWidth)*2+spacingX, y: (spacingY+buttonHeight)*3+spacingY+ImagineView.bounds.height, width: buttonWidth, height: buttonHeight))
        DeleteButton.setImage(#imageLiteral(resourceName: "Backspace"), for: .normal)
        DeleteButton.setTitleColor(UIColor.black, for: .normal)
        DeleteButton.imageView?.tintColor = UIColor.black
        let DotButton = KeyboardButton(frame: CGRect(x: spacingX, y: (spacingY+buttonHeight)*3+spacingY+ImagineView.bounds.height, width: buttonWidth, height: buttonHeight))
        DotButton.setTitle(".", for: .normal)
        DotButton.setTitleColor(UIColor.black, for: .normal)
        DotButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: buttonHeight*0.5)
        self.addSubview(DeleteButton)
        self.addSubview(DotButton)
    }
    
    /**
     Change the imaginary word set
     @params imagineWordSet: a group of string contains imaginary words.
     */
    func updateImaginaryWords(stringSet: [String]) {
        self.imagineWordSet = stringSet
        self.reloadImagineWords()
    }
}
