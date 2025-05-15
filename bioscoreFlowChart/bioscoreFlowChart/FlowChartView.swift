//
//  FlowChartView.swift
//  bioscoreFlowChart
//
//  Created by ewan decima on 5/15/25.
//


//
//  FlowChartView.swift
//  bioscoreFlowChart
//
//  Created on 5/15/25.
//

import SwiftUI

struct FlowChartView: View {
    @ObservedObject var state: FlowState
    @State private var currentStepId: Int = 0
    @State private var textInput: String = ""
    @State private var isComplete: Bool = false
    @State private var resultMessage: String = ""
    
    // Create the steps using the state
    var steps: [AnyStep] {
        makeSteps(state: state)
    }
    
    // Find the current step
    var currentStep: AnyStep? {
        steps.first { step in
            switch step {
            case .question(let id, _, _, _, _, _, _),
                 .inputQuestion(let id, _, _, _, _, _),
                 .function(let id, _, _, _),
                 .functionDecision(let id, _, _, _, _),
                 .multipleChoice(let id, _, _, _):
                return id == currentStepId
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Display current step
            if let step = currentStep {
                stepView(for: step)
            } else if isComplete {
                Text(resultMessage)
                    .font(.title)
                    .foregroundColor(.green)
                    .padding()
                
                Button("Start Over") {
                    resetFlow()
                }
                .buttonStyle(.borderedProminent)
            } else {
                Text("No step found with ID: \(currentStepId)")
                    .foregroundColor(.red)
            }
            
            // Debug info
            if !isComplete {
                Divider()
                VStack(alignment: .leading) {
                    Text("Debug Info:")
                        .font(.headline)
                    
                    Text("Current Step ID: \(currentStepId)")
                    Text("Biomarker: \(state.biomarkerName)")
                    Text("Scores: C=\(state.consistencyScore), R=\(state.reproducibilityScore), S=\(state.specificityScore)")
                }
                .font(.caption)
                .foregroundColor(.gray)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            }
        }
        .padding()
        .onAppear {
            // Reset flow when view appears
            resetFlow()
        }
    }
    
    // Reset the flow
    private func resetFlow() {
        currentStepId = 0
        textInput = ""
        isComplete = false
        resultMessage = ""
    }
    
    // Process the current step and move to the next
    private func processStep(_ step: AnyStep) {
        switch step {
        case .function(_, let execute, let next, let end):
            execute(nil)
            if end {
                completeFlow()
            } else if let next = next {
                currentStepId = next
            }
            
        case .functionDecision(_, let test, let yes, let no, let end):
            let result = test(nil)
            if end {
                completeFlow()
            } else {
                currentStepId = result ? yes : no
            }
            
        default:
            break // Other cases are handled by user interaction
        }
    }
    
    // Complete the flow and set result message
    private func completeFlow() {
        isComplete = true
        // Set appropriate result message based on final step
        switch currentStepId {
        case 5:
            resultMessage = "Result: Not a good biomarker"
        case 7:
            resultMessage = "Result: Clinical use case detected - out of scope"
        case 28:
            resultMessage = "Result: Unproven significance"
        case 29:
            resultMessage = "Result: High scientific significance"
        default:
            resultMessage = "Flow completed at step \(currentStepId)"
        }
    }
    
    // View for handling different step types
    @ViewBuilder
    private func stepView(for step: AnyStep) -> some View {
        switch step {
        case .question(_, let question, let next, let decision, let yes, let no, let end):
            questionStepView(question: question, next: next, decision: decision, yes: yes, no: no, end: end)
            
        case .inputQuestion(_, let question, let inputType, let update, let next, let end):
            inputQuestionStepView(question: question, inputType: inputType, update: update, next: next, end: end)
            
        case .multipleChoice(_, let question, let options, let end):
            multipleChoiceStepView(question: question, options: options, end: end)
            
        case .function(_, _, _, _), .functionDecision(_, _, _, _, _):
            ProgressView("Processing...")
                .onAppear {
                    // Automatically process function steps
                    if let step = currentStep {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            processStep(step)
                        }
                    }
                }
        }
    }
    
    // View for question steps
    private func questionStepView(question: String, next: Int?, decision: Bool, yes: Int?, no: Int?, end: Bool) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(question)
                .font(.title3)
                .fontWeight(.semibold)
            
            if decision {
                HStack(spacing: 16) {
                    Button("Yes") {
                        if let yes = yes {
                            currentStepId = yes
                        } else if end {
                            completeFlow()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button("No") {
                        if let no = no {
                            currentStepId = no
                        } else if end {
                            completeFlow()
                        }
                    }
                    .buttonStyle(.bordered)
                }
            } else {
                Button("Continue") {
                    if let next = next {
                        currentStepId = next
                    } else if end {
                        completeFlow()
                    }
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
    
    // View for input question steps
    private func inputQuestionStepView(question: String, inputType: String, update: @escaping (String) -> Void, next: Int?, end: Bool) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(question)
                .font(.title3)
                .fontWeight(.semibold)
            
            if inputType.lowercased() == "text" {
                TextField("Enter text", text: $textInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.vertical)
            } else {
                TextField("Enter number", text: $textInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    .padding(.vertical)
            }
            
            Button("Submit") {
                update(textInput)
                textInput = ""
                
                if let next = next {
                    currentStepId = next
                } else if end {
                    completeFlow()
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(textInput.isEmpty)
        }
    }
    
    // View for multiple choice steps
    private func multipleChoiceStepView(question: String, options: [(text: String, next: Int)], end: Bool) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(question)
                .font(.title3)
                .fontWeight(.semibold)
            
            ForEach(options, id: \.text) { option in
                Button(option.text) {
                    currentStepId = option.next
                    if end {
                        completeFlow()
                    }
                }
                .buttonStyle(.bordered)
                .padding(.vertical, 4)
            }
        }
    }
}

#Preview {
    let previewState = FlowState()
    return FlowChartView(state: previewState)
}
