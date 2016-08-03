//
//  UIApplication-Permissions.m
//  UIApplication-Permissions Sample
//
//  Created by Jack Rostron on 12/01/2014.
//  Copyright (c) 2014 Rostron. All rights reserved.
//

#import "UIApplication+Permissions.h"

#import <Contacts/Contacts.h>
#import <Photos/Photos.h>
#import <objc/runtime.h>

//Import required frameworks
@import AddressBook;
@import AssetsLibrary;
@import AVFoundation;
@import CoreBluetooth;
@import CoreLocation;
@import CoreMotion;
@import EventKit;

typedef void (^LocationSuccessCallback)();
typedef void (^LocationFailureCallback)();

static char PermissionsLocationManagerPropertyKey;
static char PermissionsLocationBlockSuccessPropertyKey;
static char PermissionsLocationBlockFailurePropertyKey;

@interface UIApplication () <CLLocationManagerDelegate>
@property (nonatomic, retain) CLLocationManager *permissionsLocationManager;
@property (nonatomic, copy) LocationSuccessCallback locationSuccessCallbackProperty;
@property (nonatomic, copy) LocationFailureCallback locationFailureCallbackProperty;
@end


@implementation UIApplication (Permissions)


#pragma mark - Check permissions
-(kPermissionAccess)hasAccessToBluetoothLE {
    switch ([[[CBCentralManager alloc] init] state]) {
        case CBCentralManagerStateUnsupported:
            return kPermissionAccessUnsupported;
            break;
            
        case CBCentralManagerStateUnauthorized:
            return kPermissionAccessDenied;
            break;
            
        default:
            return kPermissionAccessGranted;
            break;
    }
}

-(kPermissionAccess)hasAccessToCalendar {
    switch ([EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent]) {
        case EKAuthorizationStatusAuthorized:
            return kPermissionAccessGranted;
            break;
            
        case EKAuthorizationStatusDenied:
            return kPermissionAccessDenied;
            break;
            
        case EKAuthorizationStatusRestricted:
            return kPermissionAccessRestricted;
            break;
            
        default:
            return kPermissionAccessUnknown;
            break;
    }
}

-(kPermissionAccess)hasAccessToContacts {
    switch ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts]) {
        case CNAuthorizationStatusAuthorized:
            return kPermissionAccessGranted;
            break;
            
        case CNAuthorizationStatusDenied:
            return kPermissionAccessDenied;
            break;
            
        case CNAuthorizationStatusRestricted:
            return kPermissionAccessRestricted;
            break;
			
		case CNAuthorizationStatusNotDetermined:
			
        default:
            return kPermissionAccessUnknown;
            break;
    }
}

-(kPermissionAccess)hasAccessToLocation {
    switch ([CLLocationManager authorizationStatus]) {
        case kCLAuthorizationStatusAuthorizedAlways:
            return kPermissionAccessGranted;
            break;
			
		case kCLAuthorizationStatusAuthorizedWhenInUse:
			return kPermissionAccessGranted;
			break;
			
        case kCLAuthorizationStatusDenied:
            return kPermissionAccessDenied;
            break;
            
        case kCLAuthorizationStatusRestricted:
            return kPermissionAccessRestricted;
            break;
            
        default:
            return kPermissionAccessUnknown;
            break;
    }
    return kPermissionAccessUnknown;
}

-(kPermissionAccess)hasAccessToPhotos {
    switch ([PHPhotoLibrary authorizationStatus]) {
        case PHAuthorizationStatusAuthorized:
            return kPermissionAccessGranted;
            break;
            
        case PHAuthorizationStatusDenied:
            return kPermissionAccessDenied;
            break;
            
        case PHAuthorizationStatusRestricted:
            return kPermissionAccessRestricted;
            break;
		case PHAuthorizationStatusNotDetermined:
            
        default:
            return kPermissionAccessUnknown;
            break;
    }
}

-(kPermissionAccess)hasAccessToReminders {
    switch ([EKEventStore authorizationStatusForEntityType:EKEntityTypeReminder]) {
        case EKAuthorizationStatusAuthorized:
            return kPermissionAccessGranted;
            break;
            
        case EKAuthorizationStatusDenied:
            return kPermissionAccessDenied;
            break;
            
        case EKAuthorizationStatusRestricted:
            return kPermissionAccessRestricted;
            break;
            
        default:
            return kPermissionAccessUnknown;
            break;
    }
    return kPermissionAccessUnknown;
}


