import SwiftUI

struct CategoriesView: View {
    @StateObject private var phraseService = PhraseService()
    
    var body: some View {
        NavigationView {
            List(Category.allCases, id: \.self) { category in
                NavigationLink(destination: CategoryView(category: category, phraseService: phraseService)) {
                    HStack {
                        Text(category.rawValue)
                            .font(.title3)
                            .foregroundColor(.neonGreen)
                        Spacer()
                        Text("\(phraseService.phrases(for: category).count) phrases")
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                    }
                    .padding()
                    .background(Color.darkSurface)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.neonGreen, lineWidth: 1)
                    )
                }
            }
            .navigationTitle("Categories")
        }
    }
}

#Preview {
    CategoriesView()
}