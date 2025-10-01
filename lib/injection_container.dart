import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedlist/core/refresh/refresh_bus.dart';
import 'package:wedlist/core/services/ads_service.dart';
import 'package:wedlist/core/services/purchase_service.dart';
import 'package:wedlist/core/user/country_persistence.dart';
import 'package:wedlist/core/user/user_service.dart';
import 'package:wedlist/feature/dowrylist/domain/usecases/delete_user_item_usecase.dart';
// DowryList, UserItem domain'i kullanır
import 'package:wedlist/feature/dowrylist/domain/usecases/get_user_items_usecase.dart';
import 'package:wedlist/feature/dowrylist/domain/usecases/update_user_item_usecase.dart';
import 'package:wedlist/feature/dowrylist/domain/usecases/watch_user_items_usecase.dart';
import 'package:wedlist/feature/dowrylist/presentation/blocs/bloc/dowry_list_bloc.dart';
import 'package:wedlist/feature/item_add/data/datasources/photo_upload_datasource.dart';
import 'package:wedlist/feature/item_add/data/datasources/user_item_remote_datasource.dart';
import 'package:wedlist/feature/item_add/data/repositories/item_repository_impl.dart';
import 'package:wedlist/feature/item_add/data/repositories/photo_repository_impl.dart';
import 'package:wedlist/feature/item_add/data/repositories/user_item_repository_impl.dart';
import 'package:wedlist/feature/item_add/domain/repositories/item_repository.dart';
import 'package:wedlist/feature/item_add/domain/repositories/photo_repository.dart';
import 'package:wedlist/feature/item_add/domain/repositories/user_item_repository.dart';
import 'package:wedlist/feature/item_add/domain/usecases/add_user_item_usecase.dart';
import 'package:wedlist/feature/item_add/domain/usecases/upload_photo_usecase.dart';
import 'package:wedlist/feature/item_add/domain/usecases/upload_photo_with_progress_usecase.dart';
import 'package:wedlist/feature/item_add/presentation/bloc/add_item_bloc.dart';
import 'package:wedlist/feature/item_add/presentation/bloc/add_photo_cubit/add_photo_cubit.dart';
import 'package:wedlist/feature/login/data/datasources/auth_remote_data_source.dart';
import 'package:wedlist/feature/login/data/datasources/auth_remote_data_source_impl.dart';
import 'package:wedlist/feature/login/data/repositories/auth_repository_impl.dart';
import 'package:wedlist/feature/login/domain/repositories/auth_repository.dart';
// Login Feature Imports
import 'package:wedlist/feature/login/domain/usecases/sign_in.dart';
import 'package:wedlist/feature/login/domain/usecases/sign_in_with_apple.dart';
import 'package:wedlist/feature/login/domain/usecases/sign_in_with_google.dart';
import 'package:wedlist/feature/login/presentation/blocs/auth_bloc.dart';
import 'package:wedlist/feature/notification/data/datasources/notification_remote_data_source.dart';
import 'package:wedlist/feature/notification/data/repositories/notification_repository_impl.dart';
import 'package:wedlist/feature/notification/domain/repositories/notification_repository.dart';
import 'package:wedlist/feature/notification/domain/usecases/delete_notification.dart';
import 'package:wedlist/feature/notification/domain/usecases/mark_notifications_read.dart';
import 'package:wedlist/feature/notification/domain/usecases/send_notification_to_user.dart';
import 'package:wedlist/feature/notification/domain/usecases/watch_notifications.dart';
import 'package:wedlist/feature/notification/presentation/bloc/notification_bloc.dart';
import 'package:wedlist/feature/register/data/datasources/register_remote_data_source.dart';
import 'package:wedlist/feature/register/data/datasources/register_remote_data_source_impl.dart';
import 'package:wedlist/feature/register/data/repositories/register_repository_impl.dart';
import 'package:wedlist/feature/register/domain/repositories/register_repository.dart';
import 'package:wedlist/feature/register/domain/usecases/register_usecase.dart';
import 'package:wedlist/feature/register/presentation/blocs/register_bloc.dart';
import 'package:wedlist/feature/settings/data/collab_repository_impl.dart';
import 'package:wedlist/feature/settings/data/country_repository_impl.dart';
import 'package:wedlist/feature/settings/data/theme_repository_impl.dart';
import 'package:wedlist/feature/settings/domain/repositories/collab_repository.dart';
import 'package:wedlist/feature/settings/domain/repositories/country_repository.dart';
import 'package:wedlist/feature/settings/domain/usecases/add_collab_invite.dart';
import 'package:wedlist/feature/settings/domain/usecases/change_country.dart';
import 'package:wedlist/feature/settings/domain/usecases/load_collab_summary.dart';
import 'package:wedlist/feature/settings/domain/usecases/remove_partner.dart';
import 'package:wedlist/feature/settings/domain/usecases/toggle_theme.dart';
import 'package:wedlist/feature/settings/domain/usecases/watch_country.dart';
import 'package:wedlist/feature/settings/presentation/bloc/country_cubit.dart';
import 'package:wedlist/feature/settings/presentation/bloc/theme_cubit.dart';
import 'package:wedlist/feature/wishlist/data/datasources/category_remote_data_source.dart';
import 'package:wedlist/feature/wishlist/data/datasources/wishlist_remote_data_source.dart';
import 'package:wedlist/feature/wishlist/data/repositories/category_repository_impl.dart';
import 'package:wedlist/feature/wishlist/data/repositories/wishlist_repository_impl.dart';
import 'package:wedlist/feature/wishlist/domain/repositories/categort_repository.dart';
import 'package:wedlist/feature/wishlist/domain/repositories/wishlist_repository.dart';
import 'package:wedlist/feature/wishlist/domain/usecases/add_wishlist_items.dart';
import 'package:wedlist/feature/wishlist/domain/usecases/get_category_items.dart';
import 'package:wedlist/feature/wishlist/domain/usecases/get_wishlist_items.dart';
import 'package:wedlist/feature/wishlist/presentation/blocs/category_bloc/bloc/categorylist_bloc.dart';
import 'package:wedlist/feature/wishlist/presentation/blocs/cubit/wishlist_bloc/wishlist_bloc.dart';

