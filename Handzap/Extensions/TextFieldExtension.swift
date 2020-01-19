//
//  TextFieldExtension.swift
//  Handzap
//
//  Created by Jagan on 18/01/20.
//  Copyright © 2020 Jagan. All rights reserved.
//

import Foundation
import UIKit
extension UITextField {
   func setBottomLine(colour:UIColor){
         let line = UIView()
         line.frame.size = CGSize(width: self.frame.size.width, height: 0.75)
                line.frame.origin = CGPoint(x: 0, y: self.frame.height - line.frame.height)
                line.backgroundColor = colour
                line.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
                self.addSubview(line)
     }
    func setLeftView(leftImageView: UIImage,bgColor:UIColor) {
        let imageView = UIImageView(frame: CGRect(x: 8, y: 7, width: 15, height: 15))
        imageView.image = leftImageView
        let viewLeft: UIView = UIView(frame: CGRect(x: 10, y: 0, width: 40, height: 40))
        let imageViewLeft: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        viewLeft.addSubview(imageViewLeft)

        imageViewLeft.layer.cornerRadius = imageViewLeft.frame.size.height/2
        imageViewLeft.backgroundColor = bgColor
        imageViewLeft.addSubview(imageView)
        leftView = viewLeft
        leftViewMode = UITextField.ViewMode.always
    }
}
