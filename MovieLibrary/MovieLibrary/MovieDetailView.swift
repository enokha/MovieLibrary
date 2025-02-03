import SwiftUI

struct MovieDetailView: View {
    
    @EnvironmentObject var movieVM: MovieViewModel
    @Environment(\.dismiss) var dismiss
    
    let movie: Movie
    
    @State private var showingEditView = false
    
    var body: some View {
        VStack {
            // Poster
            if let data = movie.posterData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 250)
                    .padding()
            } else if let posterURL = movie.posterURL, let url = URL(string: posterURL) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    Color.gray
                }
                .frame(height: 250)
                .padding()
            } else {
                Rectangle()
                    .fill(Color.gray)
                    .frame(height: 250)
                    .padding()
            }
            
            // Movie Info
            Text(movie.title)
                .font(.largeTitle)
                .bold()
                .padding(.top)
            
            Text("Year: \(movie.releaseYear)")
                .font(.headline)
                .padding(.top, 2)
            
            Text("Rating: \(movie.rating)/5 ⭐️")
                .foregroundColor(.orange)
                .padding(.top, 2)
            
            ScrollView {
                Text(movie.description)
                    .font(.body)
                    .padding()
            }
            
            Spacer()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button("Edit") {
                    showingEditView = true
                }
                Button(role: .destructive) {
                    deleteMovie()
                } label: {
                    Image(systemName: "trash")
                }
            }
        }
        .sheet(isPresented: $showingEditView) {
            AddOrEditMovieView(existingMovie: movie)
        }
        .transition(.opacity)
        .animation(.easeInOut, value: UUID())
    }
    
    func deleteMovie() {
        // Find the index of this movie and remove it
        if let index = movieVM.movies.firstIndex(where: { $0.id == movie.id }) {
            movieVM.movies.remove(at: index)
            movieVM.saveMoviesToUserDefaults()
            dismiss()
        }
    }
}

struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleMovie = Movie(
            title: "Sample Title",
            releaseYear: "2021",
            rating: 4,
            description: "Some description here.",
            posterData: nil,
            posterURL: "https://via.placeholder.com/300.png"
        )
        
        return NavigationView {
            MovieDetailView(movie: sampleMovie)
                .environmentObject(MovieViewModel())
        }
    }
}
