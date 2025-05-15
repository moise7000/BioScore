//
//  ContentView.swift
//  bioscoreFlowChart
//
//  Created by ewan decima on 5/15/25.
//

import SwiftUI

struct ContentView: View {
    
    @State private var tc: Double = 0
    @State private var tr: Double = 0
    @State private var ts: Double = 0
    
    @State private var backendEnablerActive: Bool = false
    
    @State private var biomarkerName: String = ""
    @State private var consistencyScore: Double = 0
    @State private var reproducibilityScore: Double = 0
    @State private var specificityScore: Double = 0

    @State private var showPopover: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Text("Biomarker classification")
                    .font(.title2)
                Spacer()
                Image(systemName: "gear")
                    .foregroundStyle(.blue)
                    .onTapGesture {
                        showPopover.toggle()
                    }
                
                .popover(isPresented: $showPopover) {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Edit").font(.headline)

                        HStack {
                            Text("tc:")
                            Slider(value: $tc, in: 0...100)
                            Text(String(format: "%.1f", tc))
                        }

                        HStack {
                            Text("tr:")
                            Slider(value: $tr, in: 0...100)
                            Text(String(format: "%.1f", tr))
                        }

                        HStack {
                            Text("ts:")
                            Slider(value: $ts, in: 0...100)
                            Text(String(format: "%.1f", ts))
                        }

                        Toggle("Backend Enabler", isOn: $backendEnablerActive)
                        
                        Spacer()
                    }
                    .padding()
                    .frame(width: 300)
                }
            }
            .padding()
            
            Spacer()
            
            
            
            
            
        }
    }
}

#Preview {
    ContentView()
}
