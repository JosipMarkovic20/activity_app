//
//  LoginViewController.swift
//  Activity App
//
//  Created by Josip Marković on 25.06.2021..
//

import Foundation
import SnapKit
import RxCocoa
import RxSwift

class LoginViewController: UIViewController, LoaderProtocol {
    weak var loginNavigationDelegate: LoginNavigationDelegate?
    
    var spinner: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        return view
    }()
    
    let emailInput: TextFieldView = {
        let view = TextFieldView(inputType: .textInput, buttonIcon: nil, selectedButtonIcon: nil)
        view.applyStyle(style: TextFieldViewStyle(bottomLineColor: .systemGray,
                                                  font: .systemFont(ofSize: 17),
                                                  textColor: .black,
                                                  placeholderColor: .systemGray))
        view.textField.placeholder = R.string.localizable.email()
        return view
    }()
    
    let passwordInput: TextFieldView = {
        let view = TextFieldView(inputType: .secureEntry, buttonIcon: R.image.show_password(), selectedButtonIcon: R.image.hide_password())
        view.applyStyle(style: TextFieldViewStyle(bottomLineColor: .systemGray,
                                                  font: .systemFont(ofSize: 17),
                                                  textColor: .black,
                                                  placeholderColor: .systemGray))
        view.textField.placeholder = R.string.localizable.password()
        return view
    }()
    
    let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle(R.string.localizable.login().uppercased(), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 8
        return button
    }()
    
    let disposeBag = DisposeBag()
    let viewModel: LoginViewModel
    
    public init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        setupInputActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
}

private extension LoginViewController {
    func setupUI() {
        hideKeyboardWhenTappedAround()
        view.backgroundColor = .white
        view.addSubviews(views: [emailInput, passwordInput, loginButton])
        setupConstraints()
    }
    
    func setupConstraints() {
        emailInput.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(60)
            make.top.equalToSuperview().inset(90)
        }
        
        passwordInput.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(60)
            make.top.equalTo(emailInput.snp.bottom).offset(16)
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordInput.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(50)
            make.height.equalTo(40)

        }
    }
    
    func bindViewModel() {
        disposeBag.insert(viewModel.bindViewModel())
        
        viewModel.output
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {[unowned self] (output) in
                guard let safeEvent = output.event else { return }
                switch safeEvent{
                case .successfullLogin:
                    loginNavigationDelegate?.openHomeScreen()
                case .validationError(error: let error):
                    self.showAlertWith(title: nil, message: error)
                }
            }).disposed(by: disposeBag)
        
        loginButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                viewModel.input.onNext(.loginClick)
            })
            .disposed(by: disposeBag)
        
        viewModel.loaderPublisher
            .subscribe(onNext: { [unowned self] shouldShowLoader in
                if shouldShowLoader{
                    showLoader()
                }else{
                    hideLoader()
                }
            }).disposed(by: disposeBag)
    }
    
    func setupInputActions(){
        emailInput.textChanged = {[unowned self] (text) in
            viewModel.input.onNext(.emailInput(text: text))
        }
        
        passwordInput.textChanged = {[unowned self] (text) in
            viewModel.input.onNext(.passwordInput(text: text))
            
        }
    }
}
