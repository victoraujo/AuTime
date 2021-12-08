//
//  StringsExtension.swift
//  AuTime
//
//  Created by Victor Vieira on 03/12/21.
//

import Foundation


extension String {

    func unaccent() -> String {

        return self.folding(options: .diacriticInsensitive, locale: .current)

    }

}
