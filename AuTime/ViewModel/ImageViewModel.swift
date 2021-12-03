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
        
        guard let _ = userManager.session?.email else {
            print("Email is nil during upload file.")
            return
        }
        
        let photoRef = storageRef.child(filePath)
        
        let _ = photoRef.putFile(from: urlFile, metadata: nil){(metadata, err) in
            guard let _ = metadata else{
                print("Error in upload: \(err!.localizedDescription)")
                return
            }
            completion()
        }
        
    }
    
    func uploadImage(image: UIImage, filePath: String, completion: @escaping () -> Void){
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        guard let _ = userManager.session?.email else {
            print("Email is nil during upload file.")
            return
        }
        
        let photoRef = storageRef.child(filePath)
        if let data = image.pngData() {
            
            let uploadTask = photoRef.putData(data, metadata: nil) { (metadata, error) in
                guard let metadata = metadata else {
                    // Uh-oh, an error occurred!
                    return
                }
                // Metadata contains file metadata such as size, content-type.
                let size = metadata.size
                // You can also access to download URL after upload.
                photoRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        // Uh-oh, an error occurred!
                        return
                    }
                }
            }
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
                self.objectWillChange.send()
                completion()
            })
        }
    }
    
    func deleteImage(filePath: String, completion: @escaping () -> Void) {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let desertRef = storageRef.child("\(filePath)")
        
        // Delete the file
        desertRef.delete { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                completion()
            }
        }
    }
}
