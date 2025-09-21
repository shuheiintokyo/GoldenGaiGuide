import SwiftUI

struct BarDetailView: View {
    @ObservedObject var bar: Bar
    @Binding var showingBarDetail: Bool // Added binding to control presentation
    @Environment(\.managedObjectContext) var viewContext
    @State private var memoText: String = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Bar Header with enhanced styling
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(bar.wrappedName)
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundColor(.primary)
                                
                                HStack(spacing: 12) {
                                    // Area badge
                                    Text(bar.wrappedArea)
                                        .font(.callout)
                                        .fontWeight(.medium)
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(.blue)
                                        .cornerRadius(12)
                                    
                                    // Position info
                                    Text("Row \(bar.row), Col \(bar.column)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(.gray.opacity(0.2))
                                        .cornerRadius(8)
                                }
                            }
                            
                            Spacer()
                            
                            // Status indicator with animation
                            Circle()
                                .fill(bar.isVisited ? .green : .gray.opacity(0.4))
                                .frame(width: 32, height: 32)
                                .overlay(
                                    Image(systemName: bar.isVisited ? "checkmark" : "circle")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.white)
                                )
                                .scaleEffect(bar.isVisited ? 1.1 : 1.0)
                                .animation(.spring(response: 0.3), value: bar.isVisited)
                        }
                        
                        if let visitDate = bar.visitDate {
                            HStack {
                                Image(systemName: "calendar")
                                    .foregroundColor(.green)
                                Text("Visited on \(visitDate, style: .date)")
                                    .font(.subheadline)
                                    .foregroundColor(.green)
                            }
                        }
                    }
                    .padding()
                    .background(.gray.opacity(0.1))
                    .cornerRadius(16)
                    
                    // Visit Status Toggle with enhanced UI
                    VStack(alignment: .leading, spacing: 12) {
                        Toggle("Mark as Visited", isOn: Binding(
                            get: { bar.isVisited },
                            set: { newValue in
                                withAnimation(.spring()) {
                                    bar.isVisited = newValue
                                    if newValue {
                                        bar.visitDate = Date()
                                    } else {
                                        bar.visitDate = nil
                                    }
                                }
                                try? viewContext.save()
                                
                                // Haptic feedback
                                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                                impactFeedback.impactOccurred()
                            }
                        ))
                        .font(.headline)
                        .tint(.green)
                        
                        Text("Toggle to track your visit to this bar")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(.gray.opacity(0.1))
                    .cornerRadius(16)
                    
                    // Enhanced Memo Section
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "note.text")
                                .foregroundColor(.blue)
                            Text("Personal Notes")
                                .font(.headline)
                        }
                        
                        TextEditor(text: $memoText)
                            .frame(minHeight: 120)
                            .padding(12)
                            .background(.gray.opacity(0.1))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(.gray.opacity(0.3), lineWidth: 1)
                            )
                        
                        Text("Share your thoughts, experiences, or recommendations about this bar")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(.gray.opacity(0.1))
                    .cornerRadius(16)
                    
                    Spacer(minLength: 50)
                }
                .padding()
            }
            .navigationTitle("Bar Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        showingBarDetail = false
                    }
                    .foregroundColor(.red)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        bar.memo = memoText
                        do {
                            try viewContext.save()
                            showingBarDetail = false
                            
                            // Success haptic
                            let notificationFeedback = UINotificationFeedbackGenerator()
                            notificationFeedback.notificationOccurred(.success)
                        } catch {
                            print("Error saving memo: \(error)")
                        }
                    }
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
                }
            }
        }
        .onAppear {
            memoText = bar.wrappedMemo
        }
    }
}
