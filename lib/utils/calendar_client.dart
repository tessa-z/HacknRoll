import 'package:intl/intl.dart';


class CalendarClient {
  // for storing the CalendarApi object,
  // this can be used for performing all the operations
  static var calendar;

  // For retrieving Calendar events
  Future<String> extract() async {
    String eventData = '';
    
    String calendarId = 'primary';
    DateTime now = new DateTime.now();
    DateTime dateStart = now.toUtc();
    DateTime dateEnd = ((new DateTime(now.year, now.month, now.day)).add(new Duration(hours:24))).toUtc();  
    try {
      await calendar.events.list(calendarId, timeMin:dateStart, timeMax: dateEnd)
          .then((value) {
            // print("Event Status: ${value.status}");
            var data = value.toJson();
            // print(data);
            for (var item in data['items']) {
              // print(item);
              print(item['start']['dateTime']);
              DateTime startTime = DateTime.parse(item['start']['dateTime']);
              String formattedTime = DateFormat.jm().format(startTime); 
              String event = item['summary'] + ' at ' + formattedTime;
              // print(event);
              eventData = eventData + "\n" + event;
            }
          });
    }
    catch (e) {
      print('Error retrieving event $e');
    }
    return eventData;
    //       .patch(event, calendarId, id,
    //           conferenceDataVersion: hasConferenceSupport ? 1 : 0, sendUpdates: shouldNotifyAttendees ? "all" : "none")
    //       .then((value) {
    //     print("Event Status: ${value.status}");
    //     if (value.status == "confirmed") {
    //       String joiningLink;
    //       String eventId;

    //       eventId = value.id;

    //       if (hasConferenceSupport) {
    //         joiningLink = "https://meet.google.com/${value.conferenceData.conferenceId}";
    //       }

    //       eventData = {'id': eventId, 'link': joiningLink};

    //       print('Event updated in Google Calendar');
    //     } else {
    //       print("Unable to update event in Google Calendar");
    //     }
    //   });
    // } catch (e) {
    //   print('Error updating event $e');
    // }
  }
  // For deleting a calendar event
  Future<void> delete(String eventId, bool shouldNotify) async {}
}

