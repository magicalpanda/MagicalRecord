//
// Test Case: MagicalFactoryTests
// Created by Saul Mora on 6/8/12
// Copyright © 2012 by Magical Panda Software LLC
//

#import <SenTestingKit/SenTestingKit.h>
#import "MRFactoryObjectDefinition.h"

@interface User : NSObject
- (NSString *) firstName;
- (NSString *) lastName;
@end

@implementation User
- (NSString *) firstName;
{
    return nil;
}
- (NSString *) lastName;
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
    
    [objectTemplate setValue:@"Test" forPropertyNamed:@"firstName"];
    
    assertThat(objectTemplate.actions, isNot(empty()));
}

- (void) testCannotDefineANilProperty;
{
    MRFactoryObjectDefinition *objectTemplate = [[MRFactoryObjectDefinition alloc] initWithClass:[User class]];
    
    STAssertThrows([objectTemplate setValue:@"test" forPropertyNamed:nil], nil);
}

- (void) testCanDefineNilValueForProperty;
{
    id objectTemplate = [[MRFactoryObjectDefinition alloc] initWithClass:[User class]];
    
    [objectTemplate setValue:nil forPropertyNamed:@"firstName"];
    
    assertThat([objectTemplate firstName], is(equalTo(nil)));
}

- (void) testCanDefineAnActionForAnObjectProperty;
{
    MRFactoryObjectDefinition *objectTemplate = [[MRFactoryObjectDefinition alloc] initWithClass:[User class]];
    MRFactoryObjectBuildAction action = ^id(MRFactoryObjectDefinition *obj){
        return nil;
    };
    
    [objectTemplate setAction:action forPropertyNamed:@"firstName"];

    assertThat(objectTemplate.actions, isNot(empty()));
}

- (void) testPropertiesCannotBeDefinedForNonExistantProperties;
{
    MRFactoryObjectDefinition *objectTemplate = [[MRFactoryObjectDefinition alloc] initWithClass:[User class]];
    MRFactoryObjectBuildAction action = ^id(MRFactoryObjectDefinition *obj){ return nil; };
        
    STAssertThrows([objectTemplate setAction:action forPropertyNamed:@"test"], nil);
}

- (void) testCreateInstanceFromBuildTemplate;
{
    id objectTemplate = [[MRFactoryObjectDefinition alloc] initWithClass:[User class]];
    
    [objectTemplate setValue:@"Test First Name" forPropertyNamed:@"firstName"];
    
    assertThat([objectTemplate firstName], is(equalTo(@"Test First Name")));
}

- (void) testCanDefineASequenceActionForAnObjectProperty;
{
    id objectTemplate = [[MRFactoryObjectDefinition alloc] initWithClass:[User class]];
    MRFactoryObjectSequenceBuildAction sequenceAction = ^id(MRFactoryObjectDefinition *obj, NSUInteger index) {
        return [NSString stringWithFormat:@"Tom %d", index];
    };
    
    [objectTemplate setSequenceAction:sequenceAction forPropertyNamed:@"firstName"];
    
    assertThat([objectTemplate firstName], is(equalTo(@"Tom 1")));
    assertThat([objectTemplate firstName], is(equalTo(@"Tom 2")));
}

- (void) testCanDefineASequenceActionForAnObjectPropertyWithCustomStartingIndex;
{
    id objectTemplate = [[MRFactoryObjectDefinition alloc] initWithClass:[User class]];
    MRFactoryObjectSequenceBuildAction sequenceAction = ^id(MRFactoryObjectDefinition *obj, NSUInteger index) {
        return [NSString stringWithFormat:@"Tom %d", index];
    };
    
    [objectTemplate setSequenceAction:sequenceAction forPropertyNamed:@"firstName" withStartingIndex:100];
    
    assertThat([objectTemplate firstName], is(equalTo(@"Tom 100")));
    assertThat([objectTemplate firstName], is(equalTo(@"Tom 101")));
}

- (void) testCanDefineMultipleSequenceActionsForAnObjectProperty;
{
    id objectTemplate = [[MRFactoryObjectDefinition alloc] initWithClass:[User class]];
    MRFactoryObjectSequenceBuildAction firstNameAction = ^id(MRFactoryObjectDefinition *obj, NSUInteger index) {
        return [NSString stringWithFormat:@"Timmy %d", index];
    };
    MRFactoryObjectSequenceBuildAction lastNameAction = ^id(MRFactoryObjectDefinition *obj, NSUInteger index) {
        return [NSString stringWithFormat:@"Jones %d", index];
    };
    
    [objectTemplate setSequenceAction:firstNameAction forPropertyNamed:@"firstName"];
    [objectTemplate setSequenceAction:lastNameAction forPropertyNamed:@"lastName"];
    
    assertThat([objectTemplate firstName], is(equalTo(@"Timmy 1")));
    assertThat([objectTemplate firstName], is(equalTo(@"Timmy 2")));
    
    assertThat([objectTemplate lastName], is(equalTo(@"Jones 1")));
    assertThat([objectTemplate lastName], is(equalTo(@"Jones 2")));
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


