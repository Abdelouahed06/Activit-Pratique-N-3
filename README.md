# Flutter Counter & Chatbot Example

This Flutter project demonstrates two main features:

- A **Counter** example implemented with both StatefulWidget and BLoC pattern
- A **Chatbot** interface using BLoC for state management, connected to an Ollama LLM backend

## Features

- **Home selection screen**: Choose between Counter and Chatbot on app launch
- **Counter Example**:
  - Local state management with StatefulWidget
  - Global state management with BLoC
- **Chatbot**:
  - User authentication (simple login)
  - Chat interface with message history and streaming responses
  - Conversation management (start new, load, delete)
  - All chat state managed with BLoC

## Project Structure

```
lib/
├── counter/
│   ├── counter_bloc.dart      # BLoC logic for counter
│   ├── counter_event.dart     # Counter events
│   ├── counter_page.dart      # Counter UI (StatefulWidget & BLoC)
│   └── counter_state.dart     # Counter state
├── pages/
│   ├── chabot_bloc.dart       # BLoC logic for chatbot
│   ├── chabot_event.dart      # Chatbot events
│   ├── chabot_state.dart      # Chatbot state
│   ├── chabot.page.dart       # Chatbot UI
│   ├── home_selection.page.dart # Home selection screen
│   └── login.page.dart        # Login UI
└── main.dart                  # App entry point and routing
```

## How It Works

- On launch, the app shows a selection screen to choose Counter or Chatbot.
- **Counter Example**:
  - Shows both a local (StatefulWidget) and global (BLoC) counter, each with increment/decrement buttons.
- **Chatbot**:
  - Login with username `admin` and password `1234`.
  - After login, chat with the LLM backend (Ollama must be running locally).
  - Start new conversations, load previous ones, and delete as needed.
  - All chat state (messages, loading, conversations) is managed by BLoC.

## Requirements

- Flutter SDK (3.7.2 or later)
- Dart SDK
- Ollama server running locally (for chatbot)
