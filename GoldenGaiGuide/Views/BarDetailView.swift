import SwiftUI

struct BarDetailView: View {
    @ObservedObject var bar: Bar
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.presentationMode) var presentationMode
    @State private var memoText: String = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Bar Header
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(bar.wrappedName)
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                
                                Text("Area: \(bar.wrappedArea)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            // Status indicator
                            Circle()
                                .fill(bar.isVisited ? Color.green : Color.gray)
                                .frame(width: 20, height: 20)
                        }
                        
                        Text("Location: [GPS coordinates will be added]")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .italic()
                        
                        if let visitDate = bar.visitDate {
                            Text("Visited: \(visitDate, style: .date)")
                                .font(.subheadline)
                                .foregroundColor(.green)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // Visited Status Toggle
                    VStack(alignment: .leading) {
                        Toggle("Mark as Visited", isOn: Binding(
                            get: { bar.isVisited },
                            set: { newValue in
                                bar.isVisited = newValue
                                if newValue {
                                    bar.visitDate = Date()
                                } else {
                                    bar.visitDate = nil
                                }
                                try? viewContext.save()
                            }
                        ))
                        .font(.headline)
                        
                        Text("Toggle to track your visit to this bar")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // Memo Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Personal Notes")
                            .font(.headline)
                        
                        TextEditor(text: $memoText)
                            .frame(minHeight: 120)
                            .padding(8)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                        
                        Text("Add your thoughts, experiences, or reminders about this bar")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    Spacer(minLength: 50)
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    bar.memo = memoText
                    do {
                        try viewContext.save()
                        presentationMode.wrappedValue.dismiss()
                    } catch {
                        print("Error saving memo: \(error)")
                    }
                }
                .fontWeight(.semibold)
            )
        }
        .onAppear {
            memoText = bar.wrappedMemo
        }
    }
}
