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
        
        let textSpacer = Spacer().frame(height: 8)
        
        return HStack {
            VStack(alignment: .leading) {
                Text(taskDetails?.title ?? "").font(.headline)
                textSpacer
                Text(taskDetails?.taskDescription ?? "")
                textSpacer
                Text("\(taskDetails?.deadline ?? 0)")
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
                    if let toComplete = taskDetails {
                        toComplete.realm?.writeAsync {
                            toComplete.completed.toggle()
                            onCheckTapped(toComplete)
                        }
                    }
                }
        }
        .frame(maxWidth: .infinity, maxHeight: 80)
        .padding(16.0)
    }
}

#Preview {
    TaskCard(taskDetails: Task(
        title: "A task this is", taskDescription: "Yes, a task", deadline: 12345
    ))
}
