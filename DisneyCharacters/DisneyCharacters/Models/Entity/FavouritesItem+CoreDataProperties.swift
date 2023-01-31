import Foundation
import CoreData


extension FavouritesItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavouritesItem> {
        return NSFetchRequest<FavouritesItem>(entityName: "FavouritesItem")
    }

    @NSManaged public var avatarImage: Data?
    @NSManaged public var name: String?
    @NSManaged public var tvShowsImages: Data?

}

extension FavouritesItem : Identifiable {

}
