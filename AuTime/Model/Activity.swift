//
//  Activity.swift
//  AuTime
//
//  Created by Victor Vieira on 15/07/21.
//

import SwiftUI

struct Completion: Codable, Hashable {
    var date: Date
    var feedback: String
    
    enum CodingKeys: String, CodingKey {
        case date = "date"
        case feedback = "feedback"
    }
    
    init(date: Date, feedback: String) {
        self.date = date
        self.feedback = feedback
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.date = DateHelper.stringToDate(from: try container.decode(String.self, forKey: .date))
        self.feedback = try container.decode(String.self, forKey: .feedback)
    }
}

struct Activity: Identifiable, Codable, Hashable {
    var id: String?
    var category: String
    var completions: [Completion]
    var generateStar: Bool
    var name: String
    var repeatDays: [Int]
    var time: Date
    var stepsCount: Int
    
    func lastCompletionDate() -> Date {
        if completions.isEmpty {
            return Date(timeIntervalSince1970: 0)
        }
        
        return completions.last!.date
    }
    
    func lastCompletionFeedback() -> String {
        if completions.isEmpty {
            return ""
        }
        
        return completions.last!.feedback
    }
    
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
