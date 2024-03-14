//
//  TasksViewModel.swift
//  Tasker
//
//  Created by Kyle Emmanuel Domingo on 3/13/24.
//

import Foundation

import Combine
import RealmSwift

class TasksViewModel: ObservableObject {

    private var taskService: TaskServiceDelegate
    private var anyCancellable: AnyCancellable?
    
    @ObservedResults(
        Task.self
    ) var tasks
    
    init(taskService: TaskServiceDelegate) {
        self.taskService = taskService
        _ = tasks.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
        }
    }
    
    func fetchTasks() -> Results<Task> {
        return self.taskService.getAll(ascending: false)
    }
    
    func save(task: Task) {
        taskService.save(task: task)
    }
    
    func update(task: Task) {
        taskService.update(task: task)
    }
    
    func delete(task: Task) {
        taskService.delete(task: task)
    }
}
