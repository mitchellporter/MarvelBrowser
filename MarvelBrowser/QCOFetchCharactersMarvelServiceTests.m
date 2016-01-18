//  TDD sample app MarvelBrowser by Jon Reid, http://qualitycoding.org/about/
//  Copyright 2016 Jonathan M. Reid. See LICENSE.txt

#import "QCOFetchCharactersMarvelService.h"
#import "QCOFetchCharactersRequestModel.h"

#import <OCHamcrest/OCHamcrest.h>
#import <OCMockito/OCMockito.h>
#import <XCTest/XCTest.h>


@interface QCOFetchCharactersMarvelServiceTests : XCTestCase
@end

@implementation QCOFetchCharactersMarvelServiceTests

- (void)testFetchCharacters_ShouldAskURLSessionToCreateDataTask
{
    NSURLSession *mockSession = mock([NSURLSession class]);
    QCOFetchCharactersMarvelService *sut = [[QCOFetchCharactersMarvelService alloc] initWithSession:mockSession];
    QCOFetchCharactersRequestModel *requestModel = [[QCOFetchCharactersRequestModel alloc]
            initWithNamePrefix:@"DUMMY" pageSize:10 offset:30];

    [sut fetchCharacters:requestModel];

    [verify(mockSession) dataTaskWithURL:anything() completionHandler:anything()];
}

@end
