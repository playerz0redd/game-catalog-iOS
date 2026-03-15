
![alt text](https://img.shields.io/badge/Swift-5.9+-orange.svg)

![alt text](https://img.shields.io/badge/Architecture-MVVM--C-green.svg)

![alt text](https://img.shields.io/badge/UI-SwiftUI-informational.svg)

![alt text](https://img.shields.io/badge/Data-SwiftData%20%7C%20Firestore-blue.svg)

GameHub — это комплексное iOS-приложение для поиска видеоигр, просмотра трейлеров, скриншотов, информации о разработчиках и управления списком избранного. Данные загружаются через публичный RAWG API.

Проект написан с упором на production-ready решения, строгую архитектуру, Protocol-Oriented Programming (POP), безопасность и внимание к UI/UX (скелетоны, кастомные жесты, Lottie-анимации, стейт-машины).

Архитектура и паттерны проектирования  
В приложении используется строгое разделение ответственности, обеспечивающее высокую тестируемость и переиспользуемость кода.

MVVM + Coordinator (MVVM-C): Полная изоляция бизнес-логики от UI. Навигация вынесена из View в независимые классы-координаторы (CatalogCoordinator, FavoritesCoordinator, DevelopersCoordinator).

Router Pattern: Использование кастомного протокола IRouter и enum (например, DetailsRouter, CatalogRouter) в связке с NavigationStack и NavigationPath для типобезопасной навигации.

Protocol-Oriented Programming (POP): Инверсия зависимостей. Все сервисы (INetworkManager, IGamesCatalogService, IAuthService, IProfileService, IRemoteDataProvider, IPersistance) закрыты протоколами. Внедрение зависимостей происходит через инициализаторы.

State-Driven UI (Конечные автоматы): Реализован дженерик-стейт ViewState<T: IAppError>. Все экраны реактивно реагируют на изменение этого состояния.

Generic Views: Создан универсальный экран AllItemsView<T: IDataList>, который умеет отображать списки скриншотов, трейлеров и разработчиков, опираясь на единый контракт абстракции.

Validation Service: Логика валидации полей (email, пароли, длина имени) вынесена в отдельный сервис AuthValidationService, возвращающий массив типизированных ошибок.

🛠 Технологический стек и подходы

Сеть и Concurrency  
Современный Swift Concurrency: Повсеместное использование async/await, Task(priority:) и MainActor.

TaskGroups: Для параллельной загрузки данных (например, загрузка массива изображений из Firebase Storage для избранных игр реализована через withThrowingTaskGroup).

Custom Network Layer: Дженерик слой NetworkManager поверх URLSession. Парсинг API вынесен в DecodeManager.

Type-Safe Endpoints: Конфигурация запросов происходит через enum GameApiEndpoints, использующий URLComponents и URLQueryItem для сборки запросов. Токен хранится в Secrets.xcconfig.

Работа с данными (Локально + Облако)  
Приложение реализует логику двусторонней синхронизации данных:

SwiftData: Локальное хранилище для мгновенного доступа к избранным играм (DatabaseGameModel). Использование @Model, FetchDescriptor и макросов #Predicate.

Firebase Firestore: Удаленное облачное хранилище (FavoriteGameRemoteDatabaseModel).

Smart Sync: Если локальная база пуста, приложение асинхронно стягивает список игр из Firestore, загружает для них картинки в фоновом потоке и сохраняет локально.

File System (FileManager): Аватарка пользователя сохраняется напрямую в директорию документов устройства (StorageManager).

🔐 Авторизация и реактивность  
Firebase Auth: Регистрация, авторизация и выход пользователя.

Combine: Использование CurrentValueSubject и AnyPublisher для реактивного наблюдения за глобальным стейтом приложения:

Прослушивание статуса авторизации для автоматического переключения Root-экрана (RootViewModel).

Реактивная смена языка без перезагрузки приложения (LanguageManager).

⚠️ Система обработки ошибок  
Базовый протокол IAppError, наследующийся от LocalizedError.

Использование Typed Throws из Swift 5.9+ (например, throws(GamesCatalogServiceError)).

Проработанные гранулярные перечисления: AuthServiceError (с вложенными ValidationPasswordError), NetworkError, PersistanceError, RemoteDatabaseError. Ошибки пробрасываются через все слои и отображаются пользователю через алерты или UI.

🎨 UI / UX, Медиа и Анимации
UI Framework: SwiftUI.

SwiftUI-Shimmer: Созданы кастомные скелетоны загрузки для каждого экрана (GamesCatalogSceleton, DetailsSceletonView, DeveloperViewSceleton).

Lottie: Векторная анимация на Splash Screen (экран загрузки).

Кастомный ContentViewer: Написан собственный оверлей для просмотра медиа-контента. Включает поддержку DragGesture — смахивание вниз закрывает экран с математическим расчетом opacity в зависимости от свайпа.

AVKit: Нативное воспроизведение видео-трейлеров прямо в карточке игры.

Kingfisher: Асинхронная загрузка изображений, жесткое кэширование, даунсэмплинг (для экономии ОЗУ) и плавный fade-in. Также используется ImagePrefetcher для предзагрузки картинок при пагинации списков.

Локализация
Apple String Catalogs (.xcstrings): Поддержка английского и русского языков. Смена языка доступна прямо в настройках профиля приложения.

Основные функции  
🔍 Умный каталог и поиск: Пагинация, поиск по тексту, фильтрация по категориям. Скрытие хедера при скролле вниз.

📖 Детальная карточка игры: Интеграция с In-App Safari для перехода в магазины покупок. Просмотр скриншотов с пагингом.

🎥 Нативный плеер трейлеров: Воспроизведение видео с использованием AVPlayer.

❤️ Кроссплатформенное избранное: Добавление игр в Избранное с синхронизацией между локальной БД (SwiftData) и облаком (Firestore).

👥 Информация о разработчиках: Отдельный флоу с просмотром компаний-создателей и списком всех выпущенных ими игр.

👤 Профиль пользователя: Установка аватарки (через камеру устройства или галерею UIImagePickerController), смена языка, безопасный Sign Out.

🚀 Динамический Splash Screen: Анимация на старте с проверкой авторизации.

📱 Скриншоты приложения
<table>
<tr>
<td><img width="220" alt="Simulator Screenshot - iPhone 17 Pro - 2026-03-07 at 13 16 57" src="https://github.com/user-attachments/assets/8512c7f7-3deb-4be5-b58b-31ed71383c7b" /></td>
<td><img width="220" alt="Simulator Screenshot - iPhone 17 Pro - 2026-03-07 at 13 20 54" src="https://github.com/user-attachments/assets/bbbdb605-1948-45ea-a546-84adbb6f317f" /></td>
<td><img width="220" alt="Simulator Screenshot - iPhone 17 Pro - 2026-03-07 at 13 20 14" src="https://github.com/user-attachments/assets/7c8b6a7e-0293-4bd1-9538-0fd123be5e51" /></td>
<td><img width="220" alt="Simulator Screenshot - iPhone 17 Pro - 2026-03-07 at 13 19 18" src="https://github.com/user-attachments/assets/d4658c05-7b61-4932-841a-9f3303b2b300" /></td>
</tr>
<tr>
<td><img width="220" alt="Simulator Screenshot - iPhone 17 Pro - 2026-03-07 at 13 18 56" src="https://github.com/user-attachments/assets/9bedb9e0-56cf-4b3f-83d2-8722ee74a5c6" /></td>
<td><img width="220" alt="Simulator Screenshot - iPhone 17 Pro - 2026-03-07 at 13 17 58" src="https://github.com/user-attachments/assets/d02ee9b1-c315-4027-93cc-595013a31541" /></td>
<td><img width="220" alt="Simulator Screenshot - iPhone 17 Pro - 2026-03-07 at 13 17 42" src="https://github.com/user-attachments/assets/492547ed-9d05-4de4-9715-bab440790461" /></td>
<td><img width="220" alt="Simulator Screenshot - iPhone 17 Pro - 2026-03-07 at 21 52 38" src="https://github.com/user-attachments/assets/1fdd0343-a118-4ce4-9730-5d368654f142" />
</td>
</tr>
</table>
🚀 Установка и запуск  

Клонируйте репозиторий:  
https://github.com/playerz0redd/game-catalog-iOS.git

ВАЖНО (API Key): В проекте используется конфигурационный файл Secrets.xcconfig для защиты ключей.

Зарегистрируйтесь на сайте RAWG API и получите бесплатный ключ.

В корне проекта убедитесь, что в файле game-catalog/Resources/Secrets.xcconfig переменная GAMES_API_TOKEN заполнена вашим токеном:
GAMES_API_TOKEN = ваш_токен_здесь
Убедитесь, что зависимости SPM подтянуты (Kingfisher, Firebase, Lottie, Shimmer).

🤝 Контакты

Telegram: @playerz0redd

Email: ipasha1337@yandex.by
