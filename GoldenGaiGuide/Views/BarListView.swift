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
                LazyHStack(spacing: 16) {
                    ForEach(bars, id: \.self) { bar in
                        ElegantBarCard(bar: bar) {
                            selectedBar = bar
                            showingBarDetail = true
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            .navigationTitle("Golden Gai Bars (\(bars.count))")
            .onAppear {
                BarDataManager.shared.populateInitialData(
                    context: PersistenceController.shared.container.viewContext
                )
            }
        }
    }
}

struct ElegantBarCard: View {
    let bar: Bar
    let onTap: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            // Elegant horizontal oval with area-based colors
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            BarDataManager.shared.getAreaColor(for: bar.wrappedArea).opacity(0.8),
                            BarDataManager.shared.getAreaColor(for: bar.wrappedArea)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 180, height: 120)
                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                .overlay(
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        
                        Image(systemName: "building.2.fill")
                            .font(.system(size: 28))
                            .foregroundStyle(.white.opacity(0.9))
                        
                        if bar.isVisited {
                            VStack {
                                HStack {
                                    Spacer()
                                    Circle()
                                        .fill(.green)
                                        .frame(width: 24, height: 24)
                                        .overlay(
                                            Image(systemName: "checkmark")
                                                .font(.system(size: 12, weight: .bold))
                                                .foregroundColor(.white)
                                        )
                                        .shadow(color: .green.opacity(0.3), radius: 4)
                                }
                                .padding(.top, 8)
                                .padding(.trailing, 8)
                                Spacer()
                            }
                        }
                        
                        VStack {
                            Spacer()
                            HStack {
                                Text(bar.wrappedArea)
                                    .font(.caption2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(.black.opacity(0.4))
                                    .cornerRadius(8)
                                    .padding(.leading, 12)
                                Spacer()
                            }
                            .padding(.bottom, 8)
                        }
                    }
                )
                .scaleEffect(bar.isVisited ? 1.05 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: bar.isVisited)
            
            VStack(spacing: 4) {
                Text(bar.wrappedName)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .frame(width: 180)
                    .lineLimit(2)
                
                Text("Row \(bar.row), Col \(bar.column)")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                
                if bar.isVisited, let visitDate = bar.visitDate {
                    Text("Visited \(visitDate, style: .date)")
                        .font(.caption2)
                        .foregroundColor(.green)
                }
            }
        }
        .onTapGesture {
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
            onTap()
        }
    }
}
