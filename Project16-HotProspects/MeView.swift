//
//  MeView.swift
//  Project16-HotProspects
//
//  Created by suhail on 22/12/24.
//
import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI

struct MeView: View {
    
    @AppStorage("name") private var name = "Anonymous"
    @AppStorage("emailAddress") private var emailAddress = "you@yoursite.com"
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    @State private var qrCode = UIImage()
    
    var body: some View {
        NavigationStack{
            Form{
                TextField("Name", text: $name)
                    .textContentType(.name)
                    .font(.title)
                
                TextField("Email address", text: $emailAddress)
                    .textContentType(.emailAddress)
                    .font(.title)
                
                Image(uiImage: qrCode)
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200,height: 200)
                    .contextMenu{
                        let image = Image(uiImage: qrCode)
                        
                        ShareLink(item: image, preview: SharePreview("My Qr Code", icon: image))
                    }
                    
            }
            .navigationTitle("Your code")
            .onAppear(perform: updateQrCode)
            .onChange(of: name, updateQrCode)
            .onChange(of: emailAddress, updateQrCode)

        }
    }
    func generateQRCode(from string: String) -> UIImage{
        
        filter.message = Data(string.utf8)
        
        if let outputImage = filter.outputImage{
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent){
                return UIImage(cgImage: cgImage)
            }
        }
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
    func updateQrCode(){
        qrCode = generateQRCode(from: "\(name)\n\(emailAddress)")
    }
}

#Preview {
    MeView()
}
