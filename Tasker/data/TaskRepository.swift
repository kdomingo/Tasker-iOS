//
//  TaskRepository.swift
//  Tasker
//
//  Created by Kyle Emmanuel Domingo on 3/13/24.
//

import Foundation
import RealmSwift

protocol TaskRepository {
    func save(task: Task)
    func getAll(ascending: Bool) -> Results<Task>
    func delete(task: Task)
}

class TaskRepositoryImpl: TaskRepository, ObservableObject {
    
    private var taskDatasource: TaskDatasource
    
    init(taskDatasource: TaskDatasource) {
        self.taskDatasource = taskDatasource
    }
    
    func save(task: Task) {
        self.taskDatasource.save(task: task)
    }
    
    func getAll(ascending: Bool) -> Results<Task> {
        return self.taskDatasource.getAll(ascending: ascending)
    }
    
    func delete(task: Task) {
        self.taskDatasource.delete(task: task)
    }
}
