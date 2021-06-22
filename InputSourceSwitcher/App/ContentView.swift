import KeyboardShortcuts
import SwiftUI

// [ContentView]
struct ContentView: View {
    @ObservedObject var MyInputSources: InputSourcesModel

    var body: some View {
        VStack {
            BottomOptionView(MyInputSources: MyInputSources)
            Divider()
            HStack {
                SwitchButtonView(MyInputSources: MyInputSources)
                ShortcutsView(MyInputSources: MyInputSources)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct BottomOptionView: View {
    @ObservedObject var MyInputSources: InputSourcesModel

    var body: some View {
        HStack {
            Button("Reset") {
                print("[Button] Reset clicked")
                MyInputSources.Reset() // reset InputSources and KeyboardShortcuts
            }
            Button("Quit") {
                print("[Button] Quit clicked")
                NSApplication.shared.terminate(self) // quit app == cmd Q
            }
        }
    }
}

struct SwitchButtonView: View {
    @ObservedObject var MyInputSources: InputSourcesModel

    var body: some View {
        VStack {
            ForEach(MyInputSources.currentInputSources) { inputSource in
                Button("Switch To \(inputSource.name)") {
                    print("[UI] Button Switch To \(inputSource.name) Clicked!")

                    MyInputSources.SwitchInputSource(to: inputSource.name)
                }
            }
        }
    }
}

struct ShortcutsView: View {
    @ObservedObject var MyInputSources: InputSourcesModel

    var body: some View {
        VStack {
            // show switch buttons
            ForEach(MyInputSources.currentInputSources) { inputSource in
                HStack {
                    let shortcut = KeyboardShortcuts.Name(inputSource.name)

                    HStack(alignment: .firstTextBaseline) {
                        KeyboardShortcuts.Recorder(for: shortcut)
                            .padding(.trailing, 10)
                    }
                    .onAppear {
                        KeyboardShortcuts.onKeyDown(for: shortcut) {
                            print("[Shortcuts] shortcut of \(inputSource.name) down")
                            MyInputSources.SwitchInputSource(to: inputSource.name)
                        }
                    }
                }
            }
        }
    }
}
