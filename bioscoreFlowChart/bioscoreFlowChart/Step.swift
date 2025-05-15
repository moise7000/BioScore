//
//  Step.swift
//  bioscoreFlowChart
//
//  Created by ewan decima on 5/15/25.
//

import Foundation

enum AnyStep {
    case question(
        id: Int,
        question: String,
        next: Int?,
        decision: Bool,
        yes: Int?,
        no: Int?,
        end: Bool
    )
    
    case inputQuestion(
        id: Int,
        question: String,
        inputType: String,
        update: (String) -> Void,
        next: Int?,
        end: Bool
    )

    case function(
        id: Int,
        execute: (Any?) -> Any?,
        next: Int?,
        end: Bool
    )

    case functionDecision(
        id: Int,
        test: (Any?) -> Bool,
        yes: Int,
        no: Int,
        end: Bool
    )

    case multipleChoice(
        id: Int,
        question: String,
        options: [(text: String, next: Int)],
        end: Bool
    )
}




func makeSteps(state: FlowState) -> [AnyStep] {
    return [
        .inputQuestion(
            id: 0,
            question: "Enter biomarker name",
            inputType: "text",
            update: { input in
                state.biomarkerName = input
            },
            next: 1,
            end: false
        ),
        
        .inputQuestion(
            id: 1,
            question: "Enter consistency value",
            inputType: "Float",
            update: { input in
                if let val = Float(input) {
                    state.consistencyScore = val
                }
            },
            next: 2,
            end: false
        ),
        
        .inputQuestion(
            id: 2,
            question: "Enter reproducibility value",
            inputType: "Float",
            update: { input in
                if let val = Float(input) {
                    state.reproducibilityScore = val
                }
            },
            next: 3,
            end: true
        ),
        
        .inputQuestion(
            id: 3,
            question: "Enter specificity value",
            inputType: "Float",
            update: { input in
                if let val = Float(input) {
                    state.specificityScore = val
                }
            },
            next: 4,
            end: true
        ),
        
        .functionDecision(id: 4, test: { _ in
            state.specificityScore > state.ts && state.reproducibilityScore > state.tr && state.consistencyScore > state.tc
        }, yes: 6, no: 5, end: false),
        
        .question(id: 5, question: "Not a good biomarker", next: nil, decision: false, yes: nil, no: nil, end: true),
        
        
        
        
        .multipleChoice(id: 6, question: "Taking into account the biomarker's hypothesis developement and the intended use or purpose of the test, how you would like to classify this biomarker?", options: [("General wellness", 8), ("Clinical", 7)], end: false),
        
        .question(id: 7, question: "Detected clinical use: this case is out of scope for the algorithm", next: nil, decision: false, yes: nil, no: nil, end: true),
        
        
        .functionDecision(id: 8, test: { _ in state.backendEnablerActive}, yes: 12, no: 9, end: false),
        
        .multipleChoice(id: 9, question: "Does the biomarker represent improvement of general health?", options: [("Yes", 16), ("No",10)], end: false),
        
        .multipleChoice(id: 10, question: "Does the biomarke help reduce the risk of chronic diseases or conditions?", options: [("Yes", 16), ("No",11)], end: false),
        
        .multipleChoice(id: 11, question: "Does the biomarker help support living well with certain chronic diseases or conditions?", options: [("Yes", 16), ("No",12)], end: false),
        
        
        .inputQuestion(
            id: 12,
            question: "Enter value for improvement of general state of health",
            inputType: "Float",
            update: { input in
            if let val = Float(input) {
                state.improvementGeneralHealth = val
            }
            }, next: 13,
            end: false
        ),
        
        .inputQuestion(
            id: 13,
            question: "Enter value for help in reducing the risk of chronic diseases or condition",
            inputType: "Float",
            update: { input in
            if let val = Float(input) {
                state.riskReductionChronicDisease = val
            }
            }, next: 14,
            end: false
        ),
        
        .inputQuestion(
            id: 14,
            question: "Enter value for help in living well with certain chronic diseases or condition",
            inputType: "Float",
            update: { input in
            if let val = Float(input) {
                state.supportLivingWithChronicDisease = val
            }
            }, next: 15,
            end: false
        ),
        
        .functionDecision(id: 15, test: { _ in
            state.improvementGeneralHealth > state.t1 || state.riskReductionChronicDisease > state.t2 || state.supportLivingWithChronicDisease > state.t3
        }, yes: 16, no: 12, end: false),
        
        .question(id: 16, question: "Health outcomes generally accepted.", next: 17, decision: false, yes: nil, no: nil, end: false),
        
        .multipleChoice(id: 17, question: "Are there peer-reviewed scientific publications", options: [("Yes",18), ("No",22)], end: false),
        
        .inputQuestion(id: 18, question: "Enter the journal impact factor", inputType: "Float", update: { input in
            state.currentImpactFactor = 0
            if let val = Float(input) {
                state.currentImpactFactor = val
            }
        }, next: 19, end: false),
        
        .inputQuestion(id: 19, question: "Enter the number of publication for this journal ", inputType: "int", update: { input in
            state.currentPublicationsCount = 0
            if let val = Int(input) {
                state.currentPublicationsCount = val
            }
        }, next: 20, end: false),
        
        
        .functionDecision(id: 20, test: { _ in
            state.currentImpactFactor > 4
        }, yes: 21, no: 17, end: false),
        
        .function(id: 21, execute: { _ in
            state.validPublicationCount += state.currentPublicationsCount
            state.currentPublicationsCount = 0
            return
        }, next: 17, end: false),
        
        
        .multipleChoice(id: 22, question: "Are there Offical statements made by healthcare organizations?", options: [("Yes",23), ("No",27)], end: false),
        
        .inputQuestion(id: 23, question: "Enter the name of the organization", inputType: "text", update: { input in
            state.currentOrganisationName = input
        }, next: 24, end: false),
        
        .inputQuestion(id: 24, question: "Enter the year of the statement", inputType: "int", update: { input in
            if let val = Int(input) {
                state.currentStatementCount = val
            }
        }, next: 25, end: false),
        
        
        .functionDecision(id: 25, test: { _ in
            ["FDA","WDH"].contains(state.currentOrganisationName)
        }, yes: 26, no: 22, end: false),
        
        .function(id: 26, execute: { _ in
            state.validStatementCound += state.currentStatementCount
            state.currentStatementCount = 0
            return
        }, next: 22, end: false),
        
        
        .functionDecision(id: 27, test: { _ in
            state.validPublicationCount + state.validStatementCound > 3
        }, yes: 29, no: 28, end: false),
        
        .question(id: 28, question: "Unproven signifiance", next: nil, decision: false, yes: nil, no: nil, end: true),
        .question(id: 29, question: "High scientific signifiance", next: nil, decision: false, yes: nil, no: nil, end: true)
    ]
}
