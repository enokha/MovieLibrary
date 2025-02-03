import SwiftUI

@main
struct MovieLibraryApp: App {
    @StateObject private var movieVM = MovieViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(movieVM)
                .preferredColorScheme(movieVM.colorScheme)
        }
    }
}
