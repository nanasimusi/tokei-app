//
//  TokeiTypography.swift
//  とけいであそぼ
//

import SwiftUI

struct TokeiTypography {
    // Large time display
    static func largeTitle() -> Font {
        .system(.largeTitle, design: .rounded, weight: .bold)
    }
    
    // Section headings
    static func title() -> Font {
        .system(.title2, design: .rounded, weight: .semibold)
    }
    
    // Body text
    static func body() -> Font {
        .system(.body, design: .rounded, weight: .regular)
    }
    
    // Caption / helper text
    static func caption() -> Font {
        .system(.caption, design: .rounded, weight: .medium)
    }
    
    // Clock face numbers
    static func clockNumber(size: CGFloat) -> Font {
        .system(size: size, weight: .medium, design: .rounded)
    }
}

extension View {
    func tokeiLargeTitle() -> some View {
        self.font(TokeiTypography.largeTitle())
    }
    
    func tokeiTitle() -> some View {
        self.font(TokeiTypography.title())
    }
    
    func tokeiBody() -> some View {
        self.font(TokeiTypography.body())
    }
    
    func tokeiCaption() -> some View {
        self.font(TokeiTypography.caption())
    }
}
