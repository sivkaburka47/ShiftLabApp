//
//  StorageManager.swift
//  ShiftLabApp
//
//  Created by Станислав Дейнекин on 27.07.2024.
//

import Foundation
import UIKit
import CoreData

public final class StorageManager: NSObject {
    public static let shared = StorageManager()
    private override init() {}
    
    private var appDelegate: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }
    
    private var context: NSManagedObjectContext {
        appDelegate.persistentContainer.viewContext
    }
    public func createUser(_ id: Int16, name: String, surname: String, birthday: Date, login: String, passwords: String) {
        guard let userEntityDescription = NSEntityDescription.entity(forEntityName: "User", in: context) else { return }
        let user = User(entity: userEntityDescription, insertInto: context)
        user.id = id
        user.name = name
        user.surname = surname
        user.birthday = birthday
        user.login = login
        user.passwords = passwords
        
        appDelegate.saveContext()
    }
    
    public func getNextUserId() -> Int16 {
            let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
            fetchRequest.fetchLimit = 1

            do {
                let lastUser = try context.fetch(fetchRequest).first
                return (lastUser?.id ?? -1) + 1
            } catch {
                return 0
            }
        }
    
    public func fetchUsers() -> [User] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        do {
            return (try? context.fetch(fetchRequest) as? [User]) ?? []
        }
    }
    
    func authenticateUser(login: String, password: String) -> String {
        if let user = fetchUser(login) {
            if user.passwords == password {
                return user.name ?? ""
            }
            
        }
        return ""
    }
    
    public func fetchUser(_ login: String) -> User? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        var users: [User]?
        do {
            users = try? context.fetch(fetchRequest) as? [User]
        }
        return users?.first(where: { $0.login == login })
    }
    
    public func updateUser(with id: Int16, login: String, newPassword: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        do {
            guard let users = try? context.fetch(fetchRequest) as? [User],
                  let user = users.first(where: {$0.login == login}) else { return }
            user.passwords = newPassword
        }
        
        appDelegate.saveContext()
    }
    
    public func deleteAllUsers() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        do {
            let users = try? context.fetch(fetchRequest) as? [User]
            users?.forEach {context.delete($0)}
        }
        appDelegate.saveContext()
    }
    
    public func deleteUser(with login: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        do {
            guard let users = try? context.fetch(fetchRequest) as? [User],
                  let user = users.first(where: { $0.login == login }) else { return }
            context.delete(user)
        }
        appDelegate.saveContext()
    }
}


