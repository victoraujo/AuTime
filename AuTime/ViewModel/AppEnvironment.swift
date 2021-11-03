//
//  AppEnvironment.swift
//  AuTime
//
//  Created by Matheus Andrade on 03/11/21.
//

import Foundation
import SwiftUI

class AppEnvironment: ObservableObject {
    enum ProfileType {
        case child, parent
    }
    
    @Published var profile: ProfileType = .parent
    @Published var showSubActivities: Bool = false
    @Published var scheduleIsOpen: Bool = false
    
    func reset() {
        profile = .child
        showSubActivities = false
        scheduleIsOpen = false
    }
    
}
