import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poc_glow/ui/main_screen.dart';
import 'package:poc_glow/ui/main_screen_bloc.dart';

import 'shared_widgets/pdf_downloader_helper/pdf_downloader_helper_bloc.dart';

class MainScreenProvider extends StatelessWidget {
  const MainScreenProvider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => MainScreenBloc()),
        BlocProvider(create: (_) => PdfDownloaderHelperBloc())
      ],
      child: const MainScreen(),
    );
  }
}
