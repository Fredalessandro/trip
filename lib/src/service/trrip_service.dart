import 'dart:convert';
import '../model/trip_model.dart';
import 'local_storage_service.dart';


class TripService  {
   static String KEY = "TRIPS";
  
   static save(List<Trip> trips) async {
         SharedLocalStorageService sharedLocalStorageService = SharedLocalStorageService();
         remove();
         const JsonEncoder encoder = JsonEncoder();
         final String stringJson = encoder.convert(trips);
         sharedLocalStorageService.put(KEY, stringJson);
   }

   static saveTrip(Trip trip) async {
         SharedLocalStorageService sharedLocalStorageService = SharedLocalStorageService();
         
         List<Trip> trips = [];
         
         await get().then((value) => trips = value);
         trips.forEach((element) {
          if (element.id == trip.id) {
              element = trip;
          }
         });

         if (trips.isEmpty) {
             trips.add(trip);
         }

         remove();

         const JsonEncoder encoder = JsonEncoder();
         final String stringJson = encoder.convert(trips);
         sharedLocalStorageService.put(KEY, stringJson);
         
   }

   static Future<List<Trip>> get() async {
         
         SharedLocalStorageService sharedLocalStorageService = SharedLocalStorageService();
         
         const JsonDecoder decoder = JsonDecoder();
         String stringJson = ""; 
         
         await sharedLocalStorageService.getString(KEY).then((value) => {
                stringJson = value==null?"":value                
         });
         
         List<Trip> trips = []; 
         
         if (stringJson.isNotEmpty) {
            var object = decoder.convert(stringJson);
            
            object.forEach((element) {
              trips.add(Trip.fromJson(element as Map<String, dynamic>));
            });
          }   
         
         return trips;
   }

   static remove() async {
         SharedLocalStorageService sharedLocalStorageService = SharedLocalStorageService();
         sharedLocalStorageService.delete(KEY);
   }


}