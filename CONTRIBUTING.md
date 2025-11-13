# Contributing to BookSwap

Thank you for your interest in contributing to BookSwap! This document provides guidelines for contributing to the project.

## Development Setup

### Prerequisites
- Flutter SDK (3.9.2+)
- Firebase project with Authentication and Firestore enabled
- Android Studio or VS Code with Flutter extensions

### Getting Started
1. Clone the repository
2. Set up Firebase configuration (see [FIREBASE_SETUP.md](FIREBASE_SETUP.md))
3. Install dependencies: `flutter pub get`
4. Run the app: `flutter run`

## Code Standards

### Code Quality
- Maintain zero Flutter analyzer warnings
- Follow Dart style guidelines
- Use meaningful variable and function names
- Add comments for complex logic

### Architecture
- Use Provider pattern for state management
- Keep widgets focused and reusable
- Separate business logic from UI components
- Use proper error handling

### Testing
- Write unit tests for business logic
- Test error scenarios
- Verify Firebase integration works correctly

## Commit Guidelines

### Commit Message Format
```
<type>: <description>

[optional body]
```

### Types
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes
- `refactor`: Code refactoring
- `test`: Adding tests
- `chore`: Maintenance tasks

### Examples
```
feat: Add book search functionality
fix: Resolve image upload issue on web
docs: Update Firebase setup instructions
```

## Pull Request Process

1. Create a feature branch from `main`
2. Make your changes following the code standards
3. Ensure all tests pass
4. Update documentation if needed
5. Submit a pull request with a clear description

## Firebase Guidelines

- Never commit Firebase configuration files
- Use environment variables for sensitive data
- Test authentication flows thoroughly
- Ensure Firestore security rules are properly configured

## UI/UX Guidelines

- Maintain consistent navy (#0A0A23) and amber (#FFC107) color scheme
- Use provided reusable widgets when possible
- Ensure responsive design across platforms
- Provide clear user feedback for all actions

## Questions?

If you have questions about contributing, please open an issue or reach out to the maintainers.