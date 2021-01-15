//
//  SettingsViewController.swift
//  AebWeather
//
//  Created by Владислав Николаев on 14.01.2021.
//

import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate {
    var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.systemBackground
        
        textField = UITextField(frame: CGRect(x: 20, y: 100, width: 200, height: 40))
        textField.center = view.center
        textField.placeholder = "Enter API key here"
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        textField.delegate = self
        self.view.addSubview(textField)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(onSaveButtonPressed))
    }
    
    @objc func onSaveButtonPressed() {
        AebWeather.apiKey = textField.text!
    }
}
