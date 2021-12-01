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

    func uploadImage(urlFile: URL, filePath: String, completion: @escaping () -> Void){
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
            completion()
        }
        
    }
    
    func downloadImage(from filePath: String, _ completion: @escaping () -> Void) {
        
        guard let _ = userManager.session?.email else {
            print("Email is nil during download file.")
            return
        }                
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        DispatchQueue.main.async {
            let photoRef = storageRef.child(filePath)
            self.imageView.sd_setImage(with: photoRef, placeholderImage: UIImage(), completion: { _ , _ , _ , _ in
                completion()
                self.objectWillChange.send()
            })
        }

    }
}
