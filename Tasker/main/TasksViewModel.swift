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
    
    init(taskService: TaskServiceDelegate) {
        self.taskService = taskService
    }
    
    func save(task: Task) {
        taskService.save(task: task)
    }
    
    func delete(task: Task) {
        taskService.delete(task: task)
    }
}
