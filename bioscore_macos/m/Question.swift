//
//  Question.swift
//  m
//
//  Created by ewan decima on 3/14/25.
//

enum Question: Hashable {
    
    case start
    
    case notADevice
    case enforceDiscretion
    case regulatoryOversight
    
    case question1
    case question2A
    case question2B
    
    case question3A
    case question3B
    case question3C
    case question3D
    
    case question4A
    case question4B
    case question4C
    case question4D
    
    case question5A
    case question5B
    case question5C
    case question5D
    
    case question6A
    case question6B
    case question6C
    case question6D
    
    case question7A
    case question7B
    case question7C
    case question7D
    case question7E
    case question7F
    case final
    
    var text: String {
        switch self {
        
            case .start:
            return "Start"
            
        case .notADevice:
            return "Likely not a device"
        case .enforceDiscretion:
            return "LIKELY FDA INTENDS TO EXERCISE ENFORCEMENT DISCRETION"
        case .regulatoryOversight:
            return "LIKELY THE FOCUS OF FDA'S REGULATORY OVERSIGHT"
            
        case .question1:
            return "Is the software Function Intended for a medical purpose"
        
        case .question2A:
            return "Is the Software Function Intended For Administrative Support of a Health Care Facility?"
        case .question2B:
            return "Is the software function intended for administrative support of laboratories and/or for transferring, storing, converting formats, or displaying clinical laboratory test data and results?"
        case .question3A:
            return "Is the software function intended for maintaining or encouraging a healthy lifestyle AND is UNRELATED to the diagnosis, cure, mitigation, prevention, or treatment of a disease or condition?"
        case .question3B:
            return "Does the software function have an intended use that relates the role of a healthy lifestyle with helping to reduce the risk or impact of certain chronic diseases or conditions?"
        case .question3C:
            return "Is the relation between healthy lifestyle and disease specifically expressed as << may help to reduce the risk of >> or << may help living well with >> a chronic disease or condition?"
        case .question3D:
            return "Is the software function low risk?"
        case .question4A:
            return "Is the software function intended to serve as electronic patient records, or to transfer, store, convert formats, or display electronic patient records that are the equivalent of a paper medical chart?"
        case .question4B:
            return "Is the software function intended for interpretation or analysis of patient records, including medical image data, for the purpose of the diagnosis, cure, mitigation, prevention, or treatment of a disease or condition?"
        case .question4C:
            return "Are the software function records created, stored, transferred, or reviewed by health care professionals or by individuals working under their supervision?"
        case .question4D:
            return "Are the software function records certified under a program of voluntary certification kept or recognized by the Oﬃce of the National Coordinator for Health Information Technology (ONC)?"
        case .question5A:
            return "Is the software function SOLELY intended to transfer, store, convert formats, or display medical device data and results, including medical images, waveforms, signals, or other clinical information?"
        case .question5B:
            return " Does the software function control or alter the functions or parameters of any connected medical device? "
        case .question5C:
            return "Does the software function generate alarms or alerts or prioritize patient-related information on multi-patient displays, or provide for active patient monitoring to enable immediate clinical action?"
        case .question5D:
            return "Does the software function analyze or interpret medical device data?"
        case .question6A:
            return "Is the software function intended to acquire, process, or analyze a medical image or a signal from an in vitro diagnostic device (IVD), or a pattern or signal from a signal acquisition system?"
        case .question6B:
            return "Does the software function display, analyze, or print medical information normally communicated between health care professionals?"
        case .question6C:
            return "Does the software function provide recommendations (information/options) to a health care professional rather than provide a specific output or directive for preventing, diagnosing, or treating a disease or condition?"
        case .question6D:
            return "Does the software function provide the basis of the recommendations so that the health care professional DOES NOT RELY primarily on any recommendations to make a decision regarding an individual patient?"
        case .question7A:
            return "Does the software function provide or facilitate supplemental clinical care, by coaching or prompting, to help patients manage their health in their daily environment, without providing specific treatment or treatment suggestions?"
        case .question7B:
            return "Does the software function help patients communicate with health care professionals by supplementing or augmenting the data or information by capturing an image for patients to convey to their health care professionals about potential medical conditions?"
        case .question7C:
            return "Does the software function perform simple calculations routinely used in clinical practice?"
        case .question7D:
            return "Is the software function an extension of one or more medical devices by connecting to such device(s) for the purposes of controlling the device(s) or analyzing medical device data?"
        case .question7E:
            return "Does the software function transform a mobile platform or general-purpose computing platform into a regulated medical device by using attachments, display screens, or sensors, or by including functionalities similar to those of currently regulated medical devices?"
        case .question7F:
            return "Does the software function perform patient-specific analysis and provide specific output(s) or directive(s) to users for use in the diagnosis, treatment, mitigation, cure, or prevention of a disease or condition?"
        case .final:
            return "Your software function is likely a device that is the focus of the FDA's regulatory oversight"
        }
        
        
       
    }
    var yesPath: Question? {
        switch self {
            
        case .start:
            return .question1
        case .enforceDiscretion:
            return nil
        case .regulatoryOversight:
            return nil
        case .final:
            return nil
        case .notADevice:
            return nil
        
        
            
        case .question1:
            return .question2A
        case .question2A:
            return .notADevice
        case .question2B:
            return .notADevice
            
        case .question3A:
            return .notADevice
        case .question3B:
            return .question3C
        case .question3C:
            return .question3D
        case .question3D:
            return .enforceDiscretion
            
            
        case .question4A:
            return .question4B
        case .question4B:
            return .question6A
        case .question4C:
            return .question4D
        case .question4D:
            return .notADevice
        
            
        case .question5A:
            return .question5B
        case .question5B:
            return .question6A
        case .question5C:
            return .question6A
        case .question5D:
            return .question6A
        
        case .question6A:
            return .question7A
        case .question6B:
            return .question6C
        case .question6C:
            return .question6D
        case .question6D:
            return .notADevice
            
        case .question7A:
            return .enforceDiscretion
        case .question7B:
            return .enforceDiscretion
        case .question7C:
            return .enforceDiscretion
        case .question7D:
            return .regulatoryOversight
        case .question7E:
            return .regulatoryOversight
        case .question7F:
            return .regulatoryOversight
       
        
        
        }
        
        
        
    }
    var noPath: Question? {
        switch self {
            
        case .start:
            return .question1
            
        case .enforceDiscretion:
            return nil
        case .regulatoryOversight:
            return nil
        case .final:
            return nil
        case .notADevice:
            return nil
            
            
        case .question1:
            return .notADevice
            
        case .question2A:
            return .question2B
        
        case .question2B:
            return .question3A
        
            
        case .question3A:
            return .question3B
        case .question3B:
            return .question4A
        case .question3C:
            return .question4A
        case .question3D:
            return .question4A
            
            
        case .question4A:
            return .question5A
        
        case .question4B:
            return .question4C
        case .question4C:
            return .notADevice
        case .question4D:
            return .enforceDiscretion
            
        case .question5A:
            return .question6A
        case .question5B:
            return .question5C
        case .question5C:
            return .question5D
        case .question5D:
            return .notADevice
            
        case .question6A:
            return .question6B
        case .question6B:
            return .question7A
        case .question6C:
            return .question7A
        case .question6D:
            return .question7A
            
        case .question7A:
            return .question7B
        case .question7B:
            return .question7C
        case .question7C:
            return .question7D
        case .question7D:
            return .question7E
        case .question7E:
            return .question7F
        case .question7F:
            return .final
        
        }
    }
}
