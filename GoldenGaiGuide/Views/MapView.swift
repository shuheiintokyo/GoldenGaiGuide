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
    
    private let maxColumns = 12
    private let maxRows = 15
    
    var body: some View {
        NavigationView {
            ScrollView([.horizontal, .vertical]) {
                VStack(spacing: 1) {
                    ForEach(0..<maxRows, id: \.self) { row in
                        HStack(spacing: 1) {
                            ForEach(0..<maxColumns, id: \.self) { column in
                                MapCell(
                                    bar: findBar(row: row, column: column),
                                    onTap: { bar in
                                        hapticFeedback()
                                        toggleBarVisitStatus(bar)
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
    
    private func toggleBarVisitStatus(_ bar: Bar) {
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
    
    private func hapticFeedback() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
    }
}

struct MapCell: View {
    let bar: Bar?
    let onTap: (Bar) -> Void
    
    var body: some View {
        Rectangle()
            .fill(cellColor())
            .frame(width: 25, height: 30)
            .overlay(
                Group {
                    if let bar = bar {
                        Text(bar.wrappedName)
                            .font(.system(size: 6))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(1)
                    }
                }
            )
            .onTapGesture {
                if let bar = bar {
                    onTap(bar)
                }
            }
    }
    
    private func cellColor() -> Color {
        guard let bar = bar else { return .gray.opacity(0.2) }
        return bar.isVisited ? .green : .blue.opacity(0.8)
    }
}
