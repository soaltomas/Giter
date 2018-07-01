import UIKit
import WebKit
import SwiftyJSON

class LoginViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    
    let authRequestFactory = OAuthRequestFactory()
    let requestFactory = RequestFactory()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView = WKWebView(frame: self.view.frame)
        webView.navigationDelegate = self
        guard
            let loginRequest = authRequestFactory.getOAuthCode(clientId: "30d18382b199515d035a",
                                                           scopes: "public_repo",
                                                           redirectURL: "https://giter.localhost").request
        else {
            return
        }
        
        webView.load(loginRequest)
        self.view.addSubview(webView)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        if webView.url?.host == "giter.localhost" {
            guard
                let code = webView.url?.getParameter(name: "code")
            else {
                return
            }
            authRequestFactory.getOAuthAccessToken(clientId: "30d18382b199515d035a",
                                               clientSecret: "9cb1ca9559143eb379eb0ff7a9dc1ecfae24c22e",
                                               code: code, completionHandler: { [weak self] response in
                                                    guard
                                                        let accessToken = response.value?.accessToken
                                                    else {
                                                        return
                                                    }
                                            
                                                    currentAccessToken = accessToken
                                                
                                                    self?.performSegue(withIdentifier: "CurrentlyLoggedIn", sender: nil)
                                                })
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "CurrentlyLoggedIn" {
//
//        }
//    }
}

extension URL {
    func getParameter(name: String) -> String? {
        guard
            let parameters = URLComponents(url: self, resolvingAgainstBaseURL: true)
        else {
            return nil
        }
        return parameters.queryItems?.first(where: {$0.name == name})?.value
    }
}

var currentAccessToken: String? {
    get {
        return UserDefaults.standard.string(forKey: "accessToken")
    }
    set {
        UserDefaults.standard.set(newValue, forKey: "accessToken")
    }
}
