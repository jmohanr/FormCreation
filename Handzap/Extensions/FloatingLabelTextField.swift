//
//  FloatingLabelTextField.swift
//  Handzap
//
//  Created by Jagan on 18/01/20.
//  Copyright © 2020 Jagan. All rights reserved.
//

import Foundation
import UIKit

class FloatingLabeledTextField: UITextField {

  var floatingLabel: UILabel!
  var placeHolderText: String?

  var floatingLabelColor: UIColor = UIColor.gray {
    didSet {
        self.floatingLabel.textColor = floatingLabelColor
    }
    }
   var floatingLabelFont: UIFont = UIFont.systemFont(ofSize: 15) {

      didSet {
        self.floatingLabel.font = floatingLabelFont
      }
   }

   var floatingLabelHeight: CGFloat = 20

   override init(frame: CGRect) {
     super.init(frame: frame)
   }

   required init?(coder aDecoder: NSCoder) {

    super.init(coder: aDecoder)

    let flotingLabelFrame = CGRect(x: 0, y: 0, width: frame.width, height: 0)

    floatingLabel = UILabel(frame: flotingLabelFrame)
    floatingLabel.textColor = floatingLabelColor
    floatingLabel.font = floatingLabelFont
    floatingLabel.text = self.placeholder
    self.addSubview(floatingLabel)
    placeHolderText = placeholder
    NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidBeginEditing), name: UITextField.textDidBeginEditingNotification, object: self)

     NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidEndEditing), name: UITextField.textDidEndEditingNotification, object: self)


}
  func addingBottomLine(colour:UIColor,textField:UITextField){
      let line = UIView()
      line.frame.size = CGSize(width: textField.frame.size.width, height: 0.75)
             line.frame.origin = CGPoint(x: 0, y: textField.frame.height - line.frame.height)
             line.backgroundColor = colour
             line.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
             textField.addSubview(line)
  }
   
@objc func textFieldDidBeginEditing(_ textField: UITextField) {

    if self.text == "" {
        UIView.animate(withDuration: 0.3) {
            self.floatingLabel.frame = CGRect(x: 0, y: -self.floatingLabelHeight, width: self.frame.width, height: self.floatingLabelHeight)

        }
        self.placeholder = ""
    }
}

@objc func textFieldDidEndEditing(_ textField: UITextField) {

    if self.text == "" {
        UIView.animate(withDuration: 0.1) {
           self.floatingLabel.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 0)
        }
        self.placeholder = placeHolderText
    }
}

deinit {

    NotificationCenter.default.removeObserver(self)

  }
}

