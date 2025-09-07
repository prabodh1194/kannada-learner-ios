import SwiftUI

struct MainTabView: View {
    @StateObject private var phraseService = PhraseService()
    
    var body: some View {
        TabView {
            CategoriesView()
                .tabItem {
                    Image(systemName: "square.grid.2x2")
                    Text("Categories")
                }
            
            FavoritesView(phraseService: phraseService)
                .tabItem {
                    Image(systemName: "heart")
                    Text("Favorites")
                }
        }
        .environmentObject(phraseService)
    }
}

#Preview {
    MainTabView()
}