import Foundation
import SwiftUI

// MARK: - Main JSON Structure
struct GoldenGaiData: Codable {
    let goldenGaiMap: GoldenGaiMap
    
    enum CodingKeys: String, CodingKey {
        case goldenGaiMap = "golden_gai_map"
    }
}

struct GoldenGaiMap: Codable {
    let mapInfo: MapInfo
    let areas: [AreaInfo]
    let bars: [BarInfo]
    let emptyCells: [EmptyCell]
    
    enum CodingKeys: String, CodingKey {
        case mapInfo = "map_info"
        case areas, bars
        case emptyCells = "empty_cells"
    }
}

// MARK: - Map Configuration
struct MapInfo: Codable {
    let title: String
    let copyright: String
    let gridSize: GridSize
    
    enum CodingKeys: String, CodingKey {
        case title, copyright
        case gridSize = "grid_size"
    }
}

struct GridSize: Codable {
    let rows: Int
    let columns: Int
}

// MARK: - Area Information
struct AreaInfo: Codable {
    let name: String
    let code: String
    let color: String
    let startRow: Int
    let startColumn: Int
    
    enum CodingKeys: String, CodingKey {
        case name, code, color
        case startRow = "start_row"
        case startColumn = "start_column"
    }
    
    var uiColor: Color {
        return Color(hex: color)
    }
}

// MARK: - Bar Information
struct BarInfo: Codable {
    let id: String
    let name: String
    let area: String
    let floor: String?
    let row: Int
    let column: Int
    let type: String
}

// MARK: - Empty Cell Information
struct EmptyCell: Codable {
    let row: Int
    let column: Int
    let type: String // "street", "vacant", "parking"
}

// MARK: - Color Extension for Hex Colors
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
