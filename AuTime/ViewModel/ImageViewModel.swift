//
//  ImageViewModel.swift
//  AuTime
//
//  Created by Victor Vieira on 26/07/21.
//

import UIKit
import FirebaseStorage
import FirebaseStorageUI

class ImageViewModel: ObservableObject{
    @Published var imageView = UIImageView()
        
    var userManager = UserViewModel.shared

    func uploadImage(urlFile: URL, filePath: String){
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let localFile = urlFile
        
        guard let _ = userManager.session?.email else {
            print("Email is nil during upload file.")
            return
        }
        
        let photoRef = storageRef.child(filePath)
            
        let _ = photoRef.putFile(from: localFile, metadata: nil){(metadata, err) in
            guard let _ = metadata else{
                print("Error in upload: \(err!.localizedDescription)")
                return
            }
            print("Photo Uploaded")
        }
        
    }
    
    func downloadImage(from filePath: String) {
        
        print("Baixando imagem: \(filePath)")
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        guard let _ = userManager.session?.email else {
            print("Email is nil during download file.")
            return
        }
        
        let photoRef = storageRef.child(filePath)
        
        self.imageView.sd_setImage(with: photoRef)
        self.objectWillChange.send()
        
        print("Imagem desse objeto é \(String(describing: imageView.image))")
    }
}
