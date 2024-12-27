//
//  ProspectsView.swift
//  Project16-HotProspects
//
//  Created by suhail on 22/12/24.
//

import SwiftUI
import SwiftData
import UserNotifications

struct ProspectsView: View {
    
    enum FilterType{
        case none, contacted, uncontacted
    }
    
    let filter: FilterType
    @Query(sort: \Prospect.name) var prospects: [Prospect]
    @Environment(\.modelContext) var modelContext
    @State private var selectedProspects = Set<Prospect>()
    @State private var isShowingScanner = false
    
    var title: String{
        switch filter {
        case .none:
            "Everyone"
        case .contacted:
            "Contacted people"
        case .uncontacted:
            "Uncontacted people"
        }
    }
    var body: some View {
        NavigationStack{
            List(prospects, selection: $selectedProspects){  prospect in
                VStack(alignment: .leading){
                    HStack{
                        VStack{
                            Text(prospect.name)
                                .font(.headline)
                            Text(prospect.emailAddress)
                                .foregroundStyle(.secondary)
                        }
                        
                        if filter == .none{
                            Spacer()
                            let status = prospect.isContacted ? Color.green : Color.red
                            
                            status
                                .frame(width: 15,height: 15)
                                .clipShape(.circle)
                        
                        }
                    }
                }
                .swipeActions{
                    
                    Button("Delete", systemImage: "trash", role: .destructive){
                        modelContext.delete(prospect)
                    }
                    
                    if prospect.isContacted{
                        Button("Mark Uncontacted", systemImage: "person.crop.circle.badge.xmark"){
                            prospect.isContacted.toggle()
                        }
                        .tint(.blue)
                    }else{
                        Button("Mark Contacted", systemImage: "person.crop.circle.badge.checkmark"){
                            prospect.isContacted.toggle()
                        }
                        .tint(.green)
                        Button("Remind Me", systemImage: "bell"){
                            addNotification(for: prospect)
                        }
                        .tint(.orange)
                    }
                }
                .tag(prospect)
            }
            .navigationTitle(title)
                .toolbar{
                    ToolbarItemGroup(placement: .topBarTrailing){
                        NavigationLink {
                            EnterProspect { newProspect in
                                modelContext.insert(newProspect)

                            }
                        } label: {
                            Image(systemName: "qrcode.viewfinder")
                        }
                           
                      
                    }
                    
                        if selectedProspects.isEmpty == false{
                            ToolbarItem(placement: .bottomBar) {
                                Button("Delete Selected", action: deleteAllSelected)
                            }
                        }
                    
                    ToolbarItem(placement: .topBarLeading) {
                       EditButton()
                    }
                }
        }
        
    }
    init(filter: FilterType) {
        self.filter = filter
        if filter != .none{
            let showCOntactedOnly = filter == .contacted
           
            _prospects = Query(filter: #Predicate {
          
                $0.isContacted == showCOntactedOnly
            },sort: [SortDescriptor(\Prospect.name)])
        }
    }
    func deleteAllSelected(){
        for prospect in selectedProspects {
            modelContext.delete(prospect)
        }
    }
    
    func addNotification(for prospect: Prospect){
        let center = UNUserNotificationCenter.current()
        
        let addRequest = {
           let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.subtitle = prospect.emailAddress
            content.sound = UNNotificationSound.default
            
           // var dateComponents = DateComponents()
           // dateComponents.hour = 9
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }
        
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized{
                addRequest()
            }else{
                center.requestAuthorization(options: [.alert,.badge,.sound]) { success, error in
                    if success{
                        addRequest()
                    }else if let error{
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
}

#Preview {
    ProspectsView(filter: .none)
}
