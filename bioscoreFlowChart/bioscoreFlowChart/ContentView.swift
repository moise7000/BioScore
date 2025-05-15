//
//  ContentView.swift
//  bioscoreFlowChart
//
//  Created by ewan decima on 5/15/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var flowState = FlowState()
    
    @State private var showPopover: Bool = false
    @State private var showFlowChart: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Text("Biomarker Classification")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                Image(systemName: "gear")
                    .foregroundStyle(.blue)
                    .onTapGesture {
                        showPopover.toggle()
                    }
                    .popover(isPresented: $showPopover) {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Configuration").font(.headline).padding(.bottom)

                            Group {
                                Text("Consistency Threshold").font(.subheadline)
                                HStack {
                                    Text("tc:")
                                    Slider(value: Binding(
                                        get: { Double(flowState.tc) },
                                        set: { flowState.tc = Float($0) }
                                    ), in: 0...100)
                                    Text(String(format: "%.1f", flowState.tc))
                                }
                            }

                            Group {
                                Text("Reproducibility Threshold").font(.subheadline)
                                HStack {
                                    Text("tr:")
                                    Slider(value: Binding(
                                        get: { Double(flowState.tr) },
                                        set: { flowState.tr = Float($0) }
                                    ), in: 0...100)
                                    Text(String(format: "%.1f", flowState.tr))
                                }
                            }

                            Group {
                                Text("Specificity Threshold").font(.subheadline)
                                HStack {
                                    Text("ts:")
                                    Slider(value: Binding(
                                        get: { Double(flowState.ts) },
                                        set: { flowState.ts = Float($0) }
                                    ), in: 0...100)
                                    Text(String(format: "%.1f", flowState.ts))
                                }
                            }
                            
                            Divider()
                            
                            Group {
                                Text("Health Improvement Thresholds").font(.subheadline).padding(.top)
                                HStack {
                                    Text("t1:")
                                    Slider(value: Binding(
                                        get: { Double(flowState.t1) },
                                        set: { flowState.t1 = Float($0) }
                                    ), in: 0...100)
                                    Text(String(format: "%.1f", flowState.t1))
                                }
                                
                                HStack {
                                    Text("t2:")
                                    Slider(value: Binding(
                                        get: { Double(flowState.t2) },
                                        set: { flowState.t2 = Float($0) }
                                    ), in: 0...100)
                                    Text(String(format: "%.1f", flowState.t2))
                                }
                                
                                HStack {
                                    Text("t3:")
                                    Slider(value: Binding(
                                        get: { Double(flowState.t3) },
                                        set: { flowState.t3 = Float($0) }
                                    ), in: 0...100)
                                    Text(String(format: "%.1f", flowState.t3))
                                }
                            }

                            Toggle("Backend Enabler", isOn: $flowState.backendEnablerActive)
                                .padding(.top)
                            
                            Spacer()
                        }
                        .padding()
                        .frame(width: 300, height: 500)
                    }
            }
            .padding()
            
            if !showFlowChart {
                VStack(spacing: 20) {
                    Spacer()
                    
                    Image(systemName: "chart.bar.doc.horizontal")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .foregroundColor(.blue)
                    
                    Text("Biomarker Classification System")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("This application helps evaluate and classify biomarkers based on their consistency, reproducibility, specificity, and scientific significance.")
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Button(action: {
                        showFlowChart = true
                    }) {
                        Text("Start Classification")
                            
                    }
                    .padding(.top, 30)
                    
                    Spacer()
                }
                .padding()
            } else {
                FlowChartView(state: flowState)
                
                Button("Restart") {
                    showFlowChart = false
                }
                .padding(.bottom)
            }
        }
    }
}

#Preview {
    ContentView()
}
