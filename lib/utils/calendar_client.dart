import 'package:intl/intl.dart';


class CalendarClient {
  // for storing the CalendarApi object,
  // this can be used for performing all the operations
  static var calendar;

  // For retrieving Calendar events
  Future<String> extract() async {
    String eventData = '';
    
    String calendarId = 'primary';
     DateTime now = new DateTime.now().add(new Duration(hours: 8));
    DateTime dateStart = now.toUtc();
    DateTime dateEnd = ((new DateTime(now.year, now.month, now.day)).add(new Duration(days:1, hours:8))).toUtc();  
    print('dateStart: $dateStart');
    print('dateEnd: $dateEnd');
    print(dateEnd.timeZoneName);
    try {
      await calendar.events.list(calendarId, timeMin:dateStart, timeMax:dateEnd, singleEvents: true)
          .then((value) {
            // print("Event Status: ${value.status}");
            var data = value.toJson();
            print(data);
            // print(data);
            for (var item in data['items']) {
              // print(item);
              print(item['start']['dateTime']);
              DateTime startTime = DateTime.parse(item['start']['dateTime']).add(new Duration(hours:8));
              String formattedTime = DateFormat.jm().format(startTime); 
              String event = item['summary'] + ' at ' + formattedTime;
              // print(event);
              eventData = eventData + ", , , " + event;
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

