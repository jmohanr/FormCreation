//
//  SJView.swift
//  Handzap
//
//  Created by Jagan on 19/01/20.
//  Copyright © 2020 Jagan. All rights reserved.
//

import Foundation
import UIKit
@IBDesignable open class SJView:UIView {
    
    @IBInspectable var cornerRadius:Int {
        get {
            return Int(self.layer.cornerRadius)
        }
        set {
            self.layer.cornerRadius = CGFloat(newValue)
        }
    }
    @IBInspectable var borderWidth:Float {
           get {
               return Float(self.layer.borderWidth)
           }
           set {
               self.layer.borderWidth = CGFloat(newValue)
           }
       }
    @IBInspectable var borderColour:UIColor {
        get {
            return UIColor(cgColor: self.layer.borderColor!)
        }set{
            self.layer.borderColor = newValue.cgColor

        }
    }
}
