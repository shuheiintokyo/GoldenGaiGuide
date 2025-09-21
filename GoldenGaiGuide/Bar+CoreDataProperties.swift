import Foundation
import CoreData

extension Bar {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Bar> {
        return NSFetchRequest<Bar>(entityName: "Bar")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var area: String?
    @NSManaged public var row: Int16
    @NSManaged public var column: Int16
    @NSManaged public var isVisited: Bool
    @NSManaged public var memo: String?
    @NSManaged public var imageName: String?
    @NSManaged public var visitDate: Date?

}

extension Bar : Identifiable {
    
}
