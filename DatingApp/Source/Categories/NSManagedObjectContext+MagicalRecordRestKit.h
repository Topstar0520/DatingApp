//
//  NSManagedObjectContext+MagicalRecordRestKit.h
//  StyleI
//
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (MagicalRecordRestKit)

+ (void)MR_setRootSavingContext:(NSManagedObjectContext *)context;
+ (void)MR_setDefaultContext:(NSManagedObjectContext *)moc;

@end

@interface NSManagedObjectContext (MagicalRecordTempContext)

+ (NSManagedObjectContext *)MR_temporaryContext;

@end