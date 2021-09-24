/// Copyright (c) 2021 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import SwiftUI

struct EditAcronymView: View {
  var acronym: Acronym
  @State var short: String
  @State var long: String
  @Environment(\.presentationMode) var presentationMode
  @EnvironmentObject var auth: Auth
  @State private var showingAcronymSaveErrorAlert = false

  init(acronym: Acronym) {
    self.acronym = acronym
    _short = State(initialValue: acronym.short)
    _long = State(initialValue: acronym.long)
  }

  var body: some View {
    NavigationView {
      Form {
        Section(header: Text("Acronym").textCase(.uppercase)) {
          TextField("Acronym", text: $short)
        }
        Section(header: Text("Meaning").textCase(.uppercase)) {
          TextField("Meaning", text: $long)
        }
      }
      .navigationBarTitle("Edit Acronym", displayMode: .inline)
      .navigationBarItems(
        leading:
          Button(
            action: {
              presentationMode.wrappedValue.dismiss()
            }, label: {
              Text("Cancel")
                .fontWeight(Font.Weight.regular)
            }),
        trailing:
          Button(action: updateAcronym) {
            Text("Save")
          }
          .disabled(short.isEmpty || long.isEmpty)
      )
    }
    .alert(isPresented: $showingAcronymSaveErrorAlert) {
      Alert(title: Text("Error"), message: Text("There was a problem saving the acronym"))
    }
  }

  func updateAcronym() {
    let data = CreateAcronymData(short: self.short, long: self.long)
    guard let id = self.acronym.id else {
      fatalError("Acronym had no ID")
    }
    AcronymRequest(acronymID: id).update(with: data, auth: auth) { result in
      switch result {
      case .failure:
        DispatchQueue.main.async {
          self.showingAcronymSaveErrorAlert = true
        }
      case .success(_):
        DispatchQueue.main.async {
          self.acronym.short = self.short
          self.acronym.long = self.long
          presentationMode.wrappedValue.dismiss()
        }
      }
    }
  }
}

struct EditAcronymView_Previews: PreviewProvider {
  static var previews: some View {
    EditAcronymView(acronym: dummyAcronyms[0])
  }
}
