#import "QCOParseFetchCharactersJSONData.h"

#import "QCOCharacterSliceResponseModel.h"
#import "QCOFetchCharactersResponseModel.h"

#import <OCHamcrest/OCHamcrest.h>
#import <XCTest/XCTest.h>


@interface QCOParseFetchCharactersJSONDataTests : XCTestCase
@end

@implementation QCOParseFetchCharactersJSONDataTests

- (NSData *)sampleResponse
{
    NSString *json =
                    @"{"
                    "  \"code\": 200,"
                    "  \"status\": \"Ok\","
                    "  \"data\": {"
                    "    \"offset\": 1,"
                    "    \"total\": 3,"
                    "    \"results\": ["
                    "      {"
                    "        \"name\": \"NAME1\""
                    "      },"
                    "      {"
                    "        \"name\": \"NAME2\""
                    "      }"
                    "    ]"
                    "  }"
                    "}";
    return [json dataUsingEncoding:NSUTF8StringEncoding];
}

- (void)testParse_WithSampleResponse_ShouldHaveCode200
{
    QCOFetchCharactersResponseModel *response = QCOParseFetchCharactersJSONData([self sampleResponse]);
    
    assertThat(@(response.code), is(@200));
}

- (void)testParse_WithSampleResponse_ShouldHaveStatusOk
{
    QCOFetchCharactersResponseModel *response = QCOParseFetchCharactersJSONData([self sampleResponse]);

    assertThat(response.status, is(@"Ok"));
}

- (void)testParse_WithSampleResponse_ShouldHaveOffset1
{
    QCOFetchCharactersResponseModel *response = QCOParseFetchCharactersJSONData([self sampleResponse]);

    assertThat(@(response.slice.offset), is(@1));
}

- (void)testParse_WithSampleResponse_ShouldHaveTotal3
{
    QCOFetchCharactersResponseModel *response = QCOParseFetchCharactersJSONData([self sampleResponse]);

    assertThat(@(response.slice.total), is(@3));
}

- (void)testParse_WithSampleResponse_ShouldHaveTwoCharacters
{
    QCOFetchCharactersResponseModel *response = QCOParseFetchCharactersJSONData([self sampleResponse]);

    assertThat(response.slice.characters, containsIn(@[
            hasProperty(@"name", @"NAME1"),
            hasProperty(@"name", @"NAME2")]));
}

- (void)testParse_WithMalformedJSON_ShouldReturnCode500
{
    NSString *json = @"{\"cod";
    NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    
    QCOFetchCharactersResponseModel *response = QCOParseFetchCharactersJSONData(jsonData);
    
    assertThat(@(response.code), is(@500));
}

- (void)testBuild_WithJSONArrayInsteadOfDictionary_ShouldReturnCode500
{
    NSString *json = @"[]";
    NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    
    QCOFetchCharactersResponseModel *response = QCOParseFetchCharactersJSONData(jsonData);
    
    assertThat(@(response.code), is(@500));
}

@end
