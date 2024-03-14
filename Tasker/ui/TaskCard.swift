//
//  TaskCard.swift
//  Tasker
//
//  Created by Kyle Emmanuel Domingo on 3/14/24.
//

import SwiftUI

struct TaskCard: View {
    
    var taskDetails: Task? = nil
    var onCheckTapped: (Task) -> () = {_ in }
    
    @State private var completed: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            cardDetails
        }
        .frame(maxWidth: .infinity, maxHeight: 100)
        .background(Color.gray.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 8.0))
    }
    
    private var cardDetails: some View {
        
        @State var checked = taskDetails?.completed ?? false
        @State var deadline: String = ""
        
        let textSpacer = Spacer().frame(height: 8)
        
        return HStack {
            VStack(alignment: .leading) {
                Text(taskDetails?.title ?? "")
                    .font(.headline)
                    .strikethrough(completed)
                
                textSpacer
                
                Text(taskDetails?.taskDescription ?? "").strikethrough(completed)
                
                textSpacer
                
                Text(deadline).strikethrough(completed)
            }
            Spacer()
            RoundedRectangle(cornerRadius: 5.0)
                .fill(checked ? Color.blue : Color.blue.opacity(0.4))
                .frame(width: 25, height: 25)
                .overlay {
                    if checked {
                        Image(systemName: "checkmark")
                            .foregroundColor(Color.white)
                    }
                }
                .onTapGesture {
                    guard let thawedTask = taskDetails?.thaw() else { return }
                    thawedTask.realm?.writeAsync {
                        thawedTask.completed.toggle()
                        completed = thawedTask.completed
                        onCheckTapped(thawedTask)
                    }
                }
        }
        .frame(maxWidth: .infinity, maxHeight: 80)
        .padding(16.0)
        .onAppear {
            completed = taskDetails?.completed ??  false
            
            if let currentDeadline = taskDetails?.deadline {
                deadline = Date(timeIntervalSince1970: TimeInterval(currentDeadline)).formatted()
            }
        }
    }
}

#Preview {
    TaskCard(taskDetails: Task(
        title: "A task this is", taskDescription: "Yes, a task", deadline: 12345
    ))
}
