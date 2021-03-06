//
//  SearchViewControllerSpec.swift
//  iTunesSearchTests
//
//  Created by 이혜수 on 2022/07/04.
//

import Quick
import Nimble
@testable import iTunesSearch

class SearchViewControllerSpec: QuickSpec {
    override func spec() {
        var viewController: SearchViewController!
        var reactor: SearchViewReactor!

        beforeEach {
            reactor = SearchViewReactor()
            reactor.isStubEnabled = true
            viewController = SearchViewController(reactor: reactor)
        }


        // MARK: Action

        describe("searchController") {
            var text: String!
            var searchBar: UISearchBar!

            beforeEach {
                text = "TEXT"
                searchBar = viewController.searchController.searchBar
                searchBar.text = text
            }

            context("when search button is tapped") {
                beforeEach {
                    searchBar.delegate?.searchBarSearchButtonClicked?(searchBar)
                }

                it("trigger updateQuery action with text") {
                    expect(reactor.stub.actions.last).to(equal(.updateQuery(text)))
                }
            }

            context("when cancel button is tapped") {
                beforeEach {
                    searchBar.delegate?.searchBarCancelButtonClicked?(searchBar)
                }

                it("trigger updateQuery action with nil") {
                    expect(reactor.stub.actions.last).to(equal(.updateQuery(nil)))
                }
            }
        }


        // MARK: State

        describe("tracks state") {
            context("when updated") {
                var tracks: [Track]!

                beforeEach {
                    tracks = Track.samples
                    reactor.stub.state.value.tracks = tracks
                }

                it("update tableview's dataSource") {
                    let tableView = viewController.tableView

                    tracks.enumerated().forEach { index, track in
                        let indexPath = IndexPath(row: index, section: 0)

                        guard let cell = tableView.dataSource?.tableView(tableView, cellForRowAt: indexPath) as? TrackTableViewCell else {
                            fail()
                            return
                        }

                        expect(cell.nameLabel.text).to(equal(track.name))
                        expect(cell.artistLabel.text).to(equal(track.artist))
                    }
                }
            }
        }

        describe("isLoading state") {
            context("when updated") {
                it("update activityIndecator's isAnimating") {
                    reactor.stub.state.value.isLoading = true
                    expect(viewController.activityIndicatorView.isAnimating).to(equal(true))

                    reactor.stub.state.value.isLoading = false
                    expect(viewController.activityIndicatorView.isAnimating).to(equal(false))
                }
            }
        }
    }
}
