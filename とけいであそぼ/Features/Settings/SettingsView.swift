//
//  SettingsView.swift
//  とけいであそぼ
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("soundEnabled") private var soundEnabled = true
    @AppStorage("hapticsEnabled") private var hapticsEnabled = true
    @AppStorage("childAge") private var childAge = 5
    
    var body: some View {
        List {
            // Age setting
            Section {
                Stepper(value: $childAge, in: 3...12) {
                    HStack {
                        Text("ねんれい")
                        Spacer()
                        Text("\(childAge)さい")
                            .foregroundColor(.tokeiInkSecondary)
                    }
                }
            } header: {
                Text("こどもの せってい")
            }
            
            // Sound and haptics
            Section {
                Toggle(isOn: $soundEnabled) {
                    Label("おと", systemImage: "speaker.wave.2.fill")
                }
                
                Toggle(isOn: $hapticsEnabled) {
                    Label("しんどう", systemImage: "hand.tap.fill")
                }
            } header: {
                Text("おと と しんどう")
            }
            
            // Parent area
            Section {
                NavigationLink(destination: ParentAreaView()) {
                    Label("ほごしゃ エリア", systemImage: "lock.fill")
                }
            } header: {
                Text("ほごしゃ よう")
            }
            
            // About
            Section {
                HStack {
                    Text("バージョン")
                    Spacer()
                    Text("1.0.0")
                        .foregroundColor(.tokeiInkSecondary)
                }
            } header: {
                Text("このアプリについて")
            }
        }
        .navigationTitle("せってい")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ParentAreaView: View {
    @State private var isUnlocked = false
    @State private var pinInput = ""
    private let correctPin = "1234"
    
    var body: some View {
        if isUnlocked {
            ParentDashboardView()
        } else {
            PinEntryView(
                pin: $pinInput,
                onComplete: { enteredPin in
                    if enteredPin == correctPin {
                        isUnlocked = true
                    } else {
                        pinInput = ""
                    }
                }
            )
        }
    }
}

struct PinEntryView: View {
    @Binding var pin: String
    let onComplete: (String) -> Void
    
    private let columns = Array(repeating: GridItem(.flexible()), count: 3)
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            Text("PINを にゅうりょく")
                .font(.system(size: 24, weight: .semibold, design: .rounded))
                .foregroundColor(.tokeiInkPrimary)
            
            // PIN dots
            HStack(spacing: 16) {
                ForEach(0..<4, id: \.self) { index in
                    Circle()
                        .fill(index < pin.count ? Color.tokeiAccent : Color.tokeiSubtle)
                        .frame(width: 16, height: 16)
                }
            }
            
            // Number pad
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(1...9, id: \.self) { number in
                    PinButton(label: "\(number)") {
                        addDigit("\(number)")
                    }
                }
                
                Spacer()
                
                PinButton(label: "0") {
                    addDigit("0")
                }
                
                PinButton(label: "←", isDestructive: true) {
                    if !pin.isEmpty {
                        pin.removeLast()
                    }
                }
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
        .navigationTitle("ほごしゃ エリア")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func addDigit(_ digit: String) {
        if pin.count < 4 {
            pin += digit
            if pin.count == 4 {
                onComplete(pin)
            }
        }
    }
}

struct PinButton: View {
    let label: String
    var isDestructive: Bool = false
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: 28, weight: .medium, design: .rounded))
                .foregroundColor(isDestructive ? .tokeiInkSecondary : .tokeiInkPrimary)
                .frame(width: 72, height: 72)
                .background(
                    Circle()
                        .fill(Color.tokeiSubtle.opacity(0.5))
                )
        }
    }
}

struct ParentDashboardView: View {
    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Text("きょうの がくしゅう")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(.tokeiInkSecondary)
                    
                    ProgressView(value: 0.6)
                        .tint(Color.tokeiAccent)
                    
                    Text("6ふん / 10ふん")
                        .font(.system(size: 12, weight: .regular, design: .rounded))
                        .foregroundColor(.tokeiInkSecondary)
                }
                .padding(.vertical, 8)
            } header: {
                Text("きょうの しんちょく")
            }
            
            Section {
                StatRow(label: "せいかいりつ", value: "78%")
                StatRow(label: "れんぞく にっすう", value: "3にち")
                StatRow(label: "そうがくしゅう じかん", value: "45ふん")
            } header: {
                Text("とうけい")
            }
            
            Section {
                Text("3じ と 9じ を まちがえる けいこうが あります")
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .foregroundColor(.tokeiInkSecondary)
            } header: {
                Text("つまずき ポイント")
            }
            
            Section {
                Button(action: {}) {
                    Text("がくしゅう データを リセット")
                        .foregroundColor(.red)
                }
            }
        }
        .navigationTitle("ほごしゃ ダッシュボード")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct StatRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
            Spacer()
            Text(value)
                .foregroundColor(.tokeiAccent)
                .fontWeight(.semibold)
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
