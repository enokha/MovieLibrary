import SwiftUI
import PhotosUI

struct AddOrEditMovieView: View {
    
    @EnvironmentObject var movieVM: MovieViewModel
    @Environment(\.dismiss) var dismiss
    
    var existingMovie: Movie?
    
    // temp storage for form fields
    @State private var title: String = ""
    @State private var releaseYear: String = ""
    @State private var rating: Int = 0
    @State private var description: String = ""
    @State private var posterURL: String = ""
    @State private var selectedImageData: Data? = nil
    
    // image picker
    @State private var showPhotoPicker = false
    @State private var photoItem: PhotosPickerItem? = nil
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Movie Info")) {
                    TextField("Title *", text: $title)
                    TextField("Release Year *", text: $releaseYear)
                    
                    Stepper("Rating: \(rating)/5 ⭐️", value: $rating, in: 0...5)
                    
                    TextEditor(text: $description)
                        .frame(minHeight: 100)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                }
                
                Section(header: Text("Poster")) {
                    TextField("Poster URL", text: $posterURL)
                        .keyboardType(.URL)
                    
                    Button("Select Poster from Gallery") {
                        showPhotoPicker = true
                    }
                    
                    // Preview of selected image
                    if let selectedImageData = selectedImageData,
                       let uiImage = UIImage(data: selectedImageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 150)
                            .cornerRadius(8)
                    } else if !posterURL.isEmpty, let url = URL(string: posterURL) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            Color.gray
                        }
                        .frame(height: 150)
                        .cornerRadius(8)
                    }
                }
                
                Section {
                    Button(existingMovie == nil ? "Add Movie" : "Save Changes") {
                        saveMovie()
                    }
                }
            }
            .navigationTitle(existingMovie == nil ? "Add Movie 🎬" : "Edit Movie 🎬")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            // photo picker sheet
            .photosPicker(isPresented: $showPhotoPicker, selection: $photoItem, matching: .images)
            .onChange(of: photoItem) { newItem in
                // Async load selected image
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        selectedImageData = data
                    }
                }
            }
            .onAppear {
                if let movie = existingMovie {
                    title = movie.title
                    releaseYear = movie.releaseYear
                    rating = movie.rating
                    description = movie.description
                    if let url = movie.posterURL {
                        posterURL = url
                    }
                    if let data = movie.posterData {
                        selectedImageData = data
                    }
                }
            }
        }
    }
    
    private func saveMovie() {
        // validate fields
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty,
              !releaseYear.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        if let existingMovie = existingMovie {
            // Update
            let updated = Movie(
                id: existingMovie.id,
                title: title,
                releaseYear: releaseYear,
                rating: rating,
                description: description,
                posterData: selectedImageData,
                posterURL: posterURL.isEmpty ? nil : posterURL
            )
            movieVM.updateMovie(updated)
        } else {
            // creaute new
            let newMovie = Movie(
                title: title,
                releaseYear: releaseYear,
                rating: rating,
                description: description,
                posterData: selectedImageData,
                posterURL: posterURL.isEmpty ? nil : posterURL
            )
            movieVM.addMovie(newMovie)
        }
        
        dismiss()
    }
}

struct AddOrEditMovieView_Previews: PreviewProvider {
    static var previews: some View {
        AddOrEditMovieView()
            .environmentObject(MovieViewModel())
    }
}
