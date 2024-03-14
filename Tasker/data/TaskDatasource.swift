//
//  TaskDatasource.swift
//  Tasker
//
//  Created by Kyle Emmanuel Domingo on 3/13/24.
//

import Foundation
import RealmSwift

protocol TaskDatasource {
    func save(task: Task)
    func update(task: Task)
    func getAll(ascending: Bool) -> Results<Task>
    func delete(task: Task)
}

class TaskDatasourceImpl: TaskDatasource, ObservableObject {
    
    private var realm: Realm = try! Realm()
    
    func save(task: Task) {
        self.realm.writeAsync {
            self.realm.add(task)
        }
    }
    
    func update(task: Task) {
        self.realm.writeAsync {
            self.realm.add(task, update: .modified)
        }
    }
    
    func getAll(ascending: Bool = false) -> Results<Task> {
        return self.realm.objects(Task.self).sorted(by: \Task.deadline, ascending: ascending)
    }
    
    func getAllCompleted() -> Results<Task> {
        return self.realm.objects(Task.self).where { task in
            task.completed
        }
    }
    
    func delete(task: Task) {
        self.realm.writeAsync {
            self.realm.delete(task)
        }
    }
}
