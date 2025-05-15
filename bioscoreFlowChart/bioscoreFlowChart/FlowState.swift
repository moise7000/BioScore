//
//  FlowState.swift
//  bioscoreFlowChart
//
//  Created by ewan decima on 5/15/25.
//

import Foundation

class FlowState: ObservableObject {
    
    @Published var biomarkerName: String = ""
    @Published var backendEnablerActive: Bool = false
    
    
    @Published var consistencyScore: Float = 0
    @Published var reproducibilityScore: Float = 0
    @Published var specificityScore: Float = 0
    
    @Published var tc: Float = 0
    @Published var tr: Float = 0
    @Published var ts: Float = 0
    
    
    
    @Published var improvementGeneralHealth: Float = 0
    @Published var riskReductionChronicDisease: Float = 0
    @Published var supportLivingWithChronicDisease: Float = 0
    
    @Published var t1: Float = 0
    @Published var t2: Float = 0
    @Published var t3: Float = 0
    
    @Published var validPublicationCount: Int = 0
    @Published var validStatementCound: Int = 0
    @Published var currentImpactFactor: Float = 0
    @Published var currentPublicationsCount: Int = 0
    
    
    @Published var currentOrganisationName: String = ""
    @Published var currentStatementCount: Int = 0
    
    
    
   
}
