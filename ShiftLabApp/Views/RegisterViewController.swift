//
//  RegisterViewController.swift
//  ShiftLabApp
//
//  Created by Станислав Дейнекин on 28.07.2024.
//

import UIKit

class RegisterViewController : UIViewController, UITextFieldDelegate {
    
    @IBOutlet var nameField: UITextField!
    
    @IBOutlet var surnameField: UITextField!
    
    @IBOutlet var loginTextField: UITextField!
    
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var dateBirthdayField: UITextField!
    
    @IBOutlet var passwordRepeatTextField: UITextField!
    
    @IBOutlet var InfoTextField: UILabel!
    
    @IBOutlet var registerButton: UIButton!
    
    
    let datePicker = UIDatePicker()
    let dateFormatter = DateFormatter()
    
    @IBAction func registerButtonPressed() {
        guard let name = nameField.text, !name.isEmpty,
                      let surname = surnameField.text, !surname.isEmpty,
                      let birthdayText = dateBirthdayField.text, !birthdayText.isEmpty,
                      let login = loginTextField.text, !login.isEmpty,
                      let password = passwordTextField.text, !password.isEmpty,
                      let passwordRepeat = passwordRepeatTextField.text, !passwordRepeat.isEmpty else {
                    InfoTextField.text = "Все поля должны быть заполнены!"
                    InfoTextField.textColor = .red
                    return
                }
                
                let namePattern = "^[a-zA-Zа-яА-Я]+$"
                let namePredicate = NSPredicate(format: "SELF MATCHES %@", namePattern)
                guard namePredicate.evaluate(with: name) else {
                    InfoTextField.text = "Имя должно содержать только буквы русского или английского алфавита!"
                    InfoTextField.textColor = .red
                    return
                }
                
                let surnamePredicate = NSPredicate(format: "SELF MATCHES %@", namePattern)
                guard surnamePredicate.evaluate(with: surname) else {
                    InfoTextField.text = "Фамилия должна содержать только буквы русского или английского алфавита!"
                    InfoTextField.textColor = .red
                    return
                }
                
                let loginPattern = "^[a-zA-Z]+$"
                let loginPredicate = NSPredicate(format: "SELF MATCHES %@", loginPattern)
                guard loginPredicate.evaluate(with: login) else {
                    InfoTextField.text = "Логин должен содержать только английские буквы!"
                    InfoTextField.textColor = .red
                    return
                }
                
                let passwordPattern = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{10,}$"
                let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordPattern)
                guard passwordPredicate.evaluate(with: password) else {
                    InfoTextField.text = "Пароль должен быть не менее 10 символов, содержать буквы английского алфавита и цифры!"
                    InfoTextField.textColor = .red
                    return
                }
                
                guard password == passwordRepeat else {
                    InfoTextField.text = "Пароли не совпадают!"
                    InfoTextField.textColor = .red
                    return
                }
                
        guard let birthday = dateFormatter.date(from: birthdayText) else {
                    InfoTextField.text = "Неверный формат даты!"
                InfoTextField.textColor = .red
                    return
                }
                
                let newUserId = StorageManager.shared.getNextUserId()
                StorageManager.shared.createUser(newUserId, name: name, surname: surname, birthday: birthday, login: login, passwords: password)
                
        InfoTextField.text = "Вы успешно зарегистрировались, \(name)!"
                InfoTextField.textColor = .green
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.dismiss(animated: true)
        }
                
    }
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        InfoTextField.textColor = .white
        
        nameField.delegate = self
        surnameField.delegate = self
        loginTextField.delegate = self
        passwordTextField.delegate = self
        dateBirthdayField.delegate = self
        passwordRepeatTextField.delegate = self
                
                
        nameField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        surnameField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        loginTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        dateBirthdayField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordRepeatTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        
        dateBirthdayField.inputView = datePicker
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        let localeID = Locale.preferredLanguages.first
        datePicker.locale = Locale( identifier: localeID! )
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        toolBar.setItems([flexSpace, doneButton], animated: true)
        
        let yearAgo = Calendar.current.date(byAdding: .year, value: -100, to: Date())
        let yearLater = Calendar.current.date(byAdding: .year, value: -18, to: Date())
        datePicker.maximumDate = yearLater
        datePicker.minimumDate = yearAgo
        
        dateBirthdayField.inputAccessoryView = toolBar
        
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        
        checkRegisterButtonState()
    }
    
    
    @objc func doneAction() {
        getDateFromPicker()
        view.endEditing(true)
        checkRegisterButtonState()
    }
    
    func getDateFromPicker() {
         let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        dateBirthdayField.text = formatter.string(from : datePicker.date)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
            InfoTextField.textColor = .white
            InfoTextField.text = ""
            checkRegisterButtonState()
        }
        
        func checkRegisterButtonState() {
            let isFormValid = !nameField.text!.isEmpty &&
                              !surnameField.text!.isEmpty &&
                              !loginTextField.text!.isEmpty &&
                              !passwordTextField.text!.isEmpty &&
                              !dateBirthdayField.text!.isEmpty &&
                              !passwordRepeatTextField.text!.isEmpty
            registerButton.isEnabled = isFormValid
        }
}
