import 'package:awesome_notifications/awesome_notifications.dart';

import 'notification_week_and_time.dart';

Future<void> createHourlyReminder(
    NotificationWeekAndTime notificationSchedule) async {
  print("create interval reminder");
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: createUniqueId(),
      channelKey: 'hourly_channel',
      title: 'Complete Survey',
      body: 'Please complete your daily survey.',
      notificationLayout: NotificationLayout.Default,
    ),
    actionButtons: [
      NotificationActionButton(
        key: 'MARK_DONE',
        label: 'Mark Done',
      ),
    ],
    schedule: NotificationInterval(
      interval: 3600, //in seconds
      timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(),
      allowWhileIdle: true,
      repeats: true,
    ),
  );
}

Future<void> createDailyReminder(
    NotificationWeekAndTime notificationSchedule) async {
  print('create daily reminder');
  print('scheduling on day ${notificationSchedule.dayOfTheWeek} and hour ${notificationSchedule.timeOfDay.hour}');
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: createUniqueId(),
      channelKey: 'daily_channel',
      title: 'Complete Survey',
      body: 'Please complete your daily survey.',
      notificationLayout: NotificationLayout.Default,
    ),
    actionButtons: [
      NotificationActionButton(
        key: 'MARK_DONE',
        label: 'Mark Done',
      ),
    ],
    schedule: NotificationCalendar( //in seconds
      day: notificationSchedule.dayOfTheWeek,
      hour: notificationSchedule.timeOfDay.hour,
      minute: notificationSchedule.timeOfDay.minute,
      timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(),
      allowWhileIdle: true,
      repeats: false,
    ),
  );
}

Future<void> cancelScheduledNotifications() async {
  await AwesomeNotifications().cancelAllSchedules();
}

