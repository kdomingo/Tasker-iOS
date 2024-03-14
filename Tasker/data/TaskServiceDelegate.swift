//
//  TaskService.swift
//  Tasker
//
//  Created by Kyle Emmanuel Domingo on 3/13/24.
//

import Foundation
import RealmSwift

protocol TaskServiceDelegate {
    func save(task: Task)
    func getAll(ascending: Bool) -> Results<Task>
    func delete(task: Task)
}

class TaskService: TaskServiceDelegate, ObservableObject {

    private var taskRepository: TaskRepository

    init(taskRepository: TaskRepository) {
        self.taskRepository = taskRepository
    }
    
    func save(task: Task) {
        taskRepository.save(task: task)
    }
    
    func getAll(ascending: Bool = false) -> Results<Task> {
        return taskRepository.getAll(ascending: ascending)
    }
    
    func delete(task: Task) {
        taskRepository.delete(task: task)
    }
}
