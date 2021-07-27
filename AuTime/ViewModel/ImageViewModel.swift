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
    
    static var shared = ImageViewModel()
    
    var userManager = UserViewModel.shared

    func uploadImage(urlFile: URL){
        print("che")
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let localFile = urlFile
        
        guard let email = userManager.session?.email else {
            print("Email is nil during upload file.")
            return
        }
        
        let photoRef = storageRef.child("users/\(String(describing: email))/Activities/ocapi")
            
        let _ = photoRef.putFile(from: localFile, metadata: nil){(metadata, err) in
            guard let _ = metadata else{
                print("Error in upload: \(err!.localizedDescription)")
                return
            }
            print("Photo Uploaded")
        }
        
    }
    
    func downloadImage(){
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        guard let email = userManager.session?.email else {
            print("Email is nil during download file.")
            return
        }
        
        let photoRef = storageRef.child("users/\(String(describing: email))/Activities/ocapi")
        
        self.image.sd_setImage(with: photoRef)
        self.objectWillChange.send()
    }
}
