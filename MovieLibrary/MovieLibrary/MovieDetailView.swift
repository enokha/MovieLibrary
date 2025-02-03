import SwiftUI

struct MovieDetailView: View {
    @EnvironmentObject var movieVM: MovieViewModel
    @Environment(\.dismiss) var dismiss
    
    let movie: Movie
    @State private var showingEditView = false
    @State private var showDeleteConfirmation = false

    var body: some View {
        ScrollView {
            VStack {
                if let data = movie.posterData, let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 300)
                        .padding()
                } else if let posterURL = movie.posterURL, let url = URL(string: posterURL) {
                    AsyncImage(url: url) { image in
                        image.resizable()
                            .scaledToFit()
                    } placeholder: {
                        Color.gray.opacity(0.3)
                    }
                    .frame(height: 300)
                    .padding()
                }
                
                Text(movie.title)
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 10)
                
                StarRatingView(rating: .constant(movie.rating))
                    .padding(.vertical)
                
                Text("Year: \(movie.releaseYear)")
                    .font(.headline)
                    .padding(.top, 2)
                
                Text(movie.description)
                    .font(.body)
                    .padding()
            }
        }
        .navigationTitle(movie.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button("Edit") { showingEditView = true }
                Button(role: .destructive) {
                    showDeleteConfirmation = true
                } label: {
                    Image(systemName: "trash")
                }
            }
        }
        .sheet(isPresented: $showingEditView) {
            AddOrEditMovieView(existingMovie: movie)
        }
        .alert("Delete Movie?", isPresented: $showDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                deleteMovie()
            }
        }
        .transition(.opacity)
    }

    private func deleteMovie() {
        if let index = movieVM.movies.firstIndex(where: { $0.id == movie.id }) {
            movieVM.movies.remove(at: index)
            movieVM.saveMoviesToUserDefaults()
            dismiss()
        }
    }
}
