//
//  LoginView.swift
//  quicklook
//
//  Created by Toxicspu on 3/27/20.
//  Copyright © 2020 developer. All rights reserved.
//

import SwiftUI
import Dispatch

struct CustomTextField: UIViewRepresentable {
    
    class Coordinator: NSObject, UITextFieldDelegate {
        
        @Binding var text: String
        
        init(text: Binding<String>) {
            _text = text
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            text = textField.text ?? ""
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
    }
    
    @State var secure : Bool
    @State var initialText : String
    @Binding var text: String
    @State var placeholder : String
    @State var autoCaps: UITextAutocapitalizationType
    
    func makeUIView(context: UIViewRepresentableContext<CustomTextField>) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.placeholder = placeholder
        textField.delegate = context.coordinator
        textField.text = initialText
        textField.clearButtonMode = .always
        textField.isSecureTextEntry = secure
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        
        return textField
    }
    
    func makeCoordinator() -> CustomTextField.Coordinator {
        return Coordinator(text: $text)
    }
    
    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<CustomTextField>) {
        uiView.text = text
        uiView.placeholder = placeholder
    }
}


struct Login: View {
    @ObservedObject var viewModel = Defaults()
    @EnvironmentObject var controlCenter: ControlCenter
    @State var jamfURL = ""
    @State var username = ""
    @State var password = ""
    @State var clear = true
    @State private var wrongIP  =  false
    @State private var badPassword = false
    @State private var loading = false
    @State private var isPressed: Bool = false
    
    
    func clearCredentials(){
        $viewModel.defaultURL.wrappedValue = ""
        $viewModel.usernameStore.wrappedValue = ""
        $viewModel.passwordStore.wrappedValue = ""
    }
    
    func getToken(){
        loading = true
        clear = false
        let credentialData = "\($viewModel.usernameStore.wrappedValue):\( $viewModel.passwordStore.wrappedValue)".data(using: String.Encoding.utf8)!
        let base64EncodedCredentials = credentialData.base64EncodedString()
        guard let url = URL(string: "\(viewModel.defaultURL)/uapi/auth/tokens") else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let config = URLSessionConfiguration.default
        let authString = "Basic \(base64EncodedCredentials)"
        config.httpAdditionalHeaders = ["Authorization" : authString]
        URLSession(configuration: config).dataTask(with: request) { (data, response, err) in
            guard let data = data else { return }
            guard let dataAsString = String(data: data, encoding: .utf8)else {return}
            print(dataAsString)
            
            guard let response = try? JSONDecoder().decode(Responses.Token.self, from: data) else {
                print("Not Available")
                self.badPassword = true
                self.isPressed = false
                self.loading = false
                self.clear = true
                return
            }
            
            let queue = DispatchQueue(label:response.token)
            queue.asyncAfter(deadline: .now() + 1) {
                DispatchQueue.main.async {
                    token = response.token.description
                    
                    print("Successful Token:")
                    print(token ?? "")
                    self.controlCenter.loginToggle = false
                    self.controlCenter.mainMenuToggle = true
                    self.loading = false
                    self.clear = true
                }
            }
        }.resume()
    }
    
    
    
    @State private var animationAmount: CGFloat = 0.5
    @State var blur:CGFloat = 3
    @State var radY:CGFloat = -5
    @State var radX:CGFloat = -2
    
    var body: some View {
        VStack{
            Text("quicklook jcs").font(.largeTitle)
                
                .foregroundColor(Color.white).bold()
                .shadow(color: Color.gray, radius: blur, x: radX, y: radY)
                .onAppear{
                    let baseAnimation = Animation.easeIn(duration: 10)
                    let repeated = baseAnimation.repeatForever(autoreverses: true)
                    return withAnimation(repeated){
                        self.blur = 5
                        self.radY = 5
                        self.radX = 3
                    }
            }
            .padding(.all, 10)
            
        
            
            
            CustomTextField(secure: false, initialText: "", text:  $viewModel.defaultURL, placeholder: "https://your-jamf.url:8443", autoCaps: .none)
                .frame(width: 300, height: 20, alignment: .bottomLeading)
                .padding(.all, 8)
                .background(Color(red:0.5, green: 0.5, blue: 0.5, opacity: 0.3))
                .cornerRadius(4.0)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
            
            CustomTextField(secure: false, initialText: "", text:  $viewModel.usernameStore, placeholder: "Username", autoCaps: .none)
                .frame(width: 300, height: 20, alignment: .bottomLeading)
                .padding(.all, 8)
                .background(Color(red:0.5, green: 0.5, blue: 0.5, opacity: 0.3))
                .cornerRadius(4.0)
                .padding(.bottom, 5)
            
            
            CustomTextField(secure: true, initialText: "", text:  $viewModel.passwordStore, placeholder: "Password", autoCaps: .words)
                .frame(width: 300, height: 20, alignment: .bottomLeading)
                .padding(.all, 8)
                .background(Color(red:0.5, green: 0.5, blue: 0.5, opacity: 0.3))
                .cornerRadius(4.0)
                .padding(.bottom, 5)
            
            Button(action:
                {self.$jamfURL.wrappedValue = self.$viewModel.defaultURL.wrappedValue
                    self.isPressed.toggle()
                    self.badPassword = false
                    self.getToken()})
            {Text("login").font(.title).foregroundColor(Color.white).bold()}
                .padding(.all, 8)
                .background(ZStack{
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color.gray)
                    .opacity(0.5)})
                .padding(.bottom, 8)
                .scaleEffect(self.isPressed ? 0.75: 1)
                .opacity(self.isPressed ? 0.2:1)
                .animation(.spring())
            
            
            
            if loading {
                ActivityIndicator(isAnimating: loading)
                    .configure { $0.color = .gray}
                    .background(Color.clear)
                    .padding(.bottom, 130)
            }
            
            
            if badPassword{
                Text("Bad URL, Username or Password!")
                    .font(.footnote)
                    .foregroundColor(Color.red)
                    .italic()
            }
            
            if clear {
                Button(action:clearCredentials)
                {Text("Clear All?").font(.footnote).foregroundColor(Color.blue).opacity(0.7)}
                    .padding(.leading,30).padding(.trailing,30).padding(.bottom, 130)
            }
            Spacer()
        }.padding(.top, 40)
    }
}




struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}

//https://sarunw.com/posts/how-to-create-neomorphism-design-in-swiftui/
