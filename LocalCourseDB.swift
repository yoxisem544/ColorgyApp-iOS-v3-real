//
//  LocalCourseDB.swift
//  ColorgyCourse
//
//  Created by David on 2016/1/4.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation
import CoreData

class LocalCourseDB {
	
	static let entityName = "LocalCourseDBManagedObject"
	
	// delete all
	/// This method will delete all courses stored in data base.
	class func deleteAllCourses() {
		let main_queue = dispatch_get_main_queue()
		let qos_queue = dispatch_get_global_queue(Int(QOS_CLASS_USER_INTERACTIVE.rawValue), 0)
		dispatch_async(isSerialMode ? SERIAL_QUEUE : qos_queue , { () -> Void in
//			let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
			// try background saving
			let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).backgroundContext
			let fetchRequest = NSFetchRequest(entityName: entityName)
			do {
				let coursesInDB: [LocalCourseDBManagedObject] = try managedObjectContext.executeFetchRequest(fetchRequest) as! [LocalCourseDBManagedObject]
				for courseObject in coursesInDB {
					managedObjectContext.deleteObject(courseObject)
				}
				
				do {
					try managedObjectContext.save()
				} catch {
					print(ColorgyErrorType.DBFailure.saveFail)
				}
				
			} catch {
				print(ColorgyErrorType.DBFailure.fetchFail)
			}
		})
	}
	
	// get out all courses
	/// You can get all local courses stored in data base.
	/// @link hello
	///
	/// :returns: [LocalCourseDBManagedObject]?
	class func getAllStoredCoursesObject() -> [LocalCourseDBManagedObject]? {
		// TODO: we dont want to take care of dirty things, so i think i need to have a course class to handle this.
		let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
		let fetchRequest = NSFetchRequest(entityName: entityName)
		do {
			let coursesInDB: [LocalCourseDBManagedObject] = try managedObjectContext.executeFetchRequest(fetchRequest) as! [LocalCourseDBManagedObject]
			if coursesInDB.count == 0 {
				// return nil if element in array is zero.
				return nil
			} else {
				return coursesInDB
			}
		} catch {
			print(ColorgyErrorType.DBFailure.fetchFail)
			return nil
		}
		
	}
	
	class func getAllStoredCoursesObject(complete complete: (localCourseDBManagedObjects: [LocalCourseDBManagedObject]?) -> Void) {
		let main_queue = dispatch_get_main_queue()
		let qos_queue = dispatch_get_global_queue(Int(QOS_CLASS_USER_INTERACTIVE.rawValue), 0)
		dispatch_async(isSerialMode ? SERIAL_QUEUE : qos_queue , { () -> Void in
			// TODO: we dont want to take care of dirty things, so i think i need to have a course class to handle this.
			let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
			let fetchRequest = NSFetchRequest(entityName: entityName)
			do {
				let coursesInDB: [LocalCourseDBManagedObject] = try managedObjectContext.executeFetchRequest(fetchRequest) as! [LocalCourseDBManagedObject]
				if coursesInDB.count == 0 {
					// return nil if element in array is zero.
					dispatch_async(main_queue, { () -> Void in
						complete(localCourseDBManagedObjects: nil)
					})
				} else {
					dispatch_async(main_queue, { () -> Void in
						complete(localCourseDBManagedObjects: coursesInDB)
					})
				}
			} catch {
				dispatch_async(main_queue, { () -> Void in
					print(ColorgyErrorType.DBFailure.fetchFail)
					complete(localCourseDBManagedObjects: nil)
				})
			}
		})
	}
	
	class func getAllStoredCourses(complete complete: (localCourses: [LocalCourse]?) -> Void) {
		let main_queue = dispatch_get_main_queue()
		let qos_queue = dispatch_get_global_queue(Int(QOS_CLASS_USER_INTERACTIVE.rawValue), 0)
		dispatch_async(isSerialMode ? SERIAL_QUEUE : qos_queue , { () -> Void in
			// TODO: we dont want to take care of dirty things, so i think i need to have a course class to handle this.
			let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
			let fetchRequest = NSFetchRequest(entityName: entityName)
			do {
				let coursesInDB: [LocalCourseDBManagedObject] = try managedObjectContext.executeFetchRequest(fetchRequest) as! [LocalCourseDBManagedObject]
				if coursesInDB.count == 0 {
					// return nil if element in array is zero.
					dispatch_async(main_queue, { () -> Void in
						complete(localCourses: nil)
					})
				} else {
					var courses = [LocalCourse]()
					for obj in coursesInDB {
						if let c = LocalCourse(localCourseDBManagedObject: obj) {
							courses.append(c)
						}
					}
					dispatch_async(main_queue, { () -> Void in
						complete(localCourses: nil)
					})
				}
			} catch {
				dispatch_async(main_queue, { () -> Void in
					print(ColorgyErrorType.DBFailure.fetchFail)
					complete(localCourses: nil)
				})
			}
		})
	}
	
	class func deleteLocalCourseOnDB(localCourse: LocalCourse?) {
		let main_queue = dispatch_get_main_queue()
		let qos_queue = dispatch_get_global_queue(Int(QOS_CLASS_USER_INTERACTIVE.rawValue), 0)
		dispatch_async(isSerialMode ? SERIAL_QUEUE : qos_queue , { () -> Void in
//			let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
			// try background saving
			let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).backgroundContext
			
			guard let localCourse = localCourse else { return }
			guard let localCoursesInDB = LocalCourseDB.getAllStoredCoursesObject() else { return }
			
			for lc in localCoursesInDB {
				if lc.general_code == localCourse.general_code {
					managedObjectContext.deleteObject(lc)
				}
			}
			
			do {
				try managedObjectContext.save()
			} catch {
				print(ColorgyErrorType.DBFailure.saveFail)
			}
		})
	}
	
	class func storeLocalCourseToDB(localCourse: LocalCourse?) {
		let main_queue = dispatch_get_main_queue()
		let qos_queue = dispatch_get_global_queue(Int(QOS_CLASS_USER_INTERACTIVE.rawValue), 0)
		dispatch_async(isSerialMode ? SERIAL_QUEUE : qos_queue , { () -> Void in
//			let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
			// try background saving
			let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).backgroundContext
			let courseObject = NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: managedObjectContext) as! LocalCourseDBManagedObject
			if let localCourse = localCourse {
				
				courseObject.code = localCourse.code
				courseObject.name = localCourse.name
				courseObject.lecturer = localCourse.lecturer
				courseObject.code = localCourse.code
				
				//                courseObject.id = localCourse.id
				courseObject.type = localCourse._type
				courseObject.year = Int32(localCourse.year)
				courseObject.term = Int32(localCourse.term)
				if let credits = localCourse.credits {
					courseObject.credits = Int32(credits)
				}
				
				courseObject.general_code = localCourse.general_code
				
				if (localCourse.days?.count > 0) && (localCourse.periods?.count > 0) {
					if localCourse.days?.count >= 1 && localCourse.periods?.count >= 1 {
						courseObject.day_1 = Int32(localCourse.days![1 - 1])
						courseObject.period_1 = Int32(localCourse.periods![1 - 1])
						courseObject.location_1 = localCourse.locations?[1 - 1]
					}
					print("Int32(localCourse.days![1 - 1]) \(Int32(localCourse.days![1 - 1]))")
					print("Int32(localCourse.periods![1 - 1]) \(Int32(localCourse.periods![1 - 1]))")
					print("courseObject.day_1 \(courseObject.day_1)")
					print("courseObject.period_1 \(courseObject.period_1)")
					print("courseObject.location_1 \(courseObject.location_1)")
					if localCourse.days?.count >= 2 && localCourse.periods?.count >= 2 {
						courseObject.day_2 = Int32(localCourse.days![2 - 1])
						courseObject.period_2 = Int32(localCourse.periods![2 - 1])
						courseObject.location_2 = localCourse.locations?[2 - 1]
					}
					if localCourse.days?.count >= 3 && localCourse.periods?.count >= 3 {
						courseObject.day_3 = Int32(localCourse.days![3 - 1])
						courseObject.period_3 = Int32(localCourse.periods![3 - 1])
						courseObject.location_3 = localCourse.locations?[3 - 1]
					}
					if localCourse.days?.count >= 4 && localCourse.periods?.count >= 4 {
						courseObject.day_4 = Int32(localCourse.days![4 - 1])
						courseObject.period_4 = Int32(localCourse.periods![4 - 1])
						courseObject.location_4 = localCourse.locations?[4 - 1]
					}
					if localCourse.days?.count >= 5 && localCourse.periods?.count >= 5 {
						courseObject.day_5 = Int32(localCourse.days![5 - 1])
						courseObject.period_5 = Int32(localCourse.periods![5 - 1])
						courseObject.location_5 = localCourse.locations?[5 - 1]
					}
					if localCourse.days?.count >= 6 && localCourse.periods?.count >= 6 {
						courseObject.day_6 = Int32(localCourse.days![6 - 1])
						courseObject.period_6 = Int32(localCourse.periods![6 - 1])
						courseObject.location_6 = localCourse.locations?[6 - 1]
					}
					if localCourse.days?.count >= 7 && localCourse.periods?.count >= 7 {
						courseObject.day_7 = Int32(localCourse.days![7 - 1])
						courseObject.period_7 = Int32(localCourse.periods![7 - 1])
						courseObject.location_7 = localCourse.locations?[7 - 1]
					}
					if localCourse.days?.count >= 8 && localCourse.periods?.count >= 8 {
						courseObject.day_8 = Int32(localCourse.days![8 - 1])
						courseObject.period_8 = Int32(localCourse.periods![8 - 1])
						courseObject.location_8 = localCourse.locations?[8 - 1]
					}
					if localCourse.days?.count >= 9 && localCourse.periods?.count >= 9 {
						courseObject.day_9 = Int32(localCourse.days![9 - 1])
						courseObject.period_9 = Int32(localCourse.periods![9 - 1])
						courseObject.location_9 = localCourse.locations?[9 - 1]
					}
				}
				
				// save
				do {
					try managedObjectContext.save()
				} catch {
					print(ColorgyErrorType.DBFailure.saveFail)
				}
			}
		})
	}
}