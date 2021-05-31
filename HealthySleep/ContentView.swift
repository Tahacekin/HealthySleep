//
//  ContentView.swift
//  HealthySleep
//
//  Created by Taha Çekin on 31.05.2021.
//

import SwiftUI

struct ContentView: View {
  @State private var wakeUp = Date()
  @State private var sleepAmount = 8.0
  @State private var coffeAmount = 1

  @State private var alertTitle = ""
  @State private var alertMessage = ""
  @State private var showingAlert = false


  var body: some View {
    NavigationView {
      VStack {

        Spacer()

        Text("When do you want to wake up?")
          .font(.headline)

        DatePicker("Please Select a Time", selection: $wakeUp, displayedComponents: .hourAndMinute).labelsHidden()

        Spacer()

        Text("Desired Amount Of Sleep")
          .font(.headline)

        Stepper("\(sleepAmount, specifier: "%g") hours", value: $sleepAmount, in: 4...12, step: 0.25).padding()

        Spacer()

        Text("Daily Coffee Intake")
          .font(.headline)

        Stepper("\((coffeAmount == 1) ? "\(coffeAmount) cup" : "\(coffeAmount) cups")", value: $coffeAmount, in: 1...15).padding()

        Spacer()
      }.navigationBarTitle("Healthy Sleep")
      .navigationBarItems(trailing:
        Button(action: calculateBedTime) {
        Text("Calculate")
      })
      .alert(isPresented: $showingAlert, content: {
        Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
      })
    }
  }

  func calculateBedTime() {
    let model = SleepCalculater()

    let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
    let hour = (components.hour ?? 0) * 60 * 60
    let minute = (components.minute ?? 0) * 60

    do {

      let prediction = try model.prediction(coffee: Double(coffeAmount), estimatedSleep: sleepAmount, wake: Double(hour + minute))

      let sleepTime = wakeUp - prediction.actualSleep

      let formatter = DateFormatter()
      formatter.timeStyle = .short

      alertMessage = formatter.string(from: sleepTime)
      alertTitle = "Your Ideal Sleep Time is..."

    }
    catch {
      alertTitle = "Error"
      alertMessage = "Something went wrong when calculating your Sleep Time."
    }

    showingAlert = true
    
  }

}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

var a = ""
var b = 1
