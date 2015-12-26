//
//  textFieldClass.swift
//  Hi
//
//  Created by Isaac Albets Ramonet on 22/12/15.
//  Copyright © 2015 Isaac Albets Ramonet. All rights reserved.
//

import UIKit

class TextFieldClass: UITextField {
    
    // MARK: Properties
    
    /* Constants for styling and configuration */
    
    let textFieldText = ""
    let darkBlueColor = UIColor(red: 0.0, green: 0.298, blue: 0.686, alpha:1.0)
    let fontSize : CGFloat = 17.0
    let textFieldHeight: CGFloat = 38.0
    let textFieldExtraPadding : CGFloat = 14.0
    var leftMargin : CGFloat = 32.0
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        var newBounds = bounds
        newBounds.origin.x += leftMargin
        return newBounds
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        var newBounds = bounds
        newBounds.origin.x += leftMargin
        return newBounds
    }
    
    override func becomeFirstResponder() -> Bool {
        return true
    }
    
    func themeTextField(){
        self.text = textFieldText
        self.textColor = darkBlueColor
        self.font = UIFont(name: "Helvetica Neue Light", size: fontSize)
        self.userInteractionEnabled = true
        self.becomeFirstResponder()
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        self.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    override func sizeThatFits(size: CGSize) -> CGSize {
        let extraButtonPadding : CGFloat = textFieldExtraPadding
        var sizeThatFits = CGSizeZero
        sizeThatFits.width = super.sizeThatFits(size).width + extraButtonPadding
        sizeThatFits.height = textFieldHeight
        return sizeThatFits
    }
    
}