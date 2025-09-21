import Foundation
import CoreData

@objc(Bar)
public class Bar: NSManagedObject {
    
}

extension Bar {
    var wrappedName: String {
        name ?? "Unknown Bar"
    }
    
    var wrappedMemo: String {
        memo ?? ""
    }
    
    var wrappedArea: String {
        area ?? "Unknown"
    }
}
