part of main_page;

class _Upload extends StatefulWidget {
  final _MainPageState pageState;

  const _Upload(this.pageState);
  @override
  __UploadState createState() => __UploadState();
}

class __UploadState extends State<_Upload> {
  _MainPageState main;

  @override
  void initState() {
    main = widget.pageState;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
