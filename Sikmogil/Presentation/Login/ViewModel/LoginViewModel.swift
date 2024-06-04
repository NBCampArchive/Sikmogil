//
//  LoginViewModel.swift
//  Sikmogil
//
//  Created by 박현렬 on 6/3/24.
//

import Foundation
import GoogleSignIn

class LoginViewModel {
    
    // Apple 로그인
    func signInWithApple() {
        print("Signin with Apple")
    }
    
    // Google 로그인
    func signInWithGoogle(presentingViewController: UIViewController) {
        print("Signin with Google")
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { signInResult, error in
            guard error == nil else { return }
            guard let signInResult = signInResult else { return }
            
            signInResult.user.refreshTokensIfNeeded { user, error in
                guard error == nil else { return }
                guard let user = user else { return }
                
                let idToken = user.idToken?.tokenString
                print(idToken!)
            }
        }
    }
    
}
