import 'package:get_it/get_it.dart';
import 'package:neuvox/data/repositories/auth_repository_impl.dart';
import 'package:neuvox/domain/repositories/auth_repository.dart';
import 'package:neuvox/presentation/providers/auth_provider.dart';
import 'package:neuvox/data/services/ai_service_impl.dart';
import 'package:neuvox/domain/services/ai_service.dart';
import 'package:neuvox/data/services/text_to_speech_service_impl.dart';
import 'package:neuvox/domain/services/text_to_speech_service.dart';
import 'package:neuvox/data/services/context_service.dart';
import 'package:neuvox/presentation/providers/communication_provider.dart';
import 'package:neuro_capture/neuro_capture.dart';
import 'package:azure_client/azure_client.dart';
import 'package:neuvox/core/services/biometric_service.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Services
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
  sl.registerLazySingleton<AiService>(() => AiServiceImpl());
  sl.registerLazySingleton<TextToSpeechService>(() => TextToSpeechServiceImpl());
  sl.registerLazySingleton<ContextService>(() => ContextServiceImpl());
  sl.registerLazySingleton<BiometricService>(() => BiometricService());

  // Gen2 Hardware/Cloud
  sl.registerLazySingleton<NeuralDevice>(() => MockNeuralDevice());
  sl.registerLazySingleton<AzureService>(() => AzureService(
    const AzureConfig(tenantId: "mock-tenant", clientId: "mock-client", iotHubUrl: "neuvox-hub.azure-devices.net")
  ));

  // Providers
  sl.registerFactory(() => AuthProvider(sl()));
  sl.registerFactory(() => CommunicationProvider(sl(), sl(), sl(), sl(), sl())); // Injected: Ai, TTS, Context, Device, Azure
}
