//
//  Activity.swift
//  AuTime
//
//  Created by Victor Vieira on 15/07/21.
//

import SwiftUI

struct Activity: Identifiable, Codable, Hashable {
    var id: String?
    var category: String
    var complete: Date
    var generateStar: Bool
    var name: String
    var repeatDays: [Int]
    var time: Date
    var stepsCount: Int
    
    static func getIconImage(from category: String) -> Image {        
        switch category {
            case "Educação":
                return Image(systemName: "book.fill")
            case "Alimentação":
                return Image(systemName: "foof.fill")
            case "Prêmio":
                return Image(systemName: "star.fill")
            default:
                return Image(systemName: "heart.fill")
        }
    }
    
}
