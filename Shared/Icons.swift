//
//  Icons.swift
//  WatchyGPS
//
//  Created by Ben Goldberg on 7/19/22.
//

import SwiftUI

// created by me

// I created the smiley icon
struct SmileyShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = min(rect.size.width, rect.size.height)
        let height = width
        path.addEllipse(in: CGRect(x: 0, y: 0, width: width, height: height))
        path.move(to: CGPoint(x: 0.77896*width, y: 0.57625*height))
        path.addCurve(to: CGPoint(x: 0.50271*width, y: 0.84458*height), control1: CGPoint(x: 0.84146*width, y: 0.57625*height), control2: CGPoint(x: 0.72875*width, y: 0.84208*height))
        path.addCurve(to: CGPoint(x: 0.22188*width, y: 0.57625*height), control1: CGPoint(x: 0.27083*width, y: 0.84729*height), control2: CGPoint(x: 0.15771*width, y: 0.57625*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.77896*width, y: 0.59437*height))
        path.addCurve(to: CGPoint(x: 0.50271*width, y: 0.86271*height), control1: CGPoint(x: 0.83437*width, y: 0.56708*height), control2: CGPoint(x: 0.72917*width, y: 0.86021*height))
        path.addCurve(to: CGPoint(x: 0.22188*width, y: 0.59437*height), control1: CGPoint(x: 0.27083*width, y: 0.86521*height), control2: CGPoint(x: 0.16417*width, y: 0.56604*height))
        path.closeSubpath()
        return path
    }
}

struct Smiley2: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = min(rect.size.width, rect.size.height)
        let height = width
        path.move(to: CGPoint(x: 0.77896*width, y: 0.57625*height))
        path.addCurve(to: CGPoint(x: 0.50271*width, y: 0.84458*height), control1: CGPoint(x: 0.84146*width, y: 0.57625*height), control2: CGPoint(x: 0.72875*width, y: 0.84208*height))
        path.addCurve(to: CGPoint(x: 0.22188*width, y: 0.57625*height), control1: CGPoint(x: 0.27083*width, y: 0.84729*height), control2: CGPoint(x: 0.15771*width, y: 0.57625*height))
        path.closeSubpath()
        return path
    }
}

struct Smiley2Inv: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = min(rect.size.width, rect.size.height)
        let height = width
        path.move(to: CGPoint(x: 0.77896*width, y: (0.57625-0.57625)*height))
        path.addCurve(to: CGPoint(x: 0.50271*width, y: (0.84458-0.57625)*height), control1: CGPoint(x: 0.84146*width, y: (0.57625-0.57625)*height), control2: CGPoint(x: 0.72875*width, y: (0.84208-0.57625)*height))
        path.addCurve(to: CGPoint(x: 0.22188*width, y: (0.57625-0.57625)*height), control1: CGPoint(x: 0.27083*width, y: (0.84729-0.57625)*height), control2: CGPoint(x: 0.15771*width, y: (0.57625-0.57625)*height))
        path.closeSubpath()
        return path
    }
}

struct SmileyEyes: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = min(rect.size.width, rect.size.height)
        let height = width
        path.move(to: CGPoint(x: 0, y: 0))
        path.addEllipse(in: CGRect(x: (14.75-2.98)/48.0*width, y: (15.56-5.26)/48.0*height, width: 2*2.98/48.0*width, height: 2*5.26/48.0*height))
        path.closeSubpath()
        path.addEllipse(in: CGRect(x: (32.37-2.98)/48.0*width, y: (15.56-5.26)/48.0*height, width: 2*2.98/48.0*width, height: 2*5.26/48.0*height))
        path.closeSubpath()
        return path
    }
}

struct SmileyMouthWhite: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = min(rect.size.width, rect.size.height)
        let height = width
        path.move(to: CGPoint(x: 0.24333*width, y: 0.59958*height))
        path.addCurve(to: CGPoint(x: 0.7575*width, y: 0.59958*height), control1: CGPoint(x: 0.45687*width, y: 0.6025*height), control2: CGPoint(x: 0.55833*width, y: 0.6025*height))
        path.addCurve(to: CGPoint(x: 0.50042*width, y: 0.65396*height), control1: CGPoint(x: 0.82312*width, y: 0.59958*height), control2: CGPoint(x: 0.65979*width, y: 0.65146*height))
        path.addCurve(to: CGPoint(x: 0.24333*width, y: 0.59958*height), control1: CGPoint(x: 0.34104*width, y: 0.65646*height), control2: CGPoint(x: 0.17771*width, y: 0.59875*height))
        path.closeSubpath()
        return path
    }
}

struct Smiley: View {
    var body: some View {
        ZStack {
            SmileyShape()
                .foregroundColor(.yellow)
                .zIndex(1)
            Smiley2()
                .foregroundColor(.black)
                .zIndex(2)
            SmileyEyes()
                .foregroundColor(.black)
                .zIndex(10)
            SmileyMouthWhite()
                .foregroundColor(.white)
                .zIndex(4)
        }
        .drawingGroup()
    }
}

struct SadFace: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                SmileyShape()
                    .foregroundColor(.blue)
                    .zIndex(1)
                VStack {
                    Smiley2Inv()
                        .foregroundColor(.black)
                        .rotationEffect(Angle.degrees(180))
                    Spacer()
                        .frame(height: geometry.size.height-geometry.size.height*0.84729)
                }
                .zIndex(2)
                SmileyEyes()
                    .foregroundColor(.black)
                    .zIndex(3)
            }
        }
    }
}
