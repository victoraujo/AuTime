//
//  Activity.swift
//  AuTime
//
//  Created by Victor Vieira on 15/07/21.
//

import Foundation

struct Activity: Identifiable, Codable, Hashable {
    var id: String?
    var category: String
    var complete: Date
    var generateStar: Bool
    var name: String
    var repeatDays: [Int]
    var time: Date
}
