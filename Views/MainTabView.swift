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
            
            SearchView(phraseService: phraseService)
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
            
            PracticeView()
                .tabItem {
                    Image(systemName: "brain")
                    Text("Practice")
                }
            
            RecentlyPracticedView(phraseService: phraseService)
                .tabItem {
                    Image(systemName: "clock")
                    Text("Recent")
                }
            
            DailyGoalView(phraseService: phraseService)
                .tabItem {
                    Image(systemName: "target")
                    Text("Goal")
                }
            
            HistoryView(phraseService: phraseService)
                .tabItem {
                    Image(systemName: "calendar")
                    Text("History")
                }
            
            ReviewView(phraseService: phraseService)
                .tabItem {
                    Image(systemName: "book")
                    Text("Review")
                }
            
            CollectionsView(phraseService: phraseService)
                .tabItem {
                    Image(systemName: "folder")
                    Text("Collections")
                }
            
            ProgressView(phraseService: phraseService)
                .tabItem {
                    Image(systemName: "chart.bar")
                    Text("Progress")
                }
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
        .environmentObject(phraseService)
    }
}

#Preview {
    MainTabView()
}