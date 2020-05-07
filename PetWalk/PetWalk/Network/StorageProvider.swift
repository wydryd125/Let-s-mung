//
//  StorageProvider.swift
//  PetWalk
//
//  Created by cskim on 2020/01/16.
//  Copyright © 2020 cskim. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

typealias ImageUploadCompletion = (_ url: String)->()
typealias WalkImageUploadCompletion = ([String])->()

class StorageProvider {
  class func uploadProfileImage(_ image: UIImage, for key: String, completion: @escaping ImageUploadCompletion) {
    let imageData = image.jpegData(compressionQuality: 0.1)!    // 크기 줄인 image
    let metadata = StorageMetadata()
    metadata.contentType = "image/jpeg"
    
    let userImageReference = Storage.storage().reference().child(key)
    userImageReference.putData(imageData, metadata: metadata) { (metaData, error) in
      if let error = error { fatalError(error.localizedDescription) }
      else {
        userImageReference.downloadURL { (url, error) in
          if let error = error { fatalError(error.localizedDescription) }
          else { completion(url?.absoluteString ?? "") }
        }
      }
    }
  }
  
  class func uploadWalkImages(_ images: [UIImage], for key: String, to pet: Pet, completion: @escaping WalkImageUploadCompletion) {
    guard !images.isEmpty else { return completion([]) }
    
    var walkCaptureURLs = [String]()
    // Image Meta Data
    let metadata = StorageMetadata()
    metadata.contentType = "image/jpeg"
    
    // Convert Image
    let imageDatas = images.map { $0.jpegData(compressionQuality: 0.1)! }
    imageDatas.enumerated().forEach { (index, imageData) in
      let childKey = "\(pet.name)/\(key)_\(index)"
      let userImageReference = Storage.storage().reference().child(childKey)
      
      userImageReference.putData(imageData, metadata: metadata) { (metaData, error) in
        if let error = error { fatalError(error.localizedDescription) }
        else {
          userImageReference.downloadURL { (url, error) in
            if let error = error { fatalError(error.localizedDescription) }
            else {
              guard let url = url?.absoluteString else { return }
              walkCaptureURLs.append(url)
              if walkCaptureURLs.count == images.count { completion(walkCaptureURLs) }
            }
          }
        }
      }
    }
  }
  
  class func downloadImage(url: String, completion: @escaping (UIImage)->()) {
    // 허용할 수 있는 데이터의 최대값. url에 대한 데이터를 가져올 때 숫자를 낮게하면 가져와야되는
    // storage에 있는 이미지, 비디오 용량에 제한을 할 수 있음.
    // 데이터 크기를 제한하는 것. 크기가 큰 이미지를 가져오려고 하면 error
    Storage
      .storage()
      .reference(forURL: url)
      .getData(maxSize: Int64.max) { (data, error) in
        if let error = error { fatalError(error.localizedDescription) }
        else {
          guard let data = data, let image = UIImage(data: data) else { return }
          completion(image)
        }
    }
  }
  
  class func downloadImages(urls: [String], completion: @escaping ([UIImage])->()) {
    guard !urls.isEmpty else { return completion([]) }
    var images = [UIImage]()
    urls.forEach {
      Storage
      .storage()
      .reference(forURL: $0)
        .getData(maxSize: Int64.max) { (data, error) in
          if let error = error { fatalError(error.localizedDescription) }
          else {
            guard let data = data, let image = UIImage(data: data) else { return }
            images.append(image)
            if images.count == urls.count { completion(images) }
          }
      }
    }
  }
}
