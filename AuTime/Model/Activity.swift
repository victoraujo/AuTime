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
        case date
        case feedback
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
        case "Educação", "Education":
            return Image(systemName: "book.fill")
        case "Prêmio", "Premium":
            return Image(systemName: "star.fill")
        case "Health", "Saúde":
            return Image(systemName: "heart.fill")
        default:
            return Image(systemName: "heart.fill")
        }
    }
    
    static func getFeedbackEmoji(from emotion: String) -> Text {
        switch emotion {
        case "Upset":
            return Text("😠")
        case "Sad":
            return Text("😢")
        case "Happy":
            return Text("😁")
        case "Joyful":
            return Text("😁")
        default:
            return Text("😐")

        }
    }
    
    static func getSystemImage(from category: String) -> String {
        switch category {
        case "Education", "Educação":
            return "book"
        case "Premium", "Prêmio":
            return "star"
        case "Health", "Saúde":
            return "heart"
        default:
            return "star"
        }
    }
    
}
