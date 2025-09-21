import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var showingBarDetail = false
    @State private var selectedBar: Bar?
    
    var body: some View {
        TabView(selection: $selectedTab) {
            BarListView(selectedBar: $selectedBar, showingBarDetail: $showingBarDetail)
                .tabItem {
                    Image(systemName: "photo.on.rectangle")
                    Text("Bars")
                }
                .tag(0)
            
            VisitedBarsView(selectedBar: $selectedBar, showingBarDetail: $showingBarDetail)
                .tabItem {
                    Image(systemName: "list.bullet.clipboard")
                    Text("Visited")
                }
                .tag(1)
            
            MapView(selectedBar: $selectedBar, showingBarDetail: $showingBarDetail)
                .tabItem {
                    Image(systemName: "map")
                    Text("Map")
                }
                .tag(2)
        }
        .sheet(isPresented: $showingBarDetail) {
            if let bar = selectedBar {
                BarDetailView(bar: bar)
            }
        }
    }
}
