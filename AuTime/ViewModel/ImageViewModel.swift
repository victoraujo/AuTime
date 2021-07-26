//
//  ImageViewModel.swift
//  AuTime
//
//  Created by Victor Vieira on 26/07/21.
//

import Foundation
import FirebaseStorage
import FirebaseStorageUI

class ImageViewModel: ObservableObject{
    @Published var image = UIImageView()
    func uploadImage(urlFile: URL){let storage = Storage.storage()
    let data = Data()
    let storageRef = storage.reference()
    let localFile = urlFile
    let photoRef = storageRef.child("oxe")
        
        let uploadTask = photoRef.putFile(from: localFile, metadata: nil){(metadata, err) in
            guard let metadata = metadata else{
                print(err?.localizedDescription)
                return
            }
            print("Photo Uploaded")
        }
        
    }
    
    func downloadImage(){
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let photoRef = storageRef.child("oxe")
        
        self.image.sd_setImage(with: photoRef)
        self.objectWillChange.send()
    }
}
