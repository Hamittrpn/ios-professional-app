//
//  UITextField+SecureToggle.swift
//  Bankey
//
//  Created by Hamit Tırpan on 30.01.2024.
//

import UIKit

let passwordToggleButton = UIButton(type: .custom)

extension UITextField{
    
    func enablePasswordToggle(){
        passwordToggleButton.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        passwordToggleButton.setImage(UIImage(systemName: "eye.fill"), for: .selected)
        passwordToggleButton.addTarget(self, action: #selector(togglePasswordView), for: .touchUpInside)
        rightView = passwordToggleButton
        rightViewMode = .always
    }
    
    @objc func togglePasswordView(_ sender: Any){
        isSecureTextEntry.toggle()
        passwordToggleButton.isSelected.toggle()
    }
}
