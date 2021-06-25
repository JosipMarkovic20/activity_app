//
//  DetailsViewController.swift
//  Activity App
//
//  Created by Josip Marković on 25.06.2021..
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import SnapKit

public final class DetailsViewController: UIViewController, UITableViewDelegate {
    
    let detailsView: DetailsView = {
        let view = DetailsView()
        return view
    }()
    
    private let viewModel: DetailsViewModel!
    
    public let disposeBag = DisposeBag()
    
    init(viewModel: DetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.input.onNext(.loadData)
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

extension DetailsViewController {
    
    private func setupUI() {
        view.addSubview(detailsView)
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = .white
        setupConstraints()
        self.title = R.string.localizable.activity()
    }
    
    func setupConstraints(){
        detailsView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
    }
    
    func bindViewModel(){
        disposeBag.insert(viewModel.bindViewModel())
        
        viewModel.output
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {[unowned self] (output) in
                guard let safeEvent = output.event else { return }
                switch safeEvent{
                case .error(let message):
                    showAlertWith(title: R.string.localizable.error(), message: message)
                case .reloadData:
                    guard let safeItem = output.item else { return }
                    detailsView.configure(with: safeItem)
                }
            }).disposed(by: disposeBag)
    }
}
