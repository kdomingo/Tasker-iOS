//
//  TasksScreen.swift
//  Tasker
//
//  Created by Kyle Emmanuel Domingo on 3/13/24.
//

import SwiftUI
import RealmSwift

struct TasksScreen: View {
    
    @EnvironmentObject private var taskViewModel: TasksViewModel
    
    @State var dialogActive: Bool = false
    @State var currentTask: Task? = nil
    
    @ObservedResults(
        Task.self
    ) private var tasks
    
    var body: some View {
        ZStack {
            TasksScreenContent(addAction: {
                if (!dialogActive) {
                    dialogActive = true
                }
            }, viewAction: { task in
                currentTask = task
                dialogActive = true
            }, completeAction: { task in
                taskViewModel.save(task: task)
            }, tasks: tasks)
            
            if dialogActive {
                TaskDialog(task: $currentTask, active: $dialogActive) { task in
                    taskViewModel.save(task: task)
                } onPositiveAction: { task in
                    
                } onNegativeAction: { task in
                    taskViewModel.delete(task: task)
                }
            }
        }
    }
}

private struct TasksScreenContent: View {
    
    var addAction: () -> ()
    var viewAction: (Task) -> ()
    var completeAction: (Task) -> ()
    
    var tasks: Results<Task>
    
    var body: some View {
        
        NavigationStack {
            
            ZStack(alignment: .bottomTrailing) {
                List {
                    ForEach(tasks, id: \.id) { task in
                        TaskCard(taskDetails: .constant(task),
                                 onCheckTapped: { task in
                            completeAction(task)
                        })
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0))
                        .listRowSeparator(.hidden)
                        .onTapGesture {
                            viewAction(task)
                        }
                    }
                }
                .navigationBarTitle("Tasks", displayMode: .inline)
                
                Button {
                    self.addAction()
                } label: {
                    Image(systemName: "plus")
                        .font(.title.weight(.semibold))
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }.padding(16)
            }
        }
    }
}
