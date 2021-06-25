//
//  UIViewController+Extension.swift
//  Activity App
//
//  Created by Josip Marković on 25.06.2021..
//

import Foundation
import UIKit

public extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showAlertWith(title: String?, message: String?, action: UIAlertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil), anotherAction: UIAlertAction? = nil){
        let alert: UIAlertController = {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(action)
            if anotherAction != nil {
                alert.addAction(anotherAction!)
            }
            return alert
        }()
        self.present(alert, animated: true, completion: nil)
    }
    
}
