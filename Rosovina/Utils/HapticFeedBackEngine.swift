//
//  HapticFeedBackEngine.swift
//  Rosovina
//
//  Created by Amir Ahmed on 10/02/2024.
//

import Foundation
import UIKit
import AudioToolbox

//  Singleton Design Pattern
class HapticFeedBackEngine {
    
    static let shared = HapticFeedBackEngine()
    
    private init() {
        // Private initialization to ensure just one instance is created.
    }
    
    @objc func playSound() {
        let systemSoundID: SystemSoundID = 1407
        AudioServicesPlaySystemSound(systemSoundID)
    }
    
    func errorFeedback() {
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
    
    func warningFeedback() {
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
    }
    
    func successFeedback() {
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    func lightFeedback() {
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    func mediumFeedback() {
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    func heavyFeedback() {
        
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
    }
    
    func selectionFeedback() {
        
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
    
}

