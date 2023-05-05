//
//  Content-ViewModel.swift
//  TimeCountDown
//
//  Created by Khương Viết Tài on 04/05/2023.
//

import Foundation
import AVFoundation



extension ContentView {
    final class ViewModel: ObservableObject {
        private var player: AVAudioPlayer?
        @Published var isActive = false
        @Published var showingAlert = false
        @Published var time: String = "5:00"
        @Published var minutes: Float = 5.0 {
            didSet {
                self.time = "\(Int(minutes)):00"
            }
        }
        private var initialTime = 0
        private var endDate = Date()
        
        func start(minutes: Float) {
            self.initialTime = Int(minutes)
            self.endDate = Date()
            self.isActive = true
            self.endDate = Calendar.current.date(byAdding: .minute, value: Int(minutes), to: endDate)!
            
           
        }

        
       
        func reset() {
            self.minutes = Float(initialTime)
            self.isActive = false
            self.time = "\(Int(minutes)):00"
        }

        func updateCountdown(){
            guard isActive else { return }
            
            let now = Date()
            let diff = endDate.timeIntervalSince1970 - now.timeIntervalSince1970
            
            if diff < 0 {
                self.isActive = false
                self.time = "0:00"
                if let url = Bundle.main.url(forResource: "audio", withExtension: "mp3") {
                            player = try? AVAudioPlayer(contentsOf: url)
                            player?.play()
                        }
                self.showingAlert = true
                return
            }
            

            let date = Date(timeIntervalSince1970: diff)
            let calendar = Calendar.current
            let minutes = calendar.component(.minute, from: date)
            let seconds = calendar.component(.second, from: date)


            self.minutes = Float(minutes)
            self.time = String(format:"%d:%02d", minutes, seconds)
        }
    }
}
