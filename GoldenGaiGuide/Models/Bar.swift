import Foundation
import CoreData
import SwiftUI

class BarDataManager {
    static let shared = BarDataManager()
    private var goldenGaiData: GoldenGaiData?
    
    init() {
        loadGoldenGaiData()
    }
    
    private func loadGoldenGaiData() {
        guard let url = Bundle.main.url(forResource: "bars_data", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            print("❌ Failed to load bars_data.json")
            return
        }
        
        do {
            goldenGaiData = try JSONDecoder().decode(GoldenGaiData.self, from: data)
            print("✅ Successfully loaded Golden Gai data with \(goldenGaiData?.goldenGaiMap.bars.count ?? 0) bars")
        } catch {
            print("❌ Error decoding JSON: \(error)")
        }
    }
    
    func populateInitialData(context: NSManagedObjectContext) {
        // Check if data already exists
        let request: NSFetchRequest<Bar> = Bar.fetchRequest()
        let count = try? context.count(for: request)
        
        if count == 0 {
            createBarsFromJSON(context: context)
        }
    }
    
    private func createBarsFromJSON(context: NSManagedObjectContext) {
        guard let data = goldenGaiData else {
            print("❌ No JSON data available")
            return
        }
        
        for barInfo in data.goldenGaiMap.bars {
            let bar = Bar(context: context)
            bar.id = UUID()
            bar.name = barInfo.name
            bar.row = Int16(barInfo.row)
            bar.column = Int16(barInfo.column)
            bar.area = barInfo.area
            bar.isVisited = false
            bar.memo = ""
            bar.imageName = "bar_placeholder"
            // Store floor info in a custom field if needed
        }
        
        do {
            try context.save()
            print("✅ Successfully populated \(data.goldenGaiMap.bars.count) bars from JSON")
        } catch {
            print("❌ Error saving bars: \(error)")
        }
    }
    
    // Helper methods to access JSON data
    func getMapInfo() -> MapInfo? {
        return goldenGaiData?.goldenGaiMap.mapInfo
    }
    
    func getAreas() -> [AreaInfo] {
        return goldenGaiData?.goldenGaiMap.areas ?? []
    }
    
    func getEmptyCells() -> [EmptyCell] {
        return goldenGaiData?.goldenGaiMap.emptyCells ?? []
    }
    
    func getAreaColor(for areaCode: String) -> Color {
        return getAreas().first { $0.code == areaCode }?.uiColor ?? .gray
    }
}

