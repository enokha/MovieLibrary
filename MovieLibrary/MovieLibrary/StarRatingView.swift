import SwiftUI

struct StarRatingView: View {
    @Binding var rating: Int

    var body: some View {
        HStack {
            ForEach(1...5, id: \.self) { star in
                Image(systemName: star <= rating ? "star.fill" : "star")
                    .foregroundColor(.yellow)
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            rating = star
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        }
                    }
            }
        }
    }
}
