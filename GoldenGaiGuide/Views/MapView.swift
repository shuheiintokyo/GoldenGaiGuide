import SwiftUI

struct MapView: View {
    @FetchRequest(
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Bar.row, ascending: true),
            NSSortDescriptor(keyPath: \Bar.column, ascending: true)
        ]
    ) var bars: FetchedResults<Bar>
    
    @Environment(\.managedObjectContext) var viewContext
    @Binding var selectedBar: Bar?
    @Binding var showingBarDetail: Bool
    
    // Dynamic grid size from JSON
    private var mapInfo: MapInfo? {
        BarDataManager.shared.getMapInfo()
    }
    
    private var maxRows: Int {
        mapInfo?.gridSize.rows ?? 20
    }
    
    private var maxColumns: Int {
        mapInfo?.gridSize.columns ?? 25
    }
    
    private var emptyCells: [EmptyCell] {
        BarDataManager.shared.getEmptyCells()
    }
    
    var body: some View {
        NavigationView {
            ScrollView([.horizontal, .vertical]) {
                VStack(spacing: 0.5) {
                    ForEach(0..<maxRows, id: \.self) { row in
                        HStack(spacing: 0.5) {
                            ForEach(0..<maxColumns, id: \.self) { column in
                                MapCell(
                                    bar: findBar(row: row, column: column),
                                    emptyCell: findEmptyCell(row: row, column: column),
                                    onSingleTap: { bar in
                                        toggleBarVisitStatus(bar)
                                    },
                                    onDoubleTap: { bar in
                                        selectedBar = bar
                                        showingBarDetail = true
                                    }
                                )
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Golden Gai Map")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func findBar(row: Int, column: Int) -> Bar? {
        return bars.first { $0.row == row && $0.column == column }
    }
    
    private func findEmptyCell(row: Int, column: Int) -> EmptyCell? {
        return emptyCells.first { $0.row == row && $0.column == column }
    }
    
    private func toggleBarVisitStatus(_ bar: Bar) {
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        bar.isVisited.toggle()
        if bar.isVisited {
            bar.visitDate = Date()
        }
        
        do {
            try viewContext.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}

// MARK: - Enhanced MapCell with Empty Cell Support
struct MapCell: View {
    let bar: Bar?
    let emptyCell: EmptyCell?
    let onSingleTap: (Bar) -> Void
    let onDoubleTap: (Bar) -> Void
    
    var body: some View {
        Rectangle()
            .fill(cellColor())
            .frame(width: cellWidth(), height: cellHeight())
            .overlay(
                Group {
                    if let bar = bar {
                        // Bar cell content
                        VStack(spacing: 1) {
                            Text(bar.wrappedName)
                                .font(.system(size: fontSize(), weight: .medium))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .lineLimit(3)
                            
                            if !bar.wrappedArea.isEmpty {
                                Text(bar.wrappedArea)
                                    .font(.system(size: fontSize() * 0.7))
                                    .foregroundColor(.white.opacity(0.8))
                            }
                        }
                        .padding(1)
                        .shadow(color: .black.opacity(0.5), radius: 1)
                    } else if let emptyCell = emptyCell {
                        // Empty cell content
                        Group {
                            if emptyCell.type == "street" {
                                Image(systemName: "road.lanes")
                                    .font(.system(size: fontSize()))
                                    .foregroundColor(.white.opacity(0.6))
                            } else if emptyCell.type == "parking" {
                                Image(systemName: "car.fill")
                                    .font(.system(size: fontSize()))
                                    .foregroundColor(.white.opacity(0.6))
                            }
                            // vacant cells remain empty
                        }
                    }
                }
            )
            .cornerRadius(2)
            .shadow(color: .black.opacity(0.2), radius: 1)
            .onTapGesture(count: 2) {
                if let bar = bar {
                    onDoubleTap(bar)
                }
            }
            .onTapGesture(count: 1) {
                if let bar = bar {
                    onSingleTap(bar)
                }
            }
    }
    
    private func cellColor() -> Color {
        if let bar = bar {
            // Bar cell color
            if bar.isVisited {
                return .green
            } else {
                return BarDataManager.shared.getAreaColor(for: bar.wrappedArea)
            }
        } else if let emptyCell = emptyCell {
            // Empty cell color
            switch emptyCell.type {
            case "street":
                return .gray.opacity(0.7)
            case "vacant":
                return .gray.opacity(0.3)
            case "parking":
                return .blue.opacity(0.4)
            default:
                return .gray.opacity(0.3)
            }
        } else {
            // Completely empty
            return .clear
        }
    }
    
    private func cellWidth() -> CGFloat {
        if bar != nil {
            return 32 // Bar cells
        } else if emptyCell != nil {
            return 32 // Empty cells same size
        } else {
            return 32 // Invisible cells same size for grid alignment
        }
    }
    
    private func cellHeight() -> CGFloat {
        return 36
    }
    
    private func fontSize() -> CGFloat {
        return 7
    }
}
