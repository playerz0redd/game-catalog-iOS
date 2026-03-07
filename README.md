![alt text](https://img.shields.io/badge/Swift-5.9-orange.svg)


![alt text](https://img.shields.io/badge/Architecture-MVVM--C-green.svg)

![alt text](https://img.shields.io/badge/UI-SwiftUI-informational.svg)

GameHub — это iOS-приложение для поиска видеоигр, просмотра трейлеров, скриншотов и управления списком избранного. Проект разработан с использованием публичного RAWG API.

Проект создавался с упором на написание масштабируемого, тестируемого и легко читаемого кода с использованием самых актуальных технологий экосистемы Apple.


🛠 Технологический стек:  

UI Фреймворк: SwiftUI.

Архитектура: MVVM + Coordinator (Строгое разделение бизнес-логики, UI и роутинга).

Сетевой слой: Swift Concurrency (async/await) + URLSession. Полностью кастомный и дженерифицированный Network Manager без использования Alamofire.

Реактивщина: Combine (для глобального стейта авторизации и смены локализации).

Локальная база данных: SwiftData (для хранения избранных игр).

Авторизация: Firebase Auth.

Работа с медиа:

AVKit — для нативного проигрывания трейлеров игр прямо в приложении.

Kingfisher — для асинхронной загрузки и жесткого кэширования изображений (настроен для плавной работы в фоновом потоке).

Lottie — для векторных анимаций (Splash Screen).

Локализация: Apple String Catalogs (.xcstrings), поддержка английского и русского языков с возможностью переключения.

Protocol-Oriented Programming (POP): Все сервисы и менеджеры (INetworkManager, IPersistance, IAuthService и т.д.) скрыты за протоколами.

Паттерн Coordinator в SwiftUI: Навигация полностью вынесена из View. Используется NavigationPath и кастомные перечисления роутеров (CatalogRouter, FavoritesRouter).

Современный Concurrency: Работа с сетью построена на async/await с использованием Task(priority:) для фоновой загрузки данных. Имплементирована пагинация при пролистывании списков.

Кастомные жесты и анимации: Написан собственный ContentViewer — кастомный оверлей для просмотра изображений и видео с поддержкой жеста "свайп вниз для закрытия" (DragGesture), как в нативном приложении Фото.

Безопасность и архитектура API: Все эндпоинты строго типизированы через enum GameApiEndpoints. Парсинг JSON вынесен в отдельный дженерик-менеджер DecodeManager.

Файловая система: Профиль пользователя (аватарка) сохраняется напрямую в FileManager устройства.

Работа с ошибками: Имплементированы кастомные типы ошибок (NetworkException, AuthExceptions, GamesCatalogServiceError), которые "пробрасываются" через все слои приложения.

✨ Основные функции
🔍 Поиск и фильтрация: Полноценный поиск игр по названию и жанрам. Пагинация списка.

📖 Детали игры: Подробное описание, рейтинг Metacritic, список платформ и магазинов (с возможностью открыть магазин в In-App Safari).

🎥 Галерея и медиа: Просмотр скриншотов с пейджингом и воспроизведение видео-трейлеров (AVPlayer).

❤️ Избранное: Добавление игр в "Избранное" (сохраняется локально через SwiftData для офлайн-доступа).

👥 Разработчики: Просмотр списка компаний-разработчиков и их главных проектов.

👤 Профиль пользователя: Регистрация/Вход (Firebase), установка аватара (камера или галерея через UIImagePickerController), переключение языка.

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

code
Bash
git clone https://github.com/playerz0redd/game-catalog-iOS.git

ВАЖНО (API Key): В проекте используется конфигурационный файл Secrets.xcconfig. Для успешных запросов к сети, необходимо получить бесплатный токен на RAWG API и убедиться, что переменная GAMES_API_TOKEN установлена в вашем окружении, либо заменить её на свой ключ.

🤝 Контакты

Telegram: @playerz0redd

Email: ipasha1337@yandex.by
