//
//  CloudVM.swift
//  CloudKitTest
//
//  Created by Victor Vieira on 09/07/21.
//

import Foundation
import CloudKit
import SwiftUI

class ListBank:NSObject, ObservableObject {
    @Published var nome: [String] = []
    let Database = CKContainer(identifier: "iCloud.com.AuTime")
    func setItem(nome: String){
        let item = CKRecord(recordType: "Outro")
        item.setValue(nome, forKey: "nome")
        
        self.Database.publicCloudDatabase.save(item) { (savedRecord, error) in
            DispatchQueue.main.async {
                if error == nil {
                    print("Deu certo")
                    //self.getDrunks()
                } else {
                    print("Deu errado")
                    print("opa:\(error?.localizedDescription)")
                }
            }
            
        }
    }
    
 }
