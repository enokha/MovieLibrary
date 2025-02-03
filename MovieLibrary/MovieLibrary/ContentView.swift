import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var movieVM: MovieViewModel
    
    @State private var showingAddMovie = false
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Search Movies...", text: $movieVM.searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                List {
                    ForEach(movieVM.filteredMovies) { movie in
                        NavigationLink(destination: MovieDetailView(movie: movie)) {
                            MovieRowView(movie: movie)
                        }
                    }
                    .onDelete(perform: movieVM.deleteMovie)
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("My Movies ⭐️")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu {
                        Button("Sort by Title") {
                            movieVM.sortByTitle()
                        }
                        Button("Sort by Rating") {
                            movieVM.sortByRating()
                        }
                        Button("Sort by Year") {
                            movieVM.sortByYear()
                        }
                    } label: {
                        Label("Sort", systemImage: "arrow.up.arrow.down")
                    }
                }
                
                // toggle dark mode
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        movieVM.toggleDarkMode()
                    }) {
                        Image(systemName: movieVM.isDarkMode ? "moon.fill" : "sun.max.fill")
                            .foregroundColor(movieVM.isDarkMode ? .yellow : .blue)
                    }
                }
                
                // add movie button
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddMovie.toggle()
                    }) {
                        Label("Add Movie", systemImage: "plus")
                    }
                }
            }
            // Add movie sheet
            .sheet(isPresented: $showingAddMovie) {
                AddOrEditMovieView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(MovieViewModel())
    }
}
