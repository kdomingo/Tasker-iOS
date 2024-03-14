//
//  Task.swift
//  Tasker
//
//  Created by Kyle Emmanuel Domingo on 3/13/24.
//

import Foundation
import RealmSwift

class Task: Object, ObjectKeyIdentifiable {
    @Persisted var title: String? = nil
    @Persisted var taskDescription: String? = nil
    @Persisted var deadline: Double? = nil
    @Persisted var completed: Bool = false
    
    convenience init(title: String?, taskDescription: String?, deadline: Double?, completed: Bool = false) {
        self.init()
        self.title = title
        self.taskDescription = taskDescription
        self.deadline = deadline
        self.completed = completed
    }
}
