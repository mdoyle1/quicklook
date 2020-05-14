//
//  ActivityIndicator.swift
//  quicklook
//
//  Created by Toxicspu on 3/31/20.
//  Copyright © 2020 developer. All rights reserved.
//

import SwiftUI

//https://stackoverflow.com/questions/56496638/activity-indicator-in-swiftui
//https://www.youtube.com/watch?v=IQ4cuotho-U


struct ActivityIndicator: UIViewRepresentable {

    typealias UIView = UIActivityIndicatorView
    var isAnimating: Bool
    var configuration = { (indicator: UIView) in }

    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIView { UIView() }
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<Self>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
        configuration(uiView)
    }
}
extension View where Self == ActivityIndicator {
    func configure(_ configuration: @escaping (Self.UIView)->Void) -> Self {
        Self.init(isAnimating: self.isAnimating, configuration: configuration)
    }
}

struct Ring: Shape {
    var fillPoint: Double
    public var delayPoint: Double = 0.5
    var animatableData: Double {
        get { return fillPoint }
        set { fillPoint = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var start:Double = 0
        let end = 360 * fillPoint
        var path = Path()
        if fillPoint > delayPoint {
            start = (2 * fillPoint) * 360
        } else { start = 0 }
        path.addArc(center: CGPoint(x:rect.size.width/2, y:rect.size.height/2), radius: rect.size.width/2, startAngle: .degrees(start), endAngle: .degrees(end), clockwise: false)
        return path
    }
}


struct LoadingView<Content>: View where Content: View {

    @Binding var isShowing: Bool
    @State private var loading = false
    @State private var fillPoint = 0.0
    private var animation: Animation {Animation.linear(duration: 2.0).repeatForever(autoreverses: false)}
    var content: () -> Content

    var body: some View {
        GeometryReader { geometry in
            ZStack {

                self.content()
                    .disabled(self.isShowing)
                    .blur(radius: self.isShowing ? 3 : 0)

                VStack {
                    Text("Loading...")
                    Ring(fillPoint: self.fillPoint).stroke(Color.gray, lineWidth: 10).frame(width:40, height:40).onAppear(){
                                      withAnimation(self.animation) { self.fillPoint = 1.0 }
                                  }
                }
                .frame(width: geometry.size.width / 2,
                       height: geometry.size.height / 5)
                .background(Color.secondary.colorInvert())
                .foregroundColor(Color.primary)
                .cornerRadius(20)
                .opacity(self.isShowing ? 1 : 0)

            }
        }
    }

}
