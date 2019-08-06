//
//  CoreDataManager.swift
//  CoreDataLearning
//
//  Created by Stephen Cao on 12/7/19.
//  Copyright © 2019 Stephencao Cao. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager: NSObject {
    static let shared = CoreDataManager()
    
    lazy var context: NSManagedObjectContext = {
        let context = ((UIApplication.shared.delegate) as! AppDelegate).context
        return context
    }()
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func addFavouriteBreedWith(name: String) {
        let breed = NSEntityDescription.insertNewObject(forEntityName: "Breed", into: context) as! Breed
        breed.name = name
        breed.isFavourite = false
        saveContext()
    }
    
    func getAllFavouriteBreeds() -> [Breed] {
        let fetchRequest: NSFetchRequest = Breed.fetchRequest()
        // for sort
//        let sort = NSSortDescriptor(key: #keyPath(Breed.name), ascending: true)
//        fetchRequest.sortDescriptors = [sort]
        do {
            let result = try context.fetch(fetchRequest)
            return result
        } catch {
            fatalError();
        }
    }
    
    func getBreedWith(name: String) -> [Breed] {
        let fetchRequest: NSFetchRequest = Breed.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        do {
            let result: [Breed] = try context.fetch(fetchRequest)
            return result
        } catch {
            fatalError();
        }
    }
    
    func updateBreedFavouriteWith(name: String, newFavouriteStatus: Bool) {
        let fetchRequest: NSFetchRequest = Breed.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        do {
            let result = try context.fetch(fetchRequest)
            for breed in result {
                breed.isFavourite = newFavouriteStatus
            }
        } catch {
            fatalError();
        }
        saveContext()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: InfoCommon.SCShouldRefreshFavouriteCollectionView), object: nil)
    }
    
    func deleteWith(name: String) {
        let fetchRequest: NSFetchRequest = Breed.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        do {
            let result = try context.fetch(fetchRequest)
            for breed in result {
                context.delete(breed)
            }
        } catch {
            fatalError();
        }
        saveContext()
    }
    
    func deleteAllFavouriteBreeds() {
        let result = getAllFavouriteBreeds()
        for breed in result {
            context.delete(breed)
        }
        saveContext()
    }
}
