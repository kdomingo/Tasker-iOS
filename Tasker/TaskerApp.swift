//
//  TaskerApp.swift
//  Tasker
//
//  Created by Kyle Emmanuel Domingo on 3/13/24.
//

import SwiftUI

@main
struct TaskerApp: App {
    
    private let taskService = TaskService(taskRepository: TaskRepositoryImpl(taskDatasource: TaskDatasourceImpl()))

    var body: some Scene {
        WindowGroup {
            TasksScreen()
                .environmentObject(TasksViewModel(taskService: taskService))
        }
    }
}
