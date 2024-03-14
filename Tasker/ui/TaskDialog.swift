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
    var onDeadlineAction: () -> () = {}
    
    @State private var title: String = ""
    @State private var details: String = ""
    @State private var deadline: String = ""
    @State private var completed: Bool = false
    
    @State private var isEditing: Bool = false
    @State private var isViewing: Bool = true
    
    @State private var titleIsError: Bool = false
    
    
    @State private var showDatepicker: Bool = false
    @State private var deadlineDate: Date = Date()
    
    
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
                        .disabled(isViewing && !isEditing)
                        .onReceive(Just(title)) {_ in
                            titleIsError = false
                        }
                }
                .padding()
                .background()
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(titleIsError ? .red : .black.opacity(0.6), lineWidth: titleIsError ? 2 : 1)
                }
                .clipShape(RoundedRectangle(cornerRadius: 8))
                
                HStack {
                    TextField("Task deadline", text: $deadline)
                        .disabled(isViewing && !isEditing)
                    Button {
                        showDatepicker = true
                        onDeadlineAction()
                    } label: {
                        Image(systemName: "calendar")
                    }
                    .tint(.black)
                    .disabled((completed || (isViewing && !isEditing)))
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
                        .disabled(isViewing && !isEditing)
                    
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
                            guard let thawedTask = currentTask.thaw() else { return }
                            thawedTask.realm?.writeAsync {
                                thawedTask.completed = true
                                onAuxAction(thawedTask)
                                close()
                            }
                        } else {
                            if !title.isEmpty {
                                let newTask = Task(title: self.title,
                                                   taskDescription: self.details,
                                                   deadline: deadlineDate.timeIntervalSince1970,
                                                   completed: false)
                                onAuxAction(newTask)
                                close()
                            } else {
                                titleIsError = true
                            }
                        }
                        
                    } label: {
                        Text(nil == task ? "Save" : "Complete task")
                            .padding(8)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(completed)
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
                                    guard let thawedTask = currentTask.thaw() else { return }
                                    thawedTask.realm?.writeAsync {
                                        thawedTask.title = $title.wrappedValue
                                        thawedTask.taskDescription = $details.wrappedValue
                                        thawedTask.deadline = deadlineDate.timeIntervalSince1970
                                        onPositiveAction(thawedTask)
                                        close()
                                    }
                                }
                            }
                        } label: {
                            Text(nil != task && !isEditing ? "Edit" : "Save")
                                .padding(8)
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(completed)
                        
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
                if let currentDeadline = $task.wrappedValue?.deadline {
                    deadline = Date(timeIntervalSince1970: TimeInterval(currentDeadline)).formatted(date: .abbreviated, time: .omitted)
                }
                isViewing = nil != task
                offset = 0
            }
            .padding(32)
            
            if showDatepicker {
                VStack {
                    DatePicker("Select Deadline", selection: $deadlineDate, displayedComponents: [.date])
                        .datePickerStyle(.graphical)
                        .onChange(of: deadlineDate) { oldValue, newValue in
                            deadline = newValue.formatted(date: .abbreviated, time: .omitted)
                            showDatepicker = false
                        }
                }
                .background()
                .padding(16)
            }
        }
        .ignoresSafeArea()
    }
    
    func close() {
        offset = 300
        active = false
        task = nil
    }
}
