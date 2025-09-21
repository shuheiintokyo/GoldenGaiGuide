import SwiftUI

struct VisitedBarsView: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Bar.visitDate, ascending: false)],
        predicate: NSPredicate(format: "isVisited == true")
    ) var visitedBars: FetchedResults<Bar>
    
    @Binding var selectedBar: Bar?
    @Binding var showingBarDetail: Bool
    
    var body: some View {
        NavigationView {
            Group {
                if visitedBars.isEmpty {
                    VStack {
                        Image(systemName: "list.clipboard")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        Text("No bars visited yet")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Text("Tap bars on the map or browse the bar list to mark them as visited")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                } else {
                    List {
                        ForEach(visitedBars, id: \.self) { bar in
                            VisitedBarRow(bar: bar) {
                                selectedBar = bar
                                showingBarDetail = true
                            }
                        }
                    }
                }
            }
            .navigationTitle("Visited Bars (\(visitedBars.count))")
        }
    }
}

struct VisitedBarRow: View {
    let bar: Bar
    let onTap: () -> Void
    
    var body: some View {
        HStack {
            Circle()
                .fill(Color.green)
                .frame(width: 12, height: 12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(bar.wrappedName)
                    .font(.headline)
                
                HStack {
                    Text(bar.wrappedArea)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(8)
                    
                    if let visitDate = bar.visitDate {
                        Text(visitDate, style: .date)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                if !bar.wrappedMemo.isEmpty {
                    Text(bar.wrappedMemo)
                        .font(.caption)
                        .lineLimit(2)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
    }
}
