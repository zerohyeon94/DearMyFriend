import UIKit
import WebKit

class WebViewerController: UIViewController {
    
    private let webView = WKWebView()
    private let urlString: String
    
    init(with urlString: String) {
        self.urlString = urlString
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupUrl()
    }
    
    private func setupUrl() {
        guard let url = URL(string: self.urlString) else {
            self.dismiss(animated: true)
            return
        }
        
        self.webView.load(URLRequest(url: url))
    }
    
    private func setupUI() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "닫기", style: .done, target: self, action: #selector(didTapDone))
        self.navigationController?.navigationBar.backgroundColor = .secondarySystemBackground
        self.view.addSubviews([webView])
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: self.view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }

    @objc private func didTapDone() {
        self.dismiss(animated: true)
    }
}
