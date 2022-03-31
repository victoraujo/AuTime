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
    
    func downloadImage(from filePath: String, _ completion: @escaping () -> Void) {
        
        guard let _ = userManager.session?.email else {
            print("Email is nil during download file.")
            return
        }
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        DispatchQueue.main.async {
            let photoRef = storageRef.child(filePath.unaccent())
            self.imageView.sd_setImage(with: photoRef, placeholderImage: UIImage(named: "PlaceholderImage.png") ?? UIImage(), completion: { _ , error , _ , _ in
                if let error = error {
                    print("Erro ao setar imagem \(filePath): \(error.localizedDescription)")
                }
                
                self.objectWillChange.send()
                completion()
                
            })
        }
    }
    
    func deleteImage(filePath: String, completion: @escaping () -> Void) {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let desertRef = storageRef.child("\(filePath.unaccent())")
        
        // Delete the file
        desertRef.delete { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                completion()
            }
        }
    }

    func clearImagesCache(key: String, completion: @escaping () -> Void) {
        SDImageCache.shared.removeImage(forKey: key, cacheType: .all) {
            completion()
        }
    }
}