#pragma mark - Request permissions
-(void)requestAccessToCalendarWithSuccess:(void(^)())accessGranted andFailure:(void(^)())accessDenied {
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (granted) {
                accessGranted();
            } else {
                accessDenied();
            }
        });
    }];
}

-(void)requestAccessToContactsWithSuccess:(void(^)())accessGranted andFailure:(void(^)())accessDenied {
    CNContactStore *contactStore = [[CNContactStore alloc] init];
	if(contactStore) {
		[contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
			dispatch_async(dispatch_get_main_queue(), ^{
				if (granted) {
					accessGranted();
				} else {
					accessDenied();
				}
			});
		}];
	}
}

-(void)requestAccessToMicrophoneWithSuccess:(void(^)())accessGranted andFailure:(void(^)())accessDenied {
    AVAudioSession *session = [[AVAudioSession alloc] init];
    [session requestRecordPermission:^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (granted) {
                accessGranted();
            } else {
                accessDenied();
            }
        });
    }];
}

-(void)requestAccessToMotionWithSuccess:(void(^)())accessGranted {
    CMMotionActivityManager *motionManager = [[CMMotionActivityManager alloc] init];
    NSOperationQueue *motionQueue = [[NSOperationQueue alloc] init];
    [motionManager startActivityUpdatesToQueue:motionQueue withHandler:^(CMMotionActivity *activity) {
        accessGranted();
        [motionManager stopActivityUpdates];
    }];
}

-(void)requestAccessToPhotosWithSuccess:(void(^)())accessGranted andFailure:(void(^)())accessDenied {
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        accessGranted();
    } failureBlock:^(NSError *error) {
        accessDenied();
    }];
}

-(void)requestAccessToRemindersWithSuccess:(void(^)())accessGranted andFailure:(void(^)())accessDenied {
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    [eventStore requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (granted) {
                accessGranted();
            } else {
                accessDenied();
            }
        });
    }];
}


#pragma mark - Needs investigating
/*
 -(void)requestAccessToBluetoothLEWithSuccess:(void(^)())accessGranted {
 //REQUIRES DELEGATE - NEEDS RETHINKING
 }
 */

-(void)requestAccessToLocationWithSuccess:(void(^)())accessGranted andFailure:(void(^)())accessDenied {
    self.permissionsLocationManager = [[CLLocationManager alloc] init];
    self.permissionsLocationManager.delegate = self;
    
    self.locationSuccessCallbackProperty = accessGranted;
    self.locationFailureCallbackProperty = accessDenied;
    [self.permissionsLocationManager startUpdatingLocation];
}


#pragma mark - Location manager injection
-(CLLocationManager *)permissionsLocationManager {
    return objc_getAssociatedObject(self, &PermissionsLocationManagerPropertyKey);
}

-(void)setPermissionsLocationManager:(CLLocationManager *)manager {
    objc_setAssociatedObject(self, &PermissionsLocationManagerPropertyKey, manager, OBJC_ASSOCIATION_RETAIN);
}

-(LocationSuccessCallback)locationSuccessCallbackProperty {
    return objc_getAssociatedObject(self, &PermissionsLocationBlockSuccessPropertyKey);
}

-(void)setLocationSuccessCallbackProperty:(LocationSuccessCallback)locationCallbackProperty {
    objc_setAssociatedObject(self, &PermissionsLocationBlockSuccessPropertyKey, locationCallbackProperty, OBJC_ASSOCIATION_COPY);
}

-(LocationFailureCallback)locationFailureCallbackProperty {
    return objc_getAssociatedObject(self, &PermissionsLocationBlockFailurePropertyKey);
}

-(void)setLocationFailureCallbackProperty:(LocationFailureCallback)locationFailureCallbackProperty {
    objc_setAssociatedObject(self, &PermissionsLocationBlockFailurePropertyKey, locationFailureCallbackProperty, OBJC_ASSOCIATION_COPY);
}


#pragma mark - Location manager delegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways) {
        self.locationSuccessCallbackProperty();
    } else if (status != kCLAuthorizationStatusNotDetermined) {
        self.locationFailureCallbackProperty();
    }
}

@end
