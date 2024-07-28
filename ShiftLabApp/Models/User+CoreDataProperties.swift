//
//  User+CoreDataProperties.swift
//  ShiftLabApp
//
//  Created by Станислав Дейнекин on 28.07.2024.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var name: String?
    @NSManaged public var surname: String?
    @NSManaged public var birthday: Date?
    @NSManaged public var login: String?
    @NSManaged public var passwords: String?
    @NSManaged public var id: Int16

}

extension User : Identifiable {

}
