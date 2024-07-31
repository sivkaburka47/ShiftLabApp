//
//  ViewController.swift
//  ShiftLabApp
//
//  Created by Станислав Дейнекин on 25.07.2024.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var loginField: UITextField!
    
    @IBOutlet var passwordField: UITextField!
    
    @IBAction func goToRegister(_ sender: Any) {
        let storyboard = UIStoryboard(name: "RegisterView", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        present(vc, animated: true)
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        let userName = viewModel.userButtonPressed(login: (loginField.text ?? ""), password: (passwordField.text ?? ""))
        if userName != nil {
            let tableScreenViewController = storyboard?.instantiateViewController(withIdentifier: "TableScreenViewController") as! TableScreenViewController
            
            tableScreenViewController.username = userName

            if let window = UIApplication.shared.windows.first {
                window.rootViewController = tableScreenViewController
                window.makeKeyAndVisible()
                
                let transition = CATransition()
                transition.type = .fade
                transition.duration = 0.3
                window.layer.add(transition, forKey: kCATransition)
            }
        }
        
    }
    @IBOutlet var label: UILabel!
    
    var viewModel = ViewModel()
    
    func initialState() {
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        initialState()
    }
    
    func bindViewModel() {
        viewModel.statusText.bind({ 
            (statusText) in
            DispatchQueue.main.async {
                self.label.text = statusText
            }
        })
        viewModel.statusColor.bind({(statusColor) in
            DispatchQueue.main.async {
                self.label.textColor = statusColor
            }
        })
    }


}

