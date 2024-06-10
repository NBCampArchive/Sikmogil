//
//  LoginViewModel.swift
//  Sikmogil
//
//  Created by 박현렬 on 6/3/24.
//

import Foundation
import GoogleSignIn
import AuthenticationServices
import RxSwift
import RxCocoa


protocol LoginViewModelInput {
    func signInWithApple()
    func signInWithGoogle(presentingViewController: UIViewController)
}

protocol LoginViewModelOutput {
    var loginSuccess: PublishSubject<Void> { get }
    var loginFailure: PublishSubject<Error> { get }
}

protocol LoginViewModelIO: LoginViewModelInput & LoginViewModelOutput { }

class LoginViewModel: NSObject, LoginViewModelIO {
    let loginSuccess = PublishSubject<Void>()
    let loginFailure = PublishSubject<Error>()
    
    override init() {
        super.init()
    }
    
    func signInWithApple() {
        print("Apple Sign-In 시작")
        let appleProvider = ASAuthorizationAppleIDProvider()
        let request = appleProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    func signInWithGoogle(presentingViewController: UIViewController) {
        print("Google Sign-In 시작")

        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { signInResult, error in
                 guard error == nil else { return }
                 guard let signInResult = signInResult else { return }
                 
                 signInResult.user.refreshTokensIfNeeded { user, error in
                    guard error == nil else { return }
                    guard let user = user else { return }
                    
                     if let idToken = user.idToken?.tokenString {
                         self.loginWithServer(idToken: idToken, provider: "google")
                         print(idToken)
                     }
                     
                 }
              }
    }
    
    private func loginWithServer(idToken: String, provider: String) {
        print("서버에 로그인 시도 with ID Token: \(idToken), Provider: \(provider)")
        LoginAPIManager.shared.getAccessToken(authCode: idToken, provider: provider) { result in
            switch result {
            case .success(let tokenResponse):
                print("서버 로그인 성공: \(tokenResponse)")
                self.loginSuccess.onNext(())
            case .failure(let error):
                print("서버 로그인 실패: \(error)")
                self.loginFailure.onNext(error)
            }
        }
    }
}

extension LoginViewModel: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        print("Apple Sign-In 성공")
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            print("Apple ID Token: \(idTokenString)")
            self.loginWithServer(idToken: idTokenString, provider: "apple")
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Sign in with Apple errored: \(error.localizedDescription)")
        self.loginFailure.onNext(error)
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            fatalError("No active window scene")
        }
        guard let window = windowScene.windows.first else {
            fatalError("No windows in window scene")
        }
        return window
    }
}
