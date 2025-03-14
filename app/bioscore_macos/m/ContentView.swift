//
//  ContentView.swift
//  m
//
//  Created by ewan decima on 3/14/25.
//

import SwiftUI

struct ContentView: View {
    @State private var biomarkerName: String = ""
    @State private var currentQuestion: Question = .start
    @State private var result: String = ""
    @State private var questionHistory: [Question] = []
    @State private var showResult: Bool = false
    var body: some View {
        VStack {
            Text("Biomarkers classification")
                .font(.largeTitle)
                .padding()
            Spacer()
            if currentQuestion == .start {
                TextField("Enter the biomarkers name", text: $biomarkerName)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button{
                    if !biomarkerName.isEmpty {
                        currentQuestion = .question1
                    }
                } label: {
                    Text("Start")
                }
                .buttonStyle(.borderedProminent)
            } else if showResult {
                VStack(spacing: 15) {
                    Text("Result for: \(biomarkerName)")
                        .font(.headline)
                    Text(result)
                        .font(.title2)
                        .padding()
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.blue.opacity(0.1))
                        )
                    
                    Button("Restart") {
                        reset()
                    }
                    .buttonStyle(.borderedProminent)
                }
            } else {
                VStack(spacing: 15) {
                    Text(currentQuestion.text)
                        .font(.headline)
                        .padding()
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.blue.opacity(0.1))
                        )
                    
                    
                    HStack(spacing: 20) {
                        Button("Yes") {
                            processAnswer(true)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.green)
                        
                        
                        
                        Button("No") {
                            processAnswer(false)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.red)
                    }
                    
//                    if !questionHistory.isEmpty {
//                        Button("Back"){
//                            goBack()
//                        }
//                        .buttonStyle(.bordered)
//                    }
                    
                }
            }
            
            
            Spacer()
            
            
            
            
        }
        .padding()
        
        
        
        
    }
    
    
    private func processAnswer(_ answer: Bool) {
        questionHistory.append(currentQuestion)
        
        let nextQuestion = answer ? currentQuestion.yesPath : currentQuestion.noPath
        
        if let nextQuestion = nextQuestion {
            if nextQuestion == .notADevice || nextQuestion == .enforceDiscretion || nextQuestion == .final {
                result = nextQuestion.text
                showResult = true
            }
            currentQuestion = nextQuestion
            
        } else {
            // we reach a result
            result = currentQuestion.text
            showResult = true
        }
        
        
    }
    
    private func reset() {
        biomarkerName = ""
        currentQuestion = .start
        showResult = false
        result = ""
        questionHistory = []
    }
    
    
    
    
    
    
}

#Preview {
    ContentView()
}
