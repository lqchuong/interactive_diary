part of 'content_card_view.dart';

class _DiaryHeader extends StatelessWidget {
  final String avatarPath;
  final String displayName;
  final DateTime dateTime;

  final String dateFormat = 'MMM dd, yyyy';
  final String timeFormat = 'HH:mm a';

  const _DiaryHeader(
      {required this.avatarPath,
      required this.displayName,
      required this.dateTime,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: NartusDimens.padding8),
        child: Row(
          children: [
            // TODO change avatar to be a thumbnail downloaded and store in cached file
            CircleAvatar(
              radius: NartusDimens.radius32,
              backgroundImage: NetworkImage(avatarPath),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(
                  left: NartusDimens.padding10, right: NartusDimens.padding10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Text(S.current.diaryDateFormatter(
                      DateFormat(dateFormat).format(dateTime),
                      DateFormat(timeFormat).format(dateTime)))
                ],
              ),
            )),
            SvgPicture.asset(Assets.images.idMoreIcon)
          ],
        ),
      );
}
