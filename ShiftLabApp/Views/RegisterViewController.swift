//
//  RegisterViewController.swift
//  ShiftLabApp
//
//  Created by Станислав Дейнекин on 28.07.2024.
//

import UIKit

class RegisterViewController : UIViewController {
    
    @IBOutlet var loginTextField: UITextField!
    
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var passwordRepeatTextField: UITextField!
    
    @IBOutlet var InfoTextField: UILabel!
    
    @IBAction func registerButtonPressed() {
        
        
        guard let login = loginTextField.text, !login.isEmpty,
                  let password = passwordTextField.text, !password.isEmpty,
                  let passwordRepeat = passwordRepeatTextField.text, !passwordRepeat.isEmpty else {
                InfoTextField.text = "Отсутствует логин или пароль!"
                return
            }

            let loginPattern = "^[a-zA-Z]+$"
            let loginPredicate = NSPredicate(format: "SELF MATCHES %@", loginPattern)
            guard loginPredicate.evaluate(with: login) else {
                InfoTextField.text = "Логин должен содержать только английские буквы!"
                return
            }

            let passwordPattern = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{10,}$"
            let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordPattern)
            guard passwordPredicate.evaluate(with: password) else {
                InfoTextField.text = "Пароль должен быть не менее 10 символов, содержать буквы английского алфавита и цифры!"
                return
            }

            guard password == passwordRepeat else {
                InfoTextField.text = "Пароли не совпадают!"
                return
            }

            let newUserId = StorageManager.shared.getNextUserId()
            StorageManager.shared.createUser(newUserId, login: login, passwords: password)
            dismiss(animated: true)
        
    }
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
