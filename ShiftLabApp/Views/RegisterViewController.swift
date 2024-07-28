//
//  RegisterViewController.swift
//  ShiftLabApp
//
//  Created by Станислав Дейнекин on 28.07.2024.
//

import UIKit

class RegisterViewController : UIViewController {
    
    @IBOutlet var nameField: UITextField!
    
    @IBOutlet var surnameField: UITextField!
    
    @IBOutlet var loginTextField: UITextField!
    
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var dateBirthdayField: UITextField!
    
    @IBOutlet var passwordRepeatTextField: UITextField!
    
    @IBOutlet var InfoTextField: UILabel!
    
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
                    return
                }
                
                let namePattern = "^[a-zA-Zа-яА-Я]+$"
                let namePredicate = NSPredicate(format: "SELF MATCHES %@", namePattern)
                guard namePredicate.evaluate(with: name) else {
                    InfoTextField.text = "Имя должно содержать только буквы русского или английского алфавита!"
                    return
                }
                
                let surnamePredicate = NSPredicate(format: "SELF MATCHES %@", namePattern)
                guard surnamePredicate.evaluate(with: surname) else {
                    InfoTextField.text = "Фамилия должна содержать только буквы русского или английского алфавита!"
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
                
        guard let birthday = dateFormatter.date(from: birthdayText) else {
                    InfoTextField.text = "Неверный формат даты!"
                    return
                }
                
                let newUserId = StorageManager.shared.getNextUserId()
                StorageManager.shared.createUser(newUserId, name: name, surname: surname, birthday: birthday, login: login, passwords: password)
                
                
                dismiss(animated: true)
    }
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
    }
    
    @objc func doneAction() {
        getDateFromPicker()
        view.endEditing(true)
    }
    func getDateFromPicker() {
         let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        dateBirthdayField.text = formatter.string(from : datePicker.date)
    }
}
