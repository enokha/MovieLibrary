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
                    .onDelete(perform: movieVM.deleteMovie) // swipe to delete
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
                
                // Add movie button
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddMovie.toggle()
                    }) {
                        Label("Add Movie", systemImage: "plus")
                    }
                }
            }
            // Add Movie Sheet
            .sheet(isPresented: $showingAddMovie) {
                AddOrEditMovieView()
            }
        }
    }
}

// small subview for each row
struct MovieRowView: View {
    let movie: Movie
    
    var body: some View {
        HStack {
            if let data = movie.posterData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 70)
                    .cornerRadius(8)
            } else if let posterURL = movie.posterURL, let url = URL(string: posterURL) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Color.gray
                }
                .frame(width: 50, height: 70)
                .cornerRadius(8)
            } else {
                // default image
                Rectangle()
                    .fill(Color.gray)
                    .frame(width: 50, height: 70)
                    .cornerRadius(8)
            }
            
            VStack(alignment: .leading) {
                Text(movie.title)
                    .font(.headline)
                Text(movie.releaseYear)
                    .font(.subheadline)
            }
            Spacer()
            Text("\(movie.rating)/5 ⭐️")
                .foregroundColor(.orange)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(MovieViewModel())
    }
}
