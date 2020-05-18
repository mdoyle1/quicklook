//
//  LoginView.swift
//  quicklook
//
//  Created by Toxicspu on 3/27/20.
//  Copyright © 2020 developer. All rights reserved.
//

import SwiftUI
import Dispatch

var loginFields = ""

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
        
        
//        func textFieldShouldClear(_ textField: UITextField) -> Bool {
//            outer.badPassword = false
//            outer.loading = false
//            outer.isPressed = false
//            outer.enterCredentials = false
//            outer.getTokenTimer = false
//            outer.loginAttempts = false
//            return true
//        }
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
    @State var alert = saveCredentialAlert
    
 
    func clearCredentials(){
        
        $viewModel.defaultURL.wrappedValue = ""
        $viewModel.passwordStore.wrappedValue = ""
        $viewModel.usernameStore.wrappedValue = ""
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
                {
//                    //STORE CREDENTIALS
                    print(self.$viewModel.defaultURL)
                    print(self.$viewModel.usernameStore)
                    print(self.$viewModel.passwordStore)
           
                    self.controlCenter.enterCredentials = false
                    if self.viewModel.usernameStore.description == "" || self.viewModel.defaultURL.description  == "" || self.viewModel.passwordStore.description == "" {
                        self.controlCenter.enterCredentials.toggle()
                        self.controlCenter.loginAttempts = false
                    }
                    self.controlCenter.clearCreds = false
                    self.controlCenter.isPressed.toggle()
                    self.controlCenter.badPassword = false
                    self.controlCenter.loading.toggle()
                    TokenAPI().getToken(connect:self.controlCenter, defaults:self.viewModel, completion: {print("complete")})})
            {Text("login").font(.title).foregroundColor(Color.white).bold()}
                .padding(.all, 8)
                .background(ZStack{
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color.gray)
                        .opacity(0.5)})
                .padding(.bottom, 8)
                .scaleEffect(self.controlCenter.isPressed ? 0.75: 1)
                .opacity(self.controlCenter.isPressed ? 0.2:1)
                .animation(.spring())
            
            Group{
                
                if self.controlCenter.loginAttempts {
                    Text("Please enter valid credentials!")
                        .font(.footnote)
                        .foregroundColor(Color.red)
                        .italic()
                        .onAppear{
                            self.controlCenter.getTokenTimer = false
                            self.controlCenter.loading = false
                            self.controlCenter.isPressed = false
                            self.controlCenter.clearCreds = true
                            
                    }
                }
                
                if self.controlCenter.getTokenTimer {
                    Text("checking credentials...")
                        .font(.footnote)
                        .foregroundColor(Color.red)
                        .italic()
                        .onAppear{
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                self.controlCenter.getTokenTimer = false
                                self.controlCenter.loading = false
                                self.controlCenter.isPressed = false
                                self.controlCenter.clearCreds = true
                                self.controlCenter.loginAttempts = true
                            }
                    }
                    
                    
                }
                
                if self.controlCenter.loading {
                    ActivityIndicator(isAnimating: self.controlCenter.loading)
                        .configure { $0.color = .gray}
                        .background(Color.clear)
                        .padding(.bottom, 130)
                }
                
                
                if self.controlCenter.badPassword{
                    Text("Bad URL, Username or Password!")
                        .font(.footnote)
                        .foregroundColor(Color.red)
                        .italic()
                        .onAppear{
                            self.controlCenter.loginAttempts = true
                    }
                    
                    
                }
                
                
                if self.controlCenter.clearCreds {
                    Button(action:clearCredentials)
                    {Text("Clear All?").font(.footnote).foregroundColor(Color.blue).opacity(0.7)}
                        .padding(.leading,30).padding(.trailing,30).padding(.bottom, 130)
                }
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
