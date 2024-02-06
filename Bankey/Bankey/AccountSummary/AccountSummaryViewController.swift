import UIKit

class AccountSummaryViewController: UIViewController{
    
    // Request Model
    var profile : Profile?
    var accounts : [Account] = []
    
    // ViewModels
    var headerViewModel = AccountSummaryHeaderView.ViewModel(welcomeMessage: "Welcome", name: "Hamit", date: Date())
    
    var accountCellViewModel: [AccountSummaryCell.ViewModel] = []
    var tableView = UITableView()
    var headerView = AccountSummaryHeaderView(frame: .zero)
    let refreshController = UIRefreshControl()
    
    lazy var logoutBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutTapped))
        barButtonItem.tintColor = .label
        
        return barButtonItem
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

extension AccountSummaryViewController{

    func setup(){
        setupNavigationBar()
        setupTableView()
        setupTableHeaderView()
        setupRefreshController()
        fetchData()
    }
    
    private func setupTableView(){
        tableView.backgroundColor = primaryColor
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(AccountSummaryCell.self, forCellReuseIdentifier: AccountSummaryCell.reuseID)
        tableView.rowHeight = AccountSummaryCell.rowHeight
        tableView.tableFooterView = UIView()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func setupTableHeaderView(){
        var size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        size.width = UIScreen.main.bounds.width
        headerView.frame.size = size
        tableView.tableHeaderView = headerView
    }
    
    private func setupNavigationBar(){
        navigationItem.rightBarButtonItem = logoutBarButtonItem
    }
    
    private func setupRefreshController(){
        refreshController.tintColor = appColor
        refreshController.addTarget(self, action: #selector(refreshContent), for: .valueChanged)
        tableView.refreshControl = refreshController
    }
}

extension AccountSummaryViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard !accountCellViewModel.isEmpty else{
            return UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: AccountSummaryCell.reuseID, for: indexPath) as! AccountSummaryCell
        let account = accountCellViewModel[indexPath.row]
        cell.configure(with: account)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountCellViewModel.count
    }
}

extension AccountSummaryViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}



// MARK: Networking
extension AccountSummaryViewController{
    private func fetchData(){
        
        let group = DispatchGroup()
        
        // Testing - random number selection
        let userId = String(Int.random(in: 1..<4))
        
        group.enter()
        fetchProfile(forUserId: userId) { result in
            switch result{
            case .success(let profile):
                self.profile = profile
                self.configureTableHeaderView(with: profile)
            case .failure(let error):
                print(error.localizedDescription)
            }
            group.leave()
        }
        
        group.enter()
        fetchAccounts(forUserId: userId) { result in
            switch result{
            case .success(let accounts):
                self.accounts = accounts
                self.configureTableCells(with: accounts)
            case .failure(let error):
                print(error.localizedDescription)
            }
            group.leave()
        }
        
        group.notify(queue: .main) {
            self.tableView.reloadData()
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    private func configureTableHeaderView(with profile: Profile){
        let vm = AccountSummaryHeaderView.ViewModel(welcomeMessage: "Welcome", name: "Hamit", date: Date())
        headerView.configure(viewModel: vm)
    }
    
    private func configureTableCells(with account: [Account]){
        accountCellViewModel = account.map{
            AccountSummaryCell.ViewModel(accountType: $0.type, accountName: $0.name, balance: $0.amount)
        }
        
    }
}

// MARK: Actions
extension AccountSummaryViewController{
    @objc func logoutTapped(sender: UIButton){
        NotificationCenter.default.post(name: .logout, object: nil)
    }
    
    @objc func refreshContent(){
        fetchData()
    }
}

