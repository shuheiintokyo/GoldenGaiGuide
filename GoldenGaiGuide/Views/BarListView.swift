import SwiftUI

struct BarListView: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Bar.name, ascending: true)]
    ) var bars: FetchedResults<Bar>
    
    @Binding var selectedBar: Bar?
    @Binding var showingBarDetail: Bool
    
    var body: some View {
        NavigationView {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 20) {
                    ForEach(bars, id: \.self) { bar in
                        BarImageCard(bar: bar) {
                            selectedBar = bar
                            showingBarDetail = true
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Golden Gai Bars")
            .onAppear {
                // Populate initial data if needed
                BarDataManager.shared.populateInitialData(
                    context: PersistenceController.shared.container.viewContext
                )
            }
        }
    }
}

struct BarImageCard: View {
    let bar: Bar
    let onTap: () -> Void
    
    var body: some View {
        VStack {
            // Oval image placeholder
            RoundedRectangle(cornerRadius: 25)
                .fill(randomColor())
                .frame(width: 150, height: 100)
                .overlay(
                    // Placeholder for actual bar image
                    Image(systemName: "building.2")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                )
                .overlay(
                    // Visited indicator
                    Circle()
                        .fill(bar.isVisited ? Color.green : Color.clear)
                        .frame(width: 20, height: 20)
                        .offset(x: 60, y: -40)
                )
            
            Text(bar.wrappedName)
                .font(.caption)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .frame(width: 150)
                .lineLimit(2)
        }
        .onTapGesture {
            onTap()
        }
    }
    
    private func randomColor() -> Color {
        let colors: [Color] = [.blue, .purple, .orange, .pink, .yellow, .cyan, .indigo, .mint]
        return colors.randomElement() ?? .gray
    }
}
