//
//  ViewModel.swift
//  ShiftLabApp
//
//  Created by Станислав Дейнекин on 25.07.2024.
//

import Foundation
import UIKit.UIColor

class ViewModel {
    var statusText = Dynamic("")
    var statusColor = Dynamic(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
    
    func userButtonPressed(login: String, password: String) {
        let isAuthenticated = StorageManager.shared.authenticateUser(login: login, password: password)
        
        if isAuthenticated != "" {
            statusText.value = "You succesfully logged in, \(isAuthenticated) "
                        statusColor.value = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        } else {
                        statusText.value = "Login in failed."
                        statusColor.value = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
        }
    }
    
    
    
}
