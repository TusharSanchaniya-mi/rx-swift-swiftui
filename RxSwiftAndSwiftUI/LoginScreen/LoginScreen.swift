//
//  LoginScreen.swift
//  RxSwiftAndSwiftUI
//
//  Created by Mindinventory on 02/12/24.
//

import SwiftUI
import RxSwift

struct LoginScreen: View {
    
    private let disposeBag = DisposeBag()
    typealias ViewModel = AnyViewModel<LoginViewModel.State, LoginViewModel.Event>
    @StateObject private var viewModel: ViewModel
    
    @State private var emailInput: String = ""
    @State private var emailErrorLabel: String? = ""
    @State private var passwordInput: String = ""
    @State private var passwordErrorLabel: String? = ""
    @State private var isButtonEnabled: Bool = false
    
    init(viewModel: ViewModel = AnyViewModel(LoginViewModel())) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    private func bindingViewModel() {
        self.viewModel.state
            .observe(on: MainScheduler.instance)
            .subscribe { eventState in
                switch eventState {
                case .error(let error):
                    print("error:: \(error.localizedDescription)")
                    break
                case .next( let state):
                    switch state {
                    case .enableButton(let isEnabled):
                        if isEnabled {
                            self.emailErrorLabel = nil
                            self.passwordErrorLabel = nil
                        }
                        self.isButtonEnabled = isEnabled
                        break
                    case .showEmailError(let emailError):
                        if emailError.isNotEmpty {
                            self.emailErrorLabel = emailError
                        }
                        else {
                            self.emailErrorLabel = nil
                        }
                        break
                    case .showPasswordError(let pswdError):
                        if pswdError.isNotEmpty {
                            self.passwordErrorLabel = pswdError
                        }
                        else {
                            self.passwordErrorLabel = nil
                        }
                        break
                    }
                    break
                case .completed:
                    break
                }
            }.disposed(by: disposeBag)
    }
    
    var body: some View {
        GeometryReader { geoProxyReader in
            Spacer()
            VStack(alignment: .center, spacing: 16) {
                VStack(alignment:.leading, spacing: 16) {
                    
                    VStack(alignment:.leading, spacing: 10) {
                        TextField("address@domain.com", text: $emailInput)
                            .font(.system(size: 16, weight: .regular))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.emailAddress)
                            .textCase(.lowercase)
                            .textInputAutocapitalization(.never)
                            .onChange(of: emailInput) { newEmail in
                                self.viewModel.onReceiveEvent(.emailDidChange(newEmail))
                            }
                        
                        if let emailError = emailErrorLabel, emailError.count > 0 {
                            Text(emailError.capitalized)
                                .foregroundColor(.red)
                                .font(.footnote)
                        }
                    }
                    
                    VStack(alignment:.leading, spacing: 10) {
                        SecureField("Password", text: $passwordInput)
                            .font(.system(size: 16, weight: .regular))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.emailAddress)
                            .onChange(of: passwordInput) { password in
                                self.viewModel.onReceiveEvent(.passwordDidChange(password))
                            }
                        
                        if let passwordError = passwordErrorLabel, passwordError.count > 0 {
                            Text(passwordError.capitalized)
                                .foregroundColor(.red)
                                .font(.footnote)
                        }
                    }
                }
                .padding(.horizontal, 16)
                
                Button("Login") {
                    print("Button tapped, email is valid.")
                }
                .disabled(!isButtonEnabled)
                .padding(.horizontal, 25)
                .padding(.vertical, 10)
                .background(isButtonEnabled ? Color.blue : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            Spacer()
        }.onAppear() {
            bindingViewModel()
        }
    }
}

#Preview {
    LoginScreen()
}
