import SwiftUI
import Combine

class MovieViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var searchText: String = ""
    
    // dark modes settings
    @AppStorage("isDarkMode") var isDarkMode: Bool = false
    
    var colorScheme: ColorScheme {
        isDarkMode ? .dark : .light
    }
    
    func toggleDarkMode() {
        isDarkMode.toggle()
    }
    
    init() {
        loadMoviesFromUserDefaults()
    }
    
    func addMovie(_ movie: Movie) {
        movies.append(movie)
        saveMoviesToUserDefaults()
    }
    
    func updateMovie(_ movie: Movie) {
        if let index = movies.firstIndex(where: { $0.id == movie.id }) {
            movies[index] = movie
            saveMoviesToUserDefaults()
        }
    }
    
    func deleteMovie(at offsets: IndexSet) {
        movies.remove(atOffsets: offsets)
        saveMoviesToUserDefaults()
    }
    
    // sort
    func sortByTitle() {
        movies.sort { $0.title < $1.title }
    }
    
    func sortByRating() {
        movies.sort { $0.rating > $1.rating }
    }
    
    func sortByYear() {
        movies.sort { $0.releaseYear < $1.releaseYear }
    }
    
    var filteredMovies: [Movie] {
        if searchText.isEmpty {
            return movies
        } else {
            return movies.filter { $0.title.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    func saveMoviesToUserDefaults() {
        do {
            let data = try JSONEncoder().encode(movies)
            UserDefaults.standard.set(data, forKey: "savedMovies")
        } catch {
            print("Error encoding movies: \(error)")
        }
    }
    
    private func loadMoviesFromUserDefaults() {
        if let data = UserDefaults.standard.data(forKey: "savedMovies") {
            do {
                let decodedMovies = try JSONDecoder().decode([Movie].self, from: data)
                self.movies = decodedMovies
            } catch {
                print("Error decoding movies: \(error)")
            }
        }
    }
}
