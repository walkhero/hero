import CloudKit
import Combine

public final class Memory {
    public static internal(set) var shared = Memory()
    private static let type = "Archive"
    private static let asset = "asset"
    private static let container = CKContainer(identifier: "iCloud.WalkHero")
    public let archive = PassthroughSubject<Archive, Never>()
    public let save = PassthroughSubject<Archive, Never>()
    public let pull = PassthroughSubject<Void, Never>()
    var subs = Set<AnyCancellable>()
    private let store = PassthroughSubject<Archive, Never>()
    private let local = PassthroughSubject<Archive?, Never>()
    private let remote = PassthroughSubject<Archive?, Never>()
    private let push = PassthroughSubject<Void, Never>()
    private let subscription = PassthroughSubject<CKSubscription.ID?, Never>()
    private let record = CurrentValueSubject<CKRecord.ID?, Never>(nil)
    private let queue = DispatchQueue(label: "", qos: .utility)
    
    init() {
        save
            .debounce(for: .seconds(1), scheduler: queue)
            .removeDuplicates()
            .sink { [weak self] in
                self?.store.send($0)
                self?.push.send()
            }
            .store(in: &subs)
        
        local
            .compactMap { $0 }
            .removeDuplicates()
            .merge(with: remote
                            .compactMap { $0 }
                            .removeDuplicates())
            .scan(nil) { previous, next in
                guard let previous = previous else { return next }
                return next > previous ? next : previous
            }
            .compactMap { $0 }
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.archive.send($0)
            }
            .store(in: &subs)
        
        pull
            .merge(with: push)
            .combineLatest(record)
            .filter {
                $1 == nil
            }
            .sink { [weak self] _, _ in
                Self.container.accountStatus { status, _ in
                    if status == .available {
                        Self.container.fetchUserRecordID { user, _ in
                            user.map {
                                self?.record.send(.init(recordName: "hero_" + $0.recordName))
                            }
                        }
                    }
                }
            }.store(in: &subs)
        
        record
            .compactMap { $0 }
            .combineLatest(pull)
            .map {
                ($0.0, Date())
            }
            .removeDuplicates {
                Calendar.current.dateComponents([.second], from: $0.1, to: $1.1).second! < 2
            }
            .map {
                $0.0
            }
            .sink { [weak self] id in
                let operation = CKFetchRecordsOperation(recordIDs: [id])
                operation.qualityOfService = .userInitiated
                operation.configuration.timeoutIntervalForRequest = 20
                operation.configuration.timeoutIntervalForResource = 20
                operation.fetchRecordsCompletionBlock = { [weak self] records, _ in
                    self?.remote.send(records?.values.first.flatMap {
                        ($0[Self.asset] as? CKAsset).flatMap {
                            $0.fileURL.flatMap {
                                (try? Data(contentsOf: $0)).map {
                                    $0.mutating(transform: Archive.init(data:))
                                }
                            }
                        }
                    })
                }
                Self.container.publicCloudDatabase.add(operation)
            }
            .store(in: &subs)
        
        record
            .compactMap { $0 }
            .sink { [weak self] id in
                let subscription = CKQuerySubscription(
                    recordType: Self.type,
                    predicate: .init(format: "recordID = %@", id),
                    options: [.firesOnRecordUpdate])
                subscription.notificationInfo = .init(alertLocalizationKey: "WalkHero")
                
                Self.container.publicCloudDatabase.save(subscription) { [weak self] subscription, _ in
                    subscription.map {
                        self?.subscription.send($0.subscriptionID)
                    }
                }
            }
            .store(in: &subs)
        
        subscription
            .scan(nil) {
                guard $0 != nil else { return nil }
                return $1
            }
            .compactMap {
                $0
            }
            .sink { [weak self] in
                Self.container.publicCloudDatabase.delete(withSubscriptionID: $0) { _, _ in }
            }
            .store(in: &subs)
        
        record
            .compactMap { $0 }
            .combineLatest(push)
            .sink { [weak self] id, _ in
                let record = CKRecord(recordType: Self.type, recordID: id)
                record[Self.asset] = CKAsset(fileURL: FileManager.url)
                let operation = CKModifyRecordsOperation(recordsToSave: [record])
                operation.qualityOfService = .userInitiated
                operation.configuration.timeoutIntervalForRequest = 20
                operation.configuration.timeoutIntervalForResource = 20
                operation.savePolicy = .allKeys
                Self.container.publicCloudDatabase.add(operation)
            }
            .store(in: &subs)
        
        local
            .combineLatest(remote
                            .compactMap { $0 }
                            .removeDuplicates())
            .filter { $0.0 == nil ? true : $0.0! < $0.1 }
            .map { $1 }
            .sink { [weak self] in
                self?.store.send($0)
            }
            .store(in: &subs)
        
        remote
            .combineLatest(local
                            .compactMap { $0 }
                            .removeDuplicates())
            .filter { $0.0 == nil ? true : $0.0! < $0.1 }
            .sink { [weak self] _, _ in
                self?.push.send()
            }
            .store(in: &subs)
        
        store
            .removeDuplicates {
                $1 <= $0
            }
            .receive(on: queue)
            .sink {
                FileManager.archive = $0
            }
            .store(in: &subs)
    }
    
    public func load() {
        local.send(FileManager.archive)
    }
}
