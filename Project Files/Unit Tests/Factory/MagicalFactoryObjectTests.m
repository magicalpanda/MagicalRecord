//
// Test Case: MagicalFactoryTests
// Created by Saul Mora on 6/8/12
// Copyright © 2012 by Magical Panda Software LLC
//

#import <SenTestingKit/SenTestingKit.h>
#import "MRFactoryObjectDefinition.h"

@interface User : NSObject
- (NSString *) firstName;
@end

@implementation User
- (NSString *) firstName;
{
    return nil;
}
@end

//@class MRFactory;

//
//@interface MRFactory : NSObject
//
//+ (void) define:(Class)klass block:(void(^)(id obj))factory;
//
//- (id) create:(Class)klass;
//- (id) create:(Class)klass withAttributes:(NSDictionary *)attributes;
//- (void) register:(NSString *)identifier as:(Class)klass block:(void(^)(id))block;
//
//@end
//
//@implementation MRFactory
//
//+ (void) define:(Class)klass block:(void(^)(id obj))factory;
//{
//    
//}
//
//- (id) create:(Class)klass;
//{
//    return nil;
//}
//
//- (id) create:(Class)klass withAttributes:(NSDictionary *)attributes;
//{
//    return nil;
//}
//
//- (void) register:(NSString *)identifier as:(Class)klass block:(void(^)(id))block;
//{
//    
//}
//
//@end

@interface MagicalFactoryObjectTests : SenTestCase
@end
	
	
@implementation MagicalFactoryObjectTests

- (void) testInstatiatingABuilderObject;
{
    MRFactoryObjectDefinition *objectTemplate = [[MRFactoryObjectDefinition alloc] initWithClass:[User class]];
    assertThat(objectTemplate.actions, isNot(nilValue()));
}

- (void) testThrowsAnExceptionWithInitializedWithoutAClass;
{
    STAssertThrows([MRFactoryObjectDefinition new], nil);
}

- (void) testCanDefineAStaticValueForAnObjectProperty;
{
    MRFactoryObjectDefinition *objectTemplate = [[MRFactoryObjectDefinition alloc] initWithClass:[User class]];
    
    [objectTemplate setValue:@"Test" forPropertyNamed:@"test"];
    
    assertThat(objectTemplate.actions, isNot(empty()));
}

- (void) testCanDefineAnActionForAnObjectProperty;
{
    MRFactoryObjectDefinition *objectTemplate = [[MRFactoryObjectDefinition alloc] initWithClass:[User class]];
    MRFactoryObjectBuildAction action = ^id(MRFactoryObjectDefinition *obj){
        return nil;
    };
    
    [objectTemplate setBuildAction:action forPropertyNamed:@"test"];

    assertThat(objectTemplate.actions, isNot(empty()));
}

- (void) testCreateInstanceFromBuildTemplate;
{
    id objectTemplate = [[MRFactoryObjectDefinition alloc] initWithClass:[User class]];
    
    [objectTemplate setValue:@"Test First Name" forPropertyNamed:@"firstName"];
    
    assertThat([objectTemplate firstName], is(equalTo(@"Test First Name")));
}

//
//- (void) testRegisterAnAdminUserClassAsAUserClass;
//{
//    
//    //    [MRFactory define:^(MRFactory *factory){
//    //
//    //        [factory create:[User class] withAttributes:@{
//    //            @"firstName" : @"Bob #{sequence}"
//    //         }];
//    //    }];
//    
//    //    [MRFactory define:[User class] block:^(id template){
//    //        
//    //        [[template forProperty:@"firstName"] do:(id)^{ return @"Bob"; }];
//    //        
//    //    }];
////    [MRFactory define:^(MRFactory *factory) {
////        
////        [factory register:@"Admin" as:[User class] block:^(id obj){
////            [[obj firstName] do:^{ return @"Bob"; }];
////        }];
////        
////    }];
//}

@end


