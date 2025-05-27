//
//  ContentView.swift
//  BlurredNavigationBar
//
//  Created by Shaan on 23/05/25.
//
import SwiftUI
import UIKit

// Blur View
struct VisualEffectBlur: UIViewRepresentable {
    var blurStyle: UIBlurEffect.Style
    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: blurStyle)
    }
}

// Track Scroll Offset
struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct ContentView: View {
    @State private var scrollOffset: CGFloat = 0

    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                GeometryReader { geo in
                    Color.clear
                        .preference(key: ScrollOffsetKey.self, value: geo.frame(in: .global).minY)
                }.frame(height: 0)

                VStack(spacing: 20) {
                    Image("profile")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                        .shadow(radius: 5)
                        .padding(.top, 20)

                    Text("Welcome, Fathima!")
                        .font(.title2)
                        .bold()

                    HStack(spacing: 20) {
                        ForEach(["Profile", "Settings"], id: \.self) { title in
                            Button(title) {}
                                .padding()
                                .background(title == "Profile" ? Color.blue.opacity(0.2) : Color.green.opacity(0.2))
                                .cornerRadius(10)
                        }
                    }

                    ForEach(1..<16) { i in
                        HStack {
                            Image(systemName: "star.fill").foregroundColor(.yellow)
                            Text("Item \(i)")
                            Spacer()
                        }
                        .padding()
                        .background(Color.indigo.opacity(0.3))
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                }
                .padding(.top, 100)
            }

            // Blurred Top Bar
            ZStack {
                if scrollOffset < -10 {
                    VisualEffectBlur(blurStyle: .systemMaterial)
                        .transition(.opacity)
                }
            }
            .frame(height: 100)
            .frame(maxWidth: .infinity)
            .background(Color.black.opacity(scrollOffset < -10 ? 0.1 : 0.3))
            .animation(.easeInOut, value: scrollOffset)
        }
        .onPreferenceChange(ScrollOffsetKey.self) { scrollOffset = $0 }
        .edgesIgnoringSafeArea(.top)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
