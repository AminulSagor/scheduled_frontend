import 'package:get/get.dart';
import 'package:sheduled_call/add_number/add_number_view.dart';
import 'package:sheduled_call/add_voice/voice_recording_view.dart';
import 'package:sheduled_call/select_number/select_number_view.dart';
import 'package:sheduled_call/select_voice/select_voice_view.dart';
import '../authentication/login_view.dart';
import '../home/home_view.dart';
import '../see_number/see_number_view.dart';
import '../see_voice/see_voice_view.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(name: '/login', page: () => const LoginView()),
    GetPage(name: '/home', page: () => const HomeView()),
    GetPage(name: '/add-number', page: () => const AddNumberView()),
    GetPage(name: '/add-voice', page: () => const VoiceRecordingView()),
    GetPage(name: '/select-number', page: () => const SelectNumberView()),

    GetPage(name: '/select-voice', page: () => const SelectVoiceView()),

    GetPage(name: AppRoutes.seeNumbers, page: () => const SeeNumberView()),

    GetPage(name: AppRoutes.seeVoice, page: () => const SeeVoiceView()),
  ];
}
