//
//  BiomarkerFlow.swift
//  bioscoreFlowChart
//
//  Created by ewan decima on 5/15/25.
//


//
//  BiomarkerFlow.swift
//  bioscoreFlowChart
//
//  Created on 5/15/25.
//

import SwiftUI

struct BiomarkerFlow: View {
    @ObservedObject var state: FlowState
    
    var body: some View {
        FlowChartView(state: state)
    }
}

struct FlowStatusView: View {
    @ObservedObject var state: FlowState
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Current Status")
                .font(.headline)
            
            Divider()
            
            Group {
                statusRow(title: "Biomarker", value: state.biomarkerName)
                statusRow(title: "Consistency", value: String(format: "%.1f", state.consistencyScore))
                statusRow(title: "Reproducibility", value: String(format: "%.1f", state.reproducibilityScore))  
                statusRow(title: "Specificity", value: String(format: "%.1f", state.specificityScore))
            }
            
            Divider()
            
            Group {
                statusRow(title: "Thresholds", value: "")
                statusRow(title: "tc", value: String(format: "%.1f", state.tc))
                statusRow(title: "tr", value: String(format: "%.1f", state.tr))
                statusRow(title: "ts", value: String(format: "%.1f", state.ts))
            }
            
            if state.validPublicationCount > 0 || state.validStatementCound > 0 {
                Divider()
                
                Group {
                    statusRow(title: "Valid Publications", value: "\(state.validPublicationCount)")
                    statusRow(title: "Valid Statements", value: "\(state.validStatementCound)")
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
        .padding(.horizontal)
    }
    
    private func statusRow(title: String, value: String) -> some View {
        HStack {
            Text(title + ":")
                .fontWeight(.medium)
            Spacer()
            Text(value)
                .foregroundColor(.blue)
        }
        .font(.subheadline)
    }
}

// Flow chart helper to visualize the flow
struct FlowDiagramView: View {
    var currentStepId: Int
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(0..<30) { step in
                    Circle()
                        .fill(getColorForStep(step))
                        .frame(width: 20, height: 20)
                        .overlay(
                            Text("\(step)")
                                .font(.caption2)
                                .foregroundColor(.white)
                        )
                }
            }
            .padding()
        }
    }
    
    private func getColorForStep(_ step: Int) -> Color {
        if step == currentStepId {
            return .blue
        } else if step < currentStepId {
            return .green
        } else {
            return .gray.opacity(0.3)
        }
    }
}

// Helper extension for UI
extension View {
    func cardStyle() -> some View {
        self
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            .padding(.horizontal)
    }
}

#Preview {
    let previewState = FlowState()
    return BiomarkerFlow(state: previewState)
}
