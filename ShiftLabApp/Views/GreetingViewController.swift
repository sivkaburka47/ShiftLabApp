//
//  GreetingViewController.swift
//  ShiftLabApp
//
//  Created by Станислав Дейнекин on 31.07.2024.
//

import UIKit

class GreetingViewController: UIViewController {

    var username: String?

        override func viewDidLoad() {
            super.viewDidLoad()
            
            view.backgroundColor = .white
            
            let greetingLabel = UILabel()
            greetingLabel.text = "Привет, \(username ?? "Пользователь")!"
            greetingLabel.textAlignment = .center
            greetingLabel.font = UIFont.systemFont(ofSize: 24)
            greetingLabel.frame = view.bounds
            view.addSubview(greetingLabel)
            
            let dismissButton = UIButton(type: .system)
            dismissButton.setTitle("Закрыть", for: .normal)
            dismissButton.addTarget(self, action: #selector(dismissModal), for: .touchUpInside)
            dismissButton.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
            dismissButton.center = CGPoint(x: view.center.x, y: view.center.y + 50)
            view.addSubview(dismissButton)
        }
        
        @objc func dismissModal() {
            dismiss(animated: true, completion: nil)
        }
}