final GetIt sl = GetIt.instance; // Service Locator (sl)

Future<void> init() async {
  // Global utilities
  sl
    ..registerLazySingleton<RefreshBus>(RefreshBus.new)
    // ItemAdd Feature Injection
    // continue chain
    // ItemAdd Feature Injection
    // ItemAdd Feature Injection
    // ItemAdd Feature Injection
    // ItemAdd Feature Injection
    // ItemAdd Feature Injection
    // ItemAdd Feature Injection
    // ItemAdd Feature Injection
    ..registerLazySingleton<ItemRepository>(ItemRepositoryImpl.new)
    ..registerLazySingleton<UserItemRemoteDataSource>(
      () => UserItemRemoteDataSourceImpl(
        FirebaseFirestore.instance,
        FirebaseStorage.instance,
        FirebaseAuth.instance,
      ),
    )
    ..registerLazySingleton<UserItemRepository>(
      () => UserItemRepositoryImpl(sl<UserItemRemoteDataSource>()),
    )
    ..registerLazySingleton<AddUserItemUseCase>(
      () => AddUserItemUseCase(sl<UserItemRepository>()),
    )
    // Photo Upload
    ..registerLazySingleton<PhotoUploadDataSource>(
      () => PhotoUploadDataSourceImpl(
        FirebaseStorage.instance,
        FirebaseAuth.instance,
      ),
    )
    ..registerLazySingleton<PhotoRepository>(
      () => PhotoRepositoryImpl(sl<PhotoUploadDataSource>()),
    )
    ..registerLazySingleton<UploadPhotoUseCase>(
      () => UploadPhotoUseCase(sl<PhotoRepository>()),
    )
    ..registerLazySingleton<UploadPhotoWithProgressUseCase>(
      () => UploadPhotoWithProgressUseCase(sl<PhotoRepository>()),
    );
  final sharedPreferences = await SharedPreferences.getInstance();
  sl
    // Register Feature Injection
    ..registerFactory(() => AddItemBloc(sl<AddUserItemUseCase>()))
    ..registerFactory(
      () => AddPhotoCubit(
        sl<UploadPhotoUseCase>(),
        sl<UploadPhotoWithProgressUseCase>(),
      ),
    )
    ..registerLazySingleton<RegisterRemoteDataSource>(
      RegisterRemoteDataSourceImpl.new,
    )
    ..registerLazySingleton<RegisterRepository>(
      () => RegisterRepositoryImpl(sl<RegisterRemoteDataSource>()),
    )
    ..registerLazySingleton<RegisterUseCase>(
      () => RegisterUseCase(sl<RegisterRepository>()),
    )
    ..registerFactory(() => RegisterBloc(sl<RegisterUseCase>()))
    // Login/Auth Feature Injection
    ..registerLazySingleton<AuthRemoteDataSource>(AuthRemoteDataSourceImpl.new)
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(sl<AuthRemoteDataSource>()),
    )
    ..registerLazySingleton<SignIn>(() => SignIn(sl<AuthRepository>()))
    ..registerLazySingleton<SignInWithApple>(
      () => SignInWithApple(sl<AuthRepository>()),
    )
    ..registerLazySingleton<SignInWithGoogle>(
      () => SignInWithGoogle(sl<AuthRepository>()),
    )
    ..registerLazySingleton<CountryPersistenceService>(
      () => CountryPersistenceService(
        FirebaseFirestore.instance,
        FirebaseAuth.instance,
      ),
    )
    // Country feature
    ..registerLazySingleton<CountryRepository>(
      () => CountryRepositoryImpl(
        FirebaseFirestore.instance,
        FirebaseAuth.instance,
        sl<CountryPersistenceService>(),
      ),
    )
    // Collab (Settings) domain wiring
    ..registerLazySingleton<CollabRepository>(
      () => CollabRepositoryImpl(
        FirebaseFirestore.instance,
        FirebaseAuth.instance,
      ),
    )
    ..registerLazySingleton(() => LoadCollabSummary(sl<CollabRepository>()))
    ..registerLazySingleton(() => AddCollabInvite(sl<CollabRepository>()))
    ..registerLazySingleton(() => RemovePartner(sl<CollabRepository>()))
    ..registerLazySingleton(() => WatchCountry(sl<CountryRepository>()))
    ..registerLazySingleton(() => ChangeCountry(sl<CountryRepository>()))
    ..registerFactory(
      () => CountryCubit(
        sl<WatchCountry>(),
        sl<ChangeCountry>(),
        FirebaseFirestore.instance,
        FirebaseAuth.instance,
        sl<RefreshBus>(),
      ),
    )
    ..registerFactory(
      () => AuthBloc(
        sl<SignIn>(),
        sl<CountryPersistenceService>(),
        sl<SignInWithApple>(),
        sl<SignInWithGoogle>(),
      ),
    )
    ..registerLazySingleton(() => sharedPreferences)
    // Core
    ..registerLazySingleton<ThemeRepositoryImpl>(
      () => ThemeRepositoryImpl(sl<SharedPreferences>()),
    )
    // Domain
    ..registerLazySingleton<ToggleTheme>(
      () => ToggleTheme(sl<ThemeRepositoryImpl>()),
    )
    // Bloc (GÜNCELLENDİ ✅)
    ..registerLazySingleton<ThemeCubit>(
      () => ThemeCubit(
        sl<ThemeRepositoryImpl>(), // ✅ Direkt ThemeRepositoryImpl verildi
        sl<ToggleTheme>(),
      ),
    )
    // Wishlist Injection
    ..registerLazySingleton(() => FirebaseFirestore.instance)
    ..registerLazySingleton<WishListRemoteDataSource>(
      () => WishListRemoteDataSourceImpl(sl(), FirebaseAuth.instance),
    )
    ..registerLazySingleton<WishListRepository>(
      () => WishListRepositoryImpl(sl()),
    )
    ..registerLazySingleton(() => GetWishListItems(sl()))
    ..registerLazySingleton(() => AddWishlistItems(sl()))
    ..registerFactory(() => WishListBloc(sl(), sl<RefreshBus>()))
    // Category Injection
    ..registerLazySingleton<CategoryRemoteDataSource>(
      () => CategoryRemoteDataSourceImpl(sl(), FirebaseAuth.instance),
    )
    ..registerLazySingleton<CategoryRepository>(
      () => CategoryRepositoryImpl(sl()),
    )
    ..registerLazySingleton(() => GetCategoryItems(sl()))
    ..registerFactory(() => CategorylistBloc(sl(), sl<RefreshBus>()))
    // User Service
    ..registerLazySingleton<UserService>(
      () => UserService(FirebaseFirestore.instance, FirebaseAuth.instance),
    )
    // Ads Service
    ..registerLazySingleton<AdsService>(AdsService.new)
    // Purchase Service
    ..registerLazySingleton<PurchaseService>(PurchaseService.new)
    // Notifications
    ..registerLazySingleton<NotificationRemoteDataSource>(
      () => NotificationRemoteDataSourceImpl(
        FirebaseFirestore.instance,
        FirebaseAuth.instance,
      ),
    )
    ..registerLazySingleton<NotificationRepository>(
      () => NotificationRepositoryImpl(sl<NotificationRemoteDataSource>()),
    )
    ..registerLazySingleton(
      () => WatchNotifications(sl<NotificationRepository>()),
    )
    ..registerLazySingleton(
      () => MarkNotificationsRead(sl<NotificationRepository>()),
    )
    ..registerLazySingleton(
      () => DeleteNotificationUseCase(sl<NotificationRepository>()),
    )
    ..registerLazySingleton(
      () => SendNotificationToUser(sl<NotificationRepository>()),
    )
    ..registerFactory(() => NotificationBloc(sl(), sl(), sl(), sl()))
    // DowryList -> UserItem use cases
    ..registerLazySingleton<GetUserItemsUseCase>(
      () => GetUserItemsUseCase(sl<UserItemRepository>()),
    )
    ..registerLazySingleton<DeleteUserItemUseCase>(
      () => DeleteUserItemUseCase(sl<UserItemRepository>()),
    )
    ..registerLazySingleton<UpdateUserItemUseCase>(
      () => UpdateUserItemUseCase(sl<UserItemRepository>()),
    )
    ..registerLazySingleton<WatchUserItemsUseCase>(
      () => WatchUserItemsUseCase(sl<UserItemRepository>()),
    )
    ..registerFactory(
      () => DowryListBloc(
        sl<GetUserItemsUseCase>(),
        sl<DeleteUserItemUseCase>(),
        sl<UpdateUserItemUseCase>(),
        sl<WatchUserItemsUseCase>(),
      ),
    );
}
