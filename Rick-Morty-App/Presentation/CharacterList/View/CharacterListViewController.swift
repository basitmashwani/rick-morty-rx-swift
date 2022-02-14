//
//  CharacterListViewController.swift
//  Rick-Morty-App
//
//  Created by SyedAbdulBasit on 05/02/2022.
//

import UIKit
import RxSwift

class CharacterListViewController: UIViewController {
    // MARK: Variables
    @IBOutlet weak var tableView: UITableView!
    var viewModel: CharacterListViewModel!
    lazy var searchBar: UISearchBar = UISearchBar()
    let refreshSubject = PublishSubject<Void>()
    let filterQuerySubject = PublishSubject<String>()
    let characterSelected = PublishSubject<Character>()
    let disposedBag = DisposeBag()
    private let refreshControl = UIRefreshControl()

    var viewModelFactory: (CharacterListViewModel.Input) -> CharacterListViewModel = { _ in fatalError("factory not set")}
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:)has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSearchBar()
        setupBinding()
    }
    private func setupTableView() {
        tableView.estimatedRowHeight = 450
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.register(CharacterTableViewCell.self)
        tableView.refreshControl = refreshControl
        refreshControl.beginRefreshing()
    }

    private func setupSearchBar() {
        searchBar.searchBarStyle = UISearchBar.Style.default
           searchBar.placeholder = " Search..."
           searchBar.sizeToFit()
           searchBar.isTranslucent = false
           searchBar.backgroundImage = UIImage()
           navigationItem.titleView = searchBar
        searchBar.rx.text
               .orEmpty
               .bind(to: filterQuerySubject)
               .disposed(by: disposedBag)
    }
    private func updateUI() {
//        if viewModel.numberOfRows == 0 && isSearchActive {
//               tableView.setEmptyMessage("No record found.")
//           } else {
//               self.tableView.restore()
//           }
    }
    private func setupBinding() {

        let inputs = CharacterListViewModel.Input(viewDidAppearTrigger: rx.methodInvoked(#selector(viewDidAppear(_:))).map { _ in }, refreshTrigger: refreshSubject, filterQuery: filterQuerySubject.startWith(""))
        viewModel = viewModelFactory(inputs)

        viewModel.errorMessage
            .subscribe(onNext: {[weak self] error in
                self?.showAlert(with: "Error", and: error.localizedDescription)
            }).disposed(by: disposedBag)

        refreshControl.rx.controlEvent(.valueChanged)
            .map { _ in }
            .bind(to: refreshSubject)
            .disposed(by: disposedBag)


        tableView.rx.modelSelected(CharacterCellItemViewModel.self)
            .map { $0.toCharacter()}
            .bind(to: characterSelected)
            .disposed(by: disposedBag)

        viewModel.items
            .do(onNext: {[weak self] _ in
                self?.tableView.refreshControl?.endRefreshing()
            })
            .bind(to: tableView.rx.items) { (tblView, _, item) in
                let cell = tblView.dequeueReusableCell() as CharacterTableViewCell
                cell.configure(with: item)
                return cell
            }.disposed(by: disposedBag)
    }
}


// MARK: - TableView Delegate
extension CharacterListViewController: UITableViewDelegate {
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

