import SwiftUI

struct MovieRowView: View {
    let movie: Movie

    var body: some View {
        HStack(spacing: 12) {
            // Poster Image (from local data or URL)
            if let data = movie.posterData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 70, height: 100)
                    .cornerRadius(10)
            } else if let posterURL = movie.posterURL, let url = URL(string: posterURL) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Color.gray.opacity(0.3)
                }
                .frame(width: 70, height: 100)
                .cornerRadius(10)
            } else {
                // Default Placeholder
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 70, height: 100)
                    .cornerRadius(10)
            }

            // Movie Details (Title, Year, Rating)
            VStack(alignment: .leading, spacing: 5) {
                Text(movie.title)
                    .font(.headline)
                    .bold()
                
                Text("Year: \(movie.releaseYear)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                // Display static star rating
                StarRatingView(rating: .constant(movie.rating))
            }

            Spacer()
        }
        .padding(.vertical, 8)
    }
}

// Preview for SwiftUI Canvas
struct MovieRowView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleMovie = Movie(
            title: "Inception",
            releaseYear: "2010",
            rating: 5,
            description: "A mind-bending thriller by Christopher Nolan.",
            posterData: nil,
            posterURL: "https://m.media-amazon.com/images/I/81p+xe8cbnL._AC_SY679_.jpg"
        )
        
        MovieRowView(movie: sampleMovie)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
