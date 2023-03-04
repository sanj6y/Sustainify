//
//  ContentView.swift
//  Sustainly
//
//  Created by Sanjay Chandrasekar on 2/3/23.
//

import SwiftUI
import CodeScanner
import AVFoundation

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Button(action: {
                    // Present the ViewController when the button is tapped
                    let scannerViewController = BarcodeScannerViewController()
                    UIApplication.shared.windows.first?.rootViewController?.present(scannerViewController, animated: true, completion: nil)
                }) {
                    Text("Scan")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(40)
                }
                Spacer()
            }
            .padding()
        }
    }
}
//
//struct ContentView: View {
//    @State var PresentingScannerView = true
//    var scanner : some View {
//        CodeScannerView(codeTypes: [.qr], completion: {result in
//            if case let .success(code) = result {
//                self.scannedQRCode = code.string
//                self.PresentingScannerView = true
//            }
//        }
//        )
//    }
//}
//
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}




