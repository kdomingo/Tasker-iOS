//
//  TaskDialog.swift
//  Tasker
//
//  Created by Kyle Emmanuel Domingo on 3/14/24.
//

import SwiftUI
import Combine

struct TaskDialog: View {
    
    @State private var offset: CGFloat = 300
    
    @Binding var task: Task?
    @Binding var active: Bool
    
    var onAuxAction: (Task) -> () = {_ in }
    var onPositiveAction: (Task) -> () = {_ in }
    var onNegativeAction: (Task) -> () = {_ in }
    
    @State private var title: String = ""
    @State private var details: String = ""
    @State private var deadline: String = ""
    @State private var completed: Bool = false
    
    @State private var isEditing: Bool = false
    @State private var isViewing: Bool = true
    
    @State private var titleIsError: Bool = false
    
    
    var body: some View {
        ZStack {
            Color(.black)
                .opacity(0.1)
                .onTapGesture {
                    close()
                }
            
            VStack(alignment: .leading) {
                
                HStack {
                    Spacer()
                    Button {
                        close()
                    } label: {
                        Image(systemName: "xmark")
                    }
                    .tint(.black)
                }
                
                Spacer().frame(height: 16)
                
                HStack {
                    TextField("Task title", text: $title)
                        .onReceive(Just(title)) {_ in 
                            titleIsError = false
                        }
                }
                .padding()
                .background()
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(titleIsError ? .red : .black.opacity(0.6), lineWidth: 1)
                }
                .clipShape(RoundedRectangle(cornerRadius: 8))
                
                HStack {
                    TextField("Task deadline", text: $deadline)
                    Button {
                        
                    } label: {
                        Image(systemName: "calendar")
                    }
                    .tint(.black)
                }
                .padding()
                .background()
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.black.opacity(0.6), lineWidth: 1)
                }
                .clipShape(RoundedRectangle(cornerRadius: 8))
                
                ZStack(alignment: .topLeading) {
                    
                    TextEditor(text: $details)
                        .frame(maxHeight: 100).background(.clear)
                    
                    if (details.isEmpty) {
                        Text("Task Description")
                            .opacity(0.2)
                    }
                    
                }
                .padding()
                .background()
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.black.opacity(0.6), lineWidth: 1)
                }
                .clipShape(RoundedRectangle(cornerRadius: 8))
                
                Spacer().frame(height: 32)
                
                if !isEditing {
                    Button {
                        if let currentTask = task {
                            currentTask.realm?.writeAsync {
                                currentTask.completed = true
                                onAuxAction(currentTask)
                            }
                        } else {
                            let newTask = Task(title: self.title,
                                               taskDescription: self.details,
                                               deadline: -1,
                                               completed: false)
                            onAuxAction(newTask)
                        }
                        close()
                        
                    } label: {
                        Text(nil == task ? "Save" : "Complete task")
                            .padding(8)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                }
                
                if (nil != task) {
                    HStack {
                        Button {
                            if (nil != task && !isEditing) {
                                isEditing = true
                                return
                            }
                            
                            if (isEditing) {
                                if (title.isEmpty) {
                                    titleIsError = true
                                    return
                                }
                                
                                if let currentTask = task {
                                    onPositiveAction(currentTask)
                                    close()
                                }
                            }
                        } label: {
                            Text(nil != task && !isEditing ? "Edit" : "Save")
                                .padding(8)
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        
                        Button {
                            if nil != self.task {
                                onNegativeAction(self.task!)
                            }
                            close()
                        } label: {
                            Text("Delete")
                                .padding(8)
                                .frame(maxWidth: .infinity)
                        }
                        .tint(Color.red)
                        .buttonStyle(.borderedProminent)
                    }
                }
                
            }
            .padding(24)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 24.0))
            .offset(x: 0, y: offset)
            .onAppear {
                title = $task.wrappedValue?.title ?? ""
                details = $task.wrappedValue?.taskDescription ?? ""
                completed = $task.wrappedValue?.completed ?? false
                isViewing = nil != task
                offset = 0
            }
            .padding(32)
        }
        .ignoresSafeArea()
    }
    
    func close() {
        offset = 300
        active = false
        task = nil
    }
}
