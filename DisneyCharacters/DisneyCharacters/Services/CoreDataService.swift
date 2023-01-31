import Foundation
import CoreData

class CoreDataService {
    static let shared = CoreDataService()
    
    lazy var context: NSManagedObjectContext =  {
        persistentContainer.viewContext
    }()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "StorageModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func fetchFavouritesItems() -> [FavouritesItem] {
        var items = [FavouritesItem]()
        do {
            items =  try context.fetch(FavouritesItem.fetchRequest())
        } catch {
            print(error)
        }
        return items
    }
    
    func removeFavouritesItem(removeItem: FavouritesItem) {
        context.delete(removeItem)
        saveContext()
    }
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
