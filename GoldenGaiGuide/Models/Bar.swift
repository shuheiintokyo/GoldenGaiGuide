import Foundation
import CoreData

class BarDataManager {
    static let shared = BarDataManager()
    
    func populateInitialData(context: NSManagedObjectContext) {
        // Check if data already exists
        let request: NSFetchRequest<Bar> = Bar.fetchRequest()
        let count = try? context.count(for: request)
        
        if count == 0 {
            createSampleBars(context: context)
        }
    }
    
    private func createSampleBars(context: NSManagedObjectContext) {
        // Sample bars from Golden Gai areas G1 and G2
        let sampleBars = [
            ("花の園", 0, 0, "G1"),
            ("Hecate", 0, 1, "G1"),
            ("ポニー", 0, 2, "G1"),
            ("Bon's", 0, 3, "G1"),
            ("久", 0, 4, "G1"),
            // Add more bars based on your CSV data
        ]
        
        for (name, row, column, area) in sampleBars {
            let bar = Bar(context: context)
            bar.id = UUID()
            bar.name = name
            bar.row = Int16(row)
            bar.column = Int16(column)
            bar.area = area
            bar.isVisited = false
            bar.memo = ""
            bar.imageName = "placeholder"
        }
        
        try? context.save()
    }
}
