#import "PermissionPlugin.h"
#import <CoreLocation/CLLocationManager.h>
#import <EventKit/EventKit.h>
#import <Photos/PHPhotoLibrary.h>
#import <Contacts/Contacts.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>

@import AVFoundation;
@import CoreTelephony;
CLLocationManager *locationManager;
@implementation PermissionPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"plugins.ly.com/permission"
                                     binaryMessenger:[registrar messenger]];
    PermissionPlugin* instance = [[PermissionPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPermissionsStatus" isEqualToString:call.method]) {
    NSDictionary* argsMap = call.arguments;
        NSArray<NSString *> * permissionNames = argsMap[@"permissions"];
        NSLog (@"Number of elements in permissioon names array = %lu", [permissionNames count]);
        NSMutableArray *statusResults=[[NSMutableArray alloc] init];
        for (NSString* permissionName in permissionNames) {
        if ([@"Internet" isEqualToString:permissionName]) {
            if (@available(iOS 9.0, *)) {
                CTCellularData *cellularData = [[CTCellularData alloc] init];
                cellularData.cellularDataRestrictionDidUpdateNotifier = ^(CTCellularDataRestrictedState state) {
                    switch (state) {
                        case kCTCellularDataNotRestricted:
                            [statusResults 	addObject:@0];
                            break;
                        case kCTCellularDataRestricted:
                            [statusResults 	addObject:@1];
                            break;
                        case kCTCellularDataRestrictedStateUnknown:
                            [statusResults 	addObject:@2];
                            break;
                        default:

                        [statusResults 	addObject:@2];
                            break;
                    }
                };
            }
        } else if ([@"Calendar" isEqualToString:permissionName]) {
            EKAuthorizationStatus EKStatus = [EKEventStore  authorizationStatusForEntityType:EKEntityTypeEvent];
            switch (EKStatus) {
                case EKAuthorizationStatusAuthorized:
                    [statusResults 	addObject:@0];
                    break;
                case EKAuthorizationStatusDenied:
                    [statusResults 	addObject:@1];
                    break;
                case EKAuthorizationStatusNotDetermined:
                    [statusResults 	addObject:@2];
                    break;
                case EKAuthorizationStatusRestricted:
                    [statusResults 	addObject:@1];
                    break;
                default:
                    [statusResults 	addObject:@2];
                    break;
            }
        } else if ([@"Camera" isEqualToString:permissionName]){
            PHAuthorizationStatus PHStatus = [PHPhotoLibrary authorizationStatus];
            switch (PHStatus) {
                case PHAuthorizationStatusAuthorized:
                    [statusResults 	addObject:@0];
                    break;
                case PHAuthorizationStatusDenied:
                    [statusResults 	addObject:@1];
                    break;
                case PHAuthorizationStatusNotDetermined:
                    [statusResults 	addObject:@2];
                    break;
                case PHAuthorizationStatusRestricted:
                    [statusResults 	addObject:@1];
                    break;
                default:
                    [statusResults 	addObject:@2];
                    break;
            }
        } else if ([@"Contacts" isEqualToString:permissionName]){
            if (@available(iOS 9.0, *)) {
                CNAuthorizationStatus CNStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
                switch (CNStatus) {
                    case CNAuthorizationStatusAuthorized:
                        [statusResults 	addObject:@0];
                        break;
                    case CNAuthorizationStatusDenied:
                        [statusResults 	addObject:@1];
                        break;
                    case CNAuthorizationStatusNotDetermined:
                        [statusResults 	addObject:@2];
                        break;
                    case CNAuthorizationStatusRestricted:
                        [statusResults 	addObject:@1];
                        break;
                    default:
                        [statusResults 	addObject:@2];
                        break;
                }
            }
        } else if ([@"Microphone" isEqualToString:permissionName]){
            AVAuthorizationStatus AVStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
            switch (AVStatus) {
                case AVAuthorizationStatusAuthorized:
                    [statusResults 	addObject:@0];
                    break;
                case AVAuthorizationStatusDenied:
                    [statusResults 	addObject:@1];
                    break;
                case AVAuthorizationStatusNotDetermined:
                    [statusResults 	addObject:@2];
                    break;
                case AVAuthorizationStatusRestricted:
                    [statusResults 	addObject:@1];
                    break;
                default:
                    [statusResults 	addObject:@2];
                    break;
            }
        } else if ([@"Location" isEqualToString:permissionName]){
            CLAuthorizationStatus CLStatus =  [CLLocationManager authorizationStatus];
            switch (CLStatus) {
                case kCLAuthorizationStatusAuthorizedWhenInUse:
                    [statusResults 	addObject:@4];
                    break;
                case kCLAuthorizationStatusAuthorizedAlways:
                    [statusResults 	addObject:@5];
                    break;
                case kCLAuthorizationStatusDenied:
                    [statusResults 	addObject:@1];
                    break;
                case kCLAuthorizationStatusNotDetermined:
                    [statusResults 	addObject:@2];
                    break;
                case kCLAuthorizationStatusRestricted:
                    [statusResults 	addObject:@1];
                    break;
                default:
                  [statusResults 	addObject:@6];
                    break;
            }
        }
        }
        result(statusResults);
  } else if ([@"requestPermissions" isEqualToString:call.method]) {
    NSDictionary* argsMap = call.arguments;
    NSArray<NSString *> * permissionNames = argsMap[@"permissions"];
    NSLog (@"Number of elements in permissioon names array = %lu", [permissionNames count]);
    NSMutableArray *statusResults=[[NSMutableArray alloc] init];
    for (NSString* permissionName in permissionNames) {
      if ([@"Internet" isEqualToString:permissionName]) {
        NSURL *url = [NSURL URLWithString:@"https://www.baidu.com"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
          }];
        [dataTask resume];
        if (@available(iOS 9.0, *)) {
          CTCellularData *cellularData = [[CTCellularData alloc] init];
          cellularData.cellularDataRestrictionDidUpdateNotifier = ^(CTCellularDataRestrictedState state) {
            switch (state) {
            case kCTCellularDataNotRestricted:
            [statusResults 	addObject:@0];
            break;
            case kCTCellularDataRestricted:
            [statusResults 	addObject:@1];
            break;
            case kCTCellularDataRestrictedStateUnknown:
            [statusResults 	addObject:@2];
            break;
            default:
            [statusResults 	addObject:@2];
            break;
            }
          };
        }
      } else if ([@"Calendar" isEqualToString:permissionName]){
        EKEventStore *eventStore = [[EKEventStore alloc] init];
        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            if (error) {
              [statusResults 	addObject:@2];
              return;
            }
            if (granted) {
              [statusResults 	addObject:@0];
            } else {
              [statusResults 	addObject:@1];
            }
          }];
      } else if ([@"Camera" isEqualToString:permissionName]){
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus PHStatus) {
            switch (PHStatus) {
            case PHAuthorizationStatusAuthorized:
              [statusResults 	addObject:@0];
              break;
            case PHAuthorizationStatusDenied:
              [statusResults 	addObject:@1];
              break;
            case PHAuthorizationStatusNotDetermined:
              [statusResults 	addObject:@2];
              break;
            case PHAuthorizationStatusRestricted:
              [statusResults 	addObject:@1];
              break;
            default:
              [statusResults 	addObject:@2];
              break;
            }
          }];
      } else if ([@"Contacts" isEqualToString:permissionName]){
        if (@available(iOS 9.0, *)) {
          CNContactStore *contactStore = [[CNContactStore alloc] init];
          [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
              if (error) {
                [statusResults 	addObject:@2];
                return;
              }
              if (granted) {
                [statusResults 	addObject:@0];
              } else {
                [statusResults 	addObject:@1];
              }
            }];
        }
      } else if ([@"Microphone" isEqualToString:permissionName]){
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            if (granted) {
              [statusResults 	addObject:@0];
            } else {
              [statusResults 	addObject:@1];
            }
          }];
      } else if ([@"Location" isEqualToString:permissionName]){
        locationManager = [[CLLocationManager alloc] init];
        [locationManager requestAlwaysAuthorization];
      }
    }
    result(statusResults);
  }
  else if ([@"openSettings" isEqualToString:call.method]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        result(@YES);
    } else {
    result(FlutterMethodNotImplemented);
    }
}
@end
