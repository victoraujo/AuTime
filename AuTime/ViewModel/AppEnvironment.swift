//
//  AppEnvironment.swift
//  AuTime
//
//  Created by Matheus Andrade on 03/11/21.
//

import SwiftUI

class AppEnvironment: ObservableObject {
    enum ProfileType {
        case child, parent
    }
    
    @Published var profile: ProfileType = .parent
    
    @Published var isShowingSubActivities: Bool = false
    @Published var isShowingChangeProfile: Bool = false
    @Published var isShowingProfileSettings: Bool = false
    
    @Published var scheduleIsOpen: Bool = false    
    @Published var activitiesLibraryIsOpen: Bool = false
    
    @Published var categories: [String] = ["Amigos", "Casa", "Diversão", "Educação", "Família", "Higiene", "Prêmio", "Saúde", "Terapia"].sorted()
    
    @Published var childName = "João"
    @Published var childPhoto = UIImage(imageLiteralResourceName: "JoaoMemoji.png")
    @Published var childColorTheme: Color = .greenColor
    
    @Published var parentName = "Rilda"
    @Published var parentPhoto = UIImage(imageLiteralResourceName: "RildaMemoji.png")
    @Published var parentColorTheme: Color = .blue
    @Published var parentControlPassword = "senha"
    
    func reset() {
        profile = .parent
        isShowingSubActivities = false
        scheduleIsOpen = false
    }
    
    func changeProfile() {
        if profile == .child {
            profile = .parent
        } else {
            profile = .child
        }
    }
    
    func updateProfile(childName: String? = nil, parentName: String? = nil, parentControlPassword: String? = nil) {
        if let child = childName {
            self.childName = child
        }
        
        if let parent = parentName {
            self.parentName = parent
        }
        
        if let password = parentControlPassword {
            self.parentControlPassword = password
        }
        
        
    }
}
