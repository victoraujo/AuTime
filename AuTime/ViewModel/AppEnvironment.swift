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
    @Published var showSubActivities: Bool = false
    @Published var isShowingChangeProfile: Bool = false
    @Published var scheduleIsOpen: Bool = false
    @Published var parentColorTheme: Color = .blue
    @Published var childColorTheme: Color = .greenColor
    @Published var parentControlPassword = "senha"
    @Published var childName = "João"
    @Published var childPhoto = UIImage(imageLiteralResourceName: "JoaoMemoji.png")
    
    func reset() {
        profile = .parent
        showSubActivities = false
        scheduleIsOpen = false
    }
    
    func changeProfile() {
        if profile == .child {
            profile = .parent
        } else {
            profile = .child
        }
    }
}
