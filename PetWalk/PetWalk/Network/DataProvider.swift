//
//  Provider.swift
//  PetWalk
//
//  Created by cskim on 2020/01/15.
//  Copyright © 2020 cskim. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage

typealias RequestWalksCompletion = ([Walk])->()
typealias RequestPetsCompletion = ([Pet])->()
typealias RegisterPetCompletion = (Bool)->()
typealias RegisterWalkCompletion = (Bool)->()
typealias UpdatePetCompletion = (Bool) -> ()

class DataProvider {
  
  // MARK: Request
  
  class func requestPets(completion: @escaping RequestPetsCompletion) {
    var pets = [Pet]()
    Firestore
      .firestore()
      .collection(CollectionReference.pets)
      .getDocuments { (snapshot, error) in
        if let error = error { fatalError("Request pet : \(error.localizedDescription)") }
        else {
          guard let documents = snapshot?.documents else { fatalError("Request pet : snapshot query is empty") }
          documents.forEach {
            var data = $0.data()
            data[PetReference.key] = $0.documentID
            guard let pet = Pet.create(with: data) else { fatalError("Request pet : Document data type is wrong") }
            pets.append(pet)
          }
          completion(pets)
        }
    }
  }
  
  class func requestWalks(for pet: Pet, completion: @escaping RequestWalksCompletion) {
    var walks = [Walk]()
    Firestore
      .firestore()
      .collection(CollectionReference.pets)
      .whereField(PetReference.name, isEqualTo: pet.name)     // unique pet name
      .getDocuments { (petSnapShot, error) in
        if let error = error { fatalError("Request walk : \(error.localizedDescription)") }
        else {
          guard let document = petSnapShot?.documents.first else { fatalError("Request walk : snapshot query is empty at pets collection") }
          document.reference
            .collection(CollectionReference.walks)
            .getDocuments { (snapshot, error) in
              if let error = error { fatalError("Request walk : " + error.localizedDescription) }
              else {
                guard let documents = snapshot?.documents else { fatalError("Request walk : snapshot query is empty at walks collection") }
                documents.forEach {
                  var data = $0.data()
                  data[WalkReference.key] = $0.documentID
                  guard let walk = Walk.create(with: data) else { fatalError("Request walk : Document data type is wrong") }
                  walks.append(walk)
                }
                completion(walks)
              }
          }
        }
    }
  }
  
  // MARK: Register
  
  class func register(pet: Pet, completion: @escaping RegisterPetCompletion) {
    let petCollection = Firestore.firestore().collection(CollectionReference.pets)
    petCollection
      .whereField(PetReference.name, isEqualTo: pet.name)
      .getDocuments { (snapshot, error) in
        if let error = error { fatalError(error.localizedDescription) }
        else {
          if let documents = snapshot?.documents, documents.isEmpty {
            petCollection.addDocument(data: pet.keyValueRepresentation()) { error in
              if let error = error { fatalError("Register pet : " + error.localizedDescription) }
              else { completion(true) }
            }
          } else {
            completion(false)
          }
        }
    }
  }
  
  class func register(walk: Walk, to pet: Pet, completion: @escaping RegisterWalkCompletion) {
    Firestore
      .firestore()
      .collection(CollectionReference.pets)
      .whereField(PetReference.name, isEqualTo: pet.name)
      .getDocuments { (snapshot, error) in
        if let error = error { fatalError(error.localizedDescription) }
        else {
          if let documents = snapshot?.documents {
            documents.first?.reference
              .collection(CollectionReference.walks)
              .addDocument(data: walk.keyValueRepresentation()) { error in
                if let error = error { fatalError(error.localizedDescription) }
                else { completion(true) }
            }
          } else {
            completion(false)
          }
        }
    }
  }
  
  // MARK: Update
  
  class func update(data: [String: Any], for pet: Pet, completion: @escaping UpdatePetCompletion) {
    Firestore
      .firestore()
      .collection(CollectionReference.pets)
      .document(pet.key)
      .updateData(data) { error in
        if let error = error { fatalError(error.localizedDescription) }
        else { completion(true) }
    }
  }
  
}

