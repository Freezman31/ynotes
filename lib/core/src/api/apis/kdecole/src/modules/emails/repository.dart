part of kdecole;

class _EmailsRepository extends EmailsRepository {
  _EmailsRepository(SchoolApi api) : super(api);

  @override
  Future<Response<Map<String, dynamic>>> get() async {
    /*final List<k.Email> t = await client.getEmails();
    final List<Recipient> recipients = [];
    final List<Email> emails = [];
    for (final e in t) {
      final m = await client.getFullEmail(e);
      emails.add(Email(
        date: m.messages.last.date,
        
        entityId: m.id.toString(),
        read: m.read,

        subject: m.title,
        to: m.receivers
            .map((e) => Recipient(
                civility: '',
                firstName: e,
                lastName: '',
                headTeacher: false,
                entityId: '',
                subjects: []))
            .toList(),
        content: m.body,
        documentsIds: [],
      ));
      recipients.addAll(emails.last.to);
    }
    Logger.log('TEST', 'GETTING EMAILS');
    return Response(data: {
      "emailsReceived": emails..sort((a, b) => a.date.compareTo(b.date)),
      "emailsSent": emails
        ..where((element) => element.from.firstName == client.info.fullName)
        ..sort((a, b) => a.date.compareTo(b.date)),
      "recipients": recipients
        ..sort((a, b) => a.firstName.compareTo(b.firstName)),
    });*/
    return const Response();
  }

  @override
  Future<Response<String>> getEmailContent(Email email, bool received) async {
    return const Response();
  }

  @override
  Future<Response<void>> sendEmail(Email email) async {
    return const Response();
  }
}
