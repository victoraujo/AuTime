//
//  SubActivity.swift
//  AuTime
//
//  Created by Victor Vieira on 23/07/21.
//

import Foundation

struct SubActivity: Identifiable, Codable, Hashable {
    var id: String?
    var complete: Date
    var name: String
}
