import SwiftUI

struct CollectionsView: View {
    @ObservedObject var phraseService: PhraseService
    @State private var showingAddCollection = false
    @State private var newCollectionName = ""
    
    var body: some View {
        VStack {
            List {
                ForEach(phraseService.collections) { collection in
                    NavigationLink(destination: CollectionDetailView(phraseService: phraseService, collection: collection)) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(collection.name)
                                    .font(.headline)
                                    .foregroundColor(.neonGreen)
                                Text("\(collection.phraseIds.count) phrases")
                                    .font(.caption)
                                    .foregroundColor(.textSecondary)
                            }
                            Spacer()
                            Text(dateFormatter.string(from: collection.updatedDate))
                                .font(.caption)
                                .foregroundColor(.textSecondary)
                        }
                        .padding()
                        .background(Color.darkSurface)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.neonBlue, lineWidth: 1)
                        )
                    }
                }
                .onDelete(perform: deleteCollections)
            }
            
            Button(action: {
                showingAddCollection = true
            }) {
                HStack {
                    Image(systemName: "plus")
                    Text("New Collection")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.neonGreen)
                .foregroundColor(.darkBackground)
                .cornerRadius(12)
            }
            .padding()
        }
        .navigationTitle("Collections")
        .alert("New Collection", isPresented: $showingAddCollection) {
            TextField("Collection name", text: $newCollectionName)
            Button("Cancel", role: .cancel) { }
            Button("Create") {
                createCollection()
            }
        } message: {
            Text("Enter a name for your new collection")
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
    
    private func createCollection() {
        if !newCollectionName.isEmpty {
            let newCollection = PhraseCollection(name: newCollectionName, phraseIds: [])
            phraseService.addCollection(newCollection)
            newCollectionName = ""
        }
    }
    
    private func deleteCollections(offsets: IndexSet) {
        for index in offsets {
            phraseService.deleteCollection(phraseService.collections[index])
        }
    }
}

#Preview {
    NavigationView {
        CollectionsView(phraseService: PhraseService())
    }
}