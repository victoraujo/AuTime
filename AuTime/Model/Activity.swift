//
//  Activity.swift
//  AuTime
//
//  Created by Victor Vieira on 15/07/21.
//

import Foundation

struct Activity: Identifiable, Codable {
    var id: String?
    var name: String
    var time: Date
}
