//
//  EnterProspect.swift
//  Project16-HotProspects
//
//  Created by suhail on 27/12/24.
//

import SwiftUI

struct EnterProspect: View {
    @State private var name = ""
    @State private var email = ""
    @State private var isCOntacted = true
    @Environment(\.dismiss) var dismiss
    var completion : (Prospect) -> Void
    var body: some View {
        NavigationStack{
            Form{
                Section{
                    VStack(spacing: 20) {
                        TextField("Enter name", text: $name)
                            .font(.title)
                        
                        TextField("Enter email", text: $email)
                            .font(.title)
                        Toggle("Is contacted?", isOn: $isCOntacted)
                            .font(.title2)
                    }
                }
                Button("Save"){
                    let newPrsopect = Prospect(name: name, emailAddress: email, isContacted: isCOntacted)
                    completion(newPrsopect)
                    dismiss()
                }
                
            }
            
                .navigationTitle("Enter Details")
        }
    }
}

#Preview {
    EnterProspect(){ _ in }
}
