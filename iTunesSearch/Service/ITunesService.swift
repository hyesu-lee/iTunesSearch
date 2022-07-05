//
//  ITunesService.swift
//  iTunesSearch
//
//  Created by 이혜수 on 2022/07/04.
//

import Alamofire
import RxSwift

class ITunesService {
    func download(url: String) -> Observable<URL> {
        return Observable.create { observer in
            let request = Session.default.request(url, method: .get)
                .responseData{ (response) in
                    switch response.result {
                    case let .success(data):
                        let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                        let audioURL = documentURL.appendingPathComponent("track.mp4")

                        do {
                            try data.write(to: audioURL)
                            observer.onNext(audioURL)
                            observer.onCompleted()
                        } catch {
                            observer.onError(error)
                        }


                    case let .failure(error):
                        observer.onError(error)
                    }
                }

            return Disposables.create {
                request.cancel()
            }
        }
    }

    func search(query: String?) -> Observable<[Track]> {
        guard let query = query else { return .just([]) }

        let url = "https://itunes.apple.com/search/media=music&entity=song"
        let parameters = ["term": query]

        return Observable.create { observer in
            let request = Session.default.request(url, method: .get, parameters: parameters)
                .responseDecodable(of: TrackSearchResult.self) { response in
                    switch response.result {
                    case let .success(data):
                        observer.onNext(data.results)
                        observer.onCompleted()
                    case let .failure(error):
                        observer.onError(error)
                    }
                }

            return Disposables.create {
                request.cancel()
            }
        }
    }
}
